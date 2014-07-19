class @Uniform
  constructor: (@location, @setterName) ->

  set: (gl, value) ->
    gl[@setterName](@location, value)

  @build: (gl, program, name, setterName) ->
    new this(gl.getUniformLocation(program, name), setterName)
