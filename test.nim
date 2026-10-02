import src/nimgfx

var window: Window = Window(title: "test", w: 500, h: 500)
window.create()

var renderer: Renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(true)

var running: bool = true

var rect: Rect
rect.x = 0
rect.y = 0
rect.w = 500
rect.h = 500

var rect2: Rect
rect2.x = 100
rect2.y = 150
rect2.w = 50
rect2.h = 50

var rect3: Rect
rect3.x = 120
rect3.y = 120
rect3.w = 50
rect3.h = 70

proc down(rect: var Rect, distance: cfloat) =
  rect.y += distance
proc up(rect: var Rect, distance: cfloat) =
  rect.y -= distance
proc right(rect: var Rect, distance: cfloat) =
  rect.x += distance
proc left(rect: var Rect, distance: cfloat) =
  rect.x -= distance

proc down(circle: var Circle, distance: cfloat) =
  circle.y += distance
proc up(circle: var Circle, distance: cfloat) =
  circle.y -= distance
proc right(circle: var Circle, distance: cfloat) =
  circle.x += distance
proc left(circle: var Circle, distance: cfloat) =
  circle.x -= distance
  
let amiri: Font = loadFont("/usr/share/fonts/amiri-fonts/Amiri-Regular.ttf", 40)
let helloWorld: Text = renderer.createText("hello world", amiri, Blue)
let tux: Image = renderer.loadImage("tux.png")
let audioPlayer = createAudioPlayer()
let pushBox = audioPlayer.loadAudio("/home/abdulrahman/the_grandfather_paradox/box/push_box.wav")
var circle = Circle(x: 50, y: 50, radius: 50)

window.setResizable(true)
renderer.setScaling(500, 500, LetterboxScaling)

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
      circle.down(10)
    if event.pressed(Up):
      circle.up(10)
    if event.pressed(Right):
      circle.right(10)
    if event.pressed(Left):
      audioPlayer.playAudio(pushBox)
    let pos = event.getMousePosition()
    if event.pressed(mouseLeftButton):
      if pos.x >= rect2.x and pos.x <= rect2.x + rect2.w and pos.y >= rect2.y and pos.y <= rect2.y + rect2.h:
        echo "مربع"
    
  if down(Left):
    circle.left(1)
  else:
      audioPlayer.stopAudio()
  
  renderer.clear(Red)
  renderer.drawRect(rect, Green)
  renderer.drawRect(rect2, Blue)
  renderer.drawDebugText("hello world", 200, 200, Black)
  renderer.drawImage(tux, 250, 50)
  renderer.drawText(helloWorld, 50, 50)
  renderer.drawCircle(circle, Brown)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()