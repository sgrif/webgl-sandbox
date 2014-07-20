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

      rawUvs = data.uvs[0]
      uvs = []

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

        pushUv = (vi, uvi) ->
          attributeData.vertexUv.elements[vi * 2] = rawUvs[uvi * 2]
          attributeData.vertexUv.elements[vi * 2 + 1] = rawUvs[uvi * 2 + 1]

        faces = []
        if isQuad
          faces.push(data.faces[x])
          faces.push(data.faces[x+1])
          faces.push(data.faces[x+3])

          faces.push(data.faces[x+1])
          faces.push(data.faces[x+2])
          faces.push(data.faces[x+3])

          x += 4
          x++ if hasMaterial

          if hasUv
            pushUv(faces[0], data.faces[x])
            pushUv(faces[1], data.faces[x+1])
            pushUv(faces[2], data.faces[x+3])

            pushUv(faces[3], data.faces[x+1])
            pushUv(faces[4], data.faces[x+2])
            pushUv(faces[5], data.faces[x+3])
            x += 4

          x += 4 if hasNormal
        else
          faces.push(data.faces[x])
          faces.push(data.faces[x+1])
          faces.push(data.faces[x+2])

          numVertices = 3

          x += numVertices
          x++ if hasMaterial
          if hasUv
            pushUv(faces[0], data.faces[x])
            pushUv(faces[1], data.faces[x+1])
            pushUv(faces[2], data.faces[x+2])
            x += 3
          x += numVertices if hasNormal

        for face in faces
          faceElements.push(face)

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
