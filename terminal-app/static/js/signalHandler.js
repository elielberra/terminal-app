function handleTerminalOutput(output, terminal) {
	if (output === "SIG_PLAY_INTRO_MUSIC") {
		introSound.volume = 1;
		introSound.play();
		return;
	}
	if (output === "SIG_STOP_INTRO_MUSIC") {
		fadeOutAudio(introSound, 5000);
		return;
	}

	if (output === "SIG_PLAY_GLADIATOR_MUSIC") {
		gladiatorSound.volume = 0.3;
		gladiatorSound.play();
		setTimeout(() => {
			gladiatorSound.volume = 0.15;
		}, 38000)
		return;
	}
	if (output === "SIG_STOP_GLADIATOR_MUSIC_FADE_OUT") {
		fadeOutAudio(gladiatorSound, 8000);
		return;
	}

	if (output === "SIG_PLAY_MORSE_SOUND") {
		morseSound.volume = 0.05;
		morseSound.play();
		return;
	}
	if (output === "SIG_STOP_MORSE_SOUND") {
		fadeOutAudio(morseSound, 500)
		return;
	}

	if (output === "SIG_PLAY_ARG_FNC_MUSIC") {
		argFncSound.play();
		return;
	}

	if (output === "SIG_REDUCE_FONT_SIZE") {
		terminalFontSizeState = RED_FONT_STATE;
		fitAndResize();
		return;
	}
	if (output === "SIG_DEFAULT_FONT_SIZE") {
		terminalFontSizeState = DEF_FONT_STATE;
		fitAndResize();
		return;
	}

	if (output === "SIG_AUGMENT_FONT_SIZE") {
		terminalFontSizeState = AUG_FONT_STATE;
		fitAndResize();
		return;
	}

	if (output === "SIG_OPEN_CV_ENG") {
		openCv(ENG)
		return;
	}
	if (output === "SIG_OPEN_CV_ESP") {
		openCv(ESP)
		return;
	}

	if (output === "SIG_PLAY_BACKGROUND_SOUND") {
		resumeBackgroundSound();
		return;
	}
	if (output === "SIG_PAUSE_BACKGROUND_SOUND") {
		backgroundSound.pause();
		return;
	}

	if (output === "SIG_DISABLE_TERMINAL_INPUT") {
		terminalDiv.style.pointerEvents = "none";
		terminal.blur();
		terminal.options.disableStdin = true;
		terminal.options.cursorBlink = false;
		terminal.options.cursorInactiveStyle = "none";
		return;
	}
	if (output === "SIG_ENABLE_TERMINAL_INPUT") {
		enableTerminalInput();
		return;
	}

	if (output === "SIG_DISPLAY_THEME_VOL_BTNS") {
		lightModeIcon.style.display = "block";
		muteMusicIcon.style.display = "block";
		return;
	}
	if (output === "SIG_HIDE_THEME_VOL_BTNS") {
		lightModeIcon.style.display = "none";
		muteMusicIcon.style.display = "none";
		return;
	}

	if (output === "SIG_SHOW_CLOSE_VIDEO_BTN") {
		closeIcon.style.display = "inline-block";
		return;
	}
	if (output === "SIG_HIDE_CLOSE_VIDEO_BTN") {
		closeIcon.style.display = "none";
		return;
	}

	if (output === "SIG_COPY_BINARY_CLIPBOARD") {
		navigator.clipboard.writeText(binaryHint)
			.then(() => terminal.write((isUserLangSpanish ? clipboardTxtEs : clipboardTxtEn) + "\n\n\r"))
	}

	if (output === "SIG_PLAY_EASTER_EGG") {
		const easterEggUrl = "https://www.youtube.com/watch?v=IfhMILe8C84";
		openLinkNewTab(easterEggUrl)
	}

	if (output === "SIG_OPEN_CYBERSECURITY_DOCS") {
		const cyberSecurityDocsUrl = "https://github.com/elielberra/terminal-app?tab=readme-ov-file#cybersecurity";
		openLinkNewTab(cyberSecurityDocsUrl)
	}
}
