class @Quaternion
  constructor: (@x, @y, @z, @w) ->

  toMatrix: ->
    new Matrix4(mat4.fromQuat(mat4.create(), [@x, @y, @z, @w]))
