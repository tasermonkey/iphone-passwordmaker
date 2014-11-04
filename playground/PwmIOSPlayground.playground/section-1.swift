// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

println(str + "!!!!")

let speed:float_t = 4
var age = 31
var name = "James"
var isOld:Bool = age > 30

var msg = name + " " + String(age)

var better = "\(name) is \(age) years old."

var stuff = ["Cats", "Netflix"]

stuff[0] = "Dogs"

var occupations = [
  "Malcolm": "Captain",
  "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"

var optionalString: String? = "Hello"
optionalString == nil

var optionalName: String? = nil
var greeting = "Hello!"
if let name = optionalName {
  greeting = "Hello, \(name)"
}

let vegetable = "red pepper"
switch vegetable {
case "celery":
  let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercress":
  let vegetableComment = "That would make a good tea sandwich."
case let x where x.hasSuffix("pepper"):
  let vegetableComment = "Is it a spicy \(x)?"
default:
  let vegetableComment = "Everything tastes good in soup."
}

let interestingNumbers = [
  "Prime": [2, 3, 5, 7, 11, 13],
  "Fibonacci": [1, 1, 2, 3, 5, 8],
  "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var largestKind:String = ""
for (kind, numbers) in interestingNumbers {
  for number in numbers {
    if number > largest {
      largest = number
      largestKind = kind
    }
  }
}
largest
largestKind


extension Optional {
  func or(defaultValue: T) -> T {
    switch(self) {
    case .None:
      return defaultValue
    case .Some(let value):
      return value
    }
  }
}

func greet(name: String, day: String) -> String {
  let lunchSpecial2 = ["Monday": "Meatloaf",
    "Tuesday": "Tacos",
    "Wednesday": "Pizza",
    "Thursday": "Burgers",
    "Friday": "Burrito"
    ][day].or("Weekend")
  return "Hello \(name), today is \(day), the lunch special is \(lunchSpecial2)."
}
greet("Bob", "Tuesday")
greet("Joe", "Thursday")
greet("James", "asdfasd")

func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
  var min = scores[0]
  var max = scores[0]
  var sum = 0
  
  for score in scores {
    if score > max {
      max = score
    } else if score < min {
      min = score
    }
    sum += score
  }
  
  return (min, max, sum)
}
let statistics = calculateStatistics([5, 3, 100, 3, 9])
statistics.sum
statistics.2

func sumOf(numbers: [Int]) -> Int {
  var sum = 0
  for number in numbers {
    sum += number
  }
  return sum
}

func sumOf(numbers: Int...) -> Int {
  return sumOf(numbers)
}
sumOf()
sumOf(42, 597, 12)

func avgOf(numbers: Int...) -> Int {
  return avgOf(numbers)
}

func avgOf(numbers: [Int]) -> Int {
  var sum = sumOf(numbers)
  if ( numbers.count > 0 ) {
    return sum / numbers.count
  } else {
    return 0;
  }
}
avgOf()
avgOf(1,2,3,4,5)
avgOf(5,6,7)

func returnFifteen() -> Int {
  var y = 10
  func add() {
    y += 5
  }
  add()
  return y
}
returnFifteen()


func makeIncrementer() -> (Int -> Int) {
  func addOne(number: Int) -> Int {
    return 1 + number
  }
  return addOne
}
var increment = makeIncrementer()
increment(7)

func hasAnyMatches(list: [Int], condition: Int -> Bool) -> Bool {
  for item in list {
    if condition(item) {
      return true
    }
  }
  return false
}
func lessThan(number: Int) -> (Int -> Bool) {
  func ret(o: Int) -> Bool {
    return o < number
  }
  return ret
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(numbers, lessThan(13))

var result = numbers.map({
(number: Int) -> Int in
let result = 3 * number
return result
})
result
result = numbers.map({(number: Int) -> Int in
  return number % 2 == 0 ? number : 0
})
result
let sortedNumbers = sorted(numbers) { $0 > $1 }
sortedNumbers

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
