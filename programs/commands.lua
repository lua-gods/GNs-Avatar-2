if not host:isHost() then return end
local cmd = require("services.commandHandler")
cmd.register(function (words)
   
end,{
   {type="keyword",name="coconut"},
   {type="boolean",name="bitches?"},
   {type="alias",name="gender",data={"lego","pineapple","voltswagen","shrek","legosupra","red"}},
   {type="integer",name="weight",data={range={low=-16,high=32}}},
   {type="integer",name="age",data={range={low=0,high=100}}},
}
)