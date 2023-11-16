data = {}
math.randomseed(os.time())
wind = 50
windDir = 0
cDirection = ""
burned = 0
burning = 0
trend = 0
selected = {62,62}
paused = true
day =1
hour = 1
resolution = {100,5}
function numToCompass(num)
  val=math.floor((num/22.5)+.5)
  arr={"N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"}
  return (arr[(val % 16) + 1])
end
function love.draw()
  burned = 0
  burning = 0
  if love.keyboard.isDown("up") then
    selected[2]=selected[2] - 1
  elseif love.keyboard.isDown("down") then 
    selected[2]=selected[2] + 1
  elseif love.keyboard.isDown("right") then 
    selected[1]=selected[1] + 1
  elseif love.keyboard.isDown("left") then
    selected[1] = selected[1] - 1
  elseif love.keyboard.isDown("e") then --extinguish
    data[selected[1]+1][selected[2]+1].fireIntensity = 0
    data[selected[1] + 2][selected[2]+1].fireIntensity = 0
    data[selected[1]+1][selected[2] + 2].fireIntensity = 0
    data[selected[1] + 2][selected[2] + 2].fireIntensity = 0
  elseif love.keyboard.isDown("f") then --ignite
    data[selected[1]+1][selected[2]+1].fireIntensity=data[selected[1]+1][selected[2]+1].fireIntensity+ 5
    data[selected[1] + 2][selected[2]+1].fireIntensity=data[selected[1]+2][selected[2]+1].fireIntensity+ 5
    data[selected[1]+1][selected[2] + 2].fireIntensity=data[selected[1]+1][selected[2]+2].fireIntensity+ 5
    data[selected[1] + 2][selected[2] + 2].fireIntensity=data[selected[1]+2][selected[2]+2].fireIntensity+ 5
  elseif love.keyboard.isDown("a") then --add fuel
    data[selected[1]+1][selected[2]+1].fuel = data[selected[1]+1][selected[2]+1].fuel+10
    data[selected[1] + 2][selected[2]+1].fuel = data[selected[1] + 2][selected[2]+1].fuel+10
    data[selected[1]+1][selected[2] + 2].fuel = data[selected[1]+1][selected[2] + 2].fuel + 10
    data[selected[1] + 2][selected[2] + 2].fuel = data[selected[1] + 2][selected[2] + 2].fuel + 10
  elseif love.keyboard.isDown("c") then --clear fuel
    data[selected[1]+1][selected[2]+1].fuel = 0
    data[selected[1] + 2][selected[2]+1].fuel = 0
    data[selected[1]+1][selected[2] + 2].fuel = 0
    data[selected[1] + 2][selected[2] + 2].fuel = 0
  elseif love.keyboard.isDown(".") then --reset
    for i = 1, resolution[1] do 
      for j = 1, resolution[1] do
        data[i][j].fuel = 100
        data[i][j].fireIntensity = 0
      end
    end
  
  elseif love.keyboard.isDown("r") then --rain - decrease fire intensity, increase fuel
    for i = 1, resolution[1] do 
      for j = 1, resolution[1] do
        itData = data[i][j]
        if (itData.fireIntensity > 0) then
          itData.fireIntensity = itData.fireIntensity - 20
          if (itData.fireIntensity < 0) then
            itData.fireIntensity = 0
          end
        end
        if (itData.fuel < 100) then
          itData.fuel = itData.fuel + math.floor(math.random(5,10))
          if (itData.fuel > 100) then
            itData.fuel = 100
          end
        end
        data[i][j] = itData
      end
    end
  elseif love.keyboard.isDown("s") then --spawn fires
    ranLoc = {math.random(30,70), math.random(30,70)}
    data[ranLoc[1]][ranLoc[2]].fireIntensity = 5
  elseif love.keyboard.isDown("[") then
    wind = wind - 1
  elseif love.keyboard.isDown("]") then
    wind = wind + 1
  elseif love.keyboard.isDown("9") then
    windDir = windDir - 10
    if (windDir < 0) then
      windDir = 360 - windDir
    end
  elseif love.keyboard.isDown("0") then
    windDir = windDir + 10
    if (windDir > 360) then
      windDir = windDir - 360
    end
  elseif love.keyboard.isDown("space") then
    print(paused)
    paused = not paused
  end
  if (selected[1] < 0) then
    selected[1] = 0
  end
  if (selected[2] < 0) then
    selected[2] = 0
  end
  if (selected[2] > resolution[1]-2) then
    selected[2] = resolution[1]-2
  end
  if (selected[1] > resolution[1]-2) then
    selected[1] = resolution[1]-2
  end
  if (paused == false) then
    for i = 1, resolution[1] do 
      for j = 1, resolution[1] do
        itData = data[i][j]    
        if itData.fireIntensity ~= 0 then
          if itData.fireIntensity > itData.fuel then
            itData.fireIntensity = itData.fireIntensity - math.random(1,3)
          else
            itData.fireIntensity = itData.fireIntensity + math.random(1)+ ((wind/30 ))
          end
          if itData.fireIntensity > 100 then
            itData.fireIntensity = 100
          end        
          if itData.fireIntensity < 0 then
            itData.fireIntensity = 0
          end
          
          itData.fuel=itData.fuel-itData.fireIntensity / 50
          if itData.fuel < 0 then
            itData.fireIntensity = 0
          end
          if itData.fuel > 100 then
            itData.fuel = 100
          end
          data[i][j] = itData
          if math.random(1,45) < (((wind/8 ))+1) + (itData.fireIntensity/50) and itData.fireIntensity > 30 then
            loc = math.floor(math.random(1,4))
            chloc = {-5,-5}
            if (cDirection == "N") then
              if (loc == 1) then
                chLoc = {i-1, j-1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i, j-1}
              else
                chloc = {i+1, j-1}
              end
            elseif (cDirection == "NNE") then
              if (loc == 1 or loc == 2) then
                chLoc = {i, j-1}
              elseif (loc == 4) then
                chloc = {i+1, j-1}
              else
                chloc = {i+1, j}
              end
            elseif (cDirection == "NE") then
              if (loc == 1) then
                chLoc = {i, j-1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i+1, j-1}
              else
                chloc = {i+1, j}
              end
            elseif (cDirection == "ENE") then
              if (loc == 1 or loc == 4) then
                chLoc = {i+1, j}
              elseif (loc == 2) then
                chloc = {i+1, j-1}
              else
                chloc = {i, j-1}
              end
            elseif (cDirection == "E") then
              if (loc == 1) then
                chLoc = {i+1,j-1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i+1, j}
              else
                chloc = {i+1, j+1}
              end
            elseif (cDirection == "ESE") then
              if (loc == 1 or loc == 4) then
                chLoc = {i+1, j}
              elseif (loc == 2) then
                chloc = {i+1, j+1}
              else
                chloc = {i, j+1}
              end
            elseif (cDirection == "SE") then
              if (loc == 1) then
                chLoc = {i+1, j}
              elseif (loc == 2 or loc == 4) then
                chloc = {i+1, j+1}
              else
                chloc = {i, j+1}
              end
            elseif (cDirection == "SSE") then
              if (loc == 1 or loc== 4) then
                chLoc = {i-1, j+1}
              elseif (loc == 2) then
                chloc = {i, j+1}
              else
                chloc = {i+1, j+1}
              end
            elseif (cDirection == "S") then
              if (loc == 1) then
                chLoc = {i-1, j+1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i, j+1}
              else
                chloc = {i+1, j+1}
              end
            elseif (cDirection == "SSW") then
              if (loc == 1 or loc == 2) then
                chLoc = {i, j+1}
              elseif (loc == 4) then
                chloc = {i-1, j+1}
              else
                chloc = {i-1, j}
              end
            elseif (cDirection == "SW") then
              if (loc == 1) then
                chLoc = {i, j+1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i-1, j+1}
              else
                chloc = {i-1, j}
              end
            elseif (cDirection == "WSW") then
              if (loc == 1) then
                chLoc = {i-1, j+1}
              elseif (loc == 4) then
                chloc = {i-1, j}
              else
                chloc = {i-1, j-1}
              end
            elseif (cDirection == "W") then
              if (loc == 1) then
                chLoc = {i-1, j+1}
              elseif (loc == 2 or loc == 4) then
                chloc = {i-1, j}
              else
                chloc = {i-1, j-1}
              end
            elseif (cDirection == "WNW") then
              if (loc == 1 or loc == 2) then
                chLoc = {i-1, j}
              elseif (loc == 4) then
                chloc = {i-1, j-1}
              else
                chloc = {i, j-1}
              end
            elseif (cDirection == "NW") then
              if (loc == 1) then
                chLoc = {i-1, j}
              elseif (loc == 2 or loc == 4) then
                chloc = {i-1, j-1}
              else
                chloc = {i, j-1}
              end
            elseif (cDirection == "NNW") then
              if (loc == 1) then
                chLoc = {i-1, j}
              elseif (loc == 2) then
                chloc = {i-1, j-1}
              else
                chloc = {i, j-1}
              end
            end
            if math.floor(math.random(0,80-(itData.fireIntensity/40))) == 0 then
              chloc = {i+math.floor(math.random(-1,1)), j+math.floor(math.random(-1,1))}
            end
            
            if (chloc[1] > 0 and chloc[1] <= resolution[1] and chloc[2] > 0 and chloc[2] <= resolution[1]) then
              if (data[chloc[1]][chloc[2]].fuel > 0) then
                data[chloc[1]][chloc[2]].fireIntensity= data[chloc[1]][chloc[2]].fireIntensity + 5
              end
            end
          end
        end
        if itData.fireIntensity > 0 then
          love.graphics.setColor(255,255-(255.0 * (itData.fireIntensity/100)),63)
          burning = burning + 1
        else
          love.graphics.setColor(114+(30.0 * (itData.fuel/100)), 100+(150.0 * (itData.fuel/100)), 110+(10.0 * (itData.fuel/100)))
          if itData.fuel < 100 then
            burned = burned + 1
          end
        end
        love.graphics.rectangle("fill", (i-1) * resolution[2], (j-1) * resolution[2], resolution[2], resolution[2])    
      end
    end
    if (math.random(1,3) == 3) then
      math.randomseed(os.time())

      if (trend == -2) then
        windDir = windDir + math.random(-0.6,0)
      elseif (trned == -1) then
        windDir = windDir + math.random(-0.3, 0.1)
      elseif (trend == 0) then
        windDir = windDir + math.random(-0.3,0.3)
      elseif (trend == 1) then
        windDir = windDir + math.random(-0.1, 0.3)
      else
        windDir = windDir + math.random(0, 0.6)
      end
      if (math.random(1,5) == 1) then
        trend=trend+math.random(-2,2)
      end
      if (trend < -2) then
        trend = -2
      elseif (trend > 2) then
        trend = 2
      end
    end
    if (math.random(1,6) == 5) then
      wind = wind + math.floor(math.random(-2,2) +0.5)
    end
    if (wind < 0) then
      wind = 0
    end
  else
    for i = 1, resolution[1] do 
      for j = 1, resolution[1] do
        itData = data[i][j]   
        if itData.fireIntensity > 0 then
          love.graphics.setColor(255,255-(255.0 * (itData.fireIntensity/100)),63)
          burning = burning + 1
        else
          love.graphics.setColor(114+(30.0 * (itData.fuel/100)), 100+(150.0 * (itData.fuel/100)), 110+(10.0 * (itData.fuel/100)))
          if itData.fuel < 100 then
            burned = burned + 1
          end
        end
        love.graphics.rectangle("fill", (i-1) * resolution[2], (j-1) * resolution[2], resolution[2], resolution[2])   
      end
    end
  end
  love.graphics.setColor(0,0,0)
  love.graphics.print("Burned: " .. burned,25,510)
  love.graphics.print("Burning: " .. burning,155,510)
  love.graphics.print("Wind: " .. wind .. " " .. cDirection,285,510)
  love.graphics.print("FPS: " .. love.timer.getFPS(),420,510)
  love.graphics.print("Day " .. day,25,530)
  if (paused == false) then
    hour= hour + 1
    if (hour == 24)then
      day = day + 1
      hour = 1
    end
  end
  cDirection = numToCompass(windDir)
  love.graphics.rectangle("line", (selected[1]) * resolution[2], (selected[2]) * resolution[2], resolution[2] * 2, resolution[2] * 2)
  
end
function love.load()
  wind = math.random(0,100)
  windDir = math.random(0,360)
  trend = math.random(-2,2)
  cDirection = numToCompass(windDir)
  love.window.setMode(500, 570)
  love.window.setTitle("Wildfire Simulation")
  love.graphics.setBackgroundColor(255,255,255)
  for i = 1, resolution[1] do
    data[i] = {}
    for j = 1, resolution[1] do
      dat = {}
      dat.fuel = 100
      dat.fireIntensity = 0
      data[i][j] = dat
    end
  end
  love.graphics.setFont(love.graphics.newFont(18))
  ranLoc = {math.floor(math.random(resolution[1]/2-resolution[1]/4,resolution[1]/2-resolution[1]/4)), math.floor(math.random(resolution[1]/2-resolution[1]/4,resolution[1]/2-resolution[1]/4))}
  data[ranLoc[1]][ranLoc[2]].fireIntensity = 5
end
function love.mousepressed(x, y, button, istouch)
 if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    selected = {math.floor(x/resolution[2]),math.floor(y/resolution[2])}
    if (selected[1] < 0) then
      selected[1] = 0
    end
    if (selected[2] < 0) then
      selected[2] = 0
    end
    if (selected[2] > resolution[1]-2) then
      selected[2] = resolution[1]-2
    end
    if (selected[1] > resolution[1]-2) then
      selected[1] = resolution[1]-2
    end
  
 end
end