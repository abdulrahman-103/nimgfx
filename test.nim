import src/nimgfx

var window: Window = Window(title: "test", w: 500, h: 500)
window.create()
var renderer: Renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(On)

var running = true

var rect: Rect
rect.x = 300
rect.y = 100
rect.w = 50
rect.h = 50

proc down(rect: var Rect, distance: cfloat) =
  rect.y += distance

proc up(rect: var Rect, distance: cfloat) =
  rect.y -= distance

proc right(rect: var Rect, distance: cfloat) =
  rect.x += distance

proc left(rect: var Rect, distance: cfloat) =
  rect.x -= distance

if not init(InitVideo):
  echo "Couldn't initialize SDL"

while running:

  var event: Event
  while pollEvent(event):
    case event.type
    of quitEvent:
      running = false
    else:
      discard

    if event.pressed(Escape):
        running = false
    if event.pressed(Down):
      rect.down(10)
    if event.pressed(Up):
      rect.up(10)
    if event.pressed(Right):
      rect.right(10)    
    
  if Left.down():
    rect.left(10)
  
  renderer.clear(Red)
  renderer.setDrawColor(Green)
  renderer.drawRect(rect, Green)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()