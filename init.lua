local secrets = require 'secrets';

print("Hello Konrad :)");

print('set up mode')
gpio.mode(1, gpio.OUTPUT)

print("Setting up WiFi to Station mode.");
wifi.setmode(wifi.STATION);

print("Setting configuration object for WiFi connection");
print(secrets.ID);
print(secrets.PASS);
station_cfg = {};
station_cfg.ssid = secrets.ID;
station_cfg.pwd = secrets.PASS;

function showip(params) print("Connected to Wifi. Got IP: " .. params.IP); end
function connected(params) print("Connected to Wifi."); end

station_cfg.connected_cb = connected;
station_cfg.got_ip_cb = showip;

function light()
    print('write high')
    gpio.write(1, gpio.HIGH)
    print('read mode')
    print(gpio.read(1))
end


function dark()
    print('write low')
    gpio.write(1, gpio.LOW)
    print('read mode')
    print(gpio.read(1))
end

print("Connection Status");
print(wifi.sta.status())
print("Connecting to WiFi");
wifi.sta.config(station_cfg);
------------------------------------------------------------------------------
-- HTTP server Hello world example
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Vladimir Dronnikov <dronnikov@gmail.com>
------------------------------------------------------------------------------
require("httpserver").createServer(80, function(req, res)
    -- analyse method and url
    print("+R", req.method, req.url, node.heap())

    if req.url == "/light" then
        light()
    end

    if req.url == "/dark" then
        dark()
    end

    -- setup handler of headers, if any
    req.onheader = function(self, name, value) -- luacheck: ignore
        print("+H", name, value)
        -- E.g. look for "content-type" header,
        --   setup body parser to particular format
        -- if name == "content-type" then
        --   if value == "application/json" then
        --     req.ondata = function(self, chunk) ... end
        --   elseif value == "application/x-www-form-urlencoded" then
        --     req.ondata = function(self, chunk) ... end
        --   end
        -- end
    end
    -- setup handler of body, if any
    req.ondata = function(self, chunk) -- luacheck: ignore
        print("+B", chunk and #chunk, node.heap())
        if not chunk then
            -- reply
            res:send(nil, 200)
            res:send_header("Connection", "close")
            res:send("Hello, world!\n")
            res:finish()
        end
    end
    -- or just do something not waiting till body (if any) comes
    -- res:finish("Hello, world!")
    -- res:finish("Salut, monde!")
end)
