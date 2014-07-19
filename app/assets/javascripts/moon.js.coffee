@setupMoon = (gl, program, textureSampler) ->
  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")

  buffers =
    faceElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)

  texture = new Texture("/moon.gif", textureSampler)
  texture.load(gl)

  radius = 2
  bands = 30

  vertexCoord = []
  vertexNormal = []
  vertexUv = []
  faceElements = []

  for y in [0..bands]
    polar = y * Math.PI / bands

    for x in [0..bands]
      azimuth = 2 * x * Math.PI / bands

      coords = new SphericCoordinate(radius, polar, azimuth).cartesianCoordinates
      u = 1 - x / bands
      v = 1 - y / bands

      vertexCoord.push(coords.x)
      vertexCoord.push(coords.y)
      vertexCoord.push(coords.z)

      vertexNormal.push(coords.x / radius)
      vertexNormal.push(coords.y / radius)
      vertexNormal.push(coords.z / radius)

      vertexUv.push(u)
      vertexUv.push(v)

  for y in [0..bands-1]
    for x in [0..bands-1]
      first = (y * (bands + 1)) + x
      second = first + bands + 1
      faceElements.push(first)
      faceElements.push(second)
      faceElements.push(first + 1)

      faceElements.push(second)
      faceElements.push(second + 1)
      faceElements.push(first + 1)

  attributeData =
    vertexCoord:
      elementsPerItem: 3
      elements: new Float32Array(vertexCoord)

    vertexUv:
      elementsPerItem: 2
      elements: new Float32Array(vertexUv)

    vertexNormal:
      elementsPerItem: 3
      elements: new Float32Array(vertexNormal)

  faceElements = new Uint16Array(faceElements)

  for name, attribute of attributes
    attribute.populate(gl, buffers[name], attributeData[name])

  buffers.faceElements.bind(gl)
  buffers.faceElements.data(gl, faceElements)


  ->
    if texture.loaded
      texture.render(gl)

      buffers.faceElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, faceElements.length, gl.UNSIGNED_SHORT, 0)
