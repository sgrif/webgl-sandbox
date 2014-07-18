class @Matrix4
  constructor: (elements) ->
    elements ?= [
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]
    @elements = new Float32Array(elements)

  @translation: ({ x, y, z }) ->
    new this([
      1, 0, 0, x
      0, 1, 0, y
      0, 0, 1, z
      0, 0, 0, 1
    ])

  @rotation: (angle, axis) ->
    { x, y, z } = axis
    c = Math.cos(angle)
    s = Math.sin(angle)
    t = 1 - c
    tx = t * x
    ty = t * y

    new this([
      tx * x + c, tx * y - s * z, tx * z + s * y, 0
      tx * y + s * z, ty * y + c, ty * z - s * x, 0
      tx * z - s * y, ty * z + s * x, t * z * z + c, 0
      0, 0, 0, 1
    ])

  row: (y) -> (x) => @at(x, y)
  column: (x) -> (y) => @at(x, y)
  at: (x, y) ->
    @elements[x + y * 4]

  times: (other) ->
    result = []
    for x in [0..3]
      for y in [0..3]
        result.push(multiplyRows(@row(x), other.column(y)))
    new Matrix4(result)

  multiplyRows = (row, other) ->
    result = 0
    for i in [0..3]
      result += row(i) * other(i)
    result
