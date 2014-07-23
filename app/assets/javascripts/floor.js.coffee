@setupFloor = (gl, program, uniforms) ->
  diffuseTextureSampler = uniforms.diffuseTexture
  specularTextureSampler = uniforms.specularTexture
  normalMapSampler = uniforms.normalMap

  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")

  uniforms =
    textureRepeat: Uniform.build(gl, program, "textureRepeat", "uniform2fv")
    normalScale: Uniform.build(gl, program, "normalScale", "uniform1f")

  buffers =
    faceElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)

  attributeData =
    vertexCoord:
      elementsPerItem: 3
      elements: new Float32Array([-780, 780, 0, -520, 780, 0, -260, 780, 0, 0, 780, 0, 260, 780, 0, 520, 780, 0, 780, 780, 0, -780, 520, 0, -520, 520, 0, -260, 520, 0, 0, 520, 0, 260, 520, 0, 520, 520, 0, 780, 520, 0, -780, 260, 0, -520, 260, 0, -260, 260, 0, 0, 260, 0, 260, 260, 0, 520, 260, 0, 780, 260, 0, -780, -0, 0, -520, -0, 0, -260, -0, 0, 0, -0, 0, 260, -0, 0, 520, -0, 0, 780, -0, 0, -780, -260, 0, -520, -260, 0, -260, -260, 0, 0, -260, 0, 260, -260, 0, 520, -260, 0, 780, -260, 0, -780, -520, 0, -520, -520, 0, -260, -520, 0, 0, -520, 0, 260, -520, 0, 520, -520, 0, 780, -520, 0, -780, -780, 0, -520, -780, 0, -260, -780, 0, 0, -780, 0, 260, -780, 0, 520, -780, 0, 780, -780, 0])

    vertexUv:
      elementsPerItem: 2
      elements: new Float32Array([0, 1, 0.1666666716337204, 1, 0.3333333432674408, 1, 0.5, 1, 0.6666666865348816, 1, 0.8333333134651184, 1, 1, 1, 0, 0.8333333134651184, 0.1666666716337204, 0.8333333134651184, 0.3333333432674408, 0.8333333134651184, 0.5, 0.8333333134651184, 0.6666666865348816, 0.8333333134651184, 0.8333333134651184, 0.8333333134651184, 1, 0.8333333134651184, 0, 0.6666666865348816, 0.1666666716337204, 0.6666666865348816, 0.3333333432674408, 0.6666666865348816, 0.5, 0.6666666865348816, 0.6666666865348816, 0.6666666865348816, 0.8333333134651184, 0.6666666865348816, 1, 0.6666666865348816, 0, 0.5, 0.1666666716337204, 0.5, 0.3333333432674408, 0.5, 0.5, 0.5, 0.6666666865348816, 0.5, 0.8333333134651184, 0.5, 1, 0.5, 0, 0.3333333432674408, 0.1666666716337204, 0.3333333432674408, 0.3333333432674408, 0.3333333432674408, 0.5, 0.3333333432674408, 0.6666666865348816, 0.3333333432674408, 0.8333333134651184, 0.3333333432674408, 1, 0.3333333432674408, 0, 0.1666666716337204, 0.1666666716337204, 0.1666666716337204, 0.3333333432674408, 0.1666666716337204, 0.5, 0.1666666716337204, 0.6666666865348816, 0.1666666716337204, 0.8333333134651184, 0.1666666716337204, 1, 0.1666666716337204, 0, 0, 0.1666666716337204, 0, 0.3333333432674408, 0, 0.5, 0, 0.6666666865348816, 0, 0.8333333134651184, 0, 1, 0])

    vertexNormal:
      elementsPerItem: 3
      elements: new Float32Array([0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1])

  faceElements = new Uint16Array([0, 7, 1, 7, 8, 1, 1, 8, 2, 8, 9, 2, 2, 9, 3, 9, 10, 3, 3, 10, 4, 10, 11, 4, 4, 11, 5, 11, 12, 5, 5, 12, 6, 12, 13, 6, 7, 14, 8, 14, 15, 8, 8, 15, 9, 15, 16, 9, 9, 16, 10, 16, 17, 10, 10, 17, 11, 17, 18, 11, 11, 18, 12, 18, 19, 12, 12, 19, 13, 19, 20, 13, 14, 21, 15, 21, 22, 15, 15, 22, 16, 22, 23, 16, 16, 23, 17, 23, 24, 17, 17, 24, 18, 24, 25, 18, 18, 25, 19, 25, 26, 19, 19, 26, 20, 26, 27, 20, 21, 28, 22, 28, 29, 22, 22, 29, 23, 29, 30, 23, 23, 30, 24, 30, 31, 24, 24, 31, 25, 31, 32, 25, 25, 32, 26, 32, 33, 26, 26, 33, 27, 33, 34, 27, 28, 35, 29, 35, 36, 29, 29, 36, 30, 36, 37, 30, 30, 37, 31, 37, 38, 31, 31, 38, 32, 38, 39, 32, 32, 39, 33, 39, 40, 33, 33, 40, 34, 40, 41, 34, 35, 42, 36, 42, 43, 36, 36, 43, 37, 43, 44, 37, 37, 44, 38, 44, 45, 38, 38, 45, 39, 45, 46, 39, 39, 46, 40, 46, 47, 40, 40, 47, 41, 47, 48, 41])

  gl.useProgram(program)

  diffuseTexture = new Texture("/WoodFloor_DIF.png", diffuseTextureSampler, 0)
  diffuseTexture.load(gl)
  specularTexture = new Texture("/WoodFloor_SPC.png", specularTextureSampler, 1)
  specularTexture.load(gl)
  normalMap = new Texture("/WoodFloor_NRM.png", normalMapSampler, 2)
  normalMap.load(gl)

  uniforms.normalScale.set(gl, 1)

  for name, attribute of attributes
    attribute.populate(gl, buffers[name], attributeData[name])

  buffers.faceElements.bind(gl)
  buffers.faceElements.data(gl, faceElements)

  uniforms.textureRepeat.set(gl, new Float32Array([6, 6]))

  ->
    if diffuseTexture.loaded && specularTexture.loaded && normalMap.loaded && faceElements?
      diffuseTexture.render(gl)
      specularTexture.render(gl)
      normalMap.render(gl)

      for name, attribute of attributes
        attribute.enable(gl, buffers[name], attributeData[name])

      buffers.faceElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, faceElements.length, gl.UNSIGNED_SHORT, 0)
