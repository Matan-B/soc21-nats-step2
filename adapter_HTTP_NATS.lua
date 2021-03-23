local nats = require 'nats'
local restserver = require("restserver")

--HTTP port
local http_port = arg[1] or 10900
local server = restserver:new():port(http_port)

--NATS server (default values)
local nats_params = {
   host = arg[2] or '127.0.0.1',
   port = arg[3] or 4222,
}

local client = nats.connect(nats_params)
client:connect()

server:add_resource("*", {   
   {
      method = "POST",
      path = "/",
      handler = function(data)        
         client:publish('Json Payload: ', data)
         local result = {"Success"}
         return restserver.response():status(200):entity(result)
      end,
   } 
})

server:set_error_handler({
   handler = function()
      return {
         custom_error_field = "Error",
      }
   end,
})

server.server_name = "Http to NATS adapter"

-- This loads the restserver.xavante plugin
server:enable("restserver.xavante"):start()