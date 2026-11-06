import std/math

type Vector2*[T: SomeNumber] = object
  x*, y*: T

## negation
proc `-`*[T: SomeNumber](v: Vector2[T]): Vector2[T] =
  Vector2[T](x: -v.x, y: -v.y)

## addition
proc `+`*[T: SomeNumber](v1, v2: Vector2[T]): Vector2[T] =
  Vector2[T](x: v1.x + v2.x, y: v1.y + v2.y)

proc `+=`*[T: SomeNumber](v1: var Vector2[T], v2: Vector2[T]) =
  v1.x += v2.x
  v1.y += v2.y

## subtraction
proc `-`*[T: SomeNumber](v1, v2: Vector2[T]): Vector2[T] =
  Vector2[T](x: v1.x - v2.x, y: v1.y - v2.y)

proc `-=`*[T: SomeNumber](v1: var Vector2[T], v2: Vector2[T]) =
  v1.x -= v2.x
  v1.y -= v2.y

## multiplication
proc `*`*[T: SomeNumber](v: Vector2[T], s: T): Vector2[T] =
  Vector2[T](x: v.x * s, y: v.y * s)

proc `*`*[T: SomeNumber](s: T, v: Vector2[T]): Vector2[T] =
  v * s

proc `*`*[T: SomeNumber](v1, v2: Vector2[T]): Vector2[T] =
  Vector2[T](x: v1.x * v2.x, y: v1.y * v2.y)

proc `*=`*[T: SomeNumber](v: var Vector2[T], s: T) =
  v.x *= s
  v.y *= s

proc `*=`*[T: SomeNumber](v1: var Vector2[T], v2: Vector2[T]) =
  v1.x *= v2.x
  v1.y *= v2.y

## division
proc `div`*[T: SomeInteger](v: Vector2[T], s: T): Vector2[T] =
  Vector2[T](x: v.x div s, y: v.y div s)

proc `div`*[T: SomeInteger](v1, v2: Vector2[T]): Vector2[T] =
  Vector2[T](x: v1.x div v2.x, y: v1.y div v2.y)

proc `/`*[T: SomeFloat](v: Vector2[T], s: T): Vector2[T] =
  Vector2[T](x: v.x / s, y: v.y / s)

proc `/`*[T: SomeFloat](v1, v2: Vector2[T]): Vector2[T] =
  Vector2[T](x: v1.x / v2.x, y: v1.y / v2.y)

proc `/=`*[T: SomeFloat](v: var Vector2[T], s: T) =
  v.x /= s
  v.y /= s

proc `/=`*[T: SomeFloat](v1: var Vector2[T], v2: Vector2[T]) =
  v1.x /= v2.x
  v1.y /= v2.y

## Pythagorean theorem
proc length*[T: SomeFloat](v: Vector2[T]): T =
  sqrt(v.x * v.x + v.y * v.y)

proc length*[T: SomeInteger](v: Vector2[T]): float =
  sqrt(float(v.x) * float(v.x) + float(v.y) * float(v.y))

## Length but no sqrt
proc lengthSquared*[T: SomeNumber](v: Vector2[T]): T =
  v.x * v.x + v.y * v.y

## Normalizes the vector
proc normalize*[T: SomeFloat](v: var Vector2[T]) =
  let length = v.length()
  if length != 0:
    v.x /= length
    v.y /= length

## Returns a normalized vector
proc normalized*[T: SomeFloat](v: Vector2[T]): Vector2[T] =
  result = v
  result.normalize()

## Dot product
proc dot*[T: SomeNumber](v1, v2: Vector2[T]): T =
  v1.x * v2.x + v1.y * v2.y

## Cross product
proc cross*[T: SomeNumber](v1, v2: Vector2[T]): T =
  v1.x * v2.y - v1.y * v2.x

## Distance between two vectors
proc distance*[T: SomeFloat](v1, v2: Vector2[T]): T =
  (v1 - v2).length()

proc distance*[T: SomeInteger](v1, v2: Vector2[T]): float =
  (v1 - v2).length()

## Distance but uses lengthSquared instead of length
proc distanceSquared*[T: SomeNumber](v1, v2: Vector2[T]): T =
  (v1 - v2).lengthSquared()

## Vector2[T](x: 0, y: 0)
proc zero*[T: SomeNumber](_: typedesc[Vector2[T]]): Vector2[T] =
  Vector2[T](x: 0, y: 0)

## Vector2[T](x: 1, y: 1)
proc one*[T: SomeNumber](_: typedesc[Vector2[T]]): Vector2[T] =
  Vector2[T](x: 1, y: 1)


type Vector3*[T: SomeNumber] = object
  x*, y*, z*: T

## negation
proc `-`*[T: SomeNumber](v: Vector3[T]): Vector3[T] =
  Vector3[T](x: -v.x, y: -v.y, z: -v.z)

## addition
proc `+`*[T: SomeNumber](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z)

proc `+=`*[T: SomeNumber](v1: var Vector3[T], v2: Vector3[T]) =
  v1.x += v2.x
  v1.y += v2.y
  v1.z += v2.z

## subtraction
proc `-`*[T: SomeNumber](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z)

proc `-=`*[T: SomeNumber](v1: var Vector3[T], v2: Vector3[T]) =
  v1.x -= v2.x
  v1.y -= v2.y
  v1.z -= v2.z

## multiplication
proc `*`*[T: SomeNumber](v: Vector3[T], s: T): Vector3[T] =
  Vector3[T](x: v.x * s, y: v.y * s, z: v.z * s)

proc `*`*[T: SomeNumber](s: T, v: Vector3[T]): Vector3[T] =
  v * s

proc `*`*[T: SomeNumber](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.x * v2.x, y: v1.y * v2.y, z: v1.z * v2.z)

proc `*=`*[T: SomeNumber](v: var Vector3[T], s: T) =
  v.x *= s
  v.y *= s
  v.z *= s

proc `*=`*[T: SomeNumber](v1: var Vector3[T], v2: Vector3[T]) =
  v1.x *= v2.x
  v1.y *= v2.y
  v1.z *= v2.z

## division
proc `div`*[T: SomeInteger](v: Vector3[T], s: T): Vector3[T] =
  Vector3[T](x: v.x div s, y: v.y div s, z: v.z div s)

proc `div`*[T: SomeInteger](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.x div v2.x, y: v1.y div v2.y, z: v1.z div v2.z)

proc `/`*[T: SomeFloat](v: Vector3[T], s: T): Vector3[T] =
  Vector3[T](x: v.x / s, y: v.y / s, z: v.z / s)

proc `/`*[T: SomeFloat](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.x / v2.x, y: v1.y / v2.y, z: v1.z / v2.z)

proc `/=`*[T: SomeFloat](v: var Vector3[T], s: T) =
  v.x /= s
  v.y /= s
  v.z /= s

proc `/=`*[T: SomeFloat](v1: var Vector3[T], v2: Vector3[T]) =
  v1.x /= v2.x
  v1.y /= v2.y
  v1.z /= v2.z

## Pythagorean theorem
proc length*[T: SomeFloat](v: Vector3[T]): T =
  sqrt(v.x * v.x + v.y * v.y + v.z * v.z)

proc length*[T: SomeInteger](v: Vector3[T]): float =
  sqrt(float(v.x) * float(v.x) + float(v.y) * float(v.y) + float(v.z) * float(v.z))

## Length but no sqrt
proc lengthSquared*[T: SomeNumber](v: Vector3[T]): T =
  v.x * v.x + v.y * v.y + v.z * v.z

## Normalizes the vector
proc normalize*[T: SomeFloat](v: var Vector3[T]) =
  let length = v.length()
  if length != 0:
    v.x /= length
    v.y /= length
    v.z /= length

## Returns a normalized vector
proc normalized*[T: SomeFloat](v: Vector3[T]): Vector3[T] =
  result = v
  result.normalize()

## Dot product
proc dot*[T: SomeNumber](v1, v2: Vector3[T]): T =
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z

## Cross product
proc cross*[T: SomeNumber](v1, v2: Vector3[T]): Vector3[T] =
  Vector3[T](x: v1.y * v2.z - v1.z * v2.y, y: v1.z * v2.x - v1.x * v2.z, z: v1.x * v2.y - v1.y * v2.x)

## Distance between two vectors
proc distance*[T: SomeFloat](v1, v2: Vector3[T]): T =
  (v1 - v2).length()

proc distance*[T: SomeInteger](v1, v2: Vector3[T]): float =
  (v1 - v2).length()

## Distance but uses lengthSquared instead of length
proc distanceSquared*[T: SomeNumber](v1, v2: Vector3[T]): T =
  (v1 - v2).lengthSquared()

## Vector3[T](x: 0, y: 0, z: 0)
proc zero*[T: SomeNumber](_: typedesc[Vector3[T]]): Vector3[T] =
  Vector3[T](x: 0, y: 0, z: 0)

## Vector3[T](x: 1, y: 1, z: 1)
proc one*[T: SomeNumber](_: typedesc[Vector3[T]]): Vector3[T] =
  Vector3[T](x: 1, y: 1, z: 1)


type Vector4*[T: SomeNumber] = object
  x*, y*, z*, w*: T

## negation
proc `-`*[T: SomeNumber](v: Vector4[T]): Vector4[T] =
  Vector4[T](x: -v.x, y: -v.y, z: -v.z, w: -v.w)

## addition
proc `+`*[T: SomeNumber](v1, v2: Vector4[T]): Vector4[T] =
  Vector4[T](x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z, w: v1.w + v2.w)

proc `+=`*[T: SomeNumber](v1: var Vector4[T], v2: Vector4[T]) =
  v1.x += v2.x
  v1.y += v2.y
  v1.z += v2.z
  v1.w += v2.w

## subtraction
proc `-`*[T: SomeNumber](v1, v2: Vector4[T]): Vector4[T] =
  Vector4[T](x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z, w: v1.w - v2.w)

proc `-=`*[T: SomeNumber](v1: var Vector4[T], v2: Vector4[T]) =
  v1.x -= v2.x
  v1.y -= v2.y
  v1.z -= v2.z
  v1.w -= v2.w

## multiplication
proc `*`*[T: SomeNumber](v: Vector4[T], s: T): Vector4[T] =
  Vector4[T](x: v.x * s, y: v.y * s, z: v.z * s, w: v.w * s)

proc `*`*[T: SomeNumber](s: T, v: Vector4[T]): Vector4[T] =
  v * s

proc `*`*[T: SomeNumber](v1, v2: Vector4[T]): Vector4[T] =
  Vector4[T](x: v1.x * v2.x, y: v1.y * v2.y, z: v1.z * v2.z, w: v1.w * v2.w)

proc `*=`*[T: SomeNumber](v: var Vector4[T], s: T) =
  v.x *= s
  v.y *= s
  v.z *= s
  v.w *= s

proc `*=`*[T: SomeNumber](v1: var Vector4[T], v2: Vector4[T]) =
  v1.x *= v2.x
  v1.y *= v2.y
  v1.z *= v2.z
  v1.w *= v2.w

## division
proc `div`*[T: SomeInteger](v: Vector4[T], s: T): Vector4[T] =
  Vector4[T](x: v.x div s, y: v.y div s, z: v.z div s, w: v.w div s)

proc `div`*[T: SomeInteger](v1, v2: Vector4[T]): Vector4[T] =
  Vector4[T](x: v1.x div v2.x, y: v1.y div v2.y, z: v1.z div v2.z, w: v1.w div v2.w)

proc `/`*[T: SomeFloat](v: Vector4[T], s: T): Vector4[T] =
  Vector4[T](x: v.x / s, y: v.y / s, z: v.z / s, w: v.w / s)

proc `/`*[T: SomeFloat](v1, v2: Vector4[T]): Vector4[T] =
  Vector4[T](x: v1.x / v2.x, y: v1.y / v2.y, z: v1.z / v2.z, w: v1.w / v2.w)

proc `/=`*[T: SomeFloat](v: var Vector4[T], s: T) =
  v.x /= s
  v.y /= s
  v.z /= s
  v.w /= s

proc `/=`*[T: SomeFloat](v1: var Vector4[T], v2: Vector4[T]) =
  v1.x /= v2.x
  v1.y /= v2.y
  v1.z /= v2.z
  v1.w /= v2.w

## Pythagorean theorem
proc length*[T: SomeFloat](v: Vector4[T]): T =
  sqrt(v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w)

proc length*[T: SomeInteger](v: Vector4[T]): float =
  sqrt(float(v.x) * float(v.x) + float(v.y) * float(v.y) + float(v.z) * float(v.z) + float(v.w) * float(v.w))

## Length but no sqrt
proc lengthSquared*[T: SomeNumber](v: Vector4[T]): T =
  v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w

## Normalizes the vector
proc normalize*[T: SomeFloat](v: var Vector4[T]) =
  let length = v.length()
  if length != 0:
    v.x /= length
    v.y /= length
    v.z /= length
    v.w /= length

## Returns a normalized vector
proc normalized*[T: SomeFloat](v: Vector4[T]): Vector4[T] =
  result = v
  result.normalize()

## Dot product
proc dot*[T: SomeNumber](v1, v2: Vector4[T]): T =
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w

## Distance between two vectors
proc distance*[T: SomeFloat](v1, v2: Vector4[T]): T =
  (v1 - v2).length()

proc distance*[T: SomeInteger](v1, v2: Vector4[T]): float =
  (v1 - v2).length()

## Distance but uses lengthSquared instead of length
proc distanceSquared*[T: SomeNumber](v1, v2: Vector4[T]): T =
  (v1 - v2).lengthSquared()

## Vector4[T](x: 0, y: 0, z: 0, w: 0)
proc zero*[T: SomeNumber](_: typedesc[Vector4[T]]): Vector4[T] =
  Vector4[T](x: 0, y: 0, z: 0, w: 0)

## Vector4[T](x: 1, y: 1, z: 1, w: 1)
proc one*[T: SomeNumber](_: typedesc[Vector4[T]]): Vector4[T] =
  Vector4[T](x: 1, y: 1, z: 1, w: 1)