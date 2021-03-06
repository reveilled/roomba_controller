function finish_startup()
	sntp.sync()
    dofile("roomba_serial.lua")
    dofile("mqtt_command.lua")
    dofile("telnet.lua")
    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
    end

function wifi_connect()

	ssid = getconfigvalue("ssid")
	wifi_password = getconfigvalue("wifikey")
	hostname = getconfigvalue("hostname")

    --print ("Connecting to "..ssid.." as "..hostname)
    wifi.setmode(wifi.STATION)    
    wifi_config = {}
    wifi_config.ssid = getconfigvalue("ssid")
    wifi_config.pwd = getconfigvalue("wifikey")
    hostname = getconfigvalue("hostname")

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, finish_startup)
    wifi.sta.sethostname(hostname)
    wifi.sta.config(wifi_config)
    end    

function daily_restart()
	roomba_serial_disable()
	node.restart()
--	hours_ticked = hours_ticked + 1
--	if hours_ticked >= 24 then
--		node.restart()
--	end
end

function startup()
    node.setcpufreq(node.CPU160MHZ)
	--restart every 24 hours
	cron.schedule("0 13 * * *", daily_restart)
--	tmr.register(6,3600000,tmr.ALARM_AUTO, daily_restart )
--	tmr.start(6)
	dofile("config.lua")
	loadconfig("config.json")
    wifi_connect()
    end

hours_ticked = 0
tmr.alarm(0,5000,0,startup)
