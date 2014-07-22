class @AnimationBuilder
  constructor: ({ @name, @length, @fps, @hierarchy }) ->

  build: ->
    new Animation(@name, @length * 1000, @fps, @_parsedHeirarchy())

  _parsedHeirarchy: ->
    _.map(@hierarchy, @_parseKeyframes, this)

  _parseKeyframes: ({ keys }) ->
    new JointKeyframes(_.map(keys, @_parseFrame, this))

  _parseFrame: ({ scl, rot, pos, time }) ->
    new LazyKeyFrame(pos, rot, scl, time * 1000)
