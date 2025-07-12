const term = new Terminal({
  cursorBlink: true,
  theme: {
    background: '#000000'
  }
});

const fitAddon = new FitAddon.FitAddon();
term.loadAddon(fitAddon);
term.open(document.getElementById('terminal'));
fitAddon.fit(); // initial fit

// Connect WebSocket
const socket = new WebSocket("ws://" + location.host + "/ws");

socket.onmessage = function (event) {
  term.write(event.data);
};

term.onData(function (data) {
  socket.send(data);
});

// Auto-resize on window resize
window.addEventListener('resize', () => {
  fitAddon.fit();
});
