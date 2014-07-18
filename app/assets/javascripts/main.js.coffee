canvas = document.getElementById("canvas")
gl = canvas.getContext("webgl")

program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
gl.useProgram(program)

# Set resolution

uniformResolution = gl.getUniformLocation(program, "resolution")
gl.uniform2f(uniformResolution, canvas.width, canvas.height)

attributes =
  vertexColor: gl.getAttribLocation(program, "vertexColor")
  vertexCoord: gl.getAttribLocation(program, "vertexCoord")

buffers =
  vertexColor: gl.createBuffer()
  vertexCoord: gl.createBuffer()

data =
  vertexColor: new Float32Array([
    1, 1, 0
    0, 0, 1
    1, 0, 0
  ])
  vertexCoord: new Float32Array([
    150, 135 * Math.sqrt(3)
    30, 30
    270, 30
  ])

# Populate Colors

gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexColor)
gl.bufferData(gl.ARRAY_BUFFER, data.vertexColor, gl.STATIC_DRAW)

# Populate Coords

gl.bindBuffer(gl.ARRAY_BUFFER, buffers.vertexCoord)
gl.bufferData(gl.ARRAY_BUFFER, data.vertexCoord, gl.STATIC_DRAW)

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
  2
  gl.FLOAT
  false
  0
  0
)

gl.drawArrays(gl.TRIANGLES, 0, 3)
