class @Joint
  constructor: (@name, @parent, @rotation, @translation) ->
    @__absoluteTransformationMatrix = mat4.create()
    @__skinMatrix = mat4.create()

  applyTransformation: ({ translation, rotation, scale }) ->
    Matrix4.compose(@relativeTransformationMatrix, translation, rotation, scale)
    @_absoluteTransformationMatrix = undefined
    @_skinMatrix = undefined

  Object.defineProperties @prototype,
    absoluteTransformationMatrix:
      get: ->
        @_absoluteTransformationMatrix ?=
          mat4.multiply(
            @__absoluteTransformationMatrix
            @parent.absoluteTransformationMatrix
            @relativeTransformationMatrix
          )

    relativeTransformationMatrix:
      get: ->
        @_relativeTransformationMatrix ?= new Float32Array(@relativeBindPoseMatrix.elements)

    skinMatrix:
      get: ->
        @_skinMatrix ?=
          mat4.multiply(
            @__skinMatrix
            @absoluteTransformationMatrix
            @absoluteBindPoseMatrix.inverse.elements
          )

    absoluteBindPoseMatrix:
      get: ->
        @_absoluteBindPoseMatrix ?= @parent.absoluteBindPoseMatrix.times(@relativeBindPoseMatrix)

    relativeBindPoseMatrix:
      get: ->
        @_relativeBindPoseMatrix ?= @rotation.toMatrix().withPosition(@translation)
