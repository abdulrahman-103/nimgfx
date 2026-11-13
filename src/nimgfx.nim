import sdl3, sdl3_ttf, sdl3_image, sdl3_mixer, math, tables, nimgfx/[keys, vectors]
export keys, vectors

discard setHint(HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY, "1")

type 
  Window* = ref object
    title*: string
    flags*: WindowFlags = WINDOW_HIGH_PIXEL_DENSITY
    sdlWindow*: sdl3.Window = nil

  Renderer* = ref object
    window*: Window
    sdlRenderer*: sdl3.Renderer = nil
    textEngine: TextEngine

  Color* = object
    r*, g*, b*, a*: uint8

  Font* = sdl3_ttf.Font

  Text* = object
    sdlText: ptr sdl3_ttf.Text
    x*, y*: float32

  Event* = sdl3.Event

  Rect* = object
    x*, y*: float32 = 0
    w*, h*: float32
    fromOutside: bool = false

  Circle* = object
    x*, y*: float32 = 0
    radius*: float32

  Point* = FPoint

  Pixel* = object
    x*, y*: float32
    color*: Color

  AudioPlayer* = Mixer

  Image* = object
    texture*: Texture
    x*, y*: float32 = 0
    w*, h*: float32

  MouseButton* = enum
    mouseLeftButton = BUTTON_LEFT
    mouseMiddleButton = BUTTON_MIDDLE
    mouseRightButton = BUTTON_RIGHT
    mouseBackButton = BUTTON_X1
    mouseForwardButton = BUTTON_X2

  MouseButtonMask* = enum
    mouseLeftButtonMask = BUTTON_LMASK
    mouseMiddleButtonMask = BUTTON_MMASK
    mouseRightButtonMask = BUTTON_RMASK
    mouseBackButtonMask = BUTTON_X1MASK
    mouseForwardButtonMask = BUTTON_X2MASK

  Texture* = sdl3.Texture

  Button* = ref object
    text*: Text
    rect*: Rect
    color*: Color = Color(r: 49, g: 54, b: 59, a: 255)
    downColor*: Color = Color(r: 47, g: 83, b: 104, a: 255)
    borderColor*: Color = Color(r: 77, g: 80, b: 83, a: 255)
    borderHoverColor*: Color = Color(r: 61, g: 174, b: 233, a: 255)

  TextEdit* = ref object
    text*: Text
    w*, h*, x*, y*: float32 = 0
    color*: Color = Color(r: 49, g: 54, b: 59, a: 255)
    downColor*: Color = Color(r: 47, g: 83, b: 104, a: 255)
    borderColor*: Color = Color(r: 77, g: 80, b: 83, a: 255)
    borderHoverColor*: Color = Color(r: 61, g: 174, b: 233, a: 255)
    fromOutside: bool = false

type 
  TextureAccess* = sdl3.TextureAccess
const  
  TextureAccessStatic*: TextureAccess = TEXTUREACCESS_STATIC
  TextureAccessStreaming*: TextureAccess = TEXTUREACCESS_STREAMING
  TextureAccessTarget*: TextureAccess = TEXTUREACCESS_TARGET

type
  RendererScaleMode* = RendererLogicalPresentation
const
  NoScaling*: RendererLogicalPresentation = LOGICAL_PRESENTATION_DISABLED
  StretchScaling*: RendererLogicalPresentation = LOGICAL_PRESENTATION_STRETCH
  LetterboxScaling*: RendererLogicalPresentation = LOGICAL_PRESENTATION_LETTERBOX
  OverscanScaling*: RendererLogicalPresentation = LOGICAL_PRESENTATION_OVERSCAN
  IntegerScaling*: RendererLogicalPresentation = LOGICAL_PRESENTATION_INTEGER_SCALE

type
  TextureScaleMode* = ScaleMode
const
  Nearest*: ScaleMode = SCALEMODE_NEAREST
  Linear*: ScaleMode = SCALEMODE_LINEAR
  Pixelart*: ScaleMode = SCALEMODE_PIXELART
    
const 
  QuitEvent*: EventType = EVENT_QUIT
  KeyDownEvent*: EventType = EVENT_KEY_DOWN
  KeyUpEvent*: EventType = EVENT_KEY_UP
  MouseButtonDownEvent*: EventType = EVENT_MOUSE_BUTTON_DOWN
  MouseButtonUpEvent*: EventType = EVENT_MOUSE_BUTTON_UP
  MouseWheelEvent*: EventType = EVENT_MOUSE_WHEEL
  WindowResizeEvent*: EventType = EVENT_WINDOW_RESIZED
  WindowMaximizeEvent*: EventType = EVENT_WINDOW_MAXIMIZED
  WindowMinimizeEvent*: EventType = EVENT_WINDOW_MINIMIZED
  WindowLeaveFullscreenEvent*: EventType = EVENT_WINDOW_LEAVE_FULLSCREEN
  WindowFocusGainedEvent*: EventType = EVENT_WINDOW_FOCUS_GAINED
  WindowFocusLostEvent*: EventType = EVENT_WINDOW_FOCUS_LOST

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

proc initVideo*(): bool =
  sdl3.init(INIT_VIDEO)

proc initAudio*(): bool =
  if sdl3.init(INIT_AUDIO):
    return sdl3_mixer.init()
  else:
    return false

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

proc getMonitorSize*(): tuple[w, h: int32] =
  let monitor: ptr DisplayMode = getCurrentDisplayMode(getPrimaryDisplay())
  if monitor != nil:
    return (monitor.w, monitor.h)
  else:
    echo "SDL Error: ", getError() 
    return (0, 0)

proc scaleFactor*(window: Window): float32 =
  return getDisplayContentScale(getDisplayForWindow(window.sdlWindow))

proc create*(window: Window): void =
  window.sdlWindow = createWindow(window.title.cstring, 0, 0, window.flags)

proc setSize*(window: Window; w, h: int32): void =
  discard setWindowSize(window.sdlWindow, w.int32, h.int32)

proc getSize*(window: Window): tuple[w, h: int32] =
  var w: int32
  var h: int32
  if getWindowSize(window.sdlWindow, w, h): 
    (w, h)
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

proc setTitle*(window: Window, title: string): void =
  discard setWindowTitle(window.sdlWindow, title)

proc setFullscreen*(window: Window, state: bool): void =
  discard setWindowFullscreen(window.sdlWindow, state)

proc maximize*(window: Window): void =
  discard maximizeWindow(window.sdlWindow)

proc minimize*(window: Window): void =
  discard minimizeWindow(window.sdlWindow)

proc setResizable*(window: Window, state: bool): void =
  discard setWindowResizable(window.sdlWindow, state)

proc setAspectRatio*(window: Window; min, max: float32): void =
  discard setWindowAspectRatio(window.sdlWindow, min, max)

proc setLogicalPixels*(renderer: Renderer; w, h: int, mode: RendererScaleMode): void =
  discard setRenderLogicalPresentation(renderer.sdlRenderer, w.cint, h.cint, mode)

proc kill*(window: Window): void =
  destroyWindow(window.sdlWindow)

proc create*(renderer: Renderer): void =
  renderer.sdlRenderer = createRenderer(renderer.window.sdlWindow, nil)
  if sdl3_ttf.init():
    renderer.textEngine = createRendererTextEngine(renderer.sdlRenderer)
  else:
    echo "Couldn't initialize text"

proc setRenderColor(renderer: Renderer, color: Color): void =
  discard setRenderDrawColor(renderer.sdlRenderer, color.r, color.g, color.b, color.a)

proc clear*(renderer: Renderer, color: Color): void =
  renderer.setRenderColor(color)
  discard renderClear(renderer.sdlRenderer)

proc renderPixel*(renderer: Renderer, pixel: Pixel): void =
  renderer.setRenderColor(pixel.color)
  discard renderPoint(renderer.sdlRenderer, pixel.x, pixel.y)

proc renderPixels*(renderer: Renderer, pixels: openArray[Pixel]): void =
  for pixel in pixels:
    renderer.setRenderColor(pixel.color)
    discard renderPoint(renderer.sdlRenderer, pixel.x, pixel.y)

proc renderLine*(renderer: Renderer, point1: Vector2[float32], point2: Vector2[float32], color: Color): void =
  renderer.setRenderColor(color)
  discard renderLine(renderer.sdlRenderer, point1.x, point1.y, point2.x, point2.y)

proc renderLines*(renderer: Renderer, points: openArray[Vector2[float32]], color: Color): void =
  if points.len == 0: return
  renderer.setRenderColor(color)
  let pointsPtr: ptr UncheckedArray[FPoint] = cast[ptr UncheckedArray[FPoint]](points[points.low].addr)
  discard renderLines(renderer.sdlRenderer, toOpenArray(pointsPtr, points.low, points.high))

proc renderRect*(renderer: Renderer, rect: Rect, color: Color): void =
  renderer.setRenderColor(color)
  let sdlRect: FRect = FRect(x: rect.x, y: rect.y, w: rect.w, h: rect.h)
  discard renderFillRect(renderer.sdlRenderer, sdlRect)

proc renderHollowRect*(renderer: Renderer, rect: Rect, color: Color): void =
  renderer.renderLines([Vector2[float32](x: rect.x, y: rect.y), Vector2[float32](x: rect.x + rect.w, y: rect.y), Vector2[float32](x: rect.x + rect.w, y: rect.y + rect.h), Vector2[float32](x: rect.x, y: rect.y + rect.h), Vector2[float32](x: rect.x, y: rect.y)], color)

proc renderCircle*(renderer: Renderer, circle: Circle, color: Color, segments: int = 30): void =
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

proc waitEvent*(event: var Event): bool =
  sdl3.waitEvent(event)

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
  var x, y: float32
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

proc getMousePosition*(renderer: Renderer): tuple[x, y: float32] =
  var x, y: float32
  discard getMouseState(x, y)
  return (x.float32, y.float32)

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

type FontKey = tuple[path: string, size: float32]
var fontCache = initTable[FontKey, Font]()
proc loadFont(path: string, size: float32): Font =
  let cache: FontKey = (path, size)
  if cache notin fontCache:
    fontCache[cache] = openFont(path, size)
  return fontCache[cache]

proc kill*(font: Font): void =
  closeFont(font)

proc createText*(renderer: Renderer, text: string, fontPath: string, fontSize: float32, color: Color = White, x: float32 = 0, y: float32 = 0): Text =
  let font: Font = loadFont(fontPath, fontSize)
  let tempText: ptr sdl3_ttf.Text = createText(renderer.textEngine, font, text, 0)
  discard setTextColor(tempText, color.r, color.g, color.b, color.a)
  return Text(sdlText: tempText, x: x, y: y)

proc renderText*(renderer: Renderer, text: Text;): void =
  discard drawRendererText(text.sdlText, text.x, text.y)

proc renderTexts*(renderer: Renderer, texts: openArray[Text];): void =
  for text in texts:
    discard drawRendererText(text.sdlText, text.x, text.y)

proc renderDebugText*(renderer: Renderer, text: string; x, y: float32, color: Color): void =
  renderer.setRenderColor(color)
  discard renderDebugText(renderer.sdlRenderer, x, y, text)
  
proc createTexture*(renderer: Renderer, textureAccess: TextureAccess; w, h: int32): Texture =
  createTexture(renderer.sdlRenderer, PIXELFORMAT_RGBA32, textureAccess, w, h)

proc getSize*(texture: Texture): tuple[w, h: float32] =
  var w: float32
  var h: float32
  if getTextureSize(texture, w, h): 
    (w, h)
  else:
    (0, 0)

proc renderTexture*(renderer: Renderer, texture: Texture, x, y, w, h: float32 = 0) =
  var (w, h) = (w, h)
  if w == 0 or h == 0:
    (w, h) = texture.getSize()
  let dstrect: FRect = FRect(x: x, y: y, w: w, h: h)
  discard renderTexture(renderer.sdlRenderer, texture, nil, addr dstrect)

proc lock*(texture: Texture, pixels: var pointer, pitch: var int32) =
  discard sdl3.lockTexture(texture, nil, pixels, pitch)

proc unlock*(texture: Texture) =
  sdl3.unlockTexture(texture)

proc setTexturePixel(pixels: ptr UncheckedArray[uint8], pitch: int32, pixel: Pixel) =
  let position = pixel.y.int32 * pitch + pixel.x.int32 * 4
  pixels[position] = pixel.color.r
  pixels[position + 1] = pixel.color.g
  pixels[position + 2] = pixel.color.b
  pixels[position + 3] = pixel.color.a
  
proc setTexturePixel(pixels: ptr UncheckedArray[uint8], pitch, x, y: int32, pixel: Color) =
  let position: int32 = y * pitch + x * 4
  pixels[position] = pixel.r
  pixels[position + 1] = pixel.g
  pixels[position + 2] = pixel.b
  pixels[position + 3] = pixel.a

proc setPixel*(texture: Texture, pixel: Pixel) =
  var
    pixelsPtr: pointer
    pitch: int32
  texture.lock(pixelsPtr, pitch)
  let data = cast[ptr UncheckedArray[uint8]](pixelsPtr)
  setTexturePixel(data, pitch, pixel)
  unlockTexture(texture)

proc setPixels*(texture: Texture, pixels: openArray[Pixel]) =
  var
    pixelsPtr: pointer
    pitch: int32
  texture.lock(pixelsPtr, pitch)
  let data = cast[ptr UncheckedArray[uint8]](pixelsPtr)
  for pixel in pixels:
    setTexturePixel(data, pitch, pixel)
  unlockTexture(texture)

## Updates the texture with an array or a sequence of contiguous RGBA pixel data
proc update*(texture: Texture, pixels: openArray[Color]) =
  var
    pixelsPtr: pointer
    pitch: int32
  let (w, h): tuple[w: float32, h: float32] = texture.getSize()
  texture.lock(pixelsPtr, pitch)
  let data = cast[ptr UncheckedArray[uint8]](pixelsPtr)
  for y in 0'i32 ..< h.int32:
    for x in 0'i32 ..< w.int32:
      setTexturePixel(data, pitch, x, y, pixels[y * w.int32 + x])
  unlockTexture(texture)

proc setScaleMode*(texture: Texture, scaleMode: TextureScaleMode) =
  discard sdl3.setTextureScaleMode(texture, scaleMode)

proc getScaleMode*(texture: Texture, scaleMode: TextureScaleMode): TextureScaleMode =
  var scaleMode: ScaleMode
  discard sdl3.getTextureScaleMode(texture, scaleMode)
  scaleMode

proc setDefaultTextureScaleMode*(renderer: Renderer, scaleMode: TextureScaleMode) =
  discard sdl3.setDefaultTextureScaleMode(renderer.sdlRenderer, scaleMode)

proc getDefaultTextureScaleMode*(renderer: Renderer): TextureScaleMode =
  var scaleMode: ScaleMode
  discard sdl3.getDefaultTextureScaleMode(renderer.sdlRenderer, scaleMode)
  scaleMode

proc kill*(text: Text): void =
  destroyText(text.sdlText)

proc loadImage*(renderer: Renderer, image: string): Image =
  let texture = loadTexture(renderer.sdlRenderer, image.cstring)
  if texture == nil:
    echo "Couldn't load image"
    sdl3.quit()
  var w, h: float32
  discard getTextureSize(texture, w, h)
  return Image(texture: texture, w: w, h: h)

proc renderImage*(renderer: Renderer, image: Image): void =
  let
    x = image.x
    y = image.y
  renderTexture(renderer, image.texture, x, y)

proc inside*(pos: tuple[x, y: float32], rect: Rect): bool =
  if pos.x >= rect.x and pos.x <= rect.x + rect.w and pos.y >= rect.y and pos.y <= rect.y + rect.h:
    return true
  else:
    return false

proc hovered*(rect: Rect, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if pos.x >= rect.x and pos.x <= rect.x + rect.w and pos.y >= rect.y and pos.y <= rect.y + rect.h:
    return true
  else:
    return false

proc down*(rect: Rect, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if down(mouseLeftButton) and not rect.fromOutside:
    if pos.x >= rect.x and pos.x <= rect.x + rect.w and pos.y >= rect.y and pos.y <= rect.y + rect.h:
      return true
    else:
      return false
  else:
    return false

proc down*(button: Button, renderer: Renderer): bool =
  down(button.rect, renderer)

proc pressed*(event: Event, rect: Rect, renderer: Renderer): bool =
  let pos = renderer.getMousePosition()
  if event.pressed(mouseLeftButton):
    if pos.x >= rect.x and pos.x <= rect.x + rect.w and pos.y >= rect.y and pos.y <= rect.y + rect.h:
      return true
    else:
      return false
  else:
    return false

proc pressed*(event: Event, button: Button, renderer: Renderer): bool =
  pressed(event, button.rect, renderer)

proc renderButton*(renderer: Renderer, button: Button): void =
  let mousePos = renderer.getMousePosition()
  if not mousePos.inside(button.rect) and mouseLeftButton.down():
    button.rect.fromOutside = true
  if not mouseLeftButton.down():
    button.rect.fromOutside = false
  var color: Color
  if down(button.rect, renderer):
    color = button.downColor
  else:
    color = button.color
  var borderColor: Color
  if hovered(button.rect, renderer):
    borderColor = button.borderHoverColor
  else:
    borderColor = button.borderColor
  renderer.renderRect(button.rect, color)
  renderer.renderHollowRect(Rect(x: button.rect.x, y: button.rect.y, w: button.rect.w, h: button.rect.h), borderColor)
  button.text.x = button.rect.x
  button.text.y = button.rect.y
  renderer.renderText(button.text)

proc renderButtons*(renderer: Renderer, buttons: openArray[Button]): void =
  for button in buttons:
    renderer.renderButton(button)

proc getTicksMS*(): uint64 =
  sdl3.getTicks()

proc getTicksNS*(): uint64 =
  sdl3.getTicksNS()

proc centerHRect*(rect: var Rect, window: Window, scale: float32 = 1) =
  rect.x = (window.getSize().w.float32 - rect.w * scale) / 2

proc centerVRect*(rect: var Rect, window: Window, scale: float32 = 1) =
  rect.y = (window.getSize().h.float32 - rect.h * scale) / 2

proc centerRect*(rect: var Rect, window: Window, scale: float32 = 1) =
  rect.x = (window.getSize().w.float32 - rect.w * scale) / 2
  rect.y = (window.getSize().h.float32 - rect.h * scale) / 2