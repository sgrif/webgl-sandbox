class @Vector4
  @ORIGIN = new Vector4(0, 0, 0, 1)

  constructor: (@x, @y, @z, @w) ->

  toArray: -> [@x, @y, @z, @w]
