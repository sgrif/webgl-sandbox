@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)
  gl.enable(gl.DEPTH_TEST)

  attributes =
    vertexCoord: gl.getAttribLocation(program, "vertexCoord")
    vertexUv: gl.getAttribLocation(program, "vertexUv")

  uniforms =
    mvp: gl.getUniformLocation(program, "mvp")
    textureSampler: gl.getUniformLocation(program, "textureSampler")

  buffers =
    vertexCoord: gl.createBuffer()
    cubeElements: gl.createBuffer()
    vertexUv: gl.createBuffer()

  bufferTypes =
    vertexCoord: gl.ARRAY_BUFFER
    cubeElements: gl.ELEMENT_ARRAY_BUFFER
    vertexUv: gl.ARRAY_BUFFER

  data =
    vertexCoord: new Float32Array([
      # Front
      -1.0, -1.0,  1.0
       1.0, -1.0,  1.0
       1.0,  1.0,  1.0
      -1.0,  1.0,  1.0

      # Back
      -1.0, -1.0, -1.0
      -1.0,  1.0, -1.0
       1.0,  1.0, -1.0
       1.0, -1.0, -1.0

      # Top
      -1.0,  1.0, -1.0
      -1.0,  1.0,  1.0
       1.0,  1.0,  1.0
       1.0,  1.0, -1.0

      # Bottom
      -1.0, -1.0, -1.0
       1.0, -1.0, -1.0
       1.0, -1.0,  1.0
      -1.0, -1.0,  1.0

      # Right
       1.0, -1.0, -1.0
       1.0,  1.0, -1.0
       1.0,  1.0,  1.0
       1.0, -1.0,  1.0

      # Left
      -1.0, -1.0, -1.0
      -1.0, -1.0,  1.0
      -1.0,  1.0,  1.0
      -1.0,  1.0, -1.0
    ])
    cubeElements: new Uint16Array([
      0, 1, 2,      0, 2, 3     # Front face
      4, 5, 6,      4, 6, 7     # Back face
      8, 9, 10,     8, 10, 11   # Top face
      12, 13, 14,   12, 14, 15  # Bottom face
      16, 17, 18,   16, 18, 19  # Right face
      20, 21, 22,   20, 22, 23  # Left face
    ])
    vertexUv: new Float32Array([
      # Front face
      0.0, 0.0
      1.0, 0.0
      1.0, 1.0
      0.0, 1.0

      # Back face
      1.0, 0.0
      1.0, 1.0
      0.0, 1.0
      0.0, 0.0

      # Top face
      0.0, 1.0
      0.0, 0.0
      1.0, 0.0
      1.0, 1.0

      # Bottom face
      1.0, 1.0
      0.0, 1.0
      0.0, 0.0
      1.0, 0.0

      # Right face
      1.0, 0.0
      1.0, 1.0
      0.0, 1.0
      0.0, 0.0

      # Left face
      0.0, 0.0
      1.0, 0.0
      1.0, 1.0
      0.0, 1.0
    ])

  numElements =
    vertexCoord: 3
    vertexUv: 2

  for name, buffer of buffers
    gl.bindBuffer(bufferTypes[name], buffer)
    gl.bufferData(bufferTypes[name], data[name], gl.STATIC_DRAW)

  for name, attribute of attributes
    gl.bindBuffer(bufferTypes[name], buffers[name])
    gl.enableVertexAttribArray(attribute)
    gl.vertexAttribPointer(
      attribute
      numElements[name]
      gl.FLOAT
      false
      0
      0
    )

  texture = new Texture("/crate.gif", uniforms.textureSampler)
  texture.load(gl)

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
    if texture.loaded
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

      rotation += clock.getDelta() / 1000 * Math.PI / 6
      yAxis = vec3.fromValues(0, 1, 0)
      anim = mat4.rotate([], mat4.create(), rotation, yAxis)

      gl.uniformMatrix4fv(uniforms.mvp, false, mat4.mul([], mvp, anim))

      texture.render(gl)

      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffers.cubeElements)
      gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
