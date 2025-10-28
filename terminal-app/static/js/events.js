accessBtn.addEventListener("click", () => {
	const cmd = "bash /app/scripts/intro.sh\r";
	sendInitialCmd(cmd);
})

skipIntroBtn.addEventListener("click", () => {
	const cmd = "bash /app/scripts/welcome-msg.sh\r";
	sendInitialCmd(cmd);
})

nightModeIcon.addEventListener("click", () => {
	nightModeIcon.style.display = "none";
	lightModeIcon.style.display = "block";
	terminal.options.theme = {};
	muteMusicIcon.style.backgroundColor = semiOpaqueWhite;
	unmuteMusicIcon.style.backgroundColor = semiOpaqueWhite;
	document.body.style.backgroundColor = "black";
})

lightModeIcon.addEventListener("click", () => {
	nightModeIcon.style.display = "block";
	lightModeIcon.style.display = "none";
	setLightTheme(terminal);
	muteMusicIcon.style.backgroundColor = transparent;
	unmuteMusicIcon.style.backgroundColor = transparent;
	document.body.style.backgroundColor = lightThemeBackgroundColor;
})

muteMusicIcon.addEventListener("click", () => {
	muteMusicIcon.style.display = "none";
	unmuteMusicIcon.style.display = "block";
	backgroundSound.pause()
})

unmuteMusicIcon.addEventListener("click", () => {
	unmuteMusicIcon.style.display = "none";
	muteMusicIcon.style.display = "block";
	backgroundSound.play()
})

closeIcon.addEventListener("click", () => {
	socket.send('printf \x03\r');
	stopAudio(gladiatorSound);
	stopAudio(argFncSound);
	terminalFontSizeState = DEF_FONT_STATE;
	fitAndResize();
	resumeBackgroundSound();
	enableTerminalInput();
	lightModeIcon.style.display = "block";
	muteMusicIcon.style.display = "block";
	closeIcon.style.display = "none";
	socket.send('clear -x\r');
})

window.addEventListener("resize", fitAndResize);
