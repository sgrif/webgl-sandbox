class @Animation
  constructor: (@name, @duration, @fps, @hierarchy) ->

  transformationsAtTime: (time) ->
    _.map @hierarchy, (keys) ->
      keyframe = keys.lastKeyBefore(time)
      Matrix4.composedOf(
        keyframe.translation
        keyframe.rotation
        keyframe.scale
      )
