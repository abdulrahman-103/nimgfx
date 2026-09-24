import sdl3
export sdl3
import nimgfx/keys
export keys

type 
  App = ref object
    window: SDL_Window
    renderer: SDL_Renderer
    running: bool

  Window* = ref object
    title*: string
    w*, h*: int32
    flags*: SDL_WindowFlags = 0
    sdlWindow*: SDL_Window = nil

  Renderer* = ref object
    window*: Window
    sdlRenderer*: SDL_Renderer = nil

type
  Color* = object
    r*, g*, b*, a*: uint8
    
  Rect* = SDL_FRect

  Event* = SDL_Event

type InitFlags* = SDL_InitFlags
const
  InitAudio*: uint32 = SDL_INIT_AUDIO
  InitVideo*: uint32 = SDL_INIT_VIDEO
  InitJoystick*: uint32 = SDL_INIT_JOYSTICK
  InitHaptic*: uint32 = SDL_INIT_HAPTIC
  InitGamepad*: uint32 = SDL_INIT_GAMEPAD
  InitEvents*: uint32 = SDL_INIT_EVENTS
  InitSensor*: uint32 = SDL_INIT_SENSOR
  InitCamera*: uint32 = SDL_INIT_CAMERA
    
const 
  On*: cint = 1
  Off*: cint = 0
  quitEvent*: SDL_EventType = SDL_EVENT_QUIT
  keyDownEvent*: SDL_EventType = SDL_EVENT_KEY_DOWN
  keyUpEvent*: SDL_EventType = SDL_EVENT_KEY_UP

const Red*: Color = Color(r: 255, g: 0, b: 0, a: 255)
const Green*: Color = Color(r: 0, g: 255, b: 0, a: 255)
const Blue*: Color = Color(r: 0, g: 0, b: 255, a: 255)
const White*: Color = Color(r: 255, g: 255, b: 255, a: 255)
const Black*: Color = Color(r: 0, g: 0, b: 0, a: 255)

proc create*(window: Window): void =
  window.sdlWindow = SDL_CreateWindow(window.title.cstring, window.w.cint, window.h.cint, window.flags)

proc create*(renderer: Renderer): void =
  renderer.sdlRenderer = SDL_CreateRenderer(renderer.window.sdlWindow, nil)

proc setDrawColor*(renderer: Renderer, color: Color): void =
  SDL_SetRenderDrawColor(renderer.sdlRenderer, color.r, color.g, color.b, color.a)

proc clear*(renderer: Renderer, color: Color): void =
  renderer.setDrawColor(color)
  SDL_RenderClear(renderer.sdlRenderer)

proc drawRect*(renderer: Renderer, rect: Rect, color: Color): void =
  renderer.setDrawColor(color)
  SDL_RenderFillRect(renderer.sdlRenderer, rect)

proc setVSync*(renderer: Renderer, state: cint): void =
  SDL_SetRenderVSync(renderer.sdlRenderer, state)

proc render*(renderer: Renderer): void =
  SDL_RenderPresent(renderer.sdlRenderer)

proc kill*(renderer: Renderer): void =
  SDL_DestroyRenderer(renderer.sdlRenderer)

proc kill*(window: Window): void =
  SDL_DestroyWindow(window.sdlWindow)

proc quit*(): void =
  SDL_Quit()

proc pollEvent*(event: var Event): bool =
  SDL_PollEvent(event)

proc pressed*(event: Event, key: Key): bool =
  if event.type == keyDownEvent:
    return event.key.scancode == key and not event.key.repeat

proc released*(event: Event, key: Key): bool =
  if event.type == keyUpEvent:
    return event.key.scancode == key

proc down*(key: Key): bool =
  var numKeys: cint
  return SDL_GetKeyboardState(numKeys)[ord(key)]

proc init*(flags: InitFlags): bool =
  SDL_Init(flags)