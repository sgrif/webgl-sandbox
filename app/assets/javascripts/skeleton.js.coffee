class @Skeleton
  constructor: (@joints) ->

  Object.defineProperties @prototype,
    skinMatrices:
      get: ->
        _.map @joints, (joint) ->
          bindPose = joint.transformationMatrix
          bindPose.times(bindPose.inverse)
