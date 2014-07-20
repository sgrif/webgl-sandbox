@setupTeapot = (gl, program, textureSampler) ->
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

  texture = new Texture("/metal.jpg", textureSampler)
  texture.load(gl)

  request = new XMLHttpRequest
  request.open("GET", "/teapot.json")
  request.onreadystatechange = ->
    if request.readyState == 4
      data = JSON.parse(request.responseText)
      attributeData.vertexCoord.elements = new Float32Array(data.vertexCoord)
      attributeData.vertexUv.elements = new Float32Array(data.vertexUv)
      attributeData.vertexNormal.elements = new Float32Array(data.vertexNormal)
      faceElements = new Uint16Array(data.faceElements)
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
