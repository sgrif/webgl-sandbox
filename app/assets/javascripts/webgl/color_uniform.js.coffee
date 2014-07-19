class @ColorUniform extends Uniform
  set: (gl, { r, g, b }) ->
    gl.uniform3f(@location, r, g, b)
