---Модуль клиентской логики валидации данных
Validator = {
    ---Режимы валидации и правила
    modes = {
        signUp = {
            { field = 'login', displayName = 'Логин', min = 4, required = true },
            { field = 'password', displayName = 'Пароль', min = 8, required = true },
            { field = 'secretCode', displayName = 'Кодовое слово', min = 3, required = true }
        },
        signIn = {
            { field = 'login', displayName = 'Логин', required = true },
            { field = 'password', displayName = 'Пароль', required = true },
        }
    }
}

---Возвращает окончание строки исходя из числа
---@param count number
---@return string
local function getSymbolSuffix(count)
    local lastDigit = count % 10
    local lastTwoDigits = count % 100

    if lastTwoDigits >= 11 and lastTwoDigits <= 14 then
        return 'ов'
    end

    if lastDigit == 1 then
        return ''
    elseif lastDigit >= 2 and lastDigit <= 4 then
        return 'а'
    else
        return 'ов'
    end
end

---Валидация вводимых данных
---@param data table Данные которые нужно валидировать
---@param mode 'signUp'|'signIn' Режимы валидации
---@return boolean
function Validator:validate(data, mode)
    local rules = self.modes[mode] or {}

    for _, fieldRules in pairs(rules) do
        local field, displayName, min, required = fieldRules.field, fieldRules.displayName, fieldRules.min or nil, fieldRules.required
        local value = data[field]

        if required and string.len(value) == 0 then
            Message.outputError(string.format('Поле "%s", должно быть заполнено!', displayName))
            return false
        end

        if min and string.len(value) < min then
            Message.outputWarning(string.format('Поле "%s", должно содержать минимум %s символ%s!', displayName, min, getSymbolSuffix(min)))
            return false
        end
    end

    return true
end

---Модуль логики работы с файлом аутентификации
AuthData = {
    filePath = 'cache/authData.enc'
}

---Возвращает содержимое файла аутентификации
---@return string|false
function AuthData:getFileContent()
    FileManager:setFilePath(self.filePath)
    return FileManager:getFileContent()
end

---Проверяет наличие одинакового содержимого параметра и файла
---@param content string
---@return boolean
local function hasFileSameContent(content)
    local fileContent = AuthData:getFileContent()

    return fileContent == content
end

---Управляет содержимым файла с данными аутентификации
---@param authData string
---@return boolean|nil
function AuthData:syncDataToFile(authData)
    FileManager:setFilePath(self.filePath)
    local isAuthDataFileExists = FileManager:isFileExists()

    if isAuthDataFileExists then
        local isSameContent = hasFileSameContent(authData)

        if isSameContent then return false end

        FileManager:setFileContent(authData)
    else
        FileManager:createFile()
        FileManager:setFileContent(authData)
    end
end

---Удаляет файл с данными аутентификации
function AuthData:deleteDataFile()
    FileManager:setFilePath(self.filePath)
    FileManager:deleteFile()
end