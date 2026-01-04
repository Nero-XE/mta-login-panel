---Модуль GUI логин панели
LoginGUI = {
    checkbox = {},
    tabpanel = {},
    label = {},
    button = {},
    window = {},
    edit = {},
    tab = {}
}

---Возвращает данные регистрации из формы
---@return string login Логин
---@return string password Пароль
---@return string secretCode
function LoginGUI:getRegisterData()
    local login = guiGetText(self.edit[3])
    local password = guiGetText(self.edit[4])
    local secretCode = guiGetText(self.edit[5])

    return login, password, secretCode
end

---Возвращает данные аутентификации из формы
---@return string login Логин
---@return string password Пароль
---@return boolean isRememberAuthData Запоминать данные аутентификации?
function LoginGUI:getAuthData()
    local login = guiGetText(self.edit[1])
    local password = guiGetText(self.edit[2])
    local isRememberAuthData = guiCheckBoxGetSelected(self.checkbox[1])

    return login, password, isRememberAuthData
end

---Подстановка данных аутентификации в форму
---@param login string Логин
---@param password string Пароль
function LoginGUI:setAuthData(login, password)
    guiSetText(self.edit[1], login)
    guiSetText(self.edit[2], password)
    guiCheckBoxSetSelected(self.checkbox[1], true)
end

---Переключает на таб "Вход"
function LoginGUI:changeToAuthTab()
    outputChatBox('hello')
    guiSetSelectedTab(self.tabpanel[1], self.tab[1])
end

---Отчищает поля ввода в форме "Регистрация"
function LoginGUI:clearRegisterForm()
    guiSetText(self.edit[3], '')
    guiSetText(self.edit[4], '')
    guiSetText(self.edit[5], '')
end

---Переключает видимость окон
function LoginGUI:toggleWindow()
    local mainWindow = self.window[1]
    local secondWindow = self.window[2]
    guiSetVisible(mainWindow, not guiGetVisible(mainWindow))
    guiSetVisible(secondWindow, not guiGetVisible(secondWindow))
    guiBringToFront(secondWindow)
end

---Возвращает значение из поля ввода кодового слова
---@return string secretCode Кодовое слово
function LoginGUI:getSecretCodeValue()
    local secretCode = guiGetText(self.edit[6])

    return secretCode
end

---Инициализирует GUI логин-панели
function LoginGUI:initGUI()
    local screenW, screenH = guiGetScreenSize()
    self.window[1] = guiCreateWindow((screenW - 300) / 2, (screenH - 350) / 2, 300, 350, "Добро пожаловать!", false)
    guiWindowSetMovable(self.window[1], false)
    guiWindowSetSizable(self.window[1], false)

    self.tabpanel[1] = guiCreateTabPanel(9, 28, 282, 313, false, self.window[1])

    self.tab[1] = guiCreateTab("Вход", self.tabpanel[1])

    self.label[1] = guiCreateLabel(20, 40, 242, 50, "Логин", false, self.tab[1])

    self.edit[1] = guiCreateEdit(0, 20, 242, 30, "", false, self.label[1])

    self.label[2] = guiCreateLabel(20, 100, 242, 50, "Пароль", false, self.tab[1])

    self.edit[2] = guiCreateEdit(0, 20, 242, 30, "", false, self.label[2])
    guiEditSetMasked(self.edit[2], true)

    self.checkbox[1] = guiCreateCheckBox(20, 160, 120, 30, "Запомнить меня", false, false, self.tab[1])

    self.button[1] = guiCreateButton(20, 200, 242, 30, "Войти", false, self.tab[1])
    guiSetFont(self.button[1], "default-bold-small")
    addEventHandler('onClientGUIClick', self.button[1], Client.requestSignInHandler, false)

    self.tab[2] = guiCreateTab("Регистрация", self.tabpanel[1])

    self.label[3] = guiCreateLabel(20, 30, 242, 50, "Логин", false, self.tab[2])

    self.edit[3] = guiCreateEdit(0, 20, 242, 30, "", false, self.label[3])

    self.label[4] = guiCreateLabel(20, 90, 242, 50, "Пароль", false, self.tab[2])

    self.edit[4] = guiCreateEdit(0, 20, 242, 30, "", false, self.label[4])
    guiEditSetMasked(self.edit[4], true)

    self.label[5] = guiCreateLabel(20, 150, 242, 50, "Кодовое слово", false, self.tab[2])

    self.edit[5] = guiCreateEdit(0, 20, 242, 30, "", false, self.label[5])

    self.button[2] = guiCreateButton(20, 220, 242, 30, "Зарегистрироваться", false, self.tab[2])
    guiSetFont(self.button[2], "default-bold-small")
    addEventHandler('onClientGUIClick', self.button[2], Client.requestSignUpHandler, false)

    self.window[2] = guiCreateWindow((screenW - 350) / 2, (screenH - 220) / 2, 350, 220, "Введите кодовое слово", false)
    guiWindowSetMovable(self.window[2], false)
    guiWindowSetSizable(self.window[2], false)
    guiSetVisible(self.window[2], false)

    self.label[6] = guiCreateLabel(20, 40, 310, 50, "Кодовое слово", false, self.window[2])

    self.edit[6] = guiCreateEdit(0, 20, 310, 30, "", false, self.label[6])

    self.label[7] = guiCreateLabel(20, 100, 310, 50, "Обнаружена попытка входа с нового устройства. Для подтверждения введите кодовое слово, указанное при регистрации.", false, self.window[2])
    guiLabelSetColor(self.label[7], 155, 155, 155)
    guiLabelSetHorizontalAlign(self.label[7], "left", true)

    self.button[3] = guiCreateButton(20, 170, 150, 30, "Отмена", false, self.window[2])
    addEventHandler('onClientGUIClick', self.button[3], function ()
        guiSetVisible(self.window[1], true)
        guiSetVisible(self.window[2], false)
    end, false)

    self.button[4] = guiCreateButton(180, 170, 150, 30, "Войти", false, self.window[2])
    guiSetFont(self.button[4], "default-bold-small")
    addEventHandler('onClientGUIClick', self.button[4], Client.requestCheck2FA, false)
end