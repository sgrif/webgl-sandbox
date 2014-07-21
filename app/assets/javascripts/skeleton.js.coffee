class @Skeleton
  constructor: (@joints) ->
    @boneTextureWidth = @boneTextureHeight = 32

  createTexture: (uniforms, index) ->
    image =
      data: @skinMatrices
      width: @boneTextureWidth
      height: @boneTextureHeight
    new DataTexture(image, uniforms, index)

  Object.defineProperties @prototype,
    skinMatrices:
      get: ->
        unless @_matrix?
          @_matrix = new Float32Array(@boneTextureWidth * @boneTextureHeight * 4)
          for joint, i in @joints
            bindPose = joint.transformationMatrix
            skinMatrix = bindPose.times(bindPose.inverse)

            for x, i2 in skinMatrix.elements
              @_matrix[i2 + i * 16] = x
        @_matrix
