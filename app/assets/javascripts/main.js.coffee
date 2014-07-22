@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl") || canvas.getContext("experimental-webgl")
  gl.clearColor(0, 0, 0, 1)

  program = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  gl.useProgram(program)

  uniforms =
    m: Matrix4Uniform.build(gl, program, "m")
    v: Matrix4Uniform.build(gl, program, "v")
    p: Matrix4Uniform.build(gl, program, "p")
    cameraPosition: Vector4Uniform.build(gl, program, "cameraPosition")
    normalMatrix: Matrix3Uniform.build(gl, program, "normalMatrix")
    ambientLight: ColorUniform.build(gl, program, "ambientColor")
    lightPositions: Vector3ArrayUniform.build(gl, program, "lightPositions")
    lightDirections: Vector3ArrayUniform.build(gl, program, "lightDirections")
    spotAngles: Uniform.build(gl, program, "spotAngles", "uniform1fv")
    penumbraAngles: Uniform.build(gl, program, "penumbraAngles", "uniform1fv")
    diffuseTexture: Uniform.build(gl, program, "diffuseTexture", "uniform1i")
    specularTexture: Uniform.build(gl, program, "specularTexture", "uniform1i")
    normalMap: Uniform.build(gl, program, "normalMap", "uniform1i")

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

  ambient = r: 0, g: 0, b: 0

  lights = [
    {
      position: new Vector3(0, 368.143481165, 360)
      direction: new Vector3(0, 0.8660254037844197, 0.5)
      spotAngle: 70
      penumbraAngle: 10
    }
    {
      position: new Vector3(0, 368.143481165, -360)
      direction: new Vector3(0, 0.8660254037844197, -0.5)
      spotAngle: 70
      penumbraAngle: 10
    }
    {
      position: new Vector3(360, 368.143481165, 3.10862446895e-14)
      direction: new Vector3(0.5, 0.8660254037844197, 0)
      spotAngle: 70
      penumbraAngle: 10
    }
    {
      position: new Vector3(-360, 368.143481165, 3.10862446895e-14)
      direction: new Vector3(-0.5, 0.8660254037844197, 0)
      spotAngle: 70
      penumbraAngle: 10
    }
  ]

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
    uniforms.ambientLight.set(gl, ambient)
    uniforms.lightPositions.set(gl, _.pluck(lights, 'position'))
    uniforms.lightDirections.set(gl, _.pluck(lights, 'direction'))
    uniforms.spotAngles.set(gl, new Float32Array(_.pluck(lights, 'spotAngle')))
    uniforms.penumbraAngles.set(gl, new Float32Array(_.pluck(lights, 'penumbraAngle')))

    uniforms.m.set(gl, model.matrix)
    uniforms.normalMatrix.set(gl, model.matrix.normalMatrix)

    drawScene()
