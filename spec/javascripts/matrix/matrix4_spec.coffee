#= require matrix/matrix4

describe "Matrix4", ->
  matA = new Matrix4([
    1, 0, 0, 0
    0, 1, 0, 0
    0, 0, 1, 0
    1, 2, 3, 1
  ])
  matB = new Matrix4([
    1, 0, 0, 0
    0, 1, 0, 0
    0, 0, 1, 0
    4, 5, 6, 1
  ])
  out = new Matrix4([
    0, 0, 0, 0
    0, 0, 0, 0
    0, 0, 0, 0
    0, 0, 0, 0
  ])
  id = new Matrix4([
    1, 0, 0, 0
    0, 1, 0, 0
    0, 0, 1, 0
    0, 0, 0, 1
  ])

  it "can be given an initial set of elements", ->
    expect(matA.at(3, 0)).toBe(1)
    expect(matA.at(3, 1)).toBe(2)
    expect(matB.at(3, 0)).toBe(4)
    expect(matB.at(3, 1)).toBe(5)

  it "is an identity matrix by default", ->
    expect(new Matrix4()).toEqual(id)

  describe "#times", ->
    it "multiplies two matrices", ->
      expected = new Matrix4([
        1, 0, 0, 0
        0, 1, 0, 0
        0, 0, 1, 0
        5, 7, 9, 1
      ])

      expect(matA.times(matB)).toEqual(expected)

    it "multiplies each row against the each column and adds the results", ->
      first = new Matrix4([
        4, 5, 6, 0
        6, 5, 4, 0
        4, 6, 5, 0
        0, 0, 0, 1
      ])
      second = new Matrix4([
        1, 2, 3, 0
        3, 2, 1, 0
        2, 1, 3, 0
        0, 0, 0, 1
      ])
      expected = new Matrix4([
        28, 33, 29, 0
        28, 31, 31, 0
        26, 33, 31, 0
        0, 0, 0, 1
      ])

      expect(first.times(second)).toEqual(expected)

    it "combines unrelated elements without changing them", ->
      model = new Matrix4([
        1, 0, 0, 0
        0, 1, 0, 0
        0, 0, 1, 0
        0, 0, -4, 1
      ])
      rotation = new Matrix4([
        0.8660253882408142, 0, -0.5, 0
        0, 1, 0, 0
        0.5, 0, 0.8660253882408142, 0
        0, 0, 0, 1
      ])
      expected = new Matrix4([
        0.8660253882408142, 0, -0.5, 0
        0, 1, 0, 0
        0.5, 0, 0.8660253882408142, 0
        0, 0, -4, 1
      ])

      expect(model.times(rotation)).toEqual(expected)

  describe "#translate", ->
    it "applies the translation to the matrix", ->
      expected = new Matrix4([
        1, 0, 0, 0
        0, 1, 0, 0
        0, 0, 1, 0
        5, 7, 9, 1
      ])
      vector = x: 4, y: 5, z: 6

      expect(matA.translate(vector)).toEqual(expected)

    it "adds every value in row 0 for x", ->
      original = new Matrix4([
        1, 2, 3, 4
        0, 0, 0, 0
        0, 0, 0, 0
        5, 6, 7, 8
      ])
      expected = new Matrix4([
        1, 2, 3, 4
        0, 0, 0, 0
        0, 0, 0, 0
        7, 10, 13, 16
      ])
      vector = x: 2, y: 0, z: 0

      expect(original.translate(vector)).toEqual(expected)

    it "adds every value in row 1 for y", ->
      original = new Matrix4([
        0, 0, 0, 0
        2, 1, 4, 3
        0, 0, 0, 0
        5, 6, 7, 8
      ])
      expected = new Matrix4([
        0, 0, 0, 0
        2, 1, 4, 3
        0, 0, 0, 0
        11, 9, 19, 17
      ])
      vector = x: 0, y: 3, z: 0

      expect(original.translate(vector)).toEqual(expected)

    it "adds every value in row 2 for y", ->
      original = new Matrix4([
        0, 0, 0, 0
        0, 0, 0, 0
        3, 1, 2, 4
        5, 6, 7, 8
      ])
      expected = new Matrix4([
        0, 0, 0, 0
        0, 0, 0, 0
        3, 1, 2, 4
        8, 7, 9, 12
      ])
      vector = x: 0, y: 0, z: 1

      expect(original.translate(vector)).toEqual(expected)

  describe "#rotateX", ->
    it "rotates on the x axis", ->
      angleInRadians = Math.PI / 2
      expected = new Matrix4([
        1, 0, 0, 0,
        0, Math.cos(angleInRadians), Math.sin(angleInRadians), 0,
        0, -Math.sin(angleInRadians), Math.cos(angleInRadians), 0,
        1, 2, 3, 1
      ])

      expect(matA.rotateX(angleInRadians)).toEqualMatrix(expected)

  describe "#rotateY", ->
    it "rotates on the y axis", ->
      angleInRadians = Math.PI / 2
      expected = new Matrix4([
        Math.cos(angleInRadians), 0, -Math.sin(angleInRadians), 0
        0, 1, 0, 0
        Math.sin(angleInRadians), 0, Math.cos(angleInRadians), 0
        1, 2, 3, 1
      ])

      expect(matA.rotateY(angleInRadians)).toEqualMatrix(expected)

  describe "#rotateZ", ->
    it "rotates on the z axis", ->
      angleInRadians = Math.PI / 2
      expected = new Matrix4([
        Math.cos(angleInRadians), Math.sin(angleInRadians), 0, 0
        -Math.sin(angleInRadians), Math.cos(angleInRadians), 0, 0
        0, 0, 1, 0
        1, 2, 3, 1
      ])

      expect(matA.rotateZ(angleInRadians)).toEqualMatrix(expected)

  beforeEach ->
    @addMatchers
      toEqualMatrix: (expected) ->
        for element, i in @actual.elements
          y = Math.floor(i / 4)
          x = i % 4
          expect(element).toBeCloseTo(expected.elements[i], 8, "at #{y}, #{x}")
