@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")
  gl.clearColor(0, 0, 0, 1)

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)

  attributes =
    vertexCoord: gl.getAttribLocation(program, "vertexCoord")
    vertexUv: gl.getAttribLocation(program, "vertexUv")
    vertexNormal: gl.getAttribLocation(program, "vertexNormal")

  uniforms =
    m: gl.getUniformLocation(program, "m")
    v: gl.getUniformLocation(program, "v")
    p: gl.getUniformLocation(program, "p")
    normalMatrix: gl.getUniformLocation(program, "normalMatrix")
    lightPosition: gl.getUniformLocation(program, "lightPosition")
    alpha: gl.getUniformLocation(program, "alpha")
    textureSampler: gl.getUniformLocation(program, "textureSampler")

  buffers =
    vertexCoord: gl.createBuffer()
    cubeElements: gl.createBuffer()
    vertexUv: gl.createBuffer()
    vertexNormal: gl.createBuffer()

  bufferTypes =
    vertexCoord: gl.ARRAY_BUFFER
    cubeElements: gl.ELEMENT_ARRAY_BUFFER
    vertexUv: gl.ARRAY_BUFFER
    vertexNormal: gl.ARRAY_BUFFER

  data =
    vertexCoord: new Float32Array([
      # Front
      -1, -1,  1
       1, -1,  1
       1,  1,  1
      -1,  1,  1

      # Back
      -1, -1, -1
      -1,  1, -1
       1,  1, -1
       1, -1, -1

      # Top
      -1,  1, -1
      -1,  1,  1
       1,  1,  1
       1,  1, -1

      # Bottom
      -1, -1, -1
       1, -1, -1
       1, -1,  1
      -1, -1,  1

      # Right
       1, -1, -1
       1,  1, -1
       1,  1,  1
       1, -1,  1

      # Left
      -1, -1, -1
      -1, -1,  1
      -1,  1,  1
      -1,  1, -1
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
      0, 0
      1, 0
      1, 1
      0, 1

      1, 0
      1, 1
      0, 1
      0, 0

      0, 1
      0, 0
      1, 0
      1, 1

      1, 1
      0, 1
      0, 0
      1, 0

      1, 0
      1, 1
      0, 1
      0, 0

      0, 0
      1, 0
      1, 1
      0, 1
    ])
    vertexNormal: new Float32Array([
      0, 0, 1
      0, 0, 1
      0, 0, 1
      0, 0, 1

      0, 0, -1
      0, 0, -1
      0, 0, -1
      0, 0, -1

      0, 1, 0
      0, 1, 0
      0, 1, 0
      0, 1, 0

      0, -1, 0
      0, -1, 0
      0, -1, 0
      0, -1, 0

      1, 0, 0
      1, 0, 0
      1, 0, 0
      1, 0, 0

      -1, 0, 0
      -1, 0, 0
      -1, 0, 0
      -1, 0, 0
    ])

  numElements =
    vertexCoord: 3
    vertexUv: 2
    vertexNormal: 3

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

  model = mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(0, 0, -4))
  view = mat4.lookAt(
    mat4.create()
    vec3.fromValues(0, 2, 0)
    vec3.fromValues(0, 0, -4)
    vec3.fromValues(0, 1, 0)
  )
  projection = mat4.perspective(mat4.create(), 45, canvas.width/canvas.height, 0.1, 10)
  mv = mat4.mul(mat4.create(), view, model)

  normalMatrix = mat3.normalFromMat4(mat3.create(), mv)
  gl.uniformMatrix3fv(uniforms.normalMatrix, false, normalMatrix)

  clock = new Clock()
  clock.start()
  rotation = 0

  gui = new dat.GUI()

  light =
    position: x: -1.0, y: -2.0, z: 1.0, w: 1.0

  lightGui = gui.addFolder("Light Position")
  lightGui.add(light.position, 'x', -10, 10)
  lightGui.add(light.position, 'y', -10, 10)
  lightGui.add(light.position, 'z', -10, 10)

  rotation =
    x: 0
    y: Math.PI / 6
    z: 0

  rotationGui = gui.addFolder("Model Rotation")
  rotationGui.add(rotation, 'x', -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, 'y', -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, 'z', -2 * Math.PI, 2 * Math.PI)

  transparency =
    blend: false
    alpha: 1
  transparencyGui = gui.addFolder("Transparency")
  transparencyGui.add(transparency, 'blend')
  transparencyGui.add(transparency, 'alpha', 0, 1)

  runEveryFrame ->
    if texture.loaded
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
      if transparency.blend
        gl.enable(gl.BLEND)
        gl.disable(gl.DEPTH_TEST)
        gl.blendFunc(gl.SRC_ALPHA, gl.ONE)
      else
        gl.disable(gl.BLEND)
        gl.enable(gl.DEPTH_TEST)

      anim = mat4.create()
      mat4.rotateX(anim, anim, rotation.x)
      mat4.rotateY(anim, anim, rotation.y)
      mat4.rotateZ(anim, anim, rotation.z)

      gl.uniformMatrix4fv(uniforms.m, false, mat4.mul(mat4.create(), model, anim))
      gl.uniformMatrix4fv(uniforms.v, false, view)
      gl.uniformMatrix4fv(uniforms.p, false, projection)
      gl.uniform4fv(uniforms.lightPosition, new Float32Array([
        light.position.x, light.position.y
        light.position.z, light.position.w
      ]))
      gl.uniform1fv(uniforms.alpha, new Float32Array([transparency.alpha]))

      texture.render(gl)

      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffers.cubeElements)
      gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
