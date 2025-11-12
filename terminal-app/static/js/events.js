nightModeIcon.addEventListener("click", () => {
	nightModeIcon.style.display = "none";
	lightModeIcon.style.display = "block";
	terminal.options.theme = {};
	document.body.style.backgroundColor = "black";
})

lightModeIcon.addEventListener("click", () => {
	nightModeIcon.style.display = "block";
	lightModeIcon.style.display = "none";
	setLightTheme(terminal);
	document.body.style.backgroundColor = lightThemeBackgroundColor;
})

closeIcon.addEventListener("click", () => {
	socket.send('printf \x03\r');
	stopAudio(gladiatorSound);
	stopAudio(argFncSound);
	terminalFontSizeState = DEF_FONT_STATE;
	fitAndResize();
	enableTerminalInput();
	lightModeIcon.style.display = "block";
	closeIcon.style.display = "none";
	socket.send('clear && bash /app/scripts/instructions.sh\r');
})

window.addEventListener("resize", fitAndResize);
