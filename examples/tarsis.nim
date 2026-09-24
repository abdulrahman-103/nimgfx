## Copyright (C) 2026 Abdulrahman
## This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
## This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
## You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

import ../src/nimgfx, random
var running = true

var last_time: uint64 = SDL_GetTicksNS()
var current_time: uint64 = SDL_GetTicksNS()
var frame_time: float

type
  PieceType* = enum
    I, L, J, O, T, S, Z
  Block* = object
    column*: int
    row*: int
    color*: Color

  Piece* = object
    kind*: PieceType
    blocks*: array[4, Block]
    rot*: int
    active*: bool

var current_piece*: Piece

proc place_piece*(piece_type: PieceType; grid: var array[20, array[10, int]]) =
  if piece_type == I:
    var block1: Block
    block1.row = 0
    block1.column = 3
    var block2: Block
    block2.row = 0
    block2.column = 4
    var block3: Block
    block3.row = 0
    block3.column = 5
    var block4: Block
    block4.row = 0
    block4.column = 6
    current_piece.kind = I
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == L:
    var block1: Block
    block1.row = 0
    block1.column = 4
    var block2: Block
    block2.row = 0
    block2.column = 5
    var block3: Block
    block3.row = 0
    block3.column = 6
    var block4: Block
    block4.row = 1
    block4.column = 4
    current_piece.kind = L
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == J:
    var block1: Block
    block1.row = 0
    block1.column = 4
    var block2: Block
    block2.row = 0
    block2.column = 5
    var block3: Block
    block3.row = 0
    block3.column = 6
    var block4: Block
    block4.row = 1
    block4.column = 6
    current_piece.kind = J
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == O:
    var block1: Block
    block1.row = 0
    block1.column = 4
    var block2: Block
    block2.row = 0
    block2.column = 5
    var block3: Block
    block3.row = 1
    block3.column = 4
    var block4: Block
    block4.row = 1
    block4.column = 5
    current_piece.kind = O
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == T:
    var block1: Block
    block1.row = 0
    block1.column = 4
    var block2: Block
    block2.row = 0
    block2.column = 5
    var block3: Block
    block3.row = 0
    block3.column = 6
    var block4: Block
    block4.row = 1
    block4.column = 5
    current_piece.kind = T
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == S:
    var block1: Block
    block1.row = 0
    block1.column = 5
    var block2: Block
    block2.row = 0
    block2.column = 6
    var block3: Block
    block3.row = 1
    block3.column = 4
    var block4: Block
    block4.row = 1
    block4.column = 5
    current_piece.kind = S
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  elif piece_type == Z:
    var block1: Block
    block1.row = 0
    block1.column = 4
    var block2: Block
    block2.row = 0
    block2.column = 5
    var block3: Block
    block3.row = 1
    block3.column = 5
    var block4: Block
    block4.row = 1
    block4.column = 6
    current_piece.kind = Z
    current_piece.rot = 0
    current_piece.blocks[0] = block1
    current_piece.blocks[1] = block2
    current_piece.blocks[2] = block3
    current_piece.blocks[3] = block4
  current_piece.active = true
  var `block`: int = 0
  while `block` < 4:
    if grid[current_piece.blocks[`block`].row][
        current_piece.blocks[`block`].column] == 1:
      running = false
    grid[current_piece.blocks[`block`].row][current_piece.blocks[`block`].column] = 1
    inc(`block`)

proc rotate*(grid: var array[20, array[10, int]]; clockwise: bool) =
  if not current_piece.active:
    return
  var success: bool = false
  var rot: int = current_piece.rot
  var target_rot: int
  var degrees: int
  var kind: PieceType = current_piece.kind
  if kind == I or kind == S or kind == Z:
    degrees = 180
  else:
    degrees = 90
  if clockwise:
    target_rot = rot + degrees
  else:
    target_rot = rot - degrees
  if target_rot == -90:
    target_rot = 270
  elif target_rot == -180:
    target_rot = 180
  elif target_rot == 360:
    target_rot = 0
  if current_piece.kind == I:
    if target_rot == 180 and current_piece.blocks[0].row > 1 and current_piece.blocks[3].row < 19:
      if grid[current_piece.blocks[2].row + 1][current_piece.blocks[2].column] == 0 and
          grid[current_piece.blocks[2].row - 1][current_piece.blocks[2].column] == 0 and
          grid[current_piece.blocks[2].row - 2][current_piece.blocks[2].column] == 0:
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        inc(current_piece.blocks[3].row, 1)
        dec(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        dec(current_piece.blocks[1].row, 1)
        inc(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
        dec(current_piece.blocks[0].row, 2)
        inc(current_piece.blocks[0].column, 2)
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
        success = true
    elif target_rot == 0 and current_piece.blocks[0].column < 9 and current_piece.blocks[0].column > 1:
      if grid[current_piece.blocks[2].row][current_piece.blocks[2].column + 1] == 0 and
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column - 1] == 0 and
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column - 2] == 0:
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        dec(current_piece.blocks[3].row, 1)
        inc(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        inc(current_piece.blocks[1].row, 1)
        dec(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
        inc(current_piece.blocks[0].row, 2)
        dec(current_piece.blocks[0].column, 2)
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
        success = true
  elif current_piece.kind == S:
    if target_rot == 180 and current_piece.blocks[0].row > 0:
      if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
          grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column] == 0:
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
        inc(current_piece.blocks[2].column, 2)
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        dec(current_piece.blocks[1].row, 1)
        dec(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        dec(current_piece.blocks[3].row, 1)
        inc(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        success = true
    elif target_rot == 0 and current_piece.blocks[1].column > 0:
      if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column] == 0 and
          grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0:
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        inc(current_piece.blocks[3].row, 1)
        dec(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        inc(current_piece.blocks[1].row, 1)
        inc(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
        dec(current_piece.blocks[2].column, 2)
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
        success = true
  elif current_piece.kind == Z:
    if target_rot == 180 and current_piece.blocks[0].row > 0:
      if grid[current_piece.blocks[0].row][current_piece.blocks[0].column + 2] == 0 and
          grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 2] == 0:
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
        dec(current_piece.blocks[0].row, 1)
        inc(current_piece.blocks[0].column, 2)
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        inc(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
        dec(current_piece.blocks[2].row, 1)
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        dec(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        success = true
    elif target_rot == 0 and current_piece.blocks[2].column > 0:
      if grid[current_piece.blocks[2].row][current_piece.blocks[2].column - 1] == 0 and
          grid[current_piece.blocks[2].row + 1][current_piece.blocks[2].column + 1] == 0:
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
        inc(current_piece.blocks[3].column, 1)
        grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
        inc(current_piece.blocks[2].row, 1)
        grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 0
        dec(current_piece.blocks[1].column, 1)
        grid[current_piece.blocks[1].row][current_piece.blocks[1].column] = 1
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
        inc(current_piece.blocks[0].row, 1)
        dec(current_piece.blocks[0].column, 2)
        grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
        success = true
  elif current_piece.kind == T:
    if clockwise:
      if target_rot == 90 and current_piece.blocks[2].row > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 1)
          dec(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[2].column < 9:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 1)
          inc(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 270 and current_piece.blocks[2].row < 19:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 1)
          inc(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 1)
          dec(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
    elif not clockwise:
      if target_rot == 90 and current_piece.blocks[2].row < 19:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 1)
          dec(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 1)
          dec(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          success = true
      elif target_rot == 270 and current_piece.blocks[2].row > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 1)
          inc(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column < 9:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 1)
          inc(current_piece.blocks[3].column, 1)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          success = true
  elif current_piece.kind == L:
    if clockwise:
      if target_rot == 90 and current_piece.blocks[2].row > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[2].column < 9 and
          current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 270 and current_piece.blocks[0].row < 19:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
    elif not clockwise:
      if target_rot == 90 and current_piece.blocks[3].row < 18:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 2] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row - 2][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 270:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 2] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column < 9:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 2][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
  elif current_piece.kind == J:
    if clockwise:
      if target_rot == 90 and current_piece.blocks[2].row > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 1][
            current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[0].column < 9:
        if grid[current_piece.blocks[0].row][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and 
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 270 and current_piece.blocks[0].row < 19:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
    elif not clockwise:
      if target_rot == 90 and current_piece.blocks[2].row < 19:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 2] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 180 and current_piece.blocks[0].column > 0:
        if grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row - 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row - 2][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          dec(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          inc(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 270 and current_piece.blocks[0].row > 0:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 2][current_piece.blocks[0].column - 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          inc(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          dec(current_piece.blocks[3].row, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          dec(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
      elif target_rot == 0 and current_piece.blocks[2].column < 9:
        if grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column - 1] == 0 and
            grid[current_piece.blocks[0].row + 1][current_piece.blocks[0].column + 1] == 0 and
            grid[current_piece.blocks[0].row + 2][current_piece.blocks[0].column + 1] == 0:
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 0
          inc(current_piece.blocks[0].row, 1)
          dec(current_piece.blocks[0].column, 1)
          grid[current_piece.blocks[0].row][current_piece.blocks[0].column] = 1
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 0
          inc(current_piece.blocks[3].column, 2)
          grid[current_piece.blocks[3].row][current_piece.blocks[3].column] = 1
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 0
          dec(current_piece.blocks[2].row, 1)
          inc(current_piece.blocks[2].column, 1)
          grid[current_piece.blocks[2].row][current_piece.blocks[2].column] = 1
          success = true
  if success:
    current_piece.rot = target_rot

proc physics*(grid: var array[20, array[10, int]]) =
  if current_piece.active == false:
    return
  var `block`: int = 0
  while `block` < 4:
    ##  if touches floor
    if current_piece.blocks[`block`].row == 19:
      current_piece.active = false
      return
    elif grid[current_piece.blocks[`block`].row + 1][
        current_piece.blocks[`block`].column] == 1:
      var sibling: bool = false
      var inner_block: int = 0
      while inner_block < 4:
        if current_piece.blocks[`block`].row + 1 ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column ==
            current_piece.blocks[inner_block].column:
          sibling = true
        inc(inner_block)
      if not sibling:
        current_piece.active = false
        return
    inc(`block`)
  `block` = 0
  while `block` < 4:
    inc(current_piece.blocks[`block`].row, 1)
    grid[current_piece.blocks[`block`].row][current_piece.blocks[`block`].column] = 1
    var sibling: bool = false
    var inner_block: int = 0
    while inner_block < 4:
      if current_piece.blocks[`block`].row > 0:
        if current_piece.blocks[`block`].row - 1 ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column ==
            current_piece.blocks[inner_block].column:
          sibling = true
      inc(inner_block)
    if not sibling:
      grid[current_piece.blocks[`block`].row - 1][
          current_piece.blocks[`block`].column] = 0
    inc(`block`)

proc right*(grid: var array[20, array[10, int]]) =
  if current_piece.active == false:
    return
  var `block`: int = 0
  while `block` < 4:
    ##  if touches wall
    if current_piece.blocks[`block`].column == 9:
      return
    elif grid[current_piece.blocks[`block`].row][
        current_piece.blocks[`block`].column + 1] == 1:
      var sibling: bool = false
      var inner_block: int = 0
      while inner_block < 4:
        if current_piece.blocks[`block`].row ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column + 1 ==
            current_piece.blocks[inner_block].column:
          sibling = true
        inc(inner_block)
      if not sibling:
        return
    inc(`block`)
  `block` = 0
  while `block` < 4:
    inc(current_piece.blocks[`block`].column, 1)
    grid[current_piece.blocks[`block`].row][current_piece.blocks[`block`].column] = 1
    var sibling: bool = false
    var inner_block: int = 0
    while inner_block < 4:
      if current_piece.blocks[`block`].column > 0:
        if current_piece.blocks[`block`].row ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column - 1 ==
            current_piece.blocks[inner_block].column:
          sibling = true
      inc(inner_block)
    if not sibling:
      grid[current_piece.blocks[`block`].row][
          current_piece.blocks[`block`].column - 1] = 0
    inc(`block`)

proc left*(grid: var array[20, array[10, int]]) =
  if current_piece.active == false:
    return
  var `block`: int = 0
  while `block` < 4:
    ##  if touches wall
    if current_piece.blocks[`block`].column == 0:
      return
    elif grid[current_piece.blocks[`block`].row][
        current_piece.blocks[`block`].column - 1] == 1:
      var sibling: bool = false
      var inner_block: int = 0
      while inner_block < 4:
        if current_piece.blocks[`block`].row ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column - 1 ==
            current_piece.blocks[inner_block].column:
          sibling = true
        inc(inner_block)
      if not sibling:
        return
    inc(`block`)
  `block` = 0
  while `block` < 4:
    dec(current_piece.blocks[`block`].column, 1)
    grid[current_piece.blocks[`block`].row][current_piece.blocks[`block`].column] = 1
    var sibling: bool = false
    var inner_block: int = 0
    while inner_block < 4:
      if current_piece.blocks[`block`].column < 9:
        if current_piece.blocks[`block`].row ==
            current_piece.blocks[inner_block].row and
            current_piece.blocks[`block`].column + 1 ==
            current_piece.blocks[inner_block].column:
          sibling = true
      inc(inner_block)
    if not sibling:
      grid[current_piece.blocks[`block`].row][
          current_piece.blocks[`block`].column + 1] = 0
    inc(`block`)

proc clear_row*(grid: var array[20, array[10, int]]; clear_row_timer: ptr float;
               clear_row_timer_interval: float) =
  var already_added: bool = false
  var placed: bool = false
  var row: int = 0
  while row < 20:
    var cleared: bool = true
    var `block`: int = 0
    while `block` < 10:
      if grid[row][`block`] == 0:
        cleared = false
        break
      inc(`block`)
    if cleared:
      if not already_added:
        clear_row_timer[] += frame_time
        already_added = true
      if clear_row_timer[] >= clear_row_timer_interval:
        var `block`: int = 0
        while `block` < 10:
          grid[row][`block`] = 0
          inc(`block`)
        var dropped_row: int = row
        while dropped_row > 0:
          var `block`: int = 0
          while `block` < 10:
            grid[dropped_row][`block`] = grid[dropped_row - 1][`block`]
            grid[dropped_row - 1][`block`] = 0
            placed = true
            inc(`block`)
          dec(dropped_row)
    inc(row)
  if placed:
    clear_row_timer[] = 0.0f



const real_y: float = 720
const real_x: float = real_y / 2
const block_length: float = real_x / 10
const block_margin: float = block_length / 15
const x: int = int(real_x - block_margin)
const y: int = int(real_y - block_margin)

var gravity_timer: float = 0
var gravity_timer_interval: float = 0.5
var fast_gravity_interval: float = gravity_timer_interval / 8
var clear_row_timer: float = 0
let clear_row_timer_interval: float = 0.2
var spawn_timer: float = 0
let spawn_timer_interval: float = 0.25
var sideways_timer: float = 0
let sideways_timer_interval: float = 0.1

var grid: array[20, array[10, int]]
randomize()
var random_piece: int = rand(0 .. 6)
place_piece(PieceType(random_piece), grid)

var window = Window(title: "Tarsis", w: x.int32, h: y.int32)
window.create()
var renderer = Renderer(window: window)
renderer.create()
renderer.setVSync(On)
if not init(InitVideo):
  echo "Couldn't initialize SDL"

while running:
  current_time = SDL_GetTicksNS()
  frame_time = float(current_time - last_time) / 1000000000
  last_time = current_time

  var event: Event
  while pollEvent(event):
    case event.type
    of quitEvent:
      running = false
    else:
      discard

    if event.pressed(X) or event.pressed(Up) or event.pressed(W):
      rotate(grid, true)
    if event.pressed(nimgfx.Z):
      rotate(grid, false)
    if event.pressed(nimgfx.S) or event.pressed(Down):
      physics(grid)
      gravity_timer = 0
    if event.pressed(D) or event.pressed(Right):
      right(grid)
      sideways_timer -= 0.25
    if event.released(D) or event.released(Right):
      sideways_timer = 0
    if event.pressed(A) or event.pressed(Left):
      left(grid)
      sideways_timer -= 0.25
    if event.released(A) or event.released(Left):
      sideways_timer = 0

  if down(nimgfx.S) or down(Down):
    gravity_timer_interval = fast_gravity_interval
  else:
    gravity_timer_interval = 0.5

  if down(D) or down(Right):
    sideways_timer += frame_time
    if sideways_timer >= sideways_timer_interval:
      sideways_timer -= sideways_timer_interval
      right(grid)
  if down(A) or down(Left):
    sideways_timer += frame_time
    if sideways_timer >= sideways_timer_interval:
      sideways_timer -= sideways_timer_interval
      left(grid)

  gravity_timer += frame_time
  if gravity_timer >= gravity_timer_interval:
    gravity_timer -= gravity_timer_interval
    physics(grid)

  if not current_piece.active:
    clear_row(grid, addr(clear_row_timer), clear_row_timer_interval)
  if not current_piece.active:
    spawn_timer += frame_time
    if spawn_timer >= spawn_timer_interval:
      spawn_timer = 0
      var random_piece: int = rand(0 .. 6)
      place_piece(PieceType(random_piece), grid)

  renderer.clear(Black)

  var row: int = 0
  while row < 20:
    var column: int = 0
    while column < 10:
      if grid[row][column] == 1:
        var rect: Rect = Rect(
          x: column.float * block_length,
          y: row.float * block_length,
          w: block_length - block_margin,
          h: block_length - block_margin)
        renderer.drawRect(rect, White)
      inc(column)
    inc(row)

  renderer.render()

window.kill()
renderer.kill()
nimgfx.quit()

