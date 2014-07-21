#= require ./joint

class @RootJoint extends Joint
  constructor: (@name, @rotation, @translation) ->

  Object.defineProperties @prototype,
    transformationMatrix:
      get: -> @relativeMatrix
