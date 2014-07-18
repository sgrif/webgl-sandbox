compileShader = (gl, shaderSource, shaderType) ->
  shader = gl.createShader(shaderType)
  gl.shaderSource(shader, shaderSource)
  gl.compileShader(shader)

  unless gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    console.error(gl.getShaderInfoLog(shader))
    throw "Could not compile shader"

  shader

createProgram = (gl, vertexShader, fragmentShader) ->
  program = gl.createProgram()
  gl.attachShader(program, vertexShader)
  gl.attachShader(program, fragmentShader)
  gl.linkProgram(program)

  unless gl.getProgramParameter(program, gl.LINK_STATUS)
    console.error(gl.getProgramInfoLog(program))
    throw "Program failed to link"

  program

createShader = (gl, name) ->
  shaderSource = shaders["#{name}.glsl"]
  unless shaderSource
    throw "Unknown shader: #{name}"

  type = if name.indexOf("vertex") != -1
    gl.VERTEX_SHADER
  else if name.indexOf("fragment") != -1
    gl.FRAGMENT_SHADER
  else
    throw "Unknown shader type for #{name}"

  compileShader(gl, shaderSource, type)

@createProgramWithShaders = (gl, vertexShaderName, fragmentShaderName) ->
  vertexShader = createShader(gl, vertexShaderName)
  fragmentShader = createShader(gl, fragmentShaderName)
  createProgram(gl, vertexShader, fragmentShader)
