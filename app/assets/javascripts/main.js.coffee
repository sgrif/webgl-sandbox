@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl") || canvas.getContext("experimental-webgl")
  gl.clearColor(0, 0, 0, 1)
  gl.viewport(0, 0, canvas.width * devicePixelRatio, canvas.height * devicePixelRatio)
  canvas.width = Math.round(canvas.clientWidth * devicePixelRatio)
  canvas.height = Math.round(canvas.clientHeight * devicePixelRatio)

  martialArtistProgram = createProgramWithShaders(gl, "main_vertex", "main_fragment")
  floorProgram = createProgramWithShaders(gl, "floor_vertex", "main_fragment")

  uniformSets =
    martialArtist:
      m: Matrix4Uniform.build(gl, martialArtistProgram, "m")
      v: Matrix4Uniform.build(gl, martialArtistProgram, "v")
      p: Matrix4Uniform.build(gl, martialArtistProgram, "p")
      cameraPosition: Vector4Uniform.build(gl, martialArtistProgram, "cameraPosition")
      normalMatrix: Matrix3Uniform.build(gl, martialArtistProgram, "normalMatrix")
      ambientLight: ColorUniform.build(gl, martialArtistProgram, "ambientColor")
      lights: LightUniform.build(gl, martialArtistProgram, "lights", 4)
      diffuseTexture: Uniform.build(gl, martialArtistProgram, "diffuseTexture", "uniform1i")
      specularTexture: Uniform.build(gl, martialArtistProgram, "specularTexture", "uniform1i")
      normalMap: Uniform.build(gl, martialArtistProgram, "normalMap", "uniform1i")
    floor:
      m: Matrix4Uniform.build(gl, floorProgram, "m")
      v: Matrix4Uniform.build(gl, floorProgram, "v")
      p: Matrix4Uniform.build(gl, floorProgram, "p")
      cameraPosition: Vector4Uniform.build(gl, floorProgram, "cameraPosition")
      normalMatrix: Matrix3Uniform.build(gl, floorProgram, "normalMatrix")
      ambientLight: ColorUniform.build(gl, floorProgram, "ambientColor")
      lights: LightUniform.build(gl, floorProgram, "lights", 4)
      diffuseTexture: Uniform.build(gl, floorProgram, "diffuseTexture", "uniform1i")
      specularTexture: Uniform.build(gl, floorProgram, "specularTexture", "uniform1i")
      normalMap: Uniform.build(gl, floorProgram, "normalMap", "uniform1i")

  drawFloor = setupFloor(gl, floorProgram, uniformSets.floor)
  drawScene = setupMartialArtist(gl, martialArtistProgram, uniformSets.martialArtist)

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
      spotAngle: 45
      penumbraAngle: 10
    }
    {
      position: new Vector3(0, 368.143481165, -360)
      direction: new Vector3(0, 0.8660254037844197, -0.5)
      spotAngle: 45
      penumbraAngle: 10
    }
    {
      position: new Vector3(360, 368.143481165, 3.10862446895e-14)
      direction: new Vector3(0.5, 0.8660254037844197, 0)
      spotAngle: 45
      penumbraAngle: 10
    }
    {
      position: new Vector3(-360, 368.143481165, 3.10862446895e-14)
      direction: new Vector3(-0.5, 0.8660254037844197, 0)
      spotAngle: 45
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

  clock = new Clock()
  clock.start()

  runEveryFrame ->
    delta = clock.getDelta()
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.enable(gl.DEPTH_TEST)

    gl.useProgram(martialArtistProgram)

    uniformSets.martialArtist.m.set(gl, model.matrix)
    uniformSets.martialArtist.v.set(gl, camera.position.matrix)
    uniformSets.martialArtist.p.set(gl, camera.perspective.matrix)
    uniformSets.martialArtist.normalMatrix.set(gl, model.matrix.normalMatrix)
    uniformSets.martialArtist.cameraPosition.set(gl, camera.worldPosition)
    uniformSets.martialArtist.ambientLight.set(gl, ambient)
    uniformSets.martialArtist.lights.set(gl, lights)

    drawScene(delta)

    gl.useProgram(floorProgram)
    rotatedModel = model.matrix.rotateX(-Math.PI / 2)

    uniformSets.floor.m.set(gl, rotatedModel)
    uniformSets.floor.v.set(gl, camera.position.matrix)
    uniformSets.floor.p.set(gl, camera.perspective.matrix)
    uniformSets.floor.normalMatrix.set(gl, rotatedModel.normalMatrix)
    uniformSets.floor.cameraPosition.set(gl, camera.worldPosition)
    uniformSets.floor.ambientLight.set(gl, ambient)
    uniformSets.floor.lights.set(gl, lights)

    drawFloor(delta)
