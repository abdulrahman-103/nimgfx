import sdl3
export sdl3
type 
  App = ref object
    window: SDL_Window
    renderer: SDL_Renderer
    running: bool

  Window* = ref object
    title*: cstring
    w*, h*: cint
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

  Key* = SDL_Scancode
    
const 
  On*: cint = 1
  Off*: cint = 0
  quitEvent*: SDL_EventType = SDL_EVENT_QUIT
  keyDownEvent*: SDL_EventType = SDL_EVENT_KEY_DOWN

const
  Left*: SDL_Scancode = SDL_SCANCODE_LEFT
  Right*: SDL_Scancode = SDL_SCANCODE_RIGHT
  Up*: SDL_Scancode = SDL_SCANCODE_UP
  Down*: SDL_Scancode = SDL_SCANCODE_DOWN


const red*: Color = Color(r: 255, g: 0, b: 0, a: 255)
const green*: Color = Color(r: 0, g: 255, b: 0, a: 255)
const blue*: Color = Color(r: 0, g: 0, b: 255, a: 255)
const white*: Color = Color(r: 255, g: 255, b: 255, a: 255)
const black*: Color = Color(r: 0, g: 0, b: 0, a: 255)

proc create*(window: Window): void =
  window.sdlWindow = SDL_CreateWindow(window.title, window.w, window.h, window.flags)

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

proc down*(key: Key): bool =
  var numKeys: cint
  return SDL_GetKeyboardState(numKeys)[ord(key)]