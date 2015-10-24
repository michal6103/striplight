require "strip"
require "config"
require "color"

STA_GOTIP = 5
TIMER_NETWORK = 0   -- Timer used for network event
TIMER_COLOR = 1     -- Timer used for color change

function setColorCallback()
end

function checkNetCallback()
    if wifi.sta.status() == STA_GOTIP  then
        print("Got IP: " .. wifi.sta.getip())
        tmr.stop(TIMER_NETWORK)
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
    print("HSV",hue,255,255)
    print("RGB",r,g,b)
    strip:setRGB(r, g, b)
    hue = hue + 1
    if hue >= 255 then
        hue = 0
    end
end


initWifi()
tmr.alarm(TIMER_NETWORK, 1000, 1, checkNetCallback)

strip = Strip;
strip:start()
tmr.alarm(TIMER_COLOR, 1000, 1, rotateColorsCallback)


print(strip:getRGB())

