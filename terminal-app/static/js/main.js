[terminal, socket] = createXtermTerminal();


inactiveMsg.textContent = isUserLangSpanish ? inactiveTxtEs : inactiveTxtEn;


if (!hasVisitedSitePreviously) {
	localStorage.setItem("hasVisitedSitePreviously", "true");
}

if (!hasVisitedSitePreviously && isMobileUser) {
	alert(isUserLangSpanish ? alertMobileTxtEs : alertMobileTxtEn)
}

const cmd = "bash /app/scripts/welcome-msg.sh\r";
sendInitialCmd(cmd);
