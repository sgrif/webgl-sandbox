class @JointKeyframes
  constructor: (@keys) ->

  lastKeyBefore: (time) ->
    _.findLast(@keys, (key) -> key.time <= time)
