require "strip"
require "config"
require "color"

STA_GOTIP = 5
TIMER_NETWORK = 0   -- Timer used for network event
TIMER_COLOR = 1     -- Timer used for color change
TIMER_TIME = 2      -- Timer used for gettin time regularely

function parseTime(pl)    
    return string.match(pl, "%c(%d+):")    
end

function getTimeCallback()
    --http://188.226.243.203:5000/getTime
    if wifi.sta.status() == STA_GOTIP then
        conn=net.createConnection(net.TCP, false) 
        conn:on("receive",
            function(conn, pl)
                time = parseTime(pl)
                if time then
                    print("Setting time to: " .. tostring(time))
                    print("getTime every 10 minutes")
                    -- getTimeCallback every 10 minutes
                    tmr.alarm(TIMER_TIME, 600000, 1, getTimeCallback)
                end
            end)
        conn:connect(5000,"188.226.243.203")
        print("Getting time")
        conn:send("GET /getTime HTTP/1.1\r\nHost: 188.226.243.203\r\n"
        .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
    else
        -- start checking network every second
        tmr.alarm(TIMER_NETWORK, 1000, 1, checkNetCallback)
    end
end

function checkNetCallback()
    print("Checking IP")
    if wifi.sta.status() == STA_GOTIP  then
        print("Got IP: " .. wifi.sta.getip())
        tmr.stop(TIMER_NETWORK)
        -- getTime every 10 seconds
        print("getTime every 10 seconds")
        tmr.alarm(TIMER_TIME, 10000, 1, getTimeCallback)
    end
end

function initWifi()
    print("Connecting to Wi-Fi: " .. CONFIG.SSID)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(CONFIG.SSID,CONFIG.PASSWORD)    
end

function rotateColorsCallback()
    if hue == nil then
        hue = 0
    end
    local r, g, b
    r, g, b = Color.hsvToRgb(hue, 255, 255)
    -- print("HSV",hue,255,255)
    -- print("RGB",r,g,b)
    strip:setRGB(r, g, b)
    hue = hue + 1
    if hue >= 255 then
        hue = 0
    end
end


initWifi()
-- check if connected to network every second
tmr.alarm(TIMER_NETWORK, 1000, 1, checkNetCallback)

strip = Strip;
strip:start()
-- rotate HSV color every second
tmr.alarm(TIMER_COLOR, 1000, 1, rotateColorsCallback)


