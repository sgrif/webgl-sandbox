class @Matrix4
  constructor: (elements) ->
    elements ?= [
      1, 0, 0, 0
      0, 1, 0, 0
      0, 0, 1, 0
      0, 0, 0, 1
    ]
    @elements = new Float32Array(elements)

  row: (y) -> (x) => @at(x, y)
  column: (x) -> (y) => @at(x, y)
  at: (x, y) ->
    @elements[x + y * 4]

  times: (other) ->
    result = []
    for y in [0..3]
      for x in [0..3]
        result.push(multiplyRows(other.row(y), @column(x)))
    new Matrix4(result)

  multiplyRows = (row, other) ->
    result = 0
    for i in [0..3]
      result += row(i) * other(i)
    result

  unwrap = (row) ->
    row(i) for i in [0..3]

  translate: ({ x, y, z }) ->
    applyTranslation = (col) =>
      @at(col,0) * x + @at(col,1) * y + @at(col,2) * z + @at(col,3)

    new Matrix4([
      unwrap(@row(0))...
      unwrap(@row(1))...
      unwrap(@row(2))...
      unwrap(applyTranslation)...
    ])
