import src/nimgfx

var window: Window = Window(title: "test", w: 500, h: 500)
window.create()

var renderer: Renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(true)

var running: bool = true

var background: Rect
background.x = 0
background.y = 0
background.w = 500
background.h = 500
background.color = White


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
  
let amiri: Font = loadFont("/usr/share/fonts/amiri-fonts/Amiri-Regular.ttf", 22)
let helloWorld: Text = renderer.createText("hello world", amiri, Blue)
var tux: Image = renderer.loadImage("tux.png")
tux.x = 200
let audioPlayer = createAudioPlayer()
let pushBox = audioPlayer.loadAudio("/home/abdulrahman/the_grandfather_paradox/box/push_box.wav")
var circle = Circle(x: 50, y: 50, radius: 50)
let button = Button(x: 50, y: 50, w: 100, h: 40, text: helloworld, color: Red)
window.setResizable(true)
renderer.setScaling(500, 500, LetterboxScaling)

while running:
  var event: Event
  while pollEvent(event):
    case event.type
    of QuitEvent:
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
    if event.pressed(button, renderer):
      if background.color == White:
        background.color = Red
      else:
        background.color = White

    
  if down(Left):
    circle.left(1)
  else:
      audioPlayer.stopAudio()
  
  renderer.clear(Black)
  renderer.drawRect(background)
  renderer.drawImage(tux)
  renderer.drawButton(button)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()