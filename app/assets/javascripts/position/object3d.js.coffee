#= require vector3

class @Object3d
  constructor: ({ @position, @rotation }) ->
    @position ?= Vector3.ORIGIN
    @rotation ?= Vector3.ORIGIN

  rotate: (rotation) ->
    new Object3d
      position: @position
      rotation: @rotation.plus(rotation)

  Object.defineProperties @prototype,
    matrix:
      get: ->
        new Matrix4()
          .translate(@position)
          .rotateEuler(@rotation)
