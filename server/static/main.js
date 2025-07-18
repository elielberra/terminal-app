const term = new Terminal({cursorBlink: true});
term.open(document.getElementById('terminal'));

const socket = new WebSocket("ws://" + location.host + "/ws");

socket.onmessage = function (event) {
  term.write(event.data);
};

term.onData(data => {
  socket.send(data);
});
