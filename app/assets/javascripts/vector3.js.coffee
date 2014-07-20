class @Vector3
  @ORIGIN = new this(0, 0, 0)
  @UP = new this(0, 1, 0)
  @FULL_SCALE = new this(1, 1, 1)

  constructor: (@x, @y, @z) ->

  plus: ({ x, y, z}) -> new @constructor(@x + x, @y + y, @z + z)
  minus: ({ x, y, z }) -> new @constructor(@x - x, @y - y, @z - z)

  multiplyScalar: (s) -> new @constructor(@x * s, @y * s, @z * s)

  divideScalar: (scalar) ->
    if scalar != 0
      new @constructor(@x / scalar, @y / scalar, @z / scalar)
    else
      new @constructor(0, 0, 0)

  cross: ({ x, y, z }) ->
    newX = @y * z - @z * y
    newY = @z * x - @x * z
    newZ = @x * y - @y * x
    new @constructor(newX, newY, newZ)

  normalize: ->
    @divideScalar(@length)

  Object.defineProperties @prototype,
    length:
      get: -> Math.sqrt(@x * @x + @y * @y + @z * @z)
