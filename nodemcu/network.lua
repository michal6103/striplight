require "config"

Network = {}

function Network.initWifi(ssid, password)
    print("Connecting to Wi-Fi: " .. ssid)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid , password)
end

function Network.connectLoop()
	-- check if connected to network every second
	tmr.alarm(TIMER_NETWORK, 1000, 1, Network.checkNetCallback)
end

function Network.checkNetCallback()
    print("Checking IP")
	local status = wifi.sta.status()
    if status == STA_GOTIP  then
        print("Got IP: " .. wifi.sta.getip())
        tmr.stop(TIMER_NETWORK)
	else
		print("Wi-Fi status: " .. status)
    end
end


