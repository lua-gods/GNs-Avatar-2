--compose._data.tempo = 60000000.0 / data.timeline[2][compose._data.lastTempoIndex][2]





local midi
local midi_name
local bpm = 120
local bpm_override = nil

local time = 0
local playing = false

local lsyst = client:getSystemTime()
local track_data = {}


local last_tempo_id = 0
local next_tempo_id = 1



local function reset()
   time = 0
   for track_id = 1, #midi.tracks, 1 do
      track_data[track_id] = {
         next_note_id = 1,
         last_note_id = 0,
      }
   end
end

local function load(name)
   if file:isFile("midi/"..name..".json") then
      midi = parseJson(require("libraries.file").new("midi/"..name..".json"):readString())
      midi_name = name
      bpm = (midi.header.bpm or 120)
      if midi.timeSignature and midi.timeSignature[1] then
         bpm = bpm * ((midi.timeSignature[1].denominator or 4) / (midi.timeSignature[1].numerator or 4)) 
      end
      reset()
      return true
   end
   return false
end

load("rickroll")

require("services.pings")


events.WORLD_RENDER:register(function ()
   local syst = client:getSystemTime()
   local dt = (syst - lsyst) / 1000
   lsyst = syst
   if midi and playing then
      time = time + dt * (bpm_override or (bpm / 120))

      --tempo
      if midi.tempo and midi.tempo[next_tempo_id] and midi.tempo[next_tempo_id].seconds < time then
         if last_tempo_id ~= next_tempo_id then
            bpm = midi.tempo[next_tempo_id].bpm
            if midi.timeSignature and midi.timeSignature[1] then
               bpm = bpm * ((midi.timeSignature[1].denominator or 4) / (midi.timeSignature[1].numerator or 4)) 
            end
            last_tempo_id = next_tempo_id
         end
         next_tempo_id = next_tempo_id + 1
      end
      
      --tracks
      for track_id = 1, #midi.tracks, 1 do
         local track = midi.tracks[track_id]
         local data = track_data[track_id]
         for _ = 1, 10, 1 do
            local note = track.notes[data.next_note_id]
            if not note then
               break
            end
            if note.time < time then
               data.next_note_id = data.next_note_id + 1
               if data.last_note_id ~= data.next_note_id then
                  pings.midi(note.midi,track.instrumentNumber,track.isPercussion)
                  --if track.isPercussion or false then
                  --   if percussionFont[note.midi] then
                  --      sounds[percussionFont[note.midi]]:pos(client:getCameraDir()+client:getCameraPos()):play()
                  --   end
                  --else
                  --   sounds[soundFont[(track.instrumentNumber or 0) + 1]]:pos(client:getCameraDir()+client:getCameraPos()):pitch(2 ^ (((note.midi) - (12 * 6 - 3)) / 12)):play()
                  --end
                  data.last_note_id = data.next_note_id
               end
            else
               break
            end
         end
      end
      local no_more_notes = true
      for track_id = 1, #midi.tracks, 1 do
         if midi.tracks[track_id].notes[track_data[track_id].next_note_id] then
            no_more_notes = false
         end
      end
      if no_more_notes then
         playing = false
         return
      end
   end
end)


local sidebar = require("host.contextMenu")
local panels = require("libraries.panels")
local page = panels.newPage()

return function ()
   local e = {
      panels.newTextEdit():setAcceptedValue(midi_name):setForceFull(true),
      panels.newSpinbox():setText("BPM Override"),
      panels.newElement(),
      panels.newElement(),
      panels.newToggle():setText("Play"),
      panels.newButton():setText("Reset"),
   }
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   
   page.FRAME:register(function ()
      e[3]:setText({text=string.format("Time: %.2f",time),color="gray"})
      e[4]:setText({text=string.format("BPM: %.2f",bpm),color="gray"})
   end)
   
   e[1].VALUE_ACCEPTED:register(function (value)
      if load(value) then
         host:setActionbar(toJson({text = "Loaded "..value,color="green"}))
      else
         host:setActionbar(toJson({text = "Unable to load "..value,color="red"}))
      end
   
   end)
   e[2].VALUE_ACCEPTED:register(function (value)
      if tonumber(value) then
         bpm_override = value
      else
         bpm_override = nil
      end
   end)
   
   e[5].TOGGLED:register(function (toggle)
      playing = toggle
   end)
   
   e[6].PRESSED:register(function ()
      time = 0
      reset()
   end)
   
   page:setName("MIDI Player")
   page:setHeaderColor("#58d18f")
   page:setIcon(":music2:","emoji")
   return page
end