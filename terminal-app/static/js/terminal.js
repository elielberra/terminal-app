function isOrientationPortrait() {
	return window.matchMedia("(orientation: portrait)").matches;
}

function setTerminalFontSize() {
	let viewportRef;
	if (isMobileUser) {
		viewportRef = isOrientationPortrait() ? MOBILE_PORTRAIT_VIEWPORT_WIDTH_REF : MOBILE_LANDSCAPE_VIEWPORT_WIDTH_REF;
	} else {
		viewportRef = PC_VIEWPORT_WIDTH_REF;
	}
	let fontSizeRef;
	if (terminalFontSizeState === RED_FONT_STATE) {
		if (isMobileUser) {
			fontSizeRef = isOrientationPortrait() ? RED_PORTRAIT_MOBILE_REF_FONT_SIZE : RED_LANDSCAPE_MOBILE_REF_FONT_SIZE;
		} else {
			fontSizeRef = RED_PC_REF_FONT_SIZE
		}
	} else if (terminalFontSizeState === DEF_FONT_STATE) {
		if (isMobileUser) {
			fontSizeRef = isOrientationPortrait() ? DEF_PORTRAIT_MOBILE_REF_FONT_SIZE : DEF_LANDSCAPE_MOBILE_REF_FONT_SIZE;
		} else {
			fontSizeRef = DEF_PC_REF_FONT_SIZE
		}
	} else if (terminalFontSizeState === AUG_FONT_STATE) {
		if (isMobileUser) {
			fontSizeRef = isOrientationPortrait() ? AUG_PORTRAIT_MOBILE_REF_FONT_SIZE : AUG_LANDSCAPE_MOBILE_REF_FONT_SIZE;
		} else {
			fontSizeRef = AUG_PC_REF_FONT_SIZE
		}
	}
	const widthScale = window.innerWidth / viewportRef;
	terminal.options.fontSize = widthScale * fontSizeRef;
}

function enableTerminalInput() {
	terminalDiv.style.pointerEvents = "auto";
	terminal.focus();
	terminal.options.disableStdin = false;
	terminal.options.cursorBlink = true;
	terminal.options.cursorInactiveStyle = "block";
}


function stripAnsi(text) {
	return text.replace(/\x1B\[[0-?]*[ -/]*[@-~]/g, "").trim();
}

function createXtermTerminal() {
	const terminal = new Terminal({
		cursorBlink: true,
		cursorStyle: "underline",
		cursorInactiveStyle: "none"
	});
	terminal.open(terminalDiv);
	const scheme = location.protocol === 'https:' ? 'wss' : 'ws';
	const socket = new WebSocket(`${scheme}://${location.host}/ws`);
	socket.binaryType = "arraybuffer";
	socket.onmessage = function (event) {
		const text = (typeof event.data === "string")
			? event.data
			: new TextDecoder("utf-8").decode(new Uint8Array(event.data));
		const cleanText = stripAnsi(text);
		if (cleanText.startsWith("SIG_")) {
			handleTerminalOutput(cleanText, terminal);
		} else {
			terminal.write(text);
		}
	};
	socket.onclose = function () {
		terminal.dispose();
		terminalDiv.style.display = "none";
		inactiveMsg.style.display = "block";
		lightModeIcon.style.display = "none";
		nightModeIcon.style.display = "none";
		muteMusicIcon.style.display = "none";
		unmuteMusicIcon.style.display = "none";
		terminal.options.theme = {};
		document.body.style.backgroundColor = "black";
		backgroundSound.pause()
	};
	terminal.onData(data => {
		socket.send(data);
	});
	terminal.loadAddon(fitAddon);
	return [terminal, socket]
}

function displayTerminal() {
	inactiveMsg.style.display = "none";
	terminalDiv.style.display = "block";
	terminal.focus();
	fitAndResize();
}

function setLightTheme(terminal) {
	terminal.options.theme = {
		background: lightThemeBackgroundColor,
		foreground: "#000000",
		cursor: "#000000",
		selectionBackground: "#c0c0c0",
		black: "#000000",
		red: "#d70000",
		green: "#008700",
		yellow: "#af8700",
		blue: "#005faf",
		magenta: "#870087",
		cyan: "#008787",
		white: "#e4e4e4",
		brightBlack: "#1c1c1c",
		brightRed: "#d75f5f",
		brightGreen: "#5faf5f",
		brightYellow: "#afaf5f",
		brightBlue: "#5f87af",
		brightMagenta: "#af5faf",
		brightCyan: "#5fafaf",
		brightWhite: "#ffffff",
	};
}
