import src/nimgfx

var window: Window = Window(title: "test", w: 500, h: 500)
window.create()
window.setFullscreen(true)

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
  
let amiri: Font = loadFont("/usr/share/fonts/amiri-fonts/Amiri-Regular.ttf", 22)
let helloWorld: Text = renderer.createText("hello world", amiri, Blue)
var tux: Image = renderer.loadImage("tux.png")
tux.x = 200
window.setResizable(true)
let button = Button(x: 50, y: 50, w: 100, h: 40, text: helloworld, color: Red)

while running:
  var event: Event
  while pollEvent(event):
    case event.type
    of QuitEvent:
      running = false
    else:
      discard

  renderer.clear(Black)
  renderer.drawImage(tux)
  renderer.drawButton(button)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()