class @Vector3Uniform extends Uniform
  set: (gl, { x, y, z }) ->
    gl.uniform3fv(@location, new Float32Array([x, y, z]))
