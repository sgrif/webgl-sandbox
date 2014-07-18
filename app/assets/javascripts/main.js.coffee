@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)
  gl.enable(gl.DEPTH_TEST)

  attributes =
    vertexColor: gl.getAttribLocation(program, "vertexColor")
    vertexCoord: gl.getAttribLocation(program, "vertexCoord")

  uniforms =
    mvp: gl.getUniformLocation(program, "mvp")

  buffers =
    vertexColor: gl.createBuffer()
    vertexCoord: gl.createBuffer()
    cubeElements: gl.createBuffer()

  data =
    vertexColor: new Float32Array([
      1, 0, 0
      0, 1, 0
      0, 0, 1
      1, 1, 1

      1, 0, 0
      0, 1, 0
      0, 0, 1
      1, 1, 1
    ])
    vertexCoord: new Float32Array([
      -1, -1, 1
      1, -1, 1
      1, 1, 1
      -1, 1, 1

      -1, -1, -1
      1, -1, -1
      1, 1, -1
      -1, 1, -1
    ])
    cubeElements: new Uint16Array([
      # front
      0, 1, 2
      2, 3, 0
      # top
      3, 2, 6
      6, 7, 3
      # bbck
      7, 6, 5
      5, 4, 7
      # bottom
      4, 5, 1
      1, 0, 4
      # left
      4, 0, 3
      3, 7, 4
      # right
      1, 5, 6
      6, 2, 1
    ])

  # Populate Colors

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexColor)
  gl.bufferData(gl.ARRAY_BUFFER, data.vertexColor, gl.STATIC_DRAW)

  # Populate Coords

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexCoord)
  gl.bufferData(gl.ARRAY_BUFFER, data.vertexCoord, gl.STATIC_DRAW)

  # Populate Elements

  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffers.cubeElements)
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, data.cubeElements, gl.STATIC_DRAW)

  # Pass Colors

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexColor)
  gl.enableVertexAttribArray(attributes.vertexColor)
  gl.vertexAttribPointer(
    attributes.vertexColor
    3
    gl.FLOAT
    false
    0
    0
  )

  # Pass Coords

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexCoord)
  gl.enableVertexAttribArray(attributes.vertexCoord)
  gl.vertexAttribPointer(
    attributes.vertexCoord
    3
    gl.FLOAT
    false
    0
    0
  )

  model = mat4.translate([], mat4.create(), vec3.fromValues(0, 0, -4))
  view = mat4.lookAt(
    []
    vec3.fromValues(0, 2, 0)
    vec3.fromValues(0, 0, -4)
    vec3.fromValues(0, 1, 0)
  )
  projection = mat4.perspective([], 45, canvas.width/canvas.height, 0.1, 10)
  mvp = []
  mat4.mul(mvp, projection, view)
  mat4.mul(mvp, mvp, model)

  clock = new Clock()
  clock.start()
  rotation = 0

  runEveryFrame ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    rotation += clock.getDelta() / 1000 * Math.PI / 6
    yAxis = vec3.fromValues(0, 1, 0)
    anim = mat4.rotate([], mat4.create(), rotation, yAxis)

    gl.uniformMatrix4fv(uniforms.mvp, false, mat4.mul([], mvp, anim))

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffers.cubeElements)
    gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
