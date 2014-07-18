@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)

  attributes =
    vertexColor: gl.getAttribLocation(program, "vertexColor")
    vertexCoord: gl.getAttribLocation(program, "vertexCoord")

  uniforms =
    hueAdjust: gl.getUniformLocation(program, "hueAdjust")

  buffers =
    vertexColor: gl.createBuffer()
    vertexCoord: gl.createBuffer()

  attributeData =
    vertexColor: new Float32Array([
      1, 1, 0
      0, 0, 1
      1, 0, 0
    ])
    vertexCoord: new Float32Array([
      0, 0.45 * Math.sqrt(3), 0
      -0.9, -0.9, 0
      0.9, -0.9, 0
    ])

  # Populate Colors

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexColor)
  gl.bufferData(gl.ARRAY_BUFFER, attributeData.vertexColor, gl.STATIC_DRAW)

  # Populate Coords

  gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexCoord)
  gl.bufferData(gl.ARRAY_BUFFER, attributeData.vertexCoord, gl.STATIC_DRAW)

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

  clock = new Clock()
  clock.start()
  hueAdjust = 0

  runEveryFrame ->
    hueAdjust += clock.getDelta() / 1000
    gl.uniform1fv(uniforms.hueAdjust, new Float32Array([hueAdjust]))
    gl.drawArrays(gl.TRIANGLES, 0, 3)
