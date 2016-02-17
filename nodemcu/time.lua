Time = {
    time_host = ""
}


function Time.init(host)
    Time.time_host = host
end

function Time.startLoop(timer_id)
    print("Getting time every 10 seconds")
    tmr.alarm(timer_id, 10000, 1, Time.getTimeCallback)
end

function Time.parseTime(pl)
    return string.match(pl, "%c(%d+):")
end

function Time.onReceive(conn, pl)
    time = Time.parseTime(pl)
    if time then
        print("Setting time to: " .. tostring(time))
    end
end

function Time.onConnection(conn, c)
    print("Sending request to: " .. Time.time_host)
    conn:send("GET /getTime HTTP/1.1\r\nHost: " .. Time.time_host
    .. "\r\n" .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
end

function Time.onDisconnection(conn,c)
    conn:close()
    print("getTime every 10 minutes")
    tmr.alarm(TIMER_TIME, 600000, 1, Time.getTimeCallback)
end

function Time.getTimeCallback()
    -- http://188.226.243.203:5000/getTime
    if wifi.sta.status() == STA_GOTIP then
        conn=net.createConnection(net.TCP, 0)
        conn:on("receive", Time.onReceive)
        conn:connect(5000,Time.time_hosts)
        conn:on("connection", Time.onConnection)
        conn:on("disconnection", Time.onDisconnection)
    else
        print("No network")
    end
end

return Time
