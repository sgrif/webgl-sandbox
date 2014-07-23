#= require ./joint

class @RootJoint extends Joint
  constructor: (@name, @rotation, @translation) ->
    super(@name, undefined, @rotation, @translation)

  Object.defineProperties @prototype,
    absoluteTransformationMatrix:
      get: -> @relativeTransformationMatrix

    absoluteBindPoseMatrix:
      get: -> @relativeBindPoseMatrix
