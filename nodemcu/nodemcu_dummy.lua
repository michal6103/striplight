-- Nodemcu dummy functions
gpio = {}

function gpio.mode(a, b)
end

function gpio.write(a, b)
end

spi = {}

function spi.setup(a, b, c, d, e, f)
end

-- Dummy module to simulate timer
tmr = {}

function tmr.alarm(a,b,c,callback)
	print(callback)
	callback()
end

function tmr.stop()
end

-- dummy module to simulate wifi
wifi ={
	STATION = 0,
	sta = {}
}

function wifi.setmode()
end

function wifi.sta.config(ssid , password)
end

function wifi.sta.status()
	return STA_GOTIP
end

function wifi.sta.getip()
	return "test_ip"
end


-- dummy connection module
connection = {}
function connection:on(event, callback)
	-- TODO implement callback call
end

function connection:connect(port, host)
end

function connection:send(payload)
end


-- dummy module to simulate net
net = {
	TCP = 0
}

function net.createConnection(type, b)
	return connection
end


