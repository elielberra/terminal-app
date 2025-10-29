[terminal, socket] = createXtermTerminal();


accessBtn.textContent = isUserLangSpanish ? accessWebTxtEs : accessWebTxtEn;
skipIntroBtn.textContent = isUserLangSpanish ? skipIntroTxtEs : skipIntroTxtEn;
inactiveMsg.textContent = isUserLangSpanish ? inactiveTxtEs : inactiveTxtEn;


if (hasVisitedSitePreviously) {
	skipIntroBtn.style.display = "inline-block";
	accessBtn.textContent += (isUserLangSpanish ? " con" : " w/") + " Intro";
} else {
	skipIntroBtn.style.display = "none";
	localStorage.setItem("hasVisitedSitePreviously", "true");
}

introBtns.style.display = "flex";

if (!hasVisitedSitePreviously && isMobileUser) {
	alert(isUserLangSpanish ? alertMobileTxtEs : alertMobileTxtEn)
}
