class @JointKeyframes
  constructor: (@keys) ->

  keyframeAt: (time) ->
    prevKeyIndex = @lastKeyBefore(time)
    prevKey = @keys[prevKeyIndex]
    nextKey = @keys[prevKeyIndex + 1] || @keys[prevKeyIndex]
    prevKey.blendWith(nextKey, time)

  lastKeyBefore: (time) ->
    min = 0
    max = @keys.length - 1

    loop
      i = (min + max) >> 1
      if @keys[i].time > time
        max = i - 1
      else
        next_key = @keys[i+1]
        if !next_key? || next_key.time >= time
          return i
        else
          min = i + 1
