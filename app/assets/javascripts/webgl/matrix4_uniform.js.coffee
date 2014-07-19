class @Matrix4Uniform extends Uniform
  set: (gl, value) ->
    gl.uniformMatrix4fv(@location, false, value.elements)
