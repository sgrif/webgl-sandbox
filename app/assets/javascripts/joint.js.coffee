class @Joint
  constructor: (@name, @parent, @rotation, @translation) ->

  Object.defineProperties @prototype,
    absoluteTransformationMatrix:
      get: ->
        @parent.absoluteTransformationMatrix.times(@relativeTransformationMatrix)

    relativeTransformationMatrix:
      get: ->
        @_relativeTransformationMatrix ?= @relativeBindPoseMatrix

      set: (newMatrix) ->
        @_relativeTransformationMatrix = newMatrix

    absoluteBindPoseMatrix:
      get: ->
        @parent.absoluteBindPoseMatrix.times(@relativeBindPoseMatrix)

    relativeBindPoseMatrix:
      get: ->
        @_relativeBindPoseMatrix ?= @rotation.toMatrix().withPosition(@translation)
