@setupMartialArtist = (gl, program, uniforms) ->
  diffuseTextureSampler = uniforms.diffuseTexture
  specularTextureSampler = uniforms.specularTexture
  normalMapSampler = uniforms.normalMap

  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")
    vertexSkinWeights: VertexAttribute.build(gl, program, "vertexSkinWeights")
    vertexSkinIndices: VertexAttribute.build(gl, program, "vertexSkinIndices")

  uniforms =
    bones: Uniform.build(gl, program, "bones", "uniform1i")
    boneTextureWidth: Uniform.build(gl, program, "boneTextureWidth", "uniform1i")
    boneTextureHeight: Uniform.build(gl, program, "boneTextureHeight", "uniform1i")

  buffers =
    faceElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexSkinWeights: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexSkinIndices: Buffer.create(gl.ARRAY_BUFFER, gl)

  attributeData =
    vertexCoord:
      elementsPerItem: 3

    vertexUv:
      elementsPerItem: 2

    vertexNormal:
      elementsPerItem: 3

    vertexSkinWeights:
      elementsPerItem: 4

    vertexSkinIndices:
      elementsPerItem: 4

  faceElements = null
  skeleton = null

  diffuseTexture = new Texture("/HOM_Character_D_Red.png", diffuseTextureSampler, 0)
  diffuseTexture.load(gl)
  specularTexture = new Texture("/HOM_Character_S.png", specularTextureSampler, 1)
  specularTexture.load(gl)
  normalMap = new Texture("/HOM_Character_N.png", normalMapSampler, 2)
  normalMap.load(gl)
  boneTexture = null

  request = new XMLHttpRequest
  request.open("GET", "/person.json")
  request.onreadystatechange = ->
    if request.readyState == 4
      data = JSON.parse(request.responseText)
      skeleton = new SkeletonBuilder(data.bones).build()
      boneUniforms =
        image: uniforms.bones
        width: uniforms.boneTextureWidth
        height: uniforms.boneTextureHeight
      boneTexture = skeleton.createTexture(boneUniforms, 3)
      boneTexture.load(gl)

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
      skinWeights = data.skinWeights
      skinIndices = data.skinIndices
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

          skinIndices.push(skinWeights[face.vertex * 4])
          skinIndices.push(skinWeights[face.vertex * 4 + 1])
          skinIndices.push(skinWeights[face.vertex * 4 + 2])
          skinIndices.push(skinWeights[face.vertex * 4 + 3])

          skinWeights.push(skinWeights[face.vertex * 4])
          skinWeights.push(skinWeights[face.vertex * 4 + 1])
          skinWeights.push(skinWeights[face.vertex * 4 + 2])
          skinWeights.push(skinWeights[face.vertex * 4 + 3])

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
      attributeData.vertexSkinWeights.elements = new Float32Array(skinWeights)
      attributeData.vertexSkinIndices.elements = new Float32Array(skinIndices)

      faceElements = new Uint16Array(faceElements)

  request.send()

  ->
    if diffuseTexture.loaded && specularTexture.loaded && normalMap.loaded && faceElements?
      diffuseTexture.render(gl)
      specularTexture.render(gl)
      normalMap.render(gl)
      boneTexture.render(gl)

      for name, attribute of attributes
        attribute.populate(gl, buffers[name], attributeData[name])

      buffers.faceElements.bind(gl)
      buffers.faceElements.data(gl, faceElements)

      buffers.faceElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, faceElements.length, gl.UNSIGNED_SHORT, 0)
