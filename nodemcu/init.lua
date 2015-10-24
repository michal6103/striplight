require "strip"
require "config"


function initWifi()
	print("Connecting to Wi-Fi: " .. CONFIG.SSID)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(CONFIG.SSID,CONFIG.PASSWORD)
    print(wifi.sta.getip())
end


function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = Math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end



initWifi()
strip = Strip;
strip:start()
strip:setRGB(10,10,10)
print(strip:getRGB())


