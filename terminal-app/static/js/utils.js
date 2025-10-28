function openLinkNewTab(url, downloadFilename = null) {
	const a = document.createElement("a");
	a.href = url;
	a.target = "_blank";
	if (downloadFilename) {
		a.download = downloadFilename;
	}
	document.body.appendChild(a);
	a.click();
	a.remove();
}

function isBackgroundSoundMuted() {
	return muteMusicIcon.style.display === "none" ? true : false;
}

function getUserLanguageCode() {
	const lang = navigator.language || navigator.userLanguage || "en";
	return lang.split("-")[0];
}

function isSocketReady() {
	return socket.readyState === WebSocket.OPEN;
}

function sendResize() {
	const dimensions = fitAddon.proposeDimensions();
	if (!dimensions) return;
	terminal.resize(dimensions.cols, dimensions.rows);
	socket.send(JSON.stringify({
		type: "resize",
		cols: terminal.cols,
		rows: terminal.rows,
	}));
}

function fitAndResize() {
	if (!isSocketReady()) return;
	setTerminalFontSize();
	fitAddon.fit();
	clearTimeout(resizeTimer);
	resizeTimer = setTimeout(sendResize, 250);
}

function downloadCv(lang) {
	const driveCvFileId = lang == ENG ? engCvId : espCvId;
	const cvUrl = `https://drive.usercontent.google.com/uc?id=${driveCvFileId}&authuser=0&export=download`
	const cvFilename = `Eliel Berra CV ${lang}.pdf`;
	openLinkNewTab(cvUrl, cvFilename)
}

function waitSocketSendCmd(command) {
	if (isSocketReady()) {
		socket.send(command);
	} else {
		socket.onopen = () => {
			socket.send(command);
			fitAndResize();
		};
	}
}

function sendInitialCmd(command) {
	if (terminal._isDisposed) {
		[terminal, socket] = createXtermTerminal();
	}
	displayTerminal();
	waitSocketSendCmd(command);
}
