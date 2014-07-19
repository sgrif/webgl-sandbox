class @Matrix3Uniform extends Uniform
  set: (gl, value) ->
    gl.uniformMatrix3fv(@location, false, value)
