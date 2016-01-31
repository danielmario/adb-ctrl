my = {
  scale = 0.75,
  key = '',
  mouse = {
    pressed = false,
    x = 0,
    y = 0,
    dx = 0,
    dy = 0,
  },
  time = 0,
}

function love.load()
  local font = love.graphics.newFont(32)
  love.graphics.setFont(font)
  my.image = love.graphics.newImage(love.image.newImageData(450,768))
  my.shell = io.popen('cat >> commands', 'w')
end

function love.update()
  pcall(function ()
    my.image = love.graphics.newImage('screen.png')
  end)
  collectgarbage('collect')
end

function love.draw()
  love.graphics.scale(my.scale, my.scale)
  love.graphics.draw(my.image)
  -- love.graphics.print(tostring(my.mouse.x) .. ',' .. tostring(my.mouse.y), 10, 10)
  -- love.graphics.print(my.key, 10, 40)
end

function love.keyreleased(key)
  my.key = key
  local keycode = key
  if key == 'escape' then
    keycode = 'POWER'
  end
  if key == 'insert' then
    keycode = 'MENU'
  end
  if key == 'pageup' then
    keycode = 'BACK'
  end
  if key == 'backspace' then
    keycode = 'DEL'
  end
  if key == 'return' then
    keycode = 'ENTER'
  end
  if key == 'pagedn' then
  end
  my.shell:write('input keyevent ', keycode:upper(), '\n')
  my.shell:flush()
end

function love.mousepressed(x, y, button, istouch)
  my.mouse.pressed = true
  my.mouse.x = math.floor(x/my.scale)
  my.mouse.y = math.floor(y/my.scale)
  my.mouse.dx = 0
  my.mouse.dy = 0
  my.shell:write('sendevent /dev/input/event1 3 57 14', '\n')
  my.shell:write('sendevent /dev/input/event1 3 53 ', ('%d\n'):format(my.mouse.x))
  my.shell:write('sendevent /dev/input/event1 3 54 ', ('%d\n'):format(my.mouse.y))
  my.shell:write('sendevent /dev/input/event1 3 58 57\n')
  my.shell:write('sendevent /dev/input/event1 0 0 0\n')
  my.shell:flush()
end

function love.mousereleased(x, y, button, istouch)
  my.mouse.pressed = false
  my.mouse.x = math.floor(x/my.scale)
  my.mouse.y = math.floor(y/my.scale)
  my.mouse.dx = 0
  my.mouse.dy = 0
  my.shell:write('sendevent /dev/input/event1 3 53 ', ('%d\n'):format(my.mouse.x))
  my.shell:write('sendevent /dev/input/event1 3 54 ', ('%d\n'):format(my.mouse.y))
  my.shell:write('sendevent /dev/input/event1 3 57 4294967295\n')
  my.shell:write('sendevent /dev/input/event1 0 0 0\n')
  my.shell:flush()
end

function love.mousemoved(x, y, dx, dy)
  my.mouse.x = math.floor(x/my.scale)
  my.mouse.y = math.floor(y/my.scale)
  my.mouse.dx = my.mouse.dx + math.abs(dx)
  my.mouse.dy = my.mouse.dy + math.abs(dy)
  if my.mouse.pressed and (my.mouse.dx > 9 or my.mouse.dy > 9) then
    my.mouse.dx = 0
    my.mouse.dy = 0
    my.shell:write('sendevent /dev/input/event1 3 53 ', ('%d\n'):format(my.mouse.x))
    my.shell:write('sendevent /dev/input/event1 3 54 ', ('%d\n'):format(my.mouse.y))
    my.shell:write('sendevent /dev/input/event1 3 58 57\n')
    my.shell:write('sendevent /dev/input/event1 0 0 0\n')
    my.shell:flush()
  end
end
