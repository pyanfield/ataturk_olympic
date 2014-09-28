// Playground - noun: a place where people can play

import UIKit

// 2.20
// 扩展就是向一个已有的类、结构体或枚举类型添加新功能（functionality）。
// 扩展和 Objective-C 中的分类（categories）类似。（不过与Objective-C不同的是，Swift 的扩展没有名字。）
// Swift 中的扩展可以：
//    添加计算型属性和计算静态属性
//    定义实例方法和类型方法
//    提供新的构造器
//    定义下标
//    定义和使用新的嵌套类型
//    使一个已有类型符合某个协议

// 声明一个扩展使用关键字extension：
//    extension SomeType: SomeProtocol, AnotherProctocol {
//        // 协议实现写到这里
//    }

extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
println("One inch is \(oneInch) meters")
let threeFeet = 3.ft
println("Three feet is \(threeFeet) meters")

// 扩展可以添加新的计算属性，但是不可以添加存储属性，也不可以向已有属性添加属性观测器(property observers)。

// 扩展能向类中添加新的便利构造器，但是它们不能向类中添加新的指定构造器或析构函数。指定构造器和析构函数必须总是由原始的类实现来提供。

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
    size: Size(width: 5.0, height: 5.0))

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
    size: Size(width: 3.0, height: 3.0))

// 扩展方法 Methods
extension Int{
    // 传入的时一个没有参数没有返回值的函数
    func repetitions(task: () -> ()){
        for i in 0..<self{
            task()
        }
    }
    
    // 结构体和枚举类型中修改self或其属性的方法必须将该实例方法标注为mutating，正如来自原始实现的修改方法一样。
    mutating func square(){
        self = self * self
    }
    
    subscript(digitIndex: Int) -> Int{
        var decimalBase = 1
            for _ in 1...digitIndex{
                decimalBase *= 10
            }
        return (self / decimalBase) % 10
    }
}
3.repetitions{
    println("Test repetition function on Int")
}

var three = 3
three.square()
println(three)

println(12345678[5])

// 扩展添加嵌套类型
extension Character {
    enum Kind {
        case Vowel, Consonant, Other
    }
    var kind: Kind {
        switch String(self).lowercaseString {
        case "a", "e", "i", "o", "u":
            return .Vowel
        case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
        "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
            return .Consonant
        default:
            return .Other
            }
    }
}

func printLetterKinds(word: String) {
    println("'\(word)' is made up of the following kinds of letters:")
    for character in word {
        switch character.kind {
            case .Vowel:
                print("vowel ")
            case .Consonant:
                print("consonant ")
            case .Other:
                print("other ")
            }
    }
    print("\n")
}

printLetterKinds("Hello")







