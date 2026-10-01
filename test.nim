import src/nimgfx

if not initVideo():
  echo "Couldn't Initialize Video"
  quit(1)

if not initText():
  echo "Couldn't Initialize Text"
  quit(1)


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
  
let amiri: Font = loadFont("/usr/share/fonts/amiri-fonts/Amiri-Regular.ttf", 40)
let helloWorld: Text = renderer.createText("hello world", amiri, Blue)
let tux: Image = renderer.loadImage("tux.png")
let audioPlayer = createAudioPlayer()
let pushBox = audioPlayer.loadAudio("/home/abdulrahman/the_grandfather_paradox/box/push_box.wav")

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
      rect2.down(10)
    if event.pressed(Up):
      rect2.up(10)
    if event.pressed(Right):
      rect2.right(10)
    if event.pressed(Left):
      audioPlayer.playAudio(pushBox)
    
  if down(Left):
    rect2.left(1)
  else:
      audioPlayer.stopAudio()
  
  renderer.clear(Red)
  renderer.drawText(helloWorld, 50, 50)
  renderer.drawRect(rect, Green)
  renderer.drawHollowRects([rect2, rect3], Blue)
  renderer.drawDebugText("hello world", 200, 200, Black)
  renderer.drawImage(tux, 250, 50)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()