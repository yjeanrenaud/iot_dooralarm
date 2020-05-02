print "--- yj_dooralarm.lua ---"
--globals
buzzerpin = 1
switchpin = 5
--miliseconds before we start alterting
graceperiod = 5000 --in milliseconds!
--how often to check for the open door
checkInterval = 1000 --in milliseconds!
-- do not horn between these hours 
quietHourStart=18
quietHourStop=7
timzoneUTCoffset=1
buzzAlarmSet=false
---------------------------SETUP------------------
--setup gpios
gpio.mode(buzzerpin,gpio.OUTPUT)
gpio.mode(switchpin,gpio.INPUT)
--setup the led
pwm.setup (8,1,512) --10 Hz, half duty cicle
pwm.setup (6,1,512)
pwm.setup (7,1,512)
--go online
dofile("yj_wifi_hardcoded.lua")
-- now go and get time
tmr.alarm(1,1000, 1, function() if wifi.sta.getip()==nil then print(" Wait for IP address!") else print("New IP address is "..wifi.sta.getip()) tmr.stop(1) end end)
--nslookup
sk = net.createConnection(net.TCP, 0)
sk:dns("de.pool.ntp.org", function(conn, ip) print(ip) end)
sk = nil
--ntp sync setip. it continues to sync though
sntp.sync(ip,
  function(sec, usec, server, info)
    print('sync', sec, usec, server)
  end,
  function()
   print('failed!')
  end
,1)

function blink(state)
    if state == true then
        pwm.start(8)
        --pwm.start(6)
        pwm.start(7)
    else if state == false then
        pwm.stop(8)
        --pwm.stop(6)
        pwm.stop(7)
        end
    end
end

function buzzer (state)
    -- DEPRECIATED tmr.delay(graceperiod*1000) --microseconds
    if state == true then
		if buzzAlarmSet == false then
			tmr.alarm(graceperiod,tmr.ALARM_SINGLE,gpio.write(buzzerpin,gpio.LOW))
			--led_glow()
			buzzAlarmSet = true
			tmr.alarm(graceperiod+2000,tmr.ALARM_SINGLE, function turnoff() buzzAlarmSet = false end)
		end
    else if state == false then
		if buzzAlarmSet == false then
			tmr.alarm(graceperiod,tmr.alarm_SINGLE,gpio.write(buzzerpin,gpio.HIGH))
			buzzAlarmSet = true
			tmr.alarm(graceperiod+2000,tmr.ALARM_SINGLE, function turnoff() buzzAlarmSet = false end)
        end
    end
end

function checking()
    open = gpio.read(switchpin)
    print ("switchpin is ",open)
    
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d wday %02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"], tm["wday"]))
    print("hour= ",tm["hour"]+timzoneUTCoffset)
    print("wday= ",tm["wday"])
    if tm["year"] == 1970 then --we are still at the unix epoch
        print ("wait for sntp sync")
    else --we got time
        --print ("we got time!")
        if open == 1 then --gpio pulled up
		    -- DEPRECIATED tmr.delay(graceperiod*1000) --microseconds
            if (tm["hour"]+timzoneUTCoffset) < quietHourStart and (tm["hour"]+timzoneUTCoffset) >= quietHourStop then
                buzzer(true)
            end
            blink(true)
            --print ("peeeep")
        else do
			buzzer(false)
            blink(false)
            --print ("out")
            end
        end
    end
end

tmr.create():alarm(checkInterval, tmr.ALARM_AUTO, checking)

--while true do --endless main loop
--
--end
