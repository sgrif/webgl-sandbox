class @Matrix4
  constructor: (elements) ->
    elements ?= [
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]
    @elements = new Float32Array(elements)

  row: (y) -> (x) => @at(y, x)
  column: (x) -> (y) => @at(y, x)
  at: (y, x) ->
    @elements[x + y * 4]

  times: (other) ->
    result = []
    for y in [0..3]
      for x in [0..3]
        result.push(multiplyRows(other.row(y), @column(x)))
    new Matrix4(result)

  multiplyRows = (row, other) ->
    result = 0
    for i in [0..3]
      result += row(i) * other(i)
    result

  unwrap = (row) ->
    row(i) for i in [0..3]

  translate: ({ x, y, z }) ->
    @times(new Matrix4([
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      x, y, z, 1
    ]))

  rotateX: (angleInRadians) ->
    @times(new Matrix4([
      1, 0, 0, 0,
      0, Math.cos(angleInRadians), Math.sin(angleInRadians), 0,
      0, -Math.sin(angleInRadians), Math.cos(angleInRadians), 0,
      0, 0, 0, 1
    ]))

  rotateY: (angleInRadians) ->
    @times(new Matrix4([
      Math.cos(angleInRadians), 0, -Math.sin(angleInRadians), 0
      0, 1, 0, 0
      Math.sin(angleInRadians), 0, Math.cos(angleInRadians), 0
      0, 0, 0, 1
    ]))

  rotateZ: (angleInRadians) ->
    @times(new Matrix4([
      Math.cos(angleInRadians), Math.sin(angleInRadians), 0, 0
      -Math.sin(angleInRadians), Math.cos(angleInRadians), 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]))

  rotateEuler: ({ x, y, z }) ->
    @rotateX(x)
      .rotateY(y)
      .rotateZ(z)

  scale: ({ x, y, z }) ->
    @times(new Matrix4([
      x, 0, 0, 0
      0, y, 0, 0
      0, 0, z, 0
      0, 0, 0, 1
    ]))

  normalsFor: (model) ->
    mat3.normalFromMat4(mat3.create(), @times(model).elements)

  @lookingAt: (eye, target, up) ->
    z = eye.minus(target).normalize()
    x = up.cross(z).normalize()
    y = z.cross(x)

    rotation = new Matrix4([
      x.x, y.x, z.x, 0
      x.y, y.y, z.y, 0
      x.z, y.z, z.z, 0
      0, 0, 0, 1
    ])

    translation = new Matrix4([
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      -eye.x, -eye.y, -eye.z, 1
    ])

    translation.times(rotation)

  @perspective: (fovy, aspect, near, far) ->
    fov = 1.0 / Math.tan(fovy / 2)
    nearFar = 1 / (near - far)

    new Matrix4([
      fov / aspect, 0, 0, 0
      0, fov, 0, 0
      0, 0, (far + near) * nearFar, -1
      0, 0, (2 * far * near) * nearFar, 0
    ])
