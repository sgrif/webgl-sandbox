class @LightUniform
  constructor: (@uniformLocations) ->

  set: (gl, lights) ->
    for light, i in lights
      uniforms = @uniformLocations[i]
      position = new Float32Array([light.position.toArray()..., 1])
      direction = new Float32Array([light.direction.toArray()..., 0])

      gl.uniform4fv(uniforms.position, position)
      gl.uniform4fv(uniforms.direction, direction)
      gl.uniform1f(uniforms.spotAngle, light.spotAngle)
      gl.uniform1f(uniforms.penumbraAngle, light.penumbraAngle)

  @build: (gl, program, name, size) ->
    uniformLocations = for i in [0..size]
      position: gl.getUniformLocation(program, "lights[#{i}].position")
      direction: gl.getUniformLocation(program, "lights[#{i}].direction")
      spotAngle: gl.getUniformLocation(program, "lights[#{i}].spotAngle")
      penumbraAngle: gl.getUniformLocation(program, "lights[#{i}].penumbraAngle")
    new this(uniformLocations)
