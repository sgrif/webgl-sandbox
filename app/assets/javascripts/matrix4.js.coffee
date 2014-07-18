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

  @perspective: (fov, aspect, near, far) ->
    ymax = near * Math.tan(fov * 0.5 * Math.PI / 180)
    ymin = -ymax
    xmin = ymin * aspect
    xmax = ymax * aspect

    @frustum(xmin, xmax, ymin, ymax, near, far)

  @frustum = (left, right, bottom, top, near, far) ->
    x = 2 * near / (right - left)
    y = 2 * near / (top - bottom)

    a = (right + left) / (right - left)
    b = (top + bottom) / (top - bottom)
    c = -(far + near) / (far - near)
    d = -2 * far * near / (far - near)

    new Matrix4([
      x, 0, 0, 0
      0, y, 0, 0
      a, b, c, -1
      0, 0, 0, d
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

  lookingAt: (eye, target, up) ->
    z = eye.minus(target).normalize()
    if z.length == 0
      z.z = 1

    x = up.cross(z).normalize()

    if x.length == 0
      z.x += 0.0001
      x = up.cross(z).normalize()

    y = z.cross(x)

    new Matrix4([
      x.x, x.y, x.z, @at(3, 0)
      y.x, y.y, y.x, @at(3, 1)
      z.x, z.y, z.x, @at(3, 1)
      @at(0, 3), @at(1, 3), @at(2, 3), @at(3, 3)
    ])
