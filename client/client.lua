---Модуль клиентской логики аутентификации
Client = {}

---Установка ограничений для подключившегося игрока
function Client.restrictPlayerUntilAuth()
    setPlayerHudComponentVisible('all', false)
    guiSetInputMode('no_binds')
    showChat(true, true)
end

---Получение и подстановка данных аутентификации (если файл с данными существует у клиента)
---@return boolean|nil
function Client.getAuthData()
    local fileContent = AuthData:getFileContent()

    if not fileContent then return false end
    local authData = fromJSON(fileContent)

    if not authData then return false end
    LoginGUI:setAuthData(authData.login, authData.password)
end

---Обрабатывает запрос на регистрацию нового пользователя
---@return boolean|nil
function Client.requestSignUpHandler()
    local login, password, secretCode = LoginGUI:getRegisterData()

    if not Validator:validate({ login = login, password = password, secretCode = secretCode }, 'signUp') then return false end

    triggerServerEvent('onRequestSignUp', resourceRoot, login, password, secretCode)
end

---Хендлер на успешную регистрацию игрока
function Client.onSignUpSuccessHandler()
    LoginGUI:changeToAuthTab()
    LoginGUI:clearRegisterForm()
end

---Хранит данные аутентификации для сохранения
local preparedAuthData = nil

---Подготавливает данные аутентификации для сохранения
---@param login any
---@param password any
local function prepareAuthData(login, password)
    preparedAuthData = toJSON({ login = login, password = password })
end

---Обрабатывает запрос на авторизацию пользователя
---@return boolean|nil
function Client.requestSignInHandler()
    local login, password, isRememberAuthData = LoginGUI:getAuthData()

    if not Validator:validate({ login = login, password = password }, 'signIn') then return false end

    triggerServerEvent('onRequestSignIn', resourceRoot, login, password)

    if not isRememberAuthData then return false end

    prepareAuthData(login, password)
end

---Снимает ограничения с игрока после успешной авторизации
local function releasePlayerAfterAuth()
    setElementFrozen(localPlayer, false)
    setElementDimension(localPlayer, 0)
    setCameraTarget(localPlayer)
    setPlayerHudComponentVisible('all', true)
    guiSetInputMode('allow_binds')
    destroyElement(guiRoot)
    showChat(true, false)
    showCursor(false)
end

---Хендлер на успешную авторизацию игрока
function Client.onSignInSuccessHandler()
    releasePlayerAfterAuth()

    if preparedAuthData then
        AuthData:syncDataToFile(preparedAuthData)
    else
        AuthData:deleteDataFile()
    end
end

---Хендлер на запрос кодового слова
function Client.onSignInNeed2FAHandler()
    LoginGUI:toggleWindow()
end

---Обрабатывает запрос на проверку кодового слова
function Client.requestCheck2FA()
    local secretCode = LoginGUI:getSecretCodeValue()
    triggerServerEvent('onRequestCheck2FA', resourceRoot, secretCode)
end