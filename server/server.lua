---Модуль серверной логики аутентификации
Server = {}

---Установка ограничений для подключившихся игроков
function Server.restrictPlayerUntilAuth()
    setElementFrozen(source, true)
    setElementDimension(source, 1)
    setCameraMatrix(source, -1997.7705078125, 980.21661376953, 113.68701934814)
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
            setAccountData(accountAdded, 'loginpanel.secretcode', secretCode)
            setAccountSerial(accountAdded, playerSerial)
            triggerClientEvent(client, 'onSignUpSuccess', resourceRoot)
            Message.outputSuccess('Вы успешно зарегистрировались, войдите в аккаунт!', client)
        else
            Message.outputWarning('Введенный логин уже занят!', client)
        end
    else
        Message.outputError('На этом устройстве уже зарегистрирован аккаунт!', client)
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
    end
end

---Проверка кодового слова 
---@param secretCode string Кодовое слово
function Server.onRequestCheck2FAHandler(secretCode)
    local account, password = authData.account, authData.password
    local accountSecret = getAccountData(account, 'loginpanel.secretcode')

    if accountSecret == secretCode then
        completePlayerSignIn(client, account, password)
    else
        Message.outputError('Неверное кодовое слово!', client)
    end
end