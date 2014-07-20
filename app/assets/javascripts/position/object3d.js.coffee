#= require vector3

class @Object3d
  constructor: ({ @position, @rotation, @scale }) ->
    @position ?= Vector3.ORIGIN
    @rotation ?= Vector3.ORIGIN
    @scale ?= Vector3.FULL_SCALE

  rotate: (rotation) ->
    new Object3d
      position: @position
      rotation: @rotation.plus(rotation)
      scale: @scale

  Object.defineProperties @prototype,
    matrix:
      get: ->
        new Matrix4()
          .translate(@position)
          .rotateEuler(@rotation)
          .scale(@scale)
