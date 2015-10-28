require "strip"
require "config"
require "color"

STA_GOTIP = 5
TIMER_NETWORK = 0   -- Timer used for network event
TIMER_COLOR = 1     -- Timer used for color change
TIMER_TIME = 2      -- Timer used for gettin time regularely

MODE_MORNING = CONFIG.MODE_MORNING
MODE_DAY = CONFIG.MODE_DAY
MODE_EVENING = CONFIG.MODE_EVENING
MODE_NIGHT = CONFIG.MODE_NIGHT

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
        conn:connect(5000,CONFIG.TIME_HOST)
        print("Getting time")
        conn:send("GET /getTime HTTP/1.1\r\nHost: " .. CONFIG.TIME_HOST
		.. "\r\n" .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
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
	-- in morning and day we use full spectre
	if time >= MODE_MORNING then
		s = 255
		v = 127
	elseif time >= MODE_DAY then
    	s = 127
		v = 255
	elseif time >= MODE_EVENING then
		s = 255
		v = 127
	elseif time >= MODE_NIGHT then
		s = 255
		v = 63
	end

	-- in evening and night there is no  blue and minimal green
	if time >= MODE_EVENING or time >= MODE_NIGHT then
		if  hue > 21 then
			hue = 0
		end
	end	
    if hue >= 255 then
        hue = 0
    end

    r, g, b = Color.hsvToRgb(hue, s, v)
    -- print("HSV",hue,255,255)
    -- print("RGB",r,g,b)
    strip:setRGB(r, g, b)

    hue = hue + 1
end


initWifi()
-- check if connected to network every second
tmr.alarm(TIMER_NETWORK, 1000, 1, checkNetCallback)

strip = Strip;
strip:start()
-- rotate HSV color every second
tmr.alarm(TIMER_COLOR, 1000, 1, rotateColorsCallback)


