import sdl3/[sdl3, sdl3_ttf, sdl3_image, sdl3_mixer]
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

  Rect* = FRect

  Circle* = object

  AudioPlayer* = Mixer

  Image* = object
    texture*: Texture
    w*, h*: float
  
  ScalingMode* = RendererLogicalPresentation

const
  NoScaling* = LOGICAL_PRESENTATION_DISABLED
  StretchScaling* = LOGICAL_PRESENTATION_STRETCH
  LetterboxScaling* = LOGICAL_PRESENTATION_LETTERBOX
  OverscanScaling* = LOGICAL_PRESENTATION_OVERSCAN
  IntegerScaling* = LOGICAL_PRESENTATION_INTEGER_SCALE
    
const 
  quitEvent*: EventType = EVENT_QUIT
  keyDownEvent*: EventType = EVENT_KEY_DOWN
  keyUpEvent*: EventType = EVENT_KEY_UP

const Red*: Color = Color(r: 255, g: 0, b: 0, a: 255)
const Green*: Color = Color(r: 0, g: 255, b: 0, a: 255)
const Blue*: Color = Color(r: 0, g: 0, b: 255, a: 255)
const White*: Color = Color(r: 255, g: 255, b: 255, a: 255)
const Black*: Color = Color(r: 0, g: 0, b: 0, a: 255)

proc create*(window: Window): void =
  window.sdlWindow = createWindow(window.title.cstring, window.w.int32, window.h.int32, window.flags)

proc setSize*(window: Window; w, h: int32): void =
  discard setWindowSize(window.sdlWindow, w.int32, h.int32)

proc getSize*(window: Window): array[2, int32] =
  var w: int32
  var h: int32
  if getWindowSize(window.sdlWindow, w, h): 
    [w.int32, h.int32]
  else:
    [0, 0]

proc setPosition*(window: Window; x, y: int32): void =
  discard setWindowPosition(window.sdlWindow, x.int32, y.int32)

proc getPosition*(window: Window): array[2, int32] =
  var x: int32
  var y: int32
  if getWindowPosition(window.sdlWindow, x, y): 
    [x.int32, y.int32]
  else:
    [0, 0]

proc setFullscreen*(window: Window, state: bool): void =
  discard setWindowFullscreen(window.sdlWindow, state)

proc setResizable*(window: Window, state: bool): void =
  discard setWindowResizable(window.sdlWindow, state)

proc setAspectRatio*(window: Window; min, max: float): void =
  discard setWindowAspectRatio(window.sdlWindow, min, max)

proc setScaling*(renderer: Renderer; w, h: int, mode: ScalingMode): void =
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

proc drawRect*(renderer: Renderer, rect: Rect, color: Color): void =
  renderer.setDrawColor(color)
  discard renderFillRect(renderer.sdlRenderer, rect)

proc drawRects*(renderer: Renderer, rects: openArray[Rect], color: Color): void =
  if rects.len == 0: return
  renderer.setDrawColor(color)
  discard renderFillRects(renderer.sdlRenderer, rects)

proc drawHollowRect*(renderer: Renderer, rect: Rect, color: Color): void =
  renderer.setDrawColor(color)
  renderer.drawLines([Vector2(x: rect.x, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y)], color)

proc drawHollowRects*(renderer: Renderer, rects: openArray[Rect], color: Color): void =
  if rects.len == 0: return
  renderer.setDrawColor(color)
  for rect in rects:
    renderer.drawLines([Vector2(x: rect.x, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y), Vector2(x: rect.x + rect.w, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y + rect.h), Vector2(x: rect.x, y: rect.y)], color)

proc drawCircle*(renderer: Renderer, circle: Circle, color: Color): void =
  renderer.setDrawColor(color)

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
  if event.type == keyDownEvent:
    return event.key.scancode == key and not event.key.repeat

proc released*(event: Event, key: Key): bool =
  if event.type == keyUpEvent:
    return event.key.scancode == key

proc down*(key: Key): bool =
  var numKeys: int32
  return getKeyboardState(numKeys)[ord(key)]

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

proc loadFont*(path: string, size: int): Font =
  openFont(path, 50)

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

proc drawImage*(renderer: Renderer, image: Image; x, y: float): void =
  var dstrect: Rect
  dstrect.x = x
  dstrect.y = y
  dstrect.w = image.w
  dstrect.h = image.h
  discard renderTexture(renderer.sdlRenderer, image.texture, nil, addr dstrect)
