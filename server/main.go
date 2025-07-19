package main

import (
	"log"
	"net/http"
	"os/exec"
	"os"
	"fmt"

	"github.com/gorilla/websocket"
	"github.com/creack/pty"
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
		return origin == expectedOrigin },
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	defer conn.Close()

	cmd := exec.Command("sudo", "-u", "web-user", "/bin/bash")
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
