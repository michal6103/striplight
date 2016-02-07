strip_pwm = {
    r_pin = 1,
    g_pin = 2,
    b_pin = 3,
    started = 0
}

function strip_pwm:setup(r_pin, g_pin, b_pin)
	--[[ Function setup PINs for PWM

	params: r_pin, g_pin, b_pin : pin number to setup RGB pins
	--]]
    self.r_pin = r_pin
    self.g_pin = g_pin
    self.b_pin = b_pin
    pwm.setup(self.r_pin, 500, 512)
    pwm.setup(self.g_pin, 500, 512)
    pwm.setup(self.b_pin, 500, 512)
    pwm.start(self.r_pin)
    pwm.start(self.g_pin)
    pwm.start(self.b_pin)
    self.started = 1
end

function strip_pwm:setRGB(r, g, b)
    self.r = r
    self.g = g
    self.b = b

    pwm.setduty(self.r_pin,r * 4)
    pwm.setduty(self.g_pin,g * 4)
    pwm.setduty(self.b_pin,b * 4)
end

function strip_pwm:getRGB()
    local r = pwm.getduty(self.r_pin / 4)
    local g = pwm.getduty(self.g_pin / 4)
    local b = pwm.getduty(self.b_pin / 4)
    return r, g, b
end

function strip_wpm.write(data)
	strip_pwm:setRGB(data)
end

