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

      faces = []

      pushFace = (x, uvOffset, normalOffset) ->
        faces.push
          vertex: data.faces[x]
          uv: data.faces[x + uvOffset]
          normal: data.faces[x + normalOffset]

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
          uvOffset = 4
          uvOffset++ if hasMaterial
          normalOffset = uvOffset + 4

          pushFace(x, uvOffset, normalOffset)
          pushFace(x+1, uvOffset, normalOffset)
          pushFace(x+3, uvOffset, normalOffset)

          pushFace(x+1, uvOffset, normalOffset)
          pushFace(x+2, uvOffset, normalOffset)
          pushFace(x+3, uvOffset, normalOffset)

          x += 4
          x++ if hasMaterial
          x += 4 if hasUv
          x += 4 if hasNormal
        else
          uvOffset = 3
          uvOffset++ if hasMaterial
          normalOffset = uvOffset + 3

          pushFace(x, uvOffset, normalOffset)
          pushFace(x+1, uvOffset, normalOffset)
          pushFace(x+2, uvOffset, normalOffset)

          x += 3
          x++ if hasMaterial
          x += 3 if hasUv
          x += 3 if hasNormal

      faceElements = []
      vertices = data.vertices
      uvs = []
      normals = []
      vertexUvs = []

      numVertices = data.vertices.length / 3

      for face in faces
        unless vertexUvs[face.vertex]?
          vertexUvs[face.vertex] = face.uv

        if vertexUvs[face.vertex] == face.uv
          faceElements.push(face.vertex)
          uvOffset = face.vertex * 2
          normalOffset = face.vertex * 3
        else
          faceElements.push(numVertices)
          vertices.push(vertices[face.vertex * 3])
          vertices.push(vertices[face.vertex * 3 + 1])
          vertices.push(vertices[face.vertex * 3 + 2])
          uvOffset = numVertices * 2
          normalOffset = numVertices * 3
          numVertices++

        uvs[uvOffset] = data.uvs[0][face.uv * 2]
        uvs[uvOffset + 1] = data.uvs[0][face.uv * 2 + 1]
        normals[normalOffset] = data.normals[face.normal * 3]
        normals[normalOffset + 1] = data.normals[face.normal * 3 + 1]
        normals[normalOffset + 2] = data.normals[face.normal * 3 + 2]

      attributeData.vertexCoord.elements = new Float32Array(vertices)
      attributeData.vertexUv.elements = new Float32Array(uvs)
      attributeData.vertexNormal.elements = new Float32Array(normals)
      console.log(attributeData)
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
