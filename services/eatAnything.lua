-- made by deni weni

local relPos = vec(0,0,0)
local keybind = keybinds:newKeybind('Eat from Mainhand','key.keyboard.right.control')
local timeCount = 0
local item = ''
local isEating = false

function pings.setEating(bool)
    isEating = bool
end

if host:isHost() then
    function events.tick()
        if keybind:isPressed() and item == player:getHeldItem():toStackString() and player:getHeldItem():getID() ~= "minecraft:air" and isEating ~= true then
            pings.setEating(true)
        end
        if (not keybind:isPressed() or item ~= player:getHeldItem():toStackString() or player:getHeldItem():getID() == "minecraft:air") and isEating ~= false then
            pings.setEating(false)
        end
    end
end

function events.tick()
    relPos = player:getLookDir().x_z*0.6 + vec(0,player:getEyeHeight()*0.69,0)
    if isEating then
        timeCount = timeCount + 1
        if timeCount == math.floor(timeCount / 1) * 1 and timeCount > 0 then
            sounds:playSound('minecraft:entity.generic.eat',player:getPos()):pitch(math.random() * 0.4 + 0.8):volume(0.5)
            for i = 1, 5 do
                particles:newParticle('item ' .. item)
                :pos(player:getPos() + relPos + vec(math.random()*0.4 - 0.2,math.random()*0.4 - 0.2,math.random()*0.4 - 0.2))
                :velocity(vec(math.random()*0.1 - 0.05,math.random()*0.1 + 0.2,math.random()*0.1 - 0.05) + player:getLookDir() * 0.05)
                :scale(math.random() * 0.25 + 0.25)
            end
        end
        --if timeCount == 28 then
        --    timeCount = -5
        --    sounds:playSound('minecraft:entity.player.burp',player:getPos()):pitch(math.random() * 0.2 + 0.9):volume(0.3)
        --end
    else
        timeCount = -5
        item = player:getHeldItem():toStackString()
    end
end