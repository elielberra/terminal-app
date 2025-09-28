package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"

	"github.com/creack/pty"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		protocol := os.Getenv("WS_PROTOCOL")
		domain := os.Getenv("WS_DOMAIN")
		port := os.Getenv("WS_PORT")

		origin := r.Header.Get("Origin")

		expectedOrigin := fmt.Sprintf("%s://%s", protocol, domain)
		if port != "" {
			expectedOrigin += ":" + port
		}
		log.Println(expectedOrigin)
		return origin == expectedOrigin
	},
}

type UserLanguage string

const (
	SPANISH UserLanguage = "SPANISH"
	ENGLISH UserLanguage = "ENGLISH"
)

func getUserLanguage(r *http.Request) UserLanguage {
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
	// cmd := exec.Command("/bin/rbash")
	// cmd := exec.Command("/bin/bash") // TODO: Remove me
	// cmd := exec.Command("/bin/bash", "-c", `echo "Welcome to my Web Page"; exec rbash`)
	// cmd := exec.Command("/bin/bash", "-c", `bash scripts/hacked.sh; exec rbash`)
	cmd := exec.Command("/bin/bash", "-c", `exec rbash`)
	cmd.Env = append(os.Environ(), "USER_LANGUAGE="+string(userLanguage))
	ptmx, err := pty.Start(cmd)
	if err != nil {
		log.Println("Error starting PTY:", err)
		return
	}
	// ptmx.Write([]byte("echo HIIII"))
	defer func() {
		_ = ptmx.Close()
		_ = cmd.Process.Kill()
	}()

	go func() {
		buf := make([]byte, 1024)
		for {
			n, err := ptmx.Read(buf)
			if err != nil {
				break
			}
			conn.WriteMessage(websocket.TextMessage, buf[:n])
		}
	}()

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}
		ptmx.Write(msg)
	}
}

func main() {
	http.HandleFunc("/ws", wsHandler)
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)

	log.Println("Listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
