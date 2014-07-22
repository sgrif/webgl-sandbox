class @Joint
  constructor: (@name, @parent, @rotation, @translation) ->

  Object.defineProperties @prototype,
    absoluteTransformationMatrix:
      get: ->
        @_absoluteTransformationMatrix ?=
          @parent.absoluteTransformationMatrix.times(@relativeTransformationMatrix)

    relativeTransformationMatrix:
      get: ->
        @_relativeTransformationMatrix ?= @relativeBindPoseMatrix

      set: (newMatrix) ->
        @_relativeTransformationMatrix = newMatrix
        @_absoluteTransformationMatrix = undefined

    absoluteBindPoseMatrix:
      get: ->
        @_absoluteBindPoseMatrix ?= @parent.absoluteBindPoseMatrix.times(@relativeBindPoseMatrix)

    relativeBindPoseMatrix:
      get: ->
        @_relativeBindPoseMatrix ?= @rotation.toMatrix().withPosition(@translation)
