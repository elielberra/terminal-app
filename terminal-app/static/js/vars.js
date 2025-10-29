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
const engCvId = "1a8X9yvlBTIq26kV4W8PqGr5lLiDhqKai";
const espCvId = "13b17AyMQMklVygE6MSf32GRAD5P9UNfT";
const userLang = getUserLanguageCode()
const semiOpaqueWhite = "rgba(255, 255, 255, 0.75)";
const transparent = "rgba(255, 255, 255, 0)";
const lightThemeBackgroundColor = "#fdf2e1";
let resizeTimer;
const hasVisitedSitePreviously = localStorage.getItem("hasVisitedSitePreviously") === "true";
const inactiveTxtEn = "Your previous terminal session was closed due to inactivity";
const inactiveTxtEs = "Tu sesión anterior de la terminal se cerró por inactividad";
const accessWebTxtEn = "Access Web Page";
const accessWebTxtEs = "Acceder a la Página Web";
const skipIntroTxtEn = "Skip Intro";
const skipIntroTxtEs = "Saltar Introducción";
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
