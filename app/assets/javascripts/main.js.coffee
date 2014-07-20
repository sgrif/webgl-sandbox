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
    cameraPosition: Vector4Uniform.build(gl, program, "cameraPosition")
    normalMatrix: Matrix3Uniform.build(gl, program, "normalMatrix")
    lightPosition: Vector4Uniform.build(gl, program, "lightPosition")
    ambientLight: ColorUniform.build(gl, program, "ambientColor")
    spotAngle: Uniform.build(gl, program, "spotAngle", "uniform1f")
    penumbraAngle: Uniform.build(gl, program, "penumbraAngle", "uniform1f")
    textureSampler: Uniform.build(gl, program, "textureSampler", "uniform1i")

  drawScene = setupTeapot(gl, program, uniforms.textureSampler)

  model = new Object3d(position: x: 0, y: 0, z: 0)
  camera = new Camera
    position: new OrbitalObject3d(
      new Vector3(0, 0, 0)
      new SphericCoordinate(40, Math.PI / 2, 0)
    )
    perspective:
      matrix: Matrix4.perspective(45, canvas.width/canvas.height, 0.1, 100)

  degToRad = (degrees) ->
    degrees * Math.PI / 180

  teapot = new Object3d(rotation: new Vector3(degToRad(23.4), 0, degToRad(-23.4)))

  gui = new dat.GUI()

  ambient = r: 0.1, g: 0.1, b: 0.1

  ambientGui = gui.addFolder("Ambient Light")
  ambientGui.add(ambient, "r", 0, 1)
  ambientGui.add(ambient, "g", 0, 1)
  ambientGui.add(ambient, "b", 0, 1)

  light =
    position: x: 0, y: 0, z: 20, w: 1
    spotAngle: 55
    penumbraAngle: 10

  lightGui = gui.addFolder("Light Position")
  lightGui.add(light.position, "x", -30, 30)
  lightGui.add(light.position, "y", -30, 30)
  lightGui.add(light.position, "z", -30, 30)
  lightGui.add(light, "spotAngle", 0, 90)
  lightGui.add(light, "penumbraAngle", 0, 90)

  rotation =
    x: 0
    y: 0
    z: 0

  rotationGui = gui.addFolder("Model Rotation")
  rotationGui.add(rotation, "x", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "y", -2 * Math.PI, 2 * Math.PI)
  rotationGui.add(rotation, "z", -2 * Math.PI, 2 * Math.PI)

  cameraGui = gui.addFolder("Camera Position")
  cameraGui.add(camera.position.center, "x", -30, 30)
  cameraGui.add(camera.position.center, "y", -30, 30)
  cameraGui.add(camera.position.center, "z", -30, 30)

  cameraGui = gui.addFolder("Camera Rotation")
  cameraGui.add(camera.position.rotation, "radius", 0, 100)
  cameraGui.add(camera.position.rotation, "polar", -2 * Math.PI, 2 * Math.PI)
  cameraGui.add(camera.position.rotation, "azimuth", -2 * Math.PI, 2 * Math.PI)

  runEveryFrame ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.enable(gl.DEPTH_TEST)

    uniforms.v.set(gl, camera.position.matrix)
    uniforms.p.set(gl, camera.perspective.matrix)
    uniforms.cameraPosition.set(gl, camera.worldPosition)
    uniforms.lightPosition.set(gl, light.position)
    uniforms.ambientLight.set(gl, ambient)
    uniforms.spotAngle.set(gl, light.spotAngle)
    uniforms.penumbraAngle.set(gl, light.penumbraAngle)

    rotatedModel = teapot.rotate(rotation).matrix.times(model.matrix)

    uniforms.m.set(gl, rotatedModel)
    uniforms.normalMatrix.set(gl, rotatedModel.normalMatrix)

    drawScene()
