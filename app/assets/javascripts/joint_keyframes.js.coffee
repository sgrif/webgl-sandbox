class @JointKeyframes
  constructor: (@keys) ->

  keyframeAt: (time) ->
    prevKey = @lastKeyBefore(time)
    nextKey = @firstKeyAfter(time)
    prevKey.blendWith(nextKey, time)

  lastKeyBefore: (time) ->
    bucketIndex = @_bucketIndexFor(time)
    until key?
      key = _.findLast(@buckets[bucketIndex], (key) -> key.time <= time)
      bucketIndex--
    key

  firstKeyAfter: (time) ->
    bucketIndex = @_bucketIndexFor(time)
    until key?
      key = _.find(@buckets[bucketIndex], (key) -> key.time > time)
      bucketIndex++
    key

  _bucketIndexFor: (time) ->
    Math.floor(time / 50)

  _createBuckets: ->
    buckets = []
    for key in @keys
      bucket = buckets[@_bucketIndexFor(key.time)] ||= []
      bucket.push(key)
    buckets

  Object.defineProperties @prototype,
    buckets:
      get: ->
        @_buckets ?= @_createBuckets()
