class @VertexAttribute
  constructor: (@location) ->

  populate: (gl, buffer, arrayData) ->
    buffer.bind(gl)
    buffer.data(gl, arrayData.elements)
    buffer.unbind(gl)

  enable: (gl, buffer, arrayData) ->
    buffer.bind(gl)
    gl.enableVertexAttribArray(@location)
    gl.vertexAttribPointer(
      @location
      arrayData.elementsPerItem
      gl.FLOAT
      false
      0
      0
    )
    buffer.unbind(gl)

  @build: (gl, program, name) ->
    new this(gl.getAttribLocation(program, name))
