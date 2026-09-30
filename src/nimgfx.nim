import sdl3/[sdl3, sdl3_ttf, sdl3_image]
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

proc kill*(window: Window): void =
  destroyWindow(window.sdlWindow)

proc create*(renderer: Renderer): void =
  renderer.sdlRenderer = createRenderer(renderer.window.sdlWindow, nil)
  discard sdl3_ttf.init()
  renderer.textEngine = createRendererTextEngine(renderer.sdlRenderer)

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
  renderer.setDrawColor(color)
  discard renderFillRects(renderer.sdlRenderer, rects)

proc setVSync*(renderer: Renderer, state: bool): void =
  discard setRenderVSync(renderer.sdlRenderer, state.int32)

proc render*(renderer: Renderer): void =
  discard renderPresent(renderer.sdlRenderer)

proc kill*(renderer: Renderer): void =
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

proc initVideo*(): bool =
  sdl3.init(INIT_VIDEO)

proc initAudio*(): bool =
  sdl3.init(INIT_AUDIO)

proc initJoystick*(): bool =
  sdl3.init(INIT_JOYSTICK)

proc initHaptic*(): bool =
  sdl3.init(INIT_HAPTIC)

proc initGamepad*(): bool =
  sdl3.init(INIT_GAMEPAD)

proc initEvents*(): bool =
  sdl3.init(INIT_EVENTS)

proc initSensor*(): bool =
  sdl3.init(INIT_SENSOR)

proc initCamera*(): bool =
  sdl3.init(INIT_CAMERA)

proc initText*(): bool =
  sdl3_ttf.init()

var streams: seq[AudioStream] = @[]

proc playAudio*(path: string): void =
  var spec: AudioSpec
  var buffer: ptr uint8
  var length: uint32
  if loadWAV(path.cstring, addr spec, buffer, length):
    if streams.len > 0:
      for i in countdown(streams.high, 0):
        if getAudioStreamQueued(streams[i]) == 0:
          destroyAudioStream(streams[i])
          streams.delete(i)
    var stream: AudioStream = openAudioDeviceStream(AUDIO_DEVICE_DEFAULT_PLAYBACK, spec, nil, nil)
    streams.add(stream)
    discard putAudioStreamData(stream, buffer, length.int32)
    sdlFree(buffer)
    discard resumeAudioStreamDevice(stream)

proc createFont*(path: string, size: int): Font =
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