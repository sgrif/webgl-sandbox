class @Vector4Uniform extends Uniform
  set: (gl, { x, y, z, w }) ->
    gl.uniform4fv(@location, new Float32Array([x, y, z, w]))
