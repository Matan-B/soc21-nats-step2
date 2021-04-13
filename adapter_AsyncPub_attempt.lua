local nats = require 'nats'
local restserver = require("restserver")
local socket = require("socket")


--HTTP port
local http_port = arg[1] or 10900
local server = restserver:new():port(http_port)

--NATS server (default values)
local nats_params = {
   host = arg[2] or '127.0.0.1',
   port = arg[3] or 4222,
   --timeout = 0.1,
}

local client = nats.connect(nats_params)
client:connect()

server:add_resource("*", {   
   {
      method = "POST",
      path = "/",
      handler = function(data)

        --Manage the Requset      
        manageRequest(data)
        
        --Dispatching the Request (ideally, will resume with each callback)
        coroutine.resume(dispatchCo)
      end,
   } 
})

function publishWrap (data)
  --yielding before publishing
  coroutine.yield()
  client:publish('Json Payload: ', data)
  -- TODO: add return values to lua-nats' client:publish to return indicative errors to the client
  -- asumming success
  local result = {"Success"}
  return restserver.response():status(200):entity(result)
end

threads = {}    -- list of all live threads
function manageRequest (data)
  -- create coroutine
  co = coroutine.create(function ()
    publishWrap(data)
  end)
  -- insert it in the table
  table.insert(threads, co)
end

function dispatcher ()
  while true do
    local n = (#threads)
    for i=1,n do
      local status, res = coroutine.resume(threads[i])
      -- thread finished
      if coroutine.status(threads[i]) == 'dead' then  
        --removing finished thread
        table.remove(threads, i)
        break
      else    
        -- acts as timeout (thread is still running)
        break
      end
    end
    --if n == 0 then yield, meaning no more threads to run
    if n == 0 then 
      coroutine.yield() 
      end
  end
end

server:set_error_handler({
   handler = function()
      return {
         custom_error_field = "Error",
      }
   end,
})

server.server_name = "Http to NATS adapter"
-- This loads the restserver.xavante plugin

dispatchCo = coroutine.create(function ()
  dispatcher()
end)

s = server:enable("restserver.xavante")server:start()

-- optional:
-- starting the server with checking function and connection timeout value
-- server:start(check,1)