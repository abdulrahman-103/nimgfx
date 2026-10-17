import src/nimgfx
import strutils, sequtils
discard initVideo()
let monitorSize: tuple[w: int32, h: int32] = getMonitorSize()
var window: Window = Window(title: "Browser", w: monitorSize.w div 2, h: monitorSize.h div 2)
window.create()
var renderer: Renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(true)
window.setResizable(true)
window.maximize()

var running: bool = true
  
const amiri: string = "src/resources/Amiri-Regular.ttf"
var pageTitle: string
var buttons: seq[Button]

let splitters = {'(', ')', ' ', '\t', ':', ','}
proc split(text: string): seq[string] =
  var
    word = ""
    inQuotes = false
  for character in text:
    if character == '\"':
      inQuotes = not inQuotes
    elif character in splitters:
      if inQuotes:
        word.add(character)
      else:
        result.add(word)
        word = ""
    else:
      word.add(character)

proc convertSize(size: string, window: Window): float =
  var output: float
  if size.endsWith("vw"):
    output = size[0 .. ^3].parseFloat()
    output = (output / 100) * window.getSize().w.float32
  elif size.endsWith("vh"):
    output = size[0 .. ^3].parseFloat()
    output = (output / 100) * window.getSize().h.float32
  else:
    output = size.parseFloat()
  return output

proc parseWebContent(fileName: string): void =
  buttons = @[]
  for line in fileName.lines:
    let line = line.strip()
    let words = line.split().filterIt(it.len > 0)
    case words[0]:
    of "page":
      if "title" in words:
        pageTitle = words[words.find("title") + 1].strip(chars = {'\"'})

    of "h1":
      var
        x, y: float = 0
        text: Text
        color: Color = White
      if "text" in words:
        text = renderer.createText(words[words.find("text") + 1], amiri, 32, color)
      if "x" in words:
        x = words[words.find("x") + 1].parseFloat
      if "y" in words:
        y = words[words.find("y") + 1].parseFloat
      
    of "button":
      var
        x, y, w, h: float
        text: Text
        color: Color
      if "text" in words:
        text = renderer.createText(words[words.find("text") + 1], amiri, 20, White)
      if "x" in words:
        x = words[words.find("x") + 1].convertSize(window)
      if "y" in words:
        y = words[words.find("y") + 1].convertSize(window)
      if "w" in words:
        w = words[words.find("w") + 1].convertSize(window)
      if "h" in words:
        h = words[words.find("h") + 1].convertSize(window)
      let button = Button(x: x, y: y, w: w, h: h, text: text)
      buttons.add(button)

parseWebContent("site")
window.setTitle(window.title & " | " & pageTitle)

while running:
  parseWebContent("site")
  var event: Event
  while pollEvent(event):
    case event.type
    of QuitEvent:
      running = false
    else:
      discard

  renderer.clear(Black)
  renderer.drawButtons(buttons)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()