import math

type Vector2* = object
  x*, y*: float32

proc normalize*(v: var Vector2) =
  let length = sqrt(v.x * v.x + v.y * v.y)
  if length != 0:
    v.x /= length
    v.y /= length

proc normalized*(v: Vector2): Vector2 =
  result = v
  result.normalize()


proc zero*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: 0)

proc one*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 1, y: 1)

proc right*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 1, y: 0)

proc left*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: -1, y: 0)

proc up*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: -1)

proc down*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: 1)

# negate
proc `-`*(v: Vector2): Vector2 =
  Vector2(x: -v.x, y: -v.y)

# addition
proc `+`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x + b.x, y: a.y + b.y)

proc `+=`*(a: var Vector2, b: Vector2) =
  a.x += b.x
  a.y += b.y


# subtraction
proc `-`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x - b.x, y: a.y - b.y)

proc `-=`*(a: var Vector2, b: Vector2) =
  a.x -= b.x
  a.y -= b.y


# multiplication
proc `*`*(v: Vector2, f: float32): Vector2 =
  Vector2(x: v.x * f, y: v.y * f)

proc `*`*(f: float32, v: Vector2): Vector2 =
  v * f

proc `*`*(i: int, v: Vector2): Vector2 =
  v * float32(i)

proc `*`*(v: Vector2, i: int): Vector2 =
  v * float32(i)

proc `*`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x * b.x, y: a.y * b.y)

proc `*=`*(v: var Vector2, f: float32) =
  v.x *= f
  v.y *= f

proc `*=`*(v: var Vector2, i: int) =
  v *= float32(i)

proc `*=`*(a: var Vector2, b: Vector2) =
  a.x *= b.x
  a.y *= b.y

# division
proc `/`*(v: Vector2, f: float32): Vector2 =
  Vector2(x: v.x / f, y: v.y / f)

proc `/`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x / b.x, y: a.y / b.y)

proc `/=`*(v: var Vector2, f: float32) =
  v.x /= f
  v.y /= f

proc `/=`*(a: var Vector2, b: Vector2) =
  a.x /= b.x
  a.y /= b.y




type Vector2i* = object
  x*, y*: int32

proc zero*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: 0, y: 0)

proc one*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: 1, y: 1)

proc right*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: 1, y: 0)

proc left*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: -1, y: 0)

proc up*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: 0, y: -1)

proc down*(T: typedesc[Vector2i]): Vector2i =
  Vector2i(x: 0, y: 1)

# negate
proc `-`*(v: Vector2i): Vector2i =
  Vector2i(x: -v.x, y: -v.y)

# addition
proc `+`*(a, b: Vector2i): Vector2i =
  Vector2i(x: a.x + b.x, y: a.y + b.y)

proc `+=`*(a: var Vector2i, b: Vector2i) =
  a.x += b.x
  a.y += b.y


# subtraction
proc `-`*(a, b: Vector2i): Vector2i =
  Vector2i(x: a.x - b.x, y: a.y - b.y)

proc `-=`*(a: var Vector2i, b: Vector2i) =
  a.x -= b.x
  a.y -= b.y


# multiplication
proc `*`*(v: Vector2i, i: int32): Vector2i =
  Vector2i(x: v.x * i, y: v.y * i)

proc `*`*(i: int32, v: Vector2i): Vector2i =
  v * i

proc `*`*(a, b: Vector2i): Vector2i =
  Vector2i(x: a.x * b.x, y: a.y * b.y)

proc `*=`*(v: var Vector2i, i: int32) =
  v.x *= i
  v.y *= i

proc `*=`*(a: var Vector2i, b: Vector2i) =
  a.x *= b.x
  a.y *= b.y

# division
proc `div`*(v: Vector2i, f: int32): Vector2i =
  Vector2i(x: v.x div f, y: v.y div f)

proc `div`*(a, b: Vector2i): Vector2i =
  Vector2i(x: a.x div b.x, y: a.y div b.y)