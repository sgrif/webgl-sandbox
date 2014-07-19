class @ColorUniform extends Uniform
  constructor: (location) ->
    super(location, "uniform3fv")

  set: (gl, { r, g, b }) ->
    super(gl, new Float32Array([r, g, b]))
