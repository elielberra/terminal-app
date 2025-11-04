package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"syscall"

	"github.com/creack/pty"
	"github.com/gorilla/websocket"
)

type userLanguage string

type wsMsg struct {
	Type string `json:"type"`
	Cols int    `json:"cols"`
	Rows int    `json:"rows"`
	Data string `json:"data,omitempty"`
}

type wsCfg struct {
	Protocol       string
	Domain         string
	Port           string
	AllowedOrigins []string
}

const (
	SPANISH userLanguage = "ES"
	ENGLISH userLanguage = "EN"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		reqOrigin := r.Header.Get("Origin")
		cfg := getWsConfig()
		for _, o := range cfg.AllowedOrigins {
			if reqOrigin == o {
				return true
			}
		}
		log.Printf("ERROR: Expected one of %v but received a connection from %s", cfg.AllowedOrigins, reqOrigin)
		return false
	},
}

func getWsConfig() wsCfg {
	protocol := os.Getenv("WS_PROTOCOL")
	domain := os.Getenv("WS_DOMAIN")
	port := os.Getenv("WS_PORT")
	if protocol == "" || domain == "" {
		log.Fatal("Missing required environment variables: WS_PROTOCOL and/or WS_DOMAIN")
	}

	makeOrigin := func(d string) string {
		if port == "" {
			return fmt.Sprintf("%s://%s", protocol, d)
		}
		return fmt.Sprintf("%s://%s:%s", protocol, d, port)
	}

	allowed := []string{
		makeOrigin(domain),
		makeOrigin("www." + domain),
	}

	onionDomain := os.Getenv("ONION_DOMAIN")
	if onionDomain != "" {
		allowed = append(allowed, makeOrigin(onionDomain))
	}

	return wsCfg{
		Protocol:       protocol,
		Domain:         domain,
		Port:           port,
		AllowedOrigins: allowed,
	}
}

func getUserLanguage(r *http.Request) userLanguage {
	lang := r.Header.Get("Accept-Language")
	if len(lang) >= 2 && lang[:2] == "es" {
		return SPANISH
	}
	return ENGLISH
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	userLanguage := getUserLanguage(r)
	defer conn.Close()

	cmd := exec.Command(
		"/bin/rbash",
		"--rcfile", "/home/web-user/.bashrc",
		"-i",
	)

	webUserID := uint32(1001)
	webGroupID := uint32(1001)
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Credential: &syscall.Credential{Uid: webUserID, Gid: webGroupID},
	}

	cmd.Env = append(os.Environ(),
		"USER_LANG="+string(userLanguage),
		"LC_ALL=C.UTF-8",
		"LC_CTYPE=C.UTF-8",
		"TERM=xterm-256color",
		"GNUPGHOME=/home/web-user/.gnupg",
		"HOME=/home/web-user",
	)

	ptmx, err := pty.Start(cmd)
	if err != nil {
		log.Println("Error starting PTY:", err)
		return
	}
	defer func() {
		_ = ptmx.Close()
		_ = cmd.Process.Kill()
	}()

	go func() {
		buf := make([]byte, 4096)
		for {
			n, err := ptmx.Read(buf)
			if err != nil {
				break
			}
			if n > 0 {
				cleanOutput := bytes.ToValidUTF8(buf[:n], nil)
				conn.WriteMessage(websocket.BinaryMessage, cleanOutput)
			}
		}
	}()

	for {
		_, messageData, err := conn.ReadMessage()
		if err != nil {
			break
		}
		var messageJson wsMsg
		if err := json.Unmarshal(messageData, &messageJson); err == nil && messageJson.Type == "resize" {
			_ = pty.Setsize(ptmx, &pty.Winsize{
				Cols: uint16(messageJson.Cols),
				Rows: uint16(messageJson.Rows),
			})
			continue
		}
		ptmx.Write(messageData)
	}
}

func main() {
	http.HandleFunc("/ws", wsHandler)
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)
	appPort := ":" + os.Getenv("APP_PORT")
	log.Printf("terminal-app listening on port %s", appPort)
	log.Fatal(http.ListenAndServe(appPort, nil))
}
