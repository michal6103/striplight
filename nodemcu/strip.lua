Strip = {
    r_pin = 1,
    g_pin = 2,
    b_pin = 3,
    started = 0
}

function Strip:setup(r_pin, g_pin, b_pin)
	--[[ Function setup PINs for PWM

	params: r_pin, g_pin, b_pin : pin number to setup RGB pins
	--]]
    self.r_pin = r_pin
    self.g_pin = g_pin
    self.b_pin = b_pin
    pwm.setup(self.r_pin, 500, 512)
    pwm.setup(self.g_pin, 500, 512)
    pwm.setup(self.b_pin, 500, 512)
end

function Strip:start()
    pwm.start(self.r_pin)
    pwm.start(self.g_pin)
    pwm.start(self.b_pin)
    self.started = 1
end

function Strip:setRGB(r, g, b)
    self.r = r
    self.g = g
    self.b = b

    pwm.setduty(self.r_pin,r)
    pwm.setduty(self.g_pin,g)
    pwm.setduty(self.b_pin,b)
end

function Strip:getRGB()
    local r = pwm.getduty(self.r_pin)
    local g = pwm.getduty(self.g_pin)
    local b = pwm.getduty(self.b_pin)
    return r, g, b
end

function initWifi()
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



