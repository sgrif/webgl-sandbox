#= require vector3
class @CartesianCoordinate extends Vector3
  plusSpheric: (spheric) ->
    { x, y, z } = spheric.cartesianCoordinates
    new @constructor(@x + x, @y + y, @z + z)

  Object.defineProperties @prototype,
    cartesianCoordinates:
      get: -> this

    sphericCoordinates:
      get: ->
        radius = Math.sqrt(@x * @x + @y * @y + @z * @z)
        polar = Math.acos(@y / radius)
        azimuth = Math.atan(@x / @z)
        new SphericCoordinate(radius, polar, azimuth)
