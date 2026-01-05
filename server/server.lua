---Модуль серверной логики аутентификации
Server = {}

---Установка ограничений для подключившихся игроков
function Server.restrictPlayerUntilAuth()
    setElementFrozen(source, true)
    setElementDimension(source, 1)
    setCameraMatrix(source, -1997.7705078125, 980.21661376953, 113.68701934814)
end

---Получает значение настройки
---@param settingName string Название настройки
---@return number
local function getSettingValue(settingName)
    return tonumber(get(string.format('%s.%s', resourceName, settingName))) or 0
end

--- Обрабатывает попытку операции с проверкой лимита
--- @param player element Игрок
--- @param attemptType 'signUp'|'signIn'|'check2FA' Тип операции
--- @return boolean true если достигнут лимит и игрок кикнут
local function handleAttempt(player, attemptType)
    local configs = {
        signUp = {
            dataKey = 'loginPanel.signUpAttemptsCount',
            settingKey = 'SignUpAttemptsLimit',
            actionName = 'регистрации'
        },
        signIn = {
            dataKey = 'loginPanel.signInAttemptsCount',
            settingKey = 'SignInAttemptsLimit',
            actionName = 'авторизации'
        },
        check2FA = {
            dataKey = 'loginPanel.check2FAAttemptsCount',
            settingKey = 'Check2FAAttemptsLimit',
            actionName = 'проверки кодового слова'
        }
    }

    local config = configs[attemptType]

    local limit = getSettingValue(config.settingKey)

    local currentAttempts = getElementData(player, config.dataKey) or 0
    currentAttempts = currentAttempts + 1
    setElementData(player, config.dataKey, currentAttempts)

    if currentAttempts >= limit then
        local kickMsg = string.format('Слишком много попыток %s', config.actionName)
        if isElement(player) then
            kickPlayer(player, kickMsg)
        end
        return true
    else
        Message.outputWarning(string.format('Попытка %s №%d из %d',
            config.actionName, currentAttempts, limit), player)
        return false
    end
end

---Регистрация нового аккаунта
---@param login string Логин для нового аккаунта
---@param password string Пароль для нового аккаунта
---@param secretCode string Кодовое слово для нового аккаунта
function Server.onRequestSignUpHandler(login, password, secretCode)
    local playerSerial = getPlayerSerial(client)
    local accounts = getAccountsBySerial(playerSerial)

    if #accounts == 0 then
        local accountAdded = addAccount(login, password)
        if accountAdded then
            setAccountData(accountAdded, 'loginPanel.secretCode', secretCode)
            setAccountSerial(accountAdded, playerSerial)
            triggerClientEvent(client, 'onSignUpSuccess', resourceRoot)
            Message.outputSuccess('Вы успешно зарегистрировались, войдите в аккаунт!', client)
        else
            Message.outputWarning('Введенный логин уже занят!', client)
            handleAttempt(client, 'signUp')
        end
    else
        Message.outputError('На этом устройстве уже зарегистрирован аккаунт!', client)
        handleAttempt(client, 'signUp')
    end
end

---Завершить вход игрока
---@param player userdata Объект игрока
---@param account userdata Аккаунт MTA
---@param password string Пароль от аккаунта
local function completePlayerSignIn(player, account, password)
    logIn(player, account, password)
    triggerClientEvent(player, 'onSignInSuccess', resourceRoot)
    Message.outputSuccess('Вы успешно авторизовались!', player)
end

---Переменная хранящая данные авторизации. Потребуется при входе с нового компьютера
local authData = {}

---Авторизация игрока с проверкой на вход с нового компьютера
---@param login string Логин от аккаунта
---@param password string Пароль от аккаунта
function Server.onRequestSignInHandler(login, password)
    local account = getAccount(login, password)
    local playerSerial = getPlayerSerial(client)

    if account then
        local accountSerial = getAccountSerial(account)
        if accountSerial == playerSerial then
            completePlayerSignIn(client, account, password)
        else
            authData.account = account
            authData.password = password
            triggerClientEvent(client, 'onSignInNeed2FA', resourceRoot)
        end
    else
        Message.outputError('Неверный логин или пароль!', client)
        handleAttempt(client, 'signIn')
    end
end

---Проверка кодового слова 
---@param secretCode string Кодовое слово
function Server.onRequestCheck2FAHandler(secretCode)
    local account, password = authData.account, authData.password
    local accountSecret = getAccountData(account, 'loginPanel.secretCode')

    if accountSecret == secretCode then
        completePlayerSignIn(client, account, password)
    else
        Message.outputError('Неверное кодовое слово!', client)
        handleAttempt(client, 'check2FA')
    end
end