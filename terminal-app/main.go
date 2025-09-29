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

		if protocol == "" || domain == "" || port == "" {
			log.Fatal("Missing required environment variables: WS_PROTOCOL, WS_DOMAIN, or WS_PORT")
		}

		origin := r.Header.Get("Origin")

		expectedOrigin := fmt.Sprintf("%s://%s", protocol, domain)
		if port != "" {
			expectedOrigin += ":" + port
		}
		if origin != expectedOrigin {
			log.Printf("ERROR: Expected %s but receieved a connection from %s", expectedOrigin, origin)
		}									 // Required for acccessing web page from phone or device on the same wifi // TODO: Remove later
		return (origin == expectedOrigin) || (origin == "http://192.168.100.8:8080")
	},
}

type UserLanguage string

const (
	SPANISH UserLanguage = "ES"
	ENGLISH UserLanguage = "EN"
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
	initialCommand := "export LANG=" + string(userLanguage) + "; " +
		"exec rbash"
	cmd := exec.Command("/bin/bash", "-c", initialCommand)
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
		buf := make([]byte, 1024)
		for {
			n, err := ptmx.Read(buf)
			if err != nil {
				break
			}
			conn.WriteMessage(websocket.BinaryMessage, buf[:n])

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
