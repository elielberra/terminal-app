[terminal, socket] = createXtermTerminal();

if (isUserLangSpanish) {
	accessBtn.textContent = "Acceder a la Página Web";
	skipIntroBtn.textContent = "Saltar Introducción";
	inactiveMsg.textContent = "Tu sesión anterior de la terminal se cerró por inactividad";
}

if (hasVisitedSitePreviously) {
	skipIntroBtn.style.display = "inline-block";
	accessBtn.textContent += (isUserLangSpanish ? " con" : " w/") + " Intro";
} else {
	skipIntroBtn.style.display = "none";
	localStorage.setItem("hasVisitedSitePreviously", "true");
}

if (!hasVisitedSitePreviously && isMobileUser) {
	alert(isUserLangSpanish ? alertMobileTxtEs : alertMobileTxtEn)
}
