---Модуль сообщений
Message = {}

--- Выводит сообщение-успех в чат
---@param text string
---@param visibleTo userdata
function Message.outputSuccess(text, visibleTo)
    outputChatBox(text, visibleTo, 80, 200, 120)
end

--- Выводит сообщение-предупреждение в чат
---@param text string
---@param visibleTo userdata|nil
function Message.outputWarning(text, visibleTo)
    if visibleTo == nil then
        outputChatBox(text, 255, 179, 67)
    else
        outputChatBox(text, visibleTo, 255, 179, 67)
    end
end

--- Выводит сообщение-ошибку в чат
---@param text string
---@param visibleTo userdata|nil
function Message.outputError(text, visibleTo)
    if visibleTo == nil then
        outputChatBox(text, 241, 54, 55)
    else
        outputChatBox(text, visibleTo, 241, 54, 55)
    end
end