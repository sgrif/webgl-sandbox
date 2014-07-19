class @Texture
  constructor: (@src, @uniform) ->
    @loaded = false

  load: (gl) ->
    @texture = gl.createTexture()
    @image = new Image()
    @image.onload = @processImage(gl)
    @image.src = @src

  processImage: (gl) -> =>
    gl.bindTexture(gl.TEXTURE_2D, @texture)
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true)
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, @image)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
    gl.bindTexture(gl.TEXTURE_2D, null)
    @loaded = true

  render: (gl) ->
    gl.activeTexture(gl.TEXTURE0)
    gl.bindTexture(gl.TEXTURE_2D, @texture)
    gl.uniform1i(@uniform, 0)
