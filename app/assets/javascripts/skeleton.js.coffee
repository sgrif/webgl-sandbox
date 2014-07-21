class @Skeleton
  constructor: (@joints) ->

  Object.defineProperties @prototype,
    skinMatrices:
      get: ->
        unless @_matrix?
          @_matrix = new Float32Array(@joints.length * 16)
          for joint, i in @joints
            bindPose = joint.transformationMatrix
            skinMatrix = bindPose.times(bindPose.inverse)

            for x, i2 in skinMatrix.elements
              @_matrix[i2 + i * 16] = x
        @_matrix
