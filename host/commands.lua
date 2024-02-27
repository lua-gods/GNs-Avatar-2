if not host:isHost() then return end

local http = require("libraries.http")
local chpos,chrot
local cc = {
   ["afghanistan"] = "AF",
   ["albania"] = "AL",
   ["algeria"] = "DZ",
   ["american Samoa"] = "AS",
   ["andorra"] = "AD",
   ["angola"] = "AO",
   ["anguilla"] = "AI",
   ["antarctica"] = "AQ",
   ["antigua and Barbuda"] = "AG",
   ["argentina"] = "AR",
   ["armenia"] = "AM",
   ["aruba"] = "AW",
   ["australia"] = "AU",
   ["austria"] = "AT",
   ["azerbaijan"] = "AZ",
   ["bahamas"] = "BS",
   ["bahrain"] = "BH",
   ["bangladesh"] = "BD",
   ["barbados"] = "BB",
   ["belarus"] = "BY",
   ["belgium"] = "BE",
   ["belize"] = "BZ",
   ["benin"] = "BJ",
   ["bermuda"] = "BM",
   ["bhutan"] = "BT",
   ["bolivia (Plurinational State of)"] = "BO",
   ["bonaire, Sint Eustatius and Saba"] = "BQ",
   ["bosnia and Herzegovina"] = "BA",
   ["botswana"] = "BW",
   ["bouvet Island"] = "BV",
   ["brazil"] = "BR",
   ["british Indian Ocean Territory"] = "IO",
   ["brunei Darussalam"] = "BN",
   ["bulgaria"] = "BG",
   ["burkina Faso"] = "BF",
   ["burundi"] = "BI",
   ["cabo Verde"] = "CV",
   ["cambodia"] = "KH",
   ["cameroon"] = "CM",
   ["canada"] = "CA",
   ["cayman Islands"] = "KY",
   ["central African Republic"] = "CF",
   ["chad"] = "TD",
   ["chile"] = "CL",
   ["china"] = "CN",
   ["christmas Island"] = "CX",
   ["cocos (Keeling) Islands"] = "CC",
   ["colombia"] = "CO",
   ["comoros"] = "KM",
   ["congo (the Democratic Republic of the)"] = "CD",
   ["congo"] = "CG",
   ["cook Islands"] = "CK",
   ["costa Rica"] = "CR",
   ["croatia"] = "HR",
   ["cuba"] = "CU",
   ["curaçao"] = "CW",
   ["cyprus"] = "CY",
   ["czechia"] = "CZ",
   ["côte d'Ivoire"] = "CI",
   ["denmark"] = "DK",
   ["djibouti"] = "DJ",
   ["dominica"] = "DM",
   ["dominican Republic"] = "DO",
   ["ecuador"] = "EC",
   ["egypt"] = "EG",
   ["el Salvador"] = "SV",
   ["equatorial Guinea"] = "GQ",
   ["eritrea"] = "ER",
   ["estonia"] = "EE",
   ["eswatini"] = "SZ",
   ["ethiopia"] = "ET",
   ["falkland Islands [Malvinas]"] = "FK",
   ["faroe Islands"] = "FO",
   ["fiji"] = "FJ",
   ["finland"] = "FI",
   ["france"] = "FR",
   ["french Guiana"] = "GF",
   ["french Polynesia"] = "PF",
   ["french Southern Territories"] = "TF",
   ["gabon"] = "GA",
   ["gambia"] = "GM",
   ["georgia"] = "GE",
   ["germany"] = "DE",
   ["ghana"] = "GH",
   ["gibraltar"] = "GI",
   ["greece"] = "GR",
   ["greenland"] = "GL",
   ["grenada"] = "GD",
   ["guadeloupe"] = "GP",
   ["guam"] = "GU",
   ["guatemala"] = "GT",
   ["guernsey"] = "GG",
   ["guinea"] = "GN",
   ["guinea-Bissau"] = "GW",
   ["guyana"] = "GY",
   ["haiti"] = "HT",
   ["heard Island and McDonald Islands"] = "HM",
   ["holy See"] = "VA",
   ["honduras"] = "HN",
   ["hong Kong"] = "HK",
   ["hungary"] = "HU",
   ["iceland"] = "IS",
   ["india"] = "IN",
   ["indonesia"] = "ID",
   ["iran (Islamic Republic of)"] = "IR",
   ["iraq"] = "IQ",
   ["ireland"] = "IE",
   ["isle of Man"] = "IM",
   ["israel"] = "IL",
   ["italy"] = "IT",
   ["jamaica"] = "JM",
   ["japan"] = "JP",
   ["jersey"] = "JE",
   ["jordan"] = "JO",
   ["kazakhstan"] = "KZ",
   ["kenya"] = "KE",
   ["kiribati"] = "KI",
   ["korea (the Democratic People's Republic of)"] = "KP",
   ["korea (the Republic of)"] = "KR",
   ["kuwait"] = "KW",
   ["kyrgyzstan"] = "KG",
   ["lao People's Democratic Republic"] = "LA",
   ["latvia"] = "LV",
   ["lebanon"] = "LB",
   ["lesotho"] = "LS",
   ["liberia"] = "LR",
   ["libya"] = "LY",
   ["liechtenstein"] = "LI",
   ["lithuania"] = "LT",
   ["luxembourg"] = "LU",
   ["macao"] = "MO",
   ["madagascar"] = "MG",
   ["malawi"] = "MW",
   ["malaysia"] = "MY",
   ["maldives"] = "MV",
   ["mali"] = "ML",
   ["malta"] = "MT",
   ["marshall Islands"] = "MH",
   ["martinique"] = "MQ",
   ["mauritania"] = "MR",
   ["mauritius"] = "MU",
   ["mayotte"] = "YT",
   ["mexico"] = "MX",
   ["micronesia (Federated States of)"] = "FM",
   ["moldova (the Republic of)"] = "MD",
   ["monaco"] = "MC",
   ["mongolia"] = "MN",
   ["montenegro"] = "ME",
   ["montserrat"] = "MS",
   ["morocco"] = "MA",
   ["mozambique"] = "MZ",
   ["myanmar"] = "MM",
   ["namibia"] = "NA",
   ["nauru"] = "NR",
   ["nepal"] = "NP",
   ["netherlands"] = "NL",
   ["new Caledonia"] = "NC",
   ["new Zealand"] = "NZ",
   ["nicaragua"] = "NI",
   ["niger"] = "NE",
   ["nigeria"] = "NG",
   ["niue"] = "NU",
   ["norfolk Island"] = "NF",
   ["northern Mariana Islands"] = "MP",
   ["norway"] = "NO",
   ["oman"] = "OM",
   ["pakistan"] = "PK",
   ["palau"] = "PW",
   ["palestine, State of"] = "PS",
   ["panama"] = "PA",
   ["papua New Guinea"] = "PG",
   ["paraguay"] = "PY",
   ["peru"] = "PE",
   ["philippines"] = "PH",
   ["pitcairn"] = "PN",
   ["poland"] = "PL",
   ["portugal"] = "PT",
   ["puerto Rico"] = "PR",
   ["qatar"] = "QA",
   ["republic of North Macedonia"] = "MK",
   ["romania"] = "RO",
   ["russian Federation"] = "RU",
   ["rwanda"] = "RW",
   ["réunion"] = "RE",
   ["saint Barthélemy"] = "BL",
   ["saint Helena, Ascension and Tristan da Cunha"] = "SH",
   ["saint Kitts and Nevis"] = "KN",
   ["saint Lucia"] = "LC",
   ["saint Martin (French part)"] = "MF",
   ["saint Pierre and Miquelon"] = "PM",
   ["saint Vincent and the Grenadines"] = "VC",
   ["samoa"] = "WS",
   ["san Marino"] = "SM",
   ["sao Tome and Principe"] = "ST",
   ["saudi Arabia"] = "SA",
   ["senegal"] = "SN",
   ["serbia"] = "RS",
   ["seychelles"] = "SC",
   ["sierra Leone"] = "SL",
   ["singapore"] = "SG",
   ["sint Maarten (Dutch part)"] = "SX",
   ["slovakia"] = "SK",
   ["slovenia"] = "SI",
   ["solomon Islands"] = "SB",
   ["somalia"] = "SO",
   ["south Africa"] = "ZA",
   ["south Georgia and the South Sandwich Islands"] = "GS",
   ["south Sudan"] = "SS",
   ["spain"] = "ES",
   ["sri Lanka"] = "LK",
   ["sudan"] = "SD",
   ["suriname"] = "SR",
   ["svalbard and Jan Mayen"] = "SJ",
   ["sweden"] = "SE",
   ["switzerland"] = "CH",
   ["syrian Arab Republic"] = "SY",
   ["taiwan (Province of China)"] = "TW",
   ["tajikistan"] = "TJ",
   ["tanzania, United Republic of"] = "TZ",
   ["thailand"] = "TH",
   ["timor-Leste"] = "TL",
   ["togo"] = "TG",
   ["tokelau"] = "TK",
   ["tonga"] = "TO",
   ["trinidad and Tobago"] = "TT",
   ["tunisia"] = "TN",
   ["turkey"] = "TR",
   ["turkmenistan"] = "TM",
   ["turks and Caicos Islands"] = "TC",
   ["tuvalu"] = "TV",
   ["uganda"] = "UG",
   ["ukraine"] = "UA",
   ["united Arab Emirates"] = "AE",
   ["united Kingdom of Great Britain and Northern Ireland"] = "GB",
   ["united States Minor Outlying Islands"] = "UM",
   ["united States of America"] = "US",
   ["uruguay"] = "UY",
   ["uzbekistan"] = "UZ",
   ["vanuatu"] = "VU",
   ["venezuela (Bolivarian Republic of)"] = "VE",
   ["viet Nam"] = "VN",
   ["virgin Islands (British)"] = "VG",
   ["virgin Islands (U.S.)"] = "VI",
   ["wallis and Futuna"] = "WF",
   ["western Sahara"] = "EH",
   ["yemen"] = "YE",
   ["zambia"] = "ZM",
   ["zimbabwe"] = "ZW",
   ["åland Islands"] = "AX",
   }

local horn_proxy = {
   feet = "73ede7e6-8404-44c0-a692-18f22cf17e66", -- gd defeat
   hoho = "1fc12595-38f7-48fe-b9f1-129a04e2d783", -- gd flashbang
   ["fire in the hole"] = "c15f44e1-5e85-46c9-a44d-50416ec0effc",
   ["spongebob dramatic queue"] = "c6447916-520e-4b2f-82ef-3c4a0c694276",
   rah = "781874b1-d434-4586-b6be-0334b2ba50b5",
   ["taco bell"] = "75fe2138-8de0-4927-8dc5-6cdebb7feb16",
}

local command = require("services.commandHandler")
command.register(function (words)
   if words[1] == "calc" or words[1] == "solve" or words[1] == "eval" then -- solve
      table.remove(words,1)
      local solve = load("return " .. table.concat(words," "),"calculate",{math = math})
      command.announce(table.concat(words," ") .." = " .. solve())
   
   elseif words[1] == "gmatch" then
      command.announce("Matching "..words[3].." with "..words[2])
      local i = 0
      for word in string.gmatch(words[3],words[2]) do
         i = i + 1
         command.announce(i.." '"..word.."'")
      end
   

   elseif words[1] == "rev" then
      table.remove(words,1)
      local msg = table.concat(words," ")
      local rev = ""
      for i = 1, #msg, 1 do
         rev = msg:sub(i,i) .. rev
      end
      host:sendChatMessage(rev)
   

   elseif words[1] == "tonether" and #words == 3 then -- solve
      command.announce("nether: " .. tonumber(words[2]) / 8 .. " " .. tonumber(words[3]) / 8)
   

   elseif words[1] == "tooverworld" and #words == 3 then -- solve
      command.announce("overworld: " .. tonumber(words[2]) * 8 .. "~" .. tonumber(words[2]+1) * 8 .. " " .. tonumber(words[3]) * 8 .. "~" .. tonumber(words[3]+1) * 8)
   

   elseif words[1] == "checkpoint" then
      if chpos then
         host:sendChatCommand("/tp @s "..chpos.x.." "..chpos.y.." "..chpos.z.." "..chrot.y.." "..chrot.x)
         chpos = nil
         command.announce("back to checkpoint")
      else
         chpos = player:getPos()
         chrot = player:getRot()
         command.announce("checkpoint saved")
      end
   

   elseif words[1] == "pos" and #words == 1 then
      local pos = player:getPos():floor()
      host:appendChatHistory(pos.x.." "..pos.y.." "..pos.z)
      command.announce("pos: "..pos.x.." "..pos.y.." "..pos.z)


   elseif words[1] == "horn" and words[2] then
      table.remove(words,1)
      local final = table.concat(words," ")
      if horn_proxy[final] then
         if player:getHeldItem().id == "minecraft:goat_horn" then
            host:sendChatCommand("/audioplayer goathorn "..horn_proxy[final])
         else
            command.announce("hold a goat horn")
         end
      else
         command.announce("no proxy for that key")
      end
   
   elseif words[1] == "t" and #words > 2 then
      local lang_to = cc[words[2]] or words[2]
      table.remove(words,1) -- remove keyword
      table.remove(words,1) -- remove translate to
      local textToTranslate = table.concat(words," ")
      textToTranslate = textToTranslate:gsub('%s', '%%20'):gsub('&', '%26')
      http.get(
         'https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&sl=auto&tl='..lang_to..'&q='..textToTranslate,
         function(output, err)
            if err then print(err) return end
            local json = parseJson(output)
            host:sendChatMessage(json[1][1][1])
         end
      )
   end
end)