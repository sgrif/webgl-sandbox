class @OrbitalObject3d
  constructor: (@center, @rotation) ->

  Object.defineProperties @prototype,
    matrix:
      get: ->
        new Matrix4.lookingAt(@eye, @center, Vector3.UP)

    eye:
      get: ->
        @rotation.cartesianCoordinates.plus(@center)
