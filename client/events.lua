addEventHandler('onClientResourceStart', resourceRoot, function ()
    LoginGUI:initGUI()
    Client.restrictPlayerUntilAuth()
    Client.decryptAuthData()
end, false)

addEvent('onSignUpSuccess', true)
addEventHandler('onSignUpSuccess', resourceRoot, Client.onSignUpSuccessHandler, false)

addEvent('onSignInSuccess', true)
addEventHandler('onSignInSuccess', resourceRoot, Client.onSignInSuccessHandler, false)

addEvent('onSignInNeed2FA', true)
addEventHandler('onSignInNeed2FA', resourceRoot, Client.onSignInNeed2FAHandler, false)

addEvent('onEncryptAuthDataSuccess', true)
addEventHandler('onEncryptAuthDataSuccess', resourceRoot, Client.onEncryptAuthDataSuccessHandler, false)

addEvent('onDecryptAuthDataSuccess', true)
addEventHandler('onDecryptAuthDataSuccess', resourceRoot, Client.onDecryptAuthDataSuccessHandler, false)