-- WORM Bootloader by Fisher Medders (http://medde.rs/) 08/18/22, 08/21/23
args = {...}

-- if you prefer a more suckless edit it yourself kind of thing, just edit the config table below :)
useConfig = true
config = {
    ["backgroundColor"]="black",
    ["foregroundColor"]="white",
    ["boot"]={
        {"No Boot Options Configured!","edit /.worm/config"},
        {"Edit .worm/config to add Boot Configuration!", "edit /.worm/config"}
    }
}
if useConfig then
    if fs.exists("/.worm/config") then
        configFile = fs.open("/.worm/config","r")
        config = textutils.unserialize(configFile.readAll())
        configFile.close()
    else
        configFile = fs.open("/.worm/config","w")
        configFile.write("{\n")
        configFile.write("    [\"backgroundColor\"]=\"black\",\n")
        configFile.write("    [\"foregroundColor\"]=\"white\",\n")
        configFile.write("    [\"boot\"]={\n")
        configFile.write("        {\"No Boot Options Configured!\",\"edit /.worm/config\"},\n")
        configFile.write("        {\"Edit .worm/config to add Boot Configuration!\",\"edit /.worm/config\"}\n")
        configFile.write("    },\n")
        configFile.write("    [\"info\"]=\"boot table section 1 is the name, section 2 is the command that runs\"\n")
        configFile.write("}")
        configFile.close()
        configFile = fs.open("/.worm/config","r")
        config = textutils.unserialize(configFile.readAll())
        configFile.close()
    end
end

print("Detecting Basalt Library")
if not fs.exists("/lib/basalt.lua") then
    print("Basalt Library Not Found!")
    print("Basalt Library can be found at basalt.madefor.cc")
    print("Downloading Basalt Lib")
    if not fs.exists("/.worm/") then
        fs.mkdir("/.worm/")
        print("Making .worm directory")
    end
    sleep(1)
    shell.run("wget run https://basalt.madefor.cc/install.lua release latest.lua /lib/basalt.lua")
end

local basalt = require("/lib/basalt")

local main = basalt.createFrame():setBackground(colors[config["backgroundColor"]])

function addToString(add, amount)
    local str = ""
    for i = 1,amount do
        str = str .. add
    end
    return str
end

function addCenterLabel(ident, text, y)
    local label = main:addLabel(ident):setText(text):setPosition("{parent.w/2-".. #text/2 .."}", y):setForeground(colors[config["foregroundColor"]])
    return label
end

function drawBox()
    pW, pH = main:getSize()
    local box = {
        main:addLabel("topBar"):setPosition(2,3):setText("\159"):setForeground(colors[config["backgroundColor"]]):setBackground(colors[config["foregroundColor"]]),
        main:addLabel("topBarRight"):setPosition(pW-1,3):setText("\144"):setForeground(colors[config["foregroundColor"]]):setBackground(colors[config["backgroundColor"]]),
        main:addLabel("topBarFill"):setPosition(3,3):setText(addToString("\143", pW-4)):setForeground(colors[config["backgroundColor"]]):setBackground(colors[config["foregroundColor"]]),
        main:addLabel("bottomBar"):setPosition(2,3+pH-7):setText("\130" .. addToString("\131", pW-4) .. "\129"):setForeground(colors[config["foregroundColor"]])
    }
    for i = 1,pH-8 do
        table.insert(main:addLabel("topBar"..i+1):setPosition(2,3+i):setText("\149"):setBackground(colors[config["foregroundColor"]]):setForeground(colors[config["backgroundColor"]]),#box-1)
        table.insert(main:addLabel("topBarRight"..i):setPosition(pW-1,3+i):setText("\149"):setBackground(colors[config["backgroundColor"]]):setForeground(colors[config["foregroundColor"]]),#box-1)
    end
end

local tagline = addCenterLabel("tagline", "GNU WORM version 0.02", 2)
local instructionsOne = addCenterLabel("inst1", "Use the \24 and \25 keys to select which entry", "{parent.h-3}")
local instructionsTwo = addCenterLabel("inst2", "is highlighted. Press enter to boot selected OS", "{parent.h-2}")
local instructionsTwo = addCenterLabel("inst3", "or 'c' for a command line.", "{parent.h-1}")

drawBox()

local list = main:addList("list")
list:setSize("{parent.w-5}", "{parent.h-9}")
list:setPosition(3, 4)
list:setBackground(colors[config["backgroundColor"]])
for i = 1,#config.boot do
    list:addItem(" " .. config.boot[i][1], colors[config["backgroundColor"]], colors[config["foregroundColor"]], config.boot[i][2])
end
list:setSelectionColor(colors[config["foregroundColor"]], colors[config["backgroundColor"]], true)

function scrollUp()
    if list:getItemIndex() ~= 1 then
        list:selectItem(list:getItemIndex()-1)
    end
end

function scrollDown()
    if list:getItemIndex() ~= list:getItemCount() then
        list:selectItem(list:getItemIndex()+1)
    end
end

function listen()
    while true do
        event = { os.pullEvent() }
        if event[1] == "key" then
            if event[2] == keys.down then
                scrollDown()
            elseif event[2] == keys.up then
                scrollUp()
            elseif event[2] == keys.enter then
                --basalt.debug(list:getValue().args[1])
                basalt.stop()
                term.clear()
                term.setCursorPos(1,1)
                shell.run(list:getValue().args[1])
                break
            elseif event[2] == keys.c then
                basalt.stop()
                quit = true
                break
            end
        elseif event[1] == "mouse_scroll" then
            if event[2] == 1 then
                scrollDown()
            else
                scrollUp()
            end
        end
    end
end

parallel.waitForAll(basalt.autoUpdate, listen)
term.setCursorPos(1,1)
term.clear()
if quit then
    print("Thanks for using WORM!")
end
