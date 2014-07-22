#= require ./texture

class @DataTexture extends Texture
  constructor: (@image, @uniforms, @index = 0) ->
    @magFilter = "NEAREST"
    @minFilter = "NEAREST"
    @generateMipmap = false
    @flipY = false

  load: (gl) ->
    @texture = gl.createTexture()
    @processImage(gl)()

  render: (gl) ->
    gl.activeTexture(gl["TEXTURE#{@index}"])
    gl.bindTexture(gl.TEXTURE_2D, @texture)
    @_sendImageData(gl)
    @uniforms.image.set(gl, @index)
    @uniforms.width.set(gl, @image.width)
    @uniforms.height.set(gl, @image.height)

  _sendImageData: (gl) ->
    gl.getExtension("OES_texture_float")
    gl.texImage2D(
      gl.TEXTURE_2D
      0
      gl.RGBA
      @image.width
      @image.height
      0
      gl.RGBA
      gl.FLOAT
      @image.data
    )
