class @AnimationBuilder
  constructor: ({ @name, @length, @fps, @hierarchy }) ->

  build: ->
    new Animation(@name, @length, @fps, @_parsedHeirarchy())

  _parsedHeirarchy: ->
    _.map(@hierarchy, @_parseKeyframes, this)

  _parseKeyframes: ({ keys }) ->
    _.map(keys, @_parseFrame, this)

  _parseFrame: ({ scl, rot, pos }) ->
    new Matrix4()
      .translate(new Vector3(pos...))
      .times(new Quaternion(rot...).toMatrix())
      .scale(new Vector3(scl...))
