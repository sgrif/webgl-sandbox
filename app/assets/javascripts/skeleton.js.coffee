class @Skeleton
  constructor: (@joints) ->
    @boneTextureWidth = @boneTextureHeight = 32

  applyTransformations: (transformations) ->
    for joint, i in @joints
      joint.applyTransformation(transformations[i])

  createTexture: (uniforms, index) ->
    image =
      data: @skinMatrices
      width: @boneTextureWidth
      height: @boneTextureHeight
    new DataTexture(image, uniforms, index)

  Object.defineProperties @prototype,
    skinMatrices:
      get: ->
        @_matrix = new Float32Array(@boneTextureWidth * @boneTextureHeight * 4)
        for joint, i in @joints
          for x, i2 in joint.skinMatrix
            @_matrix[i2 + i * 16] = x
        @_matrix
