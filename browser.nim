import src/nimgfx
import strutils, sequtils, asyncnet, asyncdispatch
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
var backgroundColor = Black
var pageTitle: string
var buttons: seq[Button]
var texts: seq[Text]

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
  texts = @[]
  for line in fileName.lines:
    let line = line.strip()
    let words = line.split().filterIt(it.len > 0)
    case words[0]:
    of "page":
      if "title" in words:
        pageTitle = words[words.find("title") + 1].strip(chars = {'\"'})

    of "h1", "h2", "h3", "h4", "h5", "h6":
      var
        x, y: float32 = 0
        textSize: float32 = 12
        text: Text
        color: Color = White
      if "text" in words:
        var textSize: float32
        case words[0]:
        of "h1":
          textSize = 32
        of "h2":
          textSize = 24
        of "h3":
          textSize = 19
        of "h4":
          textSize = 16
        of "h5":
          textSize = 13
        of "h6":
          textSize = 11
        text = renderer.createText(words[words.find("text") + 1], amiri, textSize, color)
        if "x" in words:
          text.x = words[words.find("x") + 1].parseFloat
        if "y" in words:
          text.y = words[words.find("y") + 1].parseFloat
        texts.add(text)
      
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
      let button = Button(rect: Rect(x: x, y: y, w: w, h: h), text: text)
      buttons.add(button)

parseWebContent("site")
window.setTitle(window.title & " | " & pageTitle)

while running:
  var event: Event
  while pollEvent(event):
    case event.type
    of QuitEvent:
      running = false
    of WindowResizeEvent:
      parseWebContent("site")
    else:
      discard

  renderer.clear(backgroundColor)
  renderer.drawButtons(buttons)
  renderer.drawTexts(texts)
  renderer.render()

renderer.kill()
window.kill()
nimgfx.quit()