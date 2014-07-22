class @Texture
  constructor: (@src, @uniform, @index = 0) ->
    @loaded = false
    @magFilter = "LINEAR"
    @minFilter = "LINEAR"
    @generateMipmap = false
    @flipY = true

  load: (gl) ->
    @texture = gl.createTexture()
    @image = new Image()
    @image.onload = @processImage(gl)
    @image.src = @src

  processImage: (gl) -> =>
    gl.bindTexture(gl.TEXTURE_2D, @texture)
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, @flipY)
    @_sendImageData(gl)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl[@magFilter])
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl[@minFilter])
    gl.generateMipmap(gl.TEXTURE_2D) if @generateMipmap
    gl.bindTexture(gl.TEXTURE_2D, null)
    @loaded = true

  render: (gl) ->
    gl.activeTexture(gl["TEXTURE#{@index}"])
    gl.bindTexture(gl.TEXTURE_2D, @texture)
    @uniform.set(gl, @index)

  _sendImageData: (gl) ->
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, @image)
