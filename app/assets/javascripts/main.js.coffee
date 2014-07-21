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
    diffuseTexture: Uniform.build(gl, program, "diffuseTexture", "uniform1i")
    specularTexture: Uniform.build(gl, program, "specularTexture", "uniform1i")

  drawScene = setupMartialArtist(gl, program, uniforms)

  model = new Object3d(position: { x: 0, y: 0, z: 0 })
  camera = new Camera
    position: new OrbitalObject3d(
      new Vector3(0, 75, 0)
      new SphericCoordinate(250, Math.PI / 2, 0)
    )
    perspective:
      matrix: Matrix4.perspective(45, canvas.width/canvas.height, 0.1, 2000)

  degToRad = (degrees) ->
    degrees * Math.PI / 180

  gui = new dat.GUI()

  ambient = r: 0.1, g: 0.1, b: 0.1

  ambientGui = gui.addFolder("Ambient Light")
  ambientGui.add(ambient, "r", 0, 1)
  ambientGui.add(ambient, "g", 0, 1)
  ambientGui.add(ambient, "b", 0, 1)

  light =
    position: new OrbitalObject3d(
      new Vector3(0, 75, 0)
      new SphericCoordinate(100, Math.PI / 2, 0)
    )
    spotAngle: 55
    penumbraAngle: 10

  lightGui = gui.addFolder("Light Position")
  lightGui.add(light.position.rotation, "polar", -Math.PI, Math.PI)
  lightGui.add(light.position.rotation, "azimuth", -Math.PI, Math.PI)
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
  cameraGui.add(camera.position.center, "x", -600, 600)
  cameraGui.add(camera.position.center, "y", -600, 600)
  cameraGui.add(camera.position.center, "z", -600, 600)

  cameraGui = gui.addFolder("Camera Rotation")
  cameraGui.add(camera.position.rotation, "radius", 0, 2000)
  cameraGui.add(camera.position.rotation, "polar", -2 * Math.PI, 2 * Math.PI)
  cameraGui.add(camera.position.rotation, "azimuth", -2 * Math.PI, 2 * Math.PI)

  runEveryFrame ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.enable(gl.DEPTH_TEST)

    uniforms.v.set(gl, camera.position.matrix)
    uniforms.p.set(gl, camera.perspective.matrix)
    uniforms.cameraPosition.set(gl, camera.worldPosition)
    uniforms.lightPosition.set(gl, light.position.eye)
    uniforms.ambientLight.set(gl, ambient)
    uniforms.spotAngle.set(gl, light.spotAngle)
    uniforms.penumbraAngle.set(gl, light.penumbraAngle)

    rotatedModel = model.rotate(rotation).matrix

    uniforms.m.set(gl, rotatedModel)
    uniforms.normalMatrix.set(gl, rotatedModel.normalMatrix)

    drawScene()
