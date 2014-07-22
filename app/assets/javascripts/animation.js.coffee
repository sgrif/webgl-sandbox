class @Animation
  constructor: (@name, @duration, @fps, @hierarchy) ->

  transformationsAtTime: (time) ->
    _.map @hierarchy, (keys) -> keys.keyframeAt(time)
