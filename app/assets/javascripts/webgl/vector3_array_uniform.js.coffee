class @Vector3ArrayUniform extends Uniform
  set: (gl, values) ->
    flattened = _.flatten(_.map(values, ({ x, y, z }) -> [x, y, z]))
    gl.uniform3fv(@location, new Float32Array(flattened))
