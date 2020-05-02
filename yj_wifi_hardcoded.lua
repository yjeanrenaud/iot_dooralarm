 print "--- yj_wifi_hardcoded.lua ---"
local SSID = "SSID"  
local SSID_PASSWORD = "PASSWORD"  
-- configure ESP as a station  
wifi.setmode(wifi.STATION)  
-- wifi.sta.config(SSID,SSID_PASSWORD)  
station_cfg={}
station_cfg.ssid=SSID
station_cfg.pwd=SSID_PASSWORD
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)

--while wifi.sta.status() ==  wifi.STA_CONNECTING do
--   tmr.alarm(0,5000,alar.single,print("connecting..."))
--end
--if wifi.sta.status() == wifi.STA_GOTIP then
--   print("Connected - Starting Timer") 
   --tmr.alarm(0,5000,1,do_next)
--end
