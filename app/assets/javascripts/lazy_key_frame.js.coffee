class @LazyKeyFrame
  constructor: (@translationElements, @rotationElements, @scaleElements) ->

  Object.defineProperties @prototype,
    translation:
      get: ->
        @_translation ?= new Vector3(@translationElements...)

    rotation:
      get: ->
        @_rotation ?= new Quaternion(@rotationElements...)

    scale:
      get: ->
        @_scale ?= new Vector3(@scaleElements...)
