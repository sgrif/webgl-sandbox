class @Buffer
  constructor: (@type, @buffer) ->

  bind: (gl) ->
    gl.bindBuffer(@type, @buffer)

  data: (gl, data) ->
    gl.bufferData(@type, data, gl.STATIC_DRAW)

  @create: (type, gl) ->
    new this(type, gl.createBuffer())
