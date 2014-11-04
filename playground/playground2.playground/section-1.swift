
class Shape {
  var numberOfSides = 0
  func simpleDescription() -> String {
    return "A shape with \(numberOfSides) sides."
  }
}

var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()


class NamedShape {
  var numberOfSides: Int = 0
  let name: String
  
  init(name: String) {
    self.name = name
  }
  
  func simpleDescription() -> String {
    return "A shape with \(numberOfSides) sides."
  }
}
var shape2 = NamedShape(name: "square")
shape2.numberOfSides = 4
shape2.simpleDescription()

class Square: NamedShape {
  var sideLength: Double
  
  init(sideLength: Double, name: String) {
    self.sideLength = sideLength
    super.init(name: name)
    numberOfSides = 4
  }
  
  func area() ->  Double {
    return sideLength * sideLength
  }
  
  override func simpleDescription() -> String {
    return "A square with sides of length \(sideLength)."
  }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

class Circle: NamedShape {
  var radius: Double
  
  init(radius: Double, name: String) {
    self.radius = radius
    super.init(name: name)
    numberOfSides = 0
  }
  
  func area() ->  Double {
    return 3.14 * radius * radius;
  }
  
  override func simpleDescription() -> String {
    return "A circle with radius \(radius)."
  }
}

let circleTest = Circle(radius: 2.34, name: "test circle")

class EquilateralTriangle: NamedShape {
  var sideLength: Double = 0.0
  
  init(sideLength: Double, name: String) {
    self.sideLength = sideLength
    super.init(name: name)
    numberOfSides = 3
  }
  
  var perimeter: Double {
  get {
    return 3.0 * sideLength
  }
  set {
    sideLength = newValue / 3.0
  }
  }
  
  override func simpleDescription() -> String {
    return "An equilateral triangle with sides of length \(sideLength)."
  }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
triangle.perimeter
triangle.perimeter = 9.9
triangle.sideLength


class TriangleAndSquare {
  var triangle: EquilateralTriangle {
  willSet {
    square.sideLength = newValue.sideLength
  }
  }
  var square: Square {
  willSet {
    triangle.sideLength = newValue.sideLength
  }
  }
  init(size: Double, name: String) {
    square = Square(sideLength: size, name: name)
    triangle = EquilateralTriangle(sideLength: size, name: name)
  }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
triangleAndSquare.square.sideLength
triangleAndSquare.triangle.sideLength
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
triangleAndSquare.triangle.sideLength


func umm() -> Dictionary<String, String> {
  
  let myDict =  ["Hello": "World", "Foo": "Bar"]
  return myDict
}
var myDict = umm()
