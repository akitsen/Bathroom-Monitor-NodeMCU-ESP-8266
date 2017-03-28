-- main.lua --
-- SET PIN
pin=1

-- Pics
pooping = "https://i.ytimg.com/vi/9Txk0zlbYi4/maxresdefault.jpg"
occupied = "https://ryanboland.com/images/rpi-rails-occupancy-detector-v1-0/occupancy_detector_occupied-e98868ef.png"
redSquare = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Red.svg/2000px-Red.svg.png"

greenSquare = "http://i.imgur.com/J4oTdXB.png?1"
not_pooping = "http://www.wingclips.com/system/movie-clips/forrest-gump/run-forrest-run/images/forrest-gump-movie-clip-screenshot-run-forrest-run_large.jpg"
lm_logo = "https://s.graphiq.com/sites/default/files/1553/media/images/LogicMonitor_Hosted_Monitoring_Service_1741466.png"
ukrainianFlag = "http://emojipedia-us.s3.amazonaws.com/cache/69/53/695374e18c0ab77ac7bfb95244125c15.png"

-- Connect 
print('\nRunning main.lua\n')
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to an Access Point...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      tmr.stop(0)
   end
end)

hitCounter = 1

 -- Start a simple http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
    print(payload)

    -- SETUP Sensor
    gpio.mode(1,gpio.INPUT, gpio.PULLUP)
    readPin=gpio.read(pin)
    print(readPin)


    -- Header
    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n')
    conn:send('<html>\n')
    conn:send('<head><meta  content="text/html; charset=utf-8">\n')
    conn:send('<title>LogicMonitor Restroom Occupancy Monitor</title></head>\n')

    conn:send('<h1>LogicMonitor Restroom Occupancy Monitor</h1> <p2> <i> Please refresh the page to get current bathroom occupancy </i> </p2>\n')

    -- if sensor is triggered (0) , bathroom is in use.
    if readPin == 0 then
      conn:send("<h3> <b> Sorry, someone is already using the restroom. Try again in a few minutes. </b> </h3>")
      conn:send('<IMG SRC="'..occupied..'" WIDTH="400" HEIGHT="100"><br><br>\n')
      conn:send('<IMG SRC="'..pooping..'" WIDTH="400" HEIGHT="300" ><br><br>\n')
    end

    -- if sensor is open (1) , bathroom is free.
    if readPin == 1 then
      conn:send("<h3> <b> Bathroom stall is free !!! </b> </h3>")
      conn:send('<IMG SRC="'..not_pooping..'" WIDTH="600" HEIGHT="400" ><br><br>\n')
    end

    -- Footer 
    conn:send("<h10> <br><br>\n <i> Sponsored by UKRAINE IS NOT WEAK Inc. </i> </h10><br><br>\n")

    hitCounter = hitCounter + 1

    -- conn:send("<h10> <br><br>\n <a href="http://www.quick-counter.net/" title="HTML hit counter - Quick-counter.net"><img src="http://www.quick-counter.net/aip.php?tp=bb&tz=America%2FLos_Angeles" alt="HTML hit counter - Quick-counter.net" border="0" /></a> </h10><br><br>\n")
    conn:send("Page Hits Since Startup : ")
    conn:send(hitCounter / 2)

    conn:send('</html>\n')

  end)
  
  conn:on("sent",function(conn) conn:close() end)
end)
