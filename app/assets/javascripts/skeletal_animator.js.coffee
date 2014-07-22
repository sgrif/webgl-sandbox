class @SkeletalAnimator
  constructor: (@skeleton, @animation) ->

  setTime: (time) ->
    @skeleton.applyTransformations(@animation.transformationsAtTime(time))
