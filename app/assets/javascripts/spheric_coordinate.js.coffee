class @SphericCoordinate
  constructor: (@radius, @polar, @azimuth) ->

  plusSpheric: ({ radius, polar, azimuth }) ->
    new @constructor(@radius + radius, @polar + polar, @azimuth + azimuth)

  Object.defineProperties @prototype,
    cartesianCoordinates:
      get: ->
        new CartesianCoordinate(
          @radius * Math.sin(@polar) * Math.sin(@azimuth)
          @radius * Math.cos(@polar)
          @radius * Math.sin(@polar) * Math.cos(@azimuth)
        )

    sphericCoordinates:
      get: -> this
