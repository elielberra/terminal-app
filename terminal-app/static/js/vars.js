const RED_FONT_STATE = "REDUCED";
const DEF_FONT_STATE = "DEFAULT";
const AUG_FONT_STATE = "AUGMENTED";
let terminalFontSizeState = DEF_FONT_STATE;
const PC_VIEWPORT_WIDTH_REF = 1950;
const MOBILE_PORTRAIT_VIEWPORT_WIDTH_REF = 431;
const MOBILE_LANDSCAPE_VIEWPORT_WIDTH_REF = 800;
const RED_PC_REF_FONT_SIZE = 17;
const DEF_PC_REF_FONT_SIZE = 22;
const AUG_PC_REF_FONT_SIZE = 35;
const RED_PORTRAIT_MOBILE_REF_FONT_SIZE = 8;
const DEF_PORTRAIT_MOBILE_REF_FONT_SIZE = 14;
const AUG_PORTRAIT_MOBILE_REF_FONT_SIZE = 16;
const RED_LANDSCAPE_MOBILE_REF_FONT_SIZE = 6;
const DEF_LANDSCAPE_MOBILE_REF_FONT_SIZE = 9;
const AUG_LANDSCAPE_MOBILE_REF_FONT_SIZE = 13;
const fitAddon = new FitAddon.FitAddon();
const ENG = "ENG";
const ESP = "ESP";
const engCvUrl = "https://www.canva.com/design/DAFb6MvnBv4/ipzbfJ6fAykrDj9Qi1cApQ/view?utm_content=DAFb6MvnBv4&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h9a3c14187c";
const espCvUrl = "https://www.canva.com/design/DAE8A0OVbeM/AMw15SufwB-2_5YphghBXQ/view?utm_content=DAE8A0OVbeM&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hd068bcd41f";
const userLang = getUserLanguageCode()
const semiOpaqueWhite = "rgba(255, 255, 255, 0.75)";
const transparent = "rgba(255, 255, 255, 0)";
const lightThemeBackgroundColor = "#f7e3c7";
let resizeTimer;
const hasVisitedSitePreviously = localStorage.getItem("hasVisitedSitePreviously") === "true";
const inactiveTxtEn = "Your previous terminal session was closed due to inactivity";
const inactiveTxtEs = "Tu sesión anterior de la terminal se cerró por inactividad";
const alertMobileTxtEn =
    "It’s recommended to open this webpage on a computer rather than a mobile phone. " +
    "Although the page is responsive and works on mobile devices, " +
    "using a computer provides a better overall user experience.";
const alertMobileTxtEs =
    "Se recomienda abrir esta página web en una computadora en lugar de un teléfono móvil. " +
    "Aunque la página es adaptable y funciona en celulares, " +
    "el uso de una computadora ofrece una mejor experiencia general de usuario.";
const clipboardTxtEn = "(the text below will be copied to your clipboard automatically)"
const clipboardTxtEs = "(el texto de abajo se va a copiar automáticamente a tu portapapales)"
const binaryHint = "01100011 01100001 01110100 00100000 00101111 01101000 01101111 01101101 01100101 00101111 " +
    "01110111 01100101 01100010 00101101 01110101 01110011 01100101 01110010 00101111 01101000 " +
    "01101001 01101110 01110100 00101101 00110001";
const isMobileUser = /Mobi|Android|iPhone|iPad|iPod/i.test(navigator.userAgent);
const isUserLangSpanish = userLang === "es";
let terminal, socket;
