import sdl3/[sdl3, sdl3_ttf, sdl3_image, sdl3_mixer], math
import nimgfx/[keys, vectors]
export keys, vectors

type 
  App = ref object
    window: Window
    renderer: Renderer
    running: bool

  Window* = ref object
    title*: string
    w*, h*: int32
    flags*: WindowFlags = 0
    sdlWindow*: sdl3.Window = nil

  Renderer* = ref object
    window*: Window
    sdlRenderer*: sdl3.Renderer = nil
    textEngine: TextEngine

  Color* = object
    r*, g*, b*, a*: uint8

  Font* = sdl3_ttf.Font

  Text* = ptr sdl3_ttf.Text

  Event* = sdl3.Event

  Rect* = object
    x*, y*: float = 0
    w*, h*: float
    color*: Color

  Circle* = object
    x*, y*: float = 0
    radius*: float

  AudioPlayer* = Mixer

  Image* = object
    texture*: Texture
    x*, y*: float = 0
    w*, h*: float
  
  ScalingMode* = RendererLogicalPresentation

  MouseButton* = enum
    mouseLeftButton = BUTTON_LEFT
    mouseMiddleButton = BUTTON_MIDDLE
    mouseRightButton = BUTTON_RIGHT
    mouseBackButton = BUTTON_X1
    mouseForwardButton = BUTTON_X2

  MouseButtonMask = enum
    mouseLeftButtonMask = BUTTON_LMASK
    mouseMiddleButtonMask = BUTTON_MMASK
    mouseRightButtonMask = BUTTON_RMASK
    mouseBackButtonMask = BUTTON_X1MASK
    mouseForwardButtonMask = BUTTON_X2MASK


  Button* = ref object
    text*: Text
    w*, h*, x*, y*: float
    color*: Color
    fromOutside: bool = false

const
  NoScaling* = LOGICAL_PRESENTATION_DISABLED
  StretchScaling* = LOGICAL_PRESENTATION_STRETCH
  LetterboxScaling* = LOGICAL_PRESENTATION_LETTERBOX
  OverscanScaling* = LOGICAL_PRESENTATION_OVERSCAN
  IntegerScaling* = LOGICAL_PRESENTATION_INTEGER_SCALE
    
const 
  QuitEvent*: EventType = EVENT_QUIT
  KeyDownEvent*: EventType = EVENT_KEY_DOWN
  KeyUpEvent*: EventType = EVENT_KEY_UP
  MouseButtonDownEvent*: EventType = EVENT_MOUSE_BUTTON_DOWN
  MouseButtonUpEvent*: EventType = EVENT_MOUSE_BUTTON_UP


const Red*: Color = Color(r: 255, g: 0, b: 0, a: 255)
const Green*: Color = Color(r: 0, g: 255, b: 0, a: 255)
const Blue*: Color = Color(r: 0, g: 0, b: 255, a: 255)
const White*: Color = Color(r: 255, g: 255, b: 255, a: 255)
const Black*: Color = Color(r: 0, g: 0, b: 0, a: 255)
const Gray*: Color = Color(r: 128, g: 128, b: 128, a: 255)
const Cyan*: Color = Color(r: 0, g: 255, b: 255, a: 255)
const Magenta*: Color = Color(r: 255, g: 0, b: 255, a: 255)
const Yellow*: Color = Color(r: 255, g: 255, b: 0, a: 255)
const Orange*: Color = Color(r: 255, g: 127, b: 0, a: 255)
const Brown*: Color = Color(r: 139, g: 69, b: 19, a: 255)

proc create*(window: Window): void =
  window.sdlWindow = createWindow(window.title.cstring, window.w.int32, window.h.int32, window.flags)

proc setSize*(window: Window; w, h: int32): void =
  discard setWindowSize(window.sdlWindow, w.int32, h.int32)

proc getSize*(window: Window): tuple[w, h: int32] =
  var w: int32
  var h: int32
  if getWindowSize(window.sdlWindow, w, h): 
    (w.int32, h.int32)
  else:
    (0, 0)

proc setPosition*(window: Window; x, y: int32): void =
  discard setWindowPosition(window.sdlWindow, x.int32, y.int32)

proc getPosition*(window: Window): tuple[x, y: int32] =
  var x: int32
  var y: int32
  if getWindowPosition(window.sdlWindow, x, y): 
    (x.int32, y.int32)
  else:
    (0, 0)

proc setFullscreen*(window: Window, state: bool): void =
  discard setWindowFullscreen(window.sdlWindow, state)

proc setResizable*(window: Window, state: bool): void =
  discard setWindowResizable(window.sdlWindow, state)

proc setAspectRatio*(window: Window; min, max: float): void =
  discard setWindowAspectRatio(window.sdlWindow, min, max)

proc setLogicalPixels*(renderer: Renderer; w, h: int, mode: ScalingMode): void =
  discard setRenderLogicalPresentation(renderer.sdlRenderer, w.cint, h.cint, mode)

proc kill*(window: Window): void =
  destroyWindow(window.sdlWindow)

proc create*(renderer: Renderer): void =
  renderer.sdlRenderer = createRenderer(renderer.window.sdlWindow, nil)
  if sdl3_ttf.init():
    renderer.textEngine = createRendererTextEngine(renderer.sdlRenderer)
  else:
    echo "Couldn't initialize text"

proc setDrawColor*(renderer: Renderer, color: Color): void =
  discard setRenderDrawColor(renderer.sdlRenderer, color.r, color.g, color.b, color.a)

proc clear*(renderer: Renderer, color: Color): void =
  renderer.setDrawColor(color)
  discard renderClear(renderer.sdlRenderer)

proc drawPoint*(renderer: Renderer, point: Vector2, color: Color): void =
  renderer.setDrawColor(color)
  discard renderPoint(renderer.sdlRenderer, point.x, point.y)

proc drawPoints*(renderer: Renderer, points: openArray[Vector2], color: Color): void =
  if points.len == 0: return
  renderer.setDrawColor(color)
  let pointsPtr: ptr UncheckedArray[FPoint] = cast[ptr UncheckedArray[FPoint]](points[points.low].addr)
  discard renderPoints(renderer.sdlRenderer, toOpenArray(pointsPtr, points.low, points.high))

proc drawLine*(renderer: Renderer, point1: Vector2, point2: Vector2, color: Color): void =
  renderer.setDrawColor(color)
  discard renderLine(renderer.sdlRenderer, point1.x, point1.y, point2.x, point2.y)

proc drawLines*(renderer: Renderer, points: openArray[Vector2], color: Color): void =
  if points.len == 0: return
  renderer.setDrawColor(color)
  let pointsPtr: ptr UncheckedArray[FPoint] = cast[ptr UncheckedArray[FPoint]](points[points.low].addr)
  discard renderLines(renderer.sdlRenderer, toOpenArray(pointsPtr, points.low, points.high))

proc drawRect*(renderer: Renderer, rect: Rect): void =
  renderer.setDrawColor(rect.color)
  let sdlRect: FRect = FRect(x: rect.x, y: rect.y, w: rect.w, h: rect.h)
  discard renderFillRect(renderer.sdlRenderer, sdlRect)

proc drawRects*(renderer: Renderer, rects: openArray[Rect]): void =
  for rect in rects:
    drawRect(renderer, rect)

proc drawHollowRect*(renderer: Renderer, rect: Rect): void =
  renderer.drawLines([Vector2(x: rect.x, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y)], rect.color)

proc drawHollowRects*(renderer: Renderer, rects: openArray[Rect]): void =
  if rects.len == 0: return
  for rect in rects:
    renderer.drawLines([Vector2(x: rect.x, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y)], rect.color)

proc drawCircle*(renderer: Renderer, circle: Circle, color: Color, segments: int = 30): void =
  var vertices = newSeq[Vertex](segments + 1)
  let vertexColor = FColor(
    r: color.r.float32 / 255,
    g: color.g.float32 / 255,
    b: color.b.float32 / 255,
    a: color.a.float32 / 255)
  vertices[0] = Vertex(position: FPoint(x: circle.x, y: circle.y), color: vertexColor)
  for i in 0 ..< segments:
    let angle = 2.0'f32 * PI.float32 * i.float32 / segments.float32
    vertices[i + 1] = Vertex(position: FPoint(x: circle.x + cos(angle) * circle.radius, y: circle.y + sin(angle) * circle.radius), color: vertexColor)
  var indices = newSeq[cint](segments * 3)
  for i in 0 ..< segments:
    indices[i * 3] = 0
    indices[i * 3 + 1] = cint(i+1)
    indices[i * 3 + 2] = cint((i+1) mod segments + 1)
  discard renderGeometry(renderer.sdlRenderer, nil, addr vertices[0], vertices.len.cint, addr indices[0], indices.len.cint)

proc setVSync*(renderer: Renderer, state: bool): void =
  discard setRenderVSync(renderer.sdlRenderer, state.int32)

proc render*(renderer: Renderer): void =
  discard renderPresent(renderer.sdlRenderer)

proc kill*(renderer: Renderer): void =
  destroyRendererTextEngine(renderer.textEngine)
  destroyRenderer(renderer.sdlRenderer)

proc quit*(): void =
  sdl3.quit()

proc pollEvent*(event: var Event): bool =
  sdl3.pollEvent(event)

proc pressed*(event: Event, key: Key): bool =
  if event.type == KeyDownEvent:
    return event.key.scancode == key and not event.key.repeat

proc released*(event: Event, key: Key): bool =
  if event.type == KeyUpEvent:
    return event.key.scancode == key

proc down*(key: Key): bool =
  var numKeys: int32
  return getKeyboardState(numKeys)[ord(key)]

proc pressed*(event: Event, button: MouseButton): bool =
  if event.type == MouseButtonDownEvent:
    return MouseButton(event.button.button) == button

proc released*(event: Event, button: MouseButton): bool =
  if event.type == MouseButtonUpEvent:
    return MouseButton(event.button.button) == button

proc down*(button: MouseButton): bool =
  var x, y: cfloat
  let state = getMouseState(x, y)
  case button:
  of mouseLeftButton:
    if (state and uint32(mouseLeftButtonMask)) != 0:
      return true
  of mouseRightButton:
    if (state and uint32(mouseRightButtonMask)) != 0:
      return true
  of mouseMiddleButton:
    if (state and uint32(mouseMiddleButtonMask)) != 0:
      return true
  of mouseBackButton:
    if (state and uint32(mouseBackButtonMask)) != 0:
      return true
  of mouseForwardButton:
    if (state and uint32(mouseForwardButtonMask)) != 0:
      return true

proc getMousePosition*(renderer: Renderer): tuple[x, y: float] =
  var x, y: cfloat
  discard getMouseState(x, y)
  discard renderCoordinatesFromWindow(renderer.sdlRenderer, x, y, x, y)
  return (x.float, y.float)

proc createAudioPlayer*(): AudioPlayer =
  if sdl3_mixer.init():
    let mixer: Mixer = createMixerDevice(AUDIO_DEVICE_DEFAULT_PLAYBACK, nil)
    if mixer == nil:
      echo "Couldn't create audio player"
      sdl3.quit()
    else:
      return mixer
  else:
    echo "Couldn't initialize audio"
    sdl3.quit()
  
proc loadAudio*(audioPlayer: AudioPlayer, path: string): Audio =
  sdl3_mixer.loadAudio(audioPlayer, path, true)

proc playAudio*(audioPlayer: AudioPlayer, audio: Audio): void =
  discard sdl3_mixer.playAudio(audioPlayer, audio)

proc stopAudio*(audioPlayer: AudioPlayer): void =
  discard sdl3_mixer.stopAllTracks(audioPlayer, 0)

proc loadFont*(path: string, size: float): Font =
  openFont(path, size)

proc kill*(font: Font): void =
  closeFont(font)

proc createText*(renderer: Renderer, text: string, font: Font, color: Color): Text =
  let tempText = createText(renderer.textEngine, font, text, 0)
  discard setTextColor(tempText, color.r, color.g, color.b, color.a)
  return tempText

proc drawText*(renderer: Renderer, text: Text; x, y: float32): void =
  discard drawRendererText(text, x, y)

proc drawDebugText*(renderer: Renderer, text: string; x, y: float32, color: Color): void =
  renderer.setDrawColor(color)
  discard renderDebugText(renderer.sdlRenderer, x, y, text)
  
proc kill*(text: Text): void =
  destroyText(text)

proc loadImage*(renderer: Renderer, image: string): Image =
  let texture = loadTexture(renderer.sdlRenderer, image.cstring)
  if texture == nil:
    echo "Couldn't load image"
    sdl3.quit()
  var w, h: cfloat
  discard getTextureSize(texture, w, h)
  return Image(texture: texture, w: w, h: h)

proc drawImage*(renderer: Renderer, image: Image): void =
  var dstrect: FRect
  dstrect.x = image.x
  dstrect.y = image.y
  dstrect.w = image.w
  dstrect.h = image.h
  discard renderTexture(renderer.sdlRenderer, image.texture, nil, addr dstrect)

proc inside*(pos: tuple[x, y: float], button: Button): bool =
  if pos.x >= button.x and pos.x <= button.x + button.w and pos.y >= button.y and pos.y <= button.y + button.h:
    return true
  else:
    return false

proc hovered*(button: Button, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if pos.x >= button.x and pos.x <= button.x + button.w and pos.y >= button.y and pos.y <= button.y + button.h:
    return true
  else:
    return false

proc down*(button: Button, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if down(mouseLeftButton) and not button.fromOutside:
    if pos.x >= button.x and pos.x <= button.x + button.w and pos.y >= button.y and pos.y <= button.y + button.h:
      return true
    else:
      return false
  else:
    return false

proc pressed*(event: Event, button: Button, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if event.pressed(mouseLeftButton):
    if pos.x >= button.x and pos.x <= button.x + button.w and pos.y >= button.y and pos.y <= button.y + button.h:
      return true
    else:
      return false
  else:
    return false

proc drawButton*(renderer: Renderer, button: Button): void =
  let mousePos = renderer.getMousePosition()
  if not mousePos.inside(button) and mouseLeftButton.down():
    button.fromOutside = true
  if not mouseLeftButton.down():
    button.fromOutside = false
  var color: Color
  if down(button, renderer):
    color = Color(r: 47, g: 83, b: 104, a: 255)
  else:
    color = Color(r: 49, g: 54, b: 59, a: 255)
  var borderColor: Color
  if button.hovered(renderer):
    borderColor = Color(r: 61, g: 174, b: 233, a: 255)
  else:
    borderColor = Color(r: 77, g: 80, b: 83, a: 255)
  renderer.drawRect(Rect(x: button.x, y: button.y, w: button.w, h: button.h, color: color))
  renderer.drawHollowRect(Rect(x: button.x, y: button.y, w: button.w, h: button.h, color: borderColor))
  renderer.drawText(button.text, button.x, button.y)

proc getTicksMS*(): uint64 =
  sdl3.getTicks()

proc getTicksNS*(): uint64 =
  sdl3.getTicksNS()