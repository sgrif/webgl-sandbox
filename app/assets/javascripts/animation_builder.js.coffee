class @AnimationBuilder
  constructor: ({ @name, @length, @fps, @hierarchy }) ->

  build: ->
    new Animation(@name, @length, @fps, @_parsedHeirarchy())

  _parsedHeirarchy: ->
    _.map(@hierarchy, @_parseKeyframes, this)

  _parseKeyframes: ({ keys }) ->
    _.map(keys, @_parseFrame, this)

  _parseFrame: ({ scl, rot, pos }) ->
    Matrix4.composedOf(
      new Vector3(pos...)
      new Quaternion(rot...)
      new Vector3(scl...)
    )
