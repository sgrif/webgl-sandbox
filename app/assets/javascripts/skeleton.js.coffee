class @Skeleton
  constructor: (@joints) ->
    @boneTextureWidth = @boneTextureHeight = 32

  applyTransformations: (transformations) ->
    for joint, i in @joints
      { translation, rotation, scale } = transformations[i]
      joint.relativeTransformationMatrix = Matrix4.composedOf(translation, rotation, scale)

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
          transformation = joint.absoluteTransformationMatrix
          bindPose = joint.absoluteBindPoseMatrix
          skinMatrix = transformation.times(bindPose.inverse)

          for x, i2 in skinMatrix.elements
            @_matrix[i2 + i * 16] = x
        @_matrix
