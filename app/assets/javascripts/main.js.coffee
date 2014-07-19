@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")
  gl.clearColor(0, 0, 0, 1)

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)

  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")

  uniforms =
    m: Matrix4Uniform.build(gl, program, "m")
    v: Matrix4Uniform.build(gl, program, "v")
    p: Matrix4Uniform.build(gl, program, "p")
    normalMatrix: Matrix3Uniform.build(gl, program, "normalMatrix")
    lightPosition: Vector4Uniform.build(gl, program, "lightPosition")
    textureSampler: Uniform.build(gl, program, "textureSampler", "uniform1i")

  buffers =
    cubeElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)

  attributeData =
    vertexCoord:
      elementsPerItem: 3
      elements: new Float32Array([
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
    vertexUv:
      elementsPerItem: 2
      elements: new Float32Array([
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
    vertexNormal:
      elementsPerItem: 3
      elements: new Float32Array([
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
  cubeElements = new Uint16Array([
    0, 1, 2,      0, 2, 3     # Front face
    4, 5, 6,      4, 6, 7     # Back face
    8, 9, 10,     8, 10, 11   # Top face
    12, 13, 14,   12, 14, 15  # Bottom face
    16, 17, 18,   16, 18, 19  # Right face
    20, 21, 22,   20, 22, 23  # Left face
  ])

  for name, attribute of attributes
    attribute.populate(gl, buffers[name], attributeData[name])

  buffers.cubeElements.bind(gl)
  buffers.cubeElements.data(gl, cubeElements)

  texture = new Texture("/crate.gif", uniforms.textureSampler)
  texture.load(gl)

  model = new Matrix4().translate(x: 0, y: 0, z: -4)
  view = Matrix4.lookingAt(
    new Vector3(0, 2, 0)
    new Vector3(0, 0, -4)
    new Vector3(0, 1, 0)
  )
  projection = Matrix4.perspective(45, canvas.width/canvas.height, 0.1, 10)

  gui = new dat.GUI()

  light =
    position: x: -1.0, y: -2.0, z: 1.0, w: 1.0

  lightGui = gui.addFolder("Light Position")
  lightGui.add(light.position, "x", -10, 10)
  lightGui.add(light.position, "y", -10, 10)
  lightGui.add(light.position, "z", -10, 10)

  rotation =
    x: 0
    y: Math.PI / 6
    z: 0

  rotationGui = gui.addFolder("Model Rotation")
  rotationGui.add(rotation, "x", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "y", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "z", -2 * Math.PI, 2 * Math.PI)

  runEveryFrame ->
    if texture.loaded
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
      gl.enable(gl.DEPTH_TEST)

      rotatedModel = model.rotateEuler(rotation)

      uniforms.m.set(gl, rotatedModel)
      uniforms.v.set(gl, view)
      uniforms.p.set(gl, projection)
      uniforms.normalMatrix.set(gl, view.normalsFor(rotatedModel))
      uniforms.lightPosition.set(gl, light.position)

      texture.render(gl)

      buffers.cubeElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
