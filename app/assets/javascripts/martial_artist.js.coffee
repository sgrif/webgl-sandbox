@setupMartialArtist = (gl, program, textureSampler) ->
  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")

  buffers =
    faceElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)

  attributeData =
    vertexCoord:
      elementsPerItem: 3

    vertexUv:
      elementsPerItem: 2

    vertexNormal:
      elementsPerItem: 3

  faceElements = null

  texture = new Texture("/HOM_Character_D_Red.png", textureSampler)
  texture.load(gl)

  request = new XMLHttpRequest
  request.open("GET", "/person.json")
  request.onreadystatechange = ->
    if request.readyState == 4
      data = JSON.parse(request.responseText)
      attributeData.vertexCoord.elements = new Float32Array(data.vertices)
      attributeData.vertexUv.elements = new Float32Array(data.uvs[0])
      attributeData.vertexNormal.elements = new Float32Array(data.normals)

      faceElements = []
      x = 0
      faceLength = data.faces.length
      while x < faceLength
        bitMask = data.faces[x++]

        isBitSet = (value, position) -> value & (1 << position)

        isQuad = isBitSet(bitMask, 0)
        hasMaterial = isBitSet(bitMask, 1)
        hasUv = isBitSet(bitMask, 3)
        hasNormal = isBitSet(bitMask, 5)

        if isQuad
          faceElements.push(data.faces[x])
          faceElements.push(data.faces[x+1])
          faceElements.push(data.faces[x+3])

          faceElements.push(data.faces[x+1])
          faceElements.push(data.faces[x+2])
          faceElements.push(data.faces[x+3])

          numVertices = 4
        else
          faceElements.push(data.faces[x])
          faceElements.push(data.faces[x+1])
          faceElements.push(data.faces[x+2])

          numVertices = 3

        x += numVertices
        x++ if hasMaterial
        x += numVertices if hasUv
        x += numVertices if hasNormal

      faceElements = new Uint16Array(faceElements)

  request.send()

  ->
    if texture.loaded && faceElements?
      texture.render(gl)

      for name, attribute of attributes
        attribute.populate(gl, buffers[name], attributeData[name])

      buffers.faceElements.bind(gl)
      buffers.faceElements.data(gl, faceElements)

      buffers.faceElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, faceElements.length, gl.UNSIGNED_SHORT, 0)
