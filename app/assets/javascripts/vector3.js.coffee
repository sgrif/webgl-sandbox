class @Vector3
  constructor: (@x, @y, @z) ->

  minus: ({ x, y, z }) ->
    new Vector3(@x - x, @y - y, @z - z)

  cross: ({ x, y, z }) ->
    newX = @y * z - @z * y
    newY = @z * x - @x * z
    newZ = @x * y - @y * x
    new Vector3(newX, newY, newZ)

  divideScalar: (scalar) ->
    if scalar != 0
      new Vector3(@x / scalar, @y / scalar, @z / scalar)
    else
      new Vector3(0, 0, 0)

  normalize: ->
    @divideScalar(@length)

  Object.defineProperties @prototype,
    length:
      get: -> Math.sqrt(@x * @x + @y * @y + @z * @z)
