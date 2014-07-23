class @JointKeyframes
  constructor: (@keys) ->

  keyframeAt: (time) ->
    prevKeyIndex = @lastKeyBefore(time)
    prevKey = @keys[prevKeyIndex]
    nextKey = @keys[prevKeyIndex + 1] || @keys[prevKeyIndex]
    prevKey.blendWith(nextKey, time)

  lastKeyBefore: (time) ->
    for key, i in @keys by -1
      if key.time <= time
        return i
