class @Vector3
  @ORIGIN = new this(0, 0, 0)
  @UP = new this(0, 1, 0)

  constructor: (@x, @y, @z) ->

  plus: ({ x, y, z}) -> new Vector3(@x + x, @y + y, @z + z)
  minus: ({ x, y, z }) -> new Vector3(@x - x, @y - y, @z - z)

  multiplyScalar: (s) -> new Vector3(@x * s, @y * s, @z * s)

  divideScalar: (scalar) ->
    if scalar != 0
      new Vector3(@x / scalar, @y / scalar, @z / scalar)
    else
      new Vector3(0, 0, 0)

  cross: ({ x, y, z }) ->
    newX = @y * z - @z * y
    newY = @z * x - @x * z
    newZ = @x * y - @y * x
    new Vector3(newX, newY, newZ)

  normalize: ->
    @divideScalar(@length)

  Object.defineProperties @prototype,
    length:
      get: -> Math.sqrt(@x * @x + @y * @y + @z * @z)
