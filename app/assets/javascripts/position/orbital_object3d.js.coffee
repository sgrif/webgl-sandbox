class @OrbitalObject3d
  constructor: (@center, @rotation) ->

  rotateSpheric: (rotation) ->
    new @constructor(@center, @rotation.plusSpheric(rotation))

  Object.defineProperties @prototype,
    matrix:
      get: ->
        Matrix4.lookingAt(@eye, @center, Vector3.UP)

    eye:
      get: ->
        @rotation.cartesianCoordinates.plus(@center)
