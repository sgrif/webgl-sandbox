class @LazyKeyFrame
  constructor: (@translation, @rotation, @scale, @time) ->

  blendWith: (otherKeyframe, time) ->
    scale = (time - @time) / (otherKeyframe.time - @time)
    translation: vec3.lerp(vec3.create(), @translation, otherKeyframe.translation, scale)
    rotation: quat.slerp(quat.create(), @rotation, otherKeyframe.rotation, scale)
    scale: vec3.lerp(vec3.create(), @scale, otherKeyframe.scale, scale)
