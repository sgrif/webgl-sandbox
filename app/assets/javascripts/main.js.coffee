@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl")
  gl.clearColor(0, 0, 0, 1)

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)

  uniforms =
    m: Matrix4Uniform.build(gl, program, "m")
    v: Matrix4Uniform.build(gl, program, "v")
    p: Matrix4Uniform.build(gl, program, "p")
    normalMatrix: Matrix3Uniform.build(gl, program, "normalMatrix")
    lightPosition: Vector4Uniform.build(gl, program, "lightPosition")
    ambientLight: ColorUniform.build(gl, program, "ambientColor")
    textureSampler: Uniform.build(gl, program, "textureSampler", "uniform1i")

  drawMoon = setupMoon(gl, program, uniforms.textureSampler)
  drawCrate = setupCrate(gl, program, uniforms.textureSampler)

  model = new Object3d(position: x: 0, y: 0, z: 0)
  camera =
    position: new OrbitalObject3d(
      new Vector3(0, 0, 0)
      new SphericCoordinate(15, Math.PI / 2, 0)
      2
    )
    perspective:
      matrix: Matrix4.perspective(45, canvas.width/canvas.height, 0.1, 100)

  moon = new OrbitalObject3d(
    new Vector3(0, 0, 0)
    new SphericCoordinate(5, Math.PI / 2, Math.PI / 2)
  )

  crate = new OrbitalObject3d(
    new Vector3(0, 0, 0)
    new SphericCoordinate(5, Math.PI / 2, -Math.PI / 2)
  )

  gui = new dat.GUI()

  ambient = r: 0.1, g: 0.1, b: 0.1

  ambientGui = gui.addFolder("Ambient Light")
  ambientGui.add(ambient, "r", 0, 1)
  ambientGui.add(ambient, "g", 0, 1)
  ambientGui.add(ambient, "b", 0, 1)

  light =
    position: x: -1.0, y: -6.0, z: 2, w: 1.0

  lightGui = gui.addFolder("Light Position")
  lightGui.add(light.position, "x", -10, 10)
  lightGui.add(light.position, "y", -10, 10)
  lightGui.add(light.position, "z", -10, 10)

  rotation =
    radius: 0
    polar: 0
    azimuth: 0

  rotationGui = gui.addFolder("Model Rotation")
  rotationGui.add(rotation, "radius", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "polar", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "azimuth", -2 * Math.PI, 2 * Math.PI)

  runEveryFrame ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.enable(gl.DEPTH_TEST)

    uniforms.v.set(gl, camera.position.matrix)
    uniforms.p.set(gl, camera.perspective.matrix)
    uniforms.lightPosition.set(gl, light.position)
    uniforms.ambientLight.set(gl, ambient)

    rotatedModel = moon.rotateSpheric(rotation).matrix.times(model.matrix)

    uniforms.m.set(gl, rotatedModel)
    uniforms.normalMatrix.set(gl, camera.position.matrix.normalsFor(rotatedModel))

    drawMoon()

    rotatedModel = crate.rotateSpheric(rotation).matrix.times(model.matrix)

    uniforms.m.set(gl, rotatedModel)
    uniforms.normalMatrix.set(gl, camera.position.matrix.normalsFor(rotatedModel))

    drawCrate()
