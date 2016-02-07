require "config"

Time = {}


function Time.startGetTimeLoop()
    -- getTime every 10 seconds
    print("getTime every 10 seconds")
    tmr.alarm(TIMER_TIME, 10000, 1, Time.getTimeCallback)
end

function Time.parseTime(pl)
    return string.match(pl, "%c(%d+):")
end

function Time.getTimeCallback()
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
        print("No network")
    end
end



