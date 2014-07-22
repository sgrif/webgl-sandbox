class @Matrix4
  constructor: (elements) ->
    elements ?= [
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]
    @elements = new Float32Array(elements)

  times: (other) ->
    new Matrix4(mat4.multiply(mat4.create(), @elements, other.elements))

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

  timesVector: (vector) ->
    result = vec4.transformMat4(vec4.create(), vector, @elements)
    new Vector4(result...)

  Object.defineProperties @prototype,
    inverse:
      get: -> new Matrix4(mat4.invert(mat4.create(), @elements))

    normalMatrix:
      get: -> mat3.normalFromMat4(mat3.create(), @elements)

  withPosition: ({ x, y, z }) ->
    e = @elements
    new Matrix4([
      e[0], e[1], e[2], e[3]
      e[4], e[5], e[6], e[7]
      e[8], e[9], e[10], e[11]
      x, y, z, e[15]
    ])

  @lookingAt: (eye, target, up) ->
    z = eye.minus(target).normalize()
    x = up.cross(z).normalize()
    y = z.cross(x)

    new Matrix4([
      x.x, y.x, z.x, 0
      x.y, y.y, z.y, 0
      x.z, y.z, z.z, 0
      0, 0, 0, 1
    ]).translate(eye.multiplyScalar(-1))

  @perspective: (fovy, aspect, near, far) ->
    fov = 1.0 / Math.tan(fovy / 2)
    nearFar = 1 / (near - far)

    new Matrix4([
      fov / aspect, 0, 0, 0
      0, fov, 0, 0
      0, 0, (far + near) * nearFar, -1
      0, 0, (2 * far * near) * nearFar, 0
    ])

  @composedOf: (position, quaternion, scale) ->
    mat = mat4.fromRotationTranslation(mat4.create(), quaternion, position)
    mat4.scale(mat, mat, scale)
