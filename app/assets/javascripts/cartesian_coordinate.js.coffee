#= require vector3
class @CartesianCoordinate extends Vector3
  Object.defineProperties @prototype,
    cartesianCoordinates:
      get: -> this

    sphericCoordinates:
      get: ->
        radius = Math.sqrt(@x * @x + @y * @y + @z * @z)
        polar = Math.acos(@y / radius)
        azimuth = Math.atan(@x / @z)
        new SphericCoordinate(radius, polar, azimuth)
