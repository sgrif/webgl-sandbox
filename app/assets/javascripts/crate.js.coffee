@setupCrate = (gl, program, textureSampler) ->
  attributes =
    vertexCoord: VertexAttribute.build(gl, program, "vertexCoord")
    vertexUv: VertexAttribute.build(gl, program, "vertexUv")
    vertexNormal: VertexAttribute.build(gl, program, "vertexNormal")

  buffers =
    cubeElements: Buffer.create(gl.ELEMENT_ARRAY_BUFFER, gl)
    vertexCoord: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexUv: Buffer.create(gl.ARRAY_BUFFER, gl)
    vertexNormal: Buffer.create(gl.ARRAY_BUFFER, gl)

  attributeData =
    vertexCoord:
      elementsPerItem: 3
      elements: new Float32Array([
        # Front
        -1, -1,  1
         1, -1,  1
         1,  1,  1
        -1,  1,  1

        # Back
        -1, -1, -1
        -1,  1, -1
         1,  1, -1
         1, -1, -1

        # Top
        -1,  1, -1
        -1,  1,  1
         1,  1,  1
         1,  1, -1

        # Bottom
        -1, -1, -1
         1, -1, -1
         1, -1,  1
        -1, -1,  1

        # Right
         1, -1, -1
         1,  1, -1
         1,  1,  1
         1, -1,  1

        # Left
        -1, -1, -1
        -1, -1,  1
        -1,  1,  1
        -1,  1, -1
      ])
    vertexUv:
      elementsPerItem: 2
      elements: new Float32Array([
        0, 0
        1, 0
        1, 1
        0, 1

        1, 0
        1, 1
        0, 1
        0, 0

        0, 1
        0, 0
        1, 0
        1, 1

        1, 1
        0, 1
        0, 0
        1, 0

        1, 0
        1, 1
        0, 1
        0, 0

        0, 0
        1, 0
        1, 1
        0, 1
      ])
    vertexNormal:
      elementsPerItem: 3
      elements: new Float32Array([
        0, 0, 1
        0, 0, 1
        0, 0, 1
        0, 0, 1

        0, 0, -1
        0, 0, -1
        0, 0, -1
        0, 0, -1

        0, 1, 0
        0, 1, 0
        0, 1, 0
        0, 1, 0

        0, -1, 0
        0, -1, 0
        0, -1, 0
        0, -1, 0

        1, 0, 0
        1, 0, 0
        1, 0, 0
        1, 0, 0

        -1, 0, 0
        -1, 0, 0
        -1, 0, 0
        -1, 0, 0
      ])
  cubeElements = new Uint16Array([
    0, 1, 2,      0, 2, 3     # Front face
    4, 5, 6,      4, 6, 7     # Back face
    8, 9, 10,     8, 10, 11   # Top face
    12, 13, 14,   12, 14, 15  # Bottom face
    16, 17, 18,   16, 18, 19  # Right face
    20, 21, 22,   20, 22, 23  # Left face
  ])

  for name, attribute of attributes
    attribute.populate(gl, buffers[name], attributeData[name])

  buffers.cubeElements.bind(gl)
  buffers.cubeElements.data(gl, cubeElements)

  texture = new Texture("/crate.gif", textureSampler)
  texture.load(gl)

  ->
    if texture.loaded
      texture.render(gl)

      buffers.cubeElements.bind(gl)
      gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
