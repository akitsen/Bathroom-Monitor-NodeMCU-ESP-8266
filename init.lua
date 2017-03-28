-- init.lua --

-- Network Variables
ssid = "LogicMonitor"
pass = "L0g1cm0n"

-- Configure Wireless Internet
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')


-- Set static ip.
wifi.sta.setip({ip="10.41.11.6",netmask="255.255.255.0",gateway="10.41.11.1"})
--wifi.sta.setip({ip="10.36.11.200",netmask="255.255.255.0",gateway="10.36.11.1"})

-- Configure WiFi
-- wifi.sta.config(ssid,pass)

dofile("main.lua")
