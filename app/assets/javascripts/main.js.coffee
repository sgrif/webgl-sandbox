@main = ->
  canvas = document.getElementById("canvas")
  gl = canvas.getContext("webgl") || canvas.getContext("experimental-webgl")
  gl.clearColor(0, 0, 0, 1)

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
      lightPositions: Vector3ArrayUniform.build(gl, martialArtistProgram, "lightPositions")
      lightDirections: Vector3ArrayUniform.build(gl, martialArtistProgram, "lightDirections")
      spotAngles: Uniform.build(gl, martialArtistProgram, "spotAngles", "uniform1fv")
      penumbraAngles: Uniform.build(gl, martialArtistProgram, "penumbraAngles", "uniform1fv")
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
      lightPositions: Vector3ArrayUniform.build(gl, floorProgram, "lightPositions")
      lightDirections: Vector3ArrayUniform.build(gl, floorProgram, "lightDirections")
      spotAngles: Uniform.build(gl, floorProgram, "spotAngles", "uniform1fv")
      penumbraAngles: Uniform.build(gl, floorProgram, "penumbraAngles", "uniform1fv")
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

    gl.useProgram(martialArtistProgram)

    uniformSets.martialArtist.m.set(gl, model.matrix)
    uniformSets.martialArtist.v.set(gl, camera.position.matrix)
    uniformSets.martialArtist.p.set(gl, camera.perspective.matrix)
    uniformSets.martialArtist.normalMatrix.set(gl, model.matrix.normalMatrix)
    uniformSets.martialArtist.cameraPosition.set(gl, camera.worldPosition)
    uniformSets.martialArtist.ambientLight.set(gl, ambient)
    uniformSets.martialArtist.lightPositions.set(gl, _.pluck(lights, 'position'))
    uniformSets.martialArtist.lightDirections.set(gl, _.pluck(lights, 'direction'))
    uniformSets.martialArtist.spotAngles.set(gl, new Float32Array(_.pluck(lights, 'spotAngle')))
    uniformSets.martialArtist.penumbraAngles.set(gl, new Float32Array(_.pluck(lights, 'penumbraAngle')))

    drawScene()

    gl.useProgram(floorProgram)
    rotatedModel = model.matrix.rotateX(Math.PI / 2).rotateY(Math.PI)

    uniformSets.floor.m.set(gl, rotatedModel)
    uniformSets.floor.v.set(gl, camera.position.matrix)
    uniformSets.floor.p.set(gl, camera.perspective.matrix)
    uniformSets.floor.normalMatrix.set(gl, rotatedModel.normalMatrix)
    uniformSets.floor.cameraPosition.set(gl, camera.worldPosition)
    uniformSets.floor.ambientLight.set(gl, ambient)
    uniformSets.floor.lightPositions.set(gl, _.pluck(lights, 'position'))
    uniformSets.floor.lightDirections.set(gl, _.pluck(lights, 'direction'))
    uniformSets.floor.spotAngles.set(gl, new Float32Array(_.pluck(lights, 'spotAngle')))
    uniformSets.floor.penumbraAngles.set(gl, new Float32Array(_.pluck(lights, 'penumbraAngle')))

    drawFloor()
