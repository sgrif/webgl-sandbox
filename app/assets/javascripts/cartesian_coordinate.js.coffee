#= require vector3
class @CartesianCoordinate extends Vector3
  Object.defineProperties @prototype,
    cartesianCoordinates:
      get: -> this
