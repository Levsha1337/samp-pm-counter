script_author("Levsha1337")
script_name("sa-pc.online pm counter")

local inicfg = require "inicfg"
local SE = require 'samp.events'

local defaults = {
    variables =
    {
        pm = 0
    },
    settings =
    {
        pos_x = 30,
        pos_y = 330
    }
}

local td_id = 1337
local mainIni = {}

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(0)
    end
    
    sampAddChatMessage("Special for {ff4444}sa{ffffff}-{4444ff}pc{ffffff}.online by {4477aa}Levsha1337{ffffff}: pm counter", 0xFFFFFFFF)
    
    mainIni = inicfg.load(defaults, "counter.ini")
    
    addPMCounter(mainIni.variables.pm)
    
    sampRegisterChatCommand("removepmcounter", clear_pm_counter)

    wait(-1)
end

function addPMCounter(pm)
    sampTextdrawCreate(td_id, string.format("You_have_%i_pm's", pm), mainIni.settings.pos_x, mainIni.settings.pos_y)
end

function clear_pm_counter(arg)
    sampTextdrawSetString(td_id, "")
end

function setPMCount(pm)
    sampTextdrawSetString(td_id, string.format("You_have_%i_pm's", pm))
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end
  
function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
end

function onScriptTerminate()
    saveCfg()
end

function saveCfg()
    inicfg.save(mainIni, "counter.ini")
end

function SE.onServerMessage(color, text)
    local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local nick = sampGetPlayerNickname(id)
    if color == -3014486 and string.starts(text, nick) then
        local hours = tonumber(os.date("!%H", os.time() + 3 * 60 * 60))
        
        if hours <= 23 and hours > 9 then
            mainIni.variables.pm = mainIni.variables.pm + 1
            setPMCount(mainIni.variables.pm)
            saveCfg()
        end
    end
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end