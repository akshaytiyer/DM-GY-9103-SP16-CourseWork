//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool
var arrayOfInts: [Int]
var dictionaryOfCapitalsByCountry:[String:String]
var winningLotteryNumbers: Set<Int>

let number = 42
let meaningOfLife = String(number)

let fmStation = 91.1

var countingUp = ["one","two"]
let secondElement = countingUp[1]
countingUp.count
countingUp.append("three")

let nameByParkingSpace = [13: "Alice", 27: "Bob"]

//let space13Assignee: String? = nameByParkingSpace[13]
if let space13Assignee = nameByParkingSpace[13] {
    print("Key 13 is assigned in the dictionary")
}

let emptyString = ""
emptyString.isEmpty

let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()
let defaultNumber = Int()
let defaultBool = Bool()

let availableRooms = Set([205,411,412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.14) //Float

let easyPi = 3.14 //This is by default a Double
let floatFromDouble = Float(easyPi) //Converting a float to a double
let folatingPi: Float = 3.14

var anOptionalFloat: Float?
var anOptionalArrayOfStrings: [String]?
var anOptionalArrayOfOptionalStrings: [String]?

var reading1: Float?
var reading2: Float?
var reading3: Float?

reading1 = 9.8
reading2 = 9.2
reading3 = 9.7

//let avgReading = (reading1! + reading2! + reading3!)/3
if let r1 = reading1,
       r2 = reading2,
    r3 = reading3 {
            let avgReading = (r1+r2+r3)/3
} else {
    let errorString = "Instrument reported a reading that was nil"
}

//Looping Structures
for var i = 0; i < countingUp.count; ++i {
    let string = countingUp[i]
    // Use 'string'
}

//A different way of doing the same thing
let range = 0..<countingUp.count
for i in range {
    let string = countingUp[i]
    //Use 'string'
}

//Direct route to enumerate
for string in countingUp
{
    //Use 'string'
}

//Index of each item
for (i, string) in countingUp.enumerate() {
    //(0 , "one"), (1 , "two")
}

for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
}

enum PieType: Int {
    case Apple = 0
    case Cherry
    case Pecan
}

let favouritePie = PieType.Apple

let name: String
switch favouritePie {
case .Apple:
    name = "Apple"
case .Cherry:
    name = "Cherry"
case .Pecan:
    name = "Pecan"
}


//Range values
let osxVersion: Int = 8
switch osxVersion {
case 0...8:
    print("A big cat")
case 9:
    print("Mavericks")
case 10:
    print("Yosemite")
default:
    print("Greetings, people of the future! What's new in 10.\(osxVersion)?")
}

let pieRawValue = PieType.Pecan.rawValue
// pieRawValue is an Int with a value of 2

if let pieType = PieType(rawValue: pieRawValue) {
// Got a valid 'pieType'!
}





