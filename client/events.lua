addEventHandler('onClientResourceStart', resourceRoot, function ()
    LoginGUI:initGUI()
    Client.restrictPlayerUntilAuth()
    Client.getAuthData()
end, false)

addEvent('onSignUpSuccess', true)
addEventHandler('onSignUpSuccess', resourceRoot, Client.onSignUpSuccessHandler, false)

addEvent('onSignInSuccess', true)
addEventHandler('onSignInSuccess', resourceRoot, Client.onSignInSuccessHandler, false)

addEvent('onSignInNeed2FA', true)
addEventHandler('onSignInNeed2FA', resourceRoot, Client.onSignInNeed2FAHandler, false)