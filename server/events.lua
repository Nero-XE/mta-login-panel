addEventHandler('onPlayerJoin', root, Server.restrictPlayerUntilAuth)

addEvent('onRequestSignUp', true)
addEventHandler('onRequestSignUp', resourceRoot, Server.onRequestSignUpHandler, false)

addEvent('onRequestSignIn', true)
addEventHandler('onRequestSignIn', resourceRoot, Server.onRequestSignInHandler, false)

addEvent('onRequestCheck2FA', true)
addEventHandler('onRequestCheck2FA', resourceRoot, Server.onRequestCheck2FAHandler, false)