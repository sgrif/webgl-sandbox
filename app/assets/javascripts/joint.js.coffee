class @Joint
  constructor: (@name, @parent, @rotation, @translation) ->

  Object.defineProperties @prototype,
    absoluteTransformationMatrix:
      get: ->
        @_absoluteTransformationMatrix ?=
          @parent.absoluteTransformationMatrix.times(@relativeTransformationMatrix)

    relativeTransformationMatrix:
      get: ->
        @_relativeTransformationMatrix ?= new Matrix4(@relativeBindPoseMatrix.elements)

      set: (newMatrix) ->
        @relativeTransformationMatrix.elements = newMatrix
        @_absoluteTransformationMatrix = undefined

    absoluteBindPoseMatrix:
      get: ->
        @_absoluteBindPoseMatrix ?= @parent.absoluteBindPoseMatrix.times(@relativeBindPoseMatrix)

    relativeBindPoseMatrix:
      get: ->
        @_relativeBindPoseMatrix ?= @rotation.toMatrix().withPosition(@translation)
