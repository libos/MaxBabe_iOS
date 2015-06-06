//: Playground - noun: a place where people can play

import Cocoa
import Foundation





let now = NSDate()
let calendar = NSCalendar.currentCalendar()
let components = calendar.components(.CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitWeekday, fromDate: now)

let hour = String(format: "%02d",  components.hour)

let month = String(format: "%02d", components.month)
let day  = String(format: "%02d", components.weekday-1)


var str = "Hello, playground"


println(str)

var horizon = 90 * sin( idx * M_PI/6.0 )
var vertical = 90 - 90*cos(idx * M_PI/6.0 )




let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    println("on the x-axis with an x value of \(x)")
case (0, let y):
    println("on the y-axis with a y value of \(y)")
case let (x, y):
    println("somewhere else at (\(x), \(y))")
}

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

sorted(names,>)

//: let reversed = names.sort({ $0 > $1 })
//
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map {
    (var number) -> String in
    var output = ""
    while number > 0 {
        output = digitNames[number % 10]! + output
        number /= 10
    }
    return output
}
class TestCls {
    var count = 0;
    func incrementBy(amount: Int, numberOfTimes: Int) {
        count += amount * numberOfTimes
    }
}
var te = TestCls()
te.incrementBy(5, numberOfTimes: 3)

 
extension Int {
    func repeats(task:(a:Int)->()){
        for idx in 0..<self{
            task(a:idx)
            println(idx)
        }
        
    }
}


3.repeats({(a:Int)->() in
    println(a)
})




let a:String = "/Users/apple/Library/Application Support/iPhone Simulator/4.3/Applications/550AF26D-174B-42E6-881B-B7499FAA32B7/Documents/hi.png"
a.stringByDeletingLastPathComponent

a.pathExtension






var x:String = "asfa<br>sadfasf<br>basdfdasfas<br>asdfas"
var range = x.rangeOfString("<br>")

let start = advance(x.startIndex, distance(x.startIndex,range!.startIndex))
let end = advance(x.startIndex, distance(x.startIndex,range!.endIndex))

x = x.stringByReplacingCharactersInRange(start..<end, withString: "\n")
x = x.stringByReplacingOccurrencesOfString("<br>", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
x
x[start..<end]




NSLocale.preferredLanguages()[0]
NSLocale.preferredLanguages()




