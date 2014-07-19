class @OrbitalObject3d
  constructor: (@center, @rotation, @distance) ->

  Object.defineProperties @prototype,
    matrix:
      get: ->
        @_matrix ?= new Matrix4.lookingAt(@eye, @center, Vector3.UP)

    eye:
      get: ->
        @_eye ?= @rotation
          .cartesianCoordinates
          .multiplyScalar(@distance)
          .plus(@center)
