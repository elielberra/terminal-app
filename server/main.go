package main

import (
	"io"
	"log"
	"net/http"
	"os/exec"
	"os"
	"fmt"

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
		return origin == expectedOrigin },
}

type websocketWriter struct {
	conn *websocket.Conn
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	defer conn.Close()

	cmd := exec.Command("/bin/bash")
	stdin, _ := cmd.StdinPipe()
	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()

	if err := cmd.Start(); err != nil {
		log.Println("Error starting shell:", err)
		return
	}

	stdin.Write([]byte("echo Welcome\n"))
	stdin.Write([]byte("pwd\n"))

	go io.Copy(websocketWriter{conn}, stdout)
	go io.Copy(websocketWriter{conn}, stderr)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}
		stdin.Write(msg)
	}
}

func (w websocketWriter) Write(p []byte) (int, error) {
	err := w.conn.WriteMessage(websocket.TextMessage, p)
	return len(p), err
}

func main() {
	http.HandleFunc("/ws", wsHandler)
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)
	
	log.Println("Listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
