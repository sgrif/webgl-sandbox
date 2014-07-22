class @Animation
  constructor: (@name, @duration, @fps, @hierarchy) ->

  transformationsAtTime: (time) ->
    _.map @hierarchy, (keys) ->
      keyframe = keys[time] || keys[0]
      Matrix4.composedOf(
        keyframe.translation
        keyframe.rotation
        keyframe.scale
      )
