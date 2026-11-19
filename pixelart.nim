import src/nimgfx, os, math, nimPNG

discard initVideo()
let monitorSize: tuple[w: int32, h: int32] = getMonitorSize()
var window: Window = Window(title: "pixelart editor")
window.create()
window.setSize(w = monitorSize.w div 2, h = monitorSize.h div 2)
var renderer: Renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(true)
renderer.setDefaultTextureScaleMode(Pixelart)
window.setResizable(true)
window.maximize()

var running: bool = true
  
const amiri: string = "src/resources/Amiri-Regular.ttf"
var backgroundColor = colBlack
var pageTitle: string
var buttons: seq[Button]
var texts: seq[Text]

type 
  Canvas = object
    rect: Rect
    pixels: seq[Color]
    scale: float32 = 1

  Tool = enum
    pencil,
    eraser

proc `[]`(canvas: Canvas; x, y: int): Color =
  canvas.pixels[y * canvas.rect.w.int + x]

proc `[]=`(canvas: var Canvas; x, y: int, color: Color) =
  canvas.pixels[y * canvas.rect.w.int + x] = color

iterator lineBetween(v1, v2: Vector2[int]): tuple[x, y: int]=
  var
    dx = v2.x - v1.x
    dy = v2.y - v1.y
    xx, xy, yx, yy: int
  let
    xsign = if dx >= 0: 1 else: -1
    ysign = if dy >= 0: 1 else: -1
  dx = abs(dx)
  dy = abs(dy)
  if dx > dy:
    (xx, xy, yx, yy) = (xsign, 0, 0, ysign)
  else:
    (dx, dy) = (dy, dx)
    (xx, xy, yx, yy) = (0, ysign, xsign, 0)
  var
    D = 2 * dy - dx
    y = 0
  for x in 0 .. dx:
    yield (
      v1.x + x * xx + y * yx,
      v1.y + x * xy + y * yy)
    if D >= 0:
      inc y
      D -= 2 * dx
    D += 2 * dy

proc createCanvas(w, h: int): Canvas =
  let rect = Rect(x: 0, y: 0, w: w.float32, h: h.float32)
  var pixels = newSeq[Color](w * h)
  Canvas(rect: rect, pixels: pixels)

proc saveAsPNG(canvas: pointer; fileList: cstringArray; filter: cint) {.cdecl.} =
  if fileList == nil:
    echo "Dialog failed"
    return
  elif fileList[0] == nil:
    echo "Dialog cancelled"
    return

  var pixels: seq[uint8]
  let canvas = cast[ptr Canvas](canvas)
  for color in canvas.pixels:
    pixels.add(color.r)
    pixels.add(color.g)
    pixels.add(color.b)
    pixels.add(color.a)
  discard savePNG32($fileList[0], pixels, canvas.rect.w.int, canvas.rect.h.int)

proc fit(canvas: var Canvas, window: Window) =
  let
    windowSize = window.getSize
    windowW = windowSize.w.float32
    windowH = windowSize.h.float32
  if canvas.rect.w > canvas.rect.h:
    canvas.scale = windowW / canvas.rect.w
  else:
    canvas.scale = windowH / canvas.rect.h

var canvas = createCanvas(64, 64)
var canvasTexture: Texture = renderer.createTexture(TextureAccessStreaming, canvas.rect.w.int32, canvas.rect.h.int32)

for x in 0 ..< canvas.rect.w.int:
  for y in 0 ..< canvas.rect.h.int:
    canvas[x, y] = colWhite

var activeTool: Tool
var pencilColor: Color = colBlack
var maximizedBefore: bool = false
var previousMousePos: tuple[x: float32, y: float32] = renderer.getMousePosition()
var released: bool = true

let pencilButton = Button(rect: Rect(x: 0, y: 0, w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), text: createText(renderer, "قلم", amiri, 30))
let eraserButton = Button(rect: Rect(x: 0, y: 50 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), text: createText(renderer, "مساحة", amiri, 30))
let blackButton = Button(rect: Rect(x: 0, y: 100 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), color: colBlack)
let whiteButton = Button(rect: Rect(x: 0, y: 150 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), color: colWhite)
let redButton = Button(rect: Rect(x: 0, y: 200 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), color: colRed)
let greenButton = Button(rect: Rect(x: 0, y: 250 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), color: colGreen)
let blueButton = Button(rect: Rect(x: 0, y: 300 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), color: colBlue)
let saveButton = Button(rect: Rect(x: 0, y: 350 * window.scaleFactor(), w: 80 * window.scaleFactor(), h: 40 * window.scaleFactor()), text: createText(renderer, "حفظ", amiri, 30))
buttons.add(pencilButton)
buttons.add(eraserButton)
buttons.add(blackButton)
buttons.add(whiteButton)
buttons.add(redButton)
buttons.add(greenButton)
buttons.add(blueButton)
buttons.add(saveButton)

while running:
  var event: Event
  while pollEvent(event):
    case event.type
    of QuitEvent:
      running = false
    of MouseWheelEvent:
      canvas.scale += event.wheel.y * 2
      if canvas.scale < 0.00001:
        canvas.scale = 0.00001
    of MouseButtonDownEvent:
      discard
    of MouseButtonUpEvent:
      if event.released(mouseLeftButton):
        released = true
    of WindowMaximizeEvent:
      if not maximizedBefore:
        maximizedBefore = true
        canvas.fit(window)
    else:
      discard

    if event.pressed(pencilButton, renderer):
      activeTool = pencil
    if event.pressed(eraserButton, renderer):
      activeTool = eraser
    if event.pressed(blackButton, renderer):
      pencilColor = colBlack
    if event.pressed(whiteButton, renderer):
      pencilColor = colWhite
    if event.pressed(redButton, renderer):
      pencilColor = colRed
    if event.pressed(greenButton, renderer):
      pencilColor = colGreen
    if event.pressed(blueButton, renderer):
      pencilColor = colBlue
    if event.pressed(saveButton, renderer):
      saveFileDialog(window = window, callback = saveAsPNG, data = addr canvas)

  if mouseLeftButton.down():
    case activeTool:
    of pencil:
      var mousePos: tuple[x: float32, y: float32] = renderer.getMousePosition()
      let renderedCanvasRect = Rect(x: canvas.rect.x, y: canvas.rect.y, w: canvas.rect.w * canvas.scale, h: canvas.rect.h * canvas.scale)
      if mousePos.inside(renderedCanvasRect):
        let
          previous = Vector2[int](x: int((previousMousePos.x - canvas.rect.x) / canvas.scale), y: int((previousMousePos.y - canvas.rect.y) / canvas.scale))
          current = Vector2[int](x: int((mousePos.x - canvas.rect.x) / canvas.scale), y: int((mousePos.y - canvas.rect.y) / canvas.scale))
        if (abs(current.x - previous.x) > 1 or abs(current.y - previous.y) > 1) and not released:
          for pixel in lineBetween(previous, current):
            if pixel.x < 0 or pixel.x >= canvas.rect.w.int or pixel.y < 0 or pixel.y >= canvas.rect.h.int:
              continue
            canvas[pixel.x, pixel.y] = pencilColor
        else:
          let 
            x = int((mousePos.x - canvas.rect.x) / canvas.scale)
            y = int((mousePos.y - canvas.rect.y) / canvas.scale)
          canvas[x, y] = pencilColor
    of eraser:
      var mousePos: tuple[x: float32, y: float32] = renderer.getMousePosition()
      let renderedCanvasRect = Rect(x: canvas.rect.x, y: canvas.rect.y, w: canvas.rect.w * canvas.scale, h: canvas.rect.h * canvas.scale)
      if mousePos.inside(renderedCanvasRect):
        let
          previous = Vector2[int](x: int((previousMousePos.x - canvas.rect.x) / canvas.scale), y: int((previousMousePos.y - canvas.rect.y) / canvas.scale))
          current = Vector2[int](x: int((mousePos.x - canvas.rect.x) / canvas.scale), y: int((mousePos.y - canvas.rect.y) / canvas.scale))
        if (abs(current.x - previous.x) > 1 or abs(current.y - previous.y) > 1) and not released:
          for pixel in lineBetween(previous, current):
            if pixel.x < 0 or pixel.x >= canvas.rect.w.int or pixel.y < 0 or pixel.y >= canvas.rect.h.int:
              continue
            canvas[pixel.x, pixel.y] = default(Color)
        else:
          let 
            x = int((mousePos.x - canvas.rect.x) / canvas.scale)
            y = int((mousePos.y - canvas.rect.y) / canvas.scale)
          canvas[x, y] = default(Color)
    else:
      discard
    previousMousePos = renderer.getMousePosition()
    released = false
  
  renderer.clear(colBlack)
  canvas.rect.centerRect(window, scale = canvas.scale)
  canvasTexture.update(canvas.pixels)
  renderer.renderTexture(
    texture = canvasTexture,
    x = canvas.rect.x,
    y = canvas.rect.y,
    w = canvasTexture.getSize().w * canvas.scale,
    h = canvasTexture.getSize().h * canvas.scale)
  renderer.renderButtons(buttons)
  renderer.render()
renderer.kill()
window.kill()
nimgfx.quit()