class @SkeletonBuilder
  constructor: (@data) ->
    @_parsedJoints = []

  build: ->
    new Skeleton(@_joints())

  _joints: ->
    _.map(@data, @_parseJoint, this)

  _parseJoint: ({ name, parent, rotq, pos }, index) ->
    @_parsedJoints[index] ?=
      if parent == -1
        new RootJoint(name, new Quaternion(rotq...), new Vector3(pos...))
      else
        parentJoint = @_parseJoint(@data[parent], parent)
        new Joint(name, parentJoint, new Quaternion(rotq...), new Vector3(pos...))
