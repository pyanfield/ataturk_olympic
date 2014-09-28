// Playground - noun: a place where people can play

import UIKit

// 2.21
// 类，结构体，枚举通过提供协议所要求的方法，属性的具体实现来采用(adopt)协议。任意能够满足协议要求的类型被称为协议的遵循者。
// 协议可以要求其遵循者提供特定的实例属性，实例方法，类方法，操作符或下标脚本等。
// 使用关键字 protocol 来定义

// 如果一个类在含有父类的同时也采用了协议，应当把父类放在所有的协议之前
//  class SubClass: SuperClass, Protocol1, Protocol2

// 协议中的属性经常被加以var前缀声明其为变量属性，在声明后加上{ set get }来表示属性是可读写的，只读的属性则写作{ get }
protocol SomeProtocol {
    // 可读写
    var mustBeSettable : Int { get set }
    
    // 只读属性，在实现的时候如果实现了 set 方法，也依然有效
    var doesNotNeedToBeSettable: Int { get }
    
    // 使用 class 定义一个类属性或者方法，如果在 struct 或 enum 中，使用 static 关键字
    class var someTypeProperty: Int { get set }
    
    // mutating 方法，在类中实现该协议时，不用写 mutating 关键字，但是如果在 struct 或者 enum 中实现的话，必须要添加 mutating 关键字
    mutating func toggle()
    
    // 如果在类中实现了该构造方法，则必须在类中构造函数之前用 required 来修饰， 即在 class 中 required init(){}
    // 如果某类即实现了该协议，又重写了其父类的构造函数，则应该在类中用 required 和 override 来修饰： required override init(){}
    init()
}


protocol FullyNamed {
    var fullName: String { get }
}
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil ) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : " ") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName

// 在扩展中添加协议成员
// 通过扩展为已存在的类型遵循协议时，该类型的所有实例也会随之添加协议中的方法.
protocol PrintText{
    func log()
}

extension String: PrintText{
    func log(){
        println(">>" + self)
    }
}
var hello = "Hello Anfield"
hello.log()

// 当一个类型已经实现了协议中的所有要求，却没有声明时，可以通过扩展来补充协议声明
struct Test{
    var name: String
    func log(){
        println(":: " + name)
    }
}
extension Test:PrintText{}
var t: PrintText = Test(name: "Kaka")
t.log()

// 协议类型可以被集合使用，表示集合中的元素均为协议类型, 如 [PrintText]

// 协议能够继承一到多个其他协议。语法与类的继承相似，多个协议间用逗号，分隔
// protocol InheritingProtocol: SomeProtocol, AnotherProtocol

// 你可以在协议的继承列表中,通过添加“class”关键字,限制协议只能适配到类（class）类型。（结构体或枚举不能遵循该协议）。
// 该“class”关键字必须是第一个出现在协议的继承列表中，其后，才是其他继承协议。
protocol SomeClassOnlyProtocol: class, SomeProtocol {
    func test()
}

// 协议合成
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
// 一个协议可由多个协议采用protocol<SomeProtocol， AnotherProtocol>这样的格式进行组合，称为协议合成(protocol composition)。
func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    println("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(birthdayPerson)
// 协议合成并不会生成一个新协议类型，而是将多个协议合成为一个临时的协议，超出范围后立即失效。


// is 操作符用来检查实例是否遵循了某个协议。
// as? 返回一个可选值，当实例遵循协议时，返回该协议类型;否则返回nil
// as 用以强制向下转型。

// @objc用来表示协议是可选的，也可以用来表示暴露给Objective-C的代码，此外，@objc型协议只对类有效，因此只能在类中检查协议的一致性。

@objc protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    // Circle类把area实现为基于存储型属性radius的计算型属性
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {
    // Country类则把area实现为存储型属性
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    // as?返回一个可选值，当实例遵循协议时，返回该协议类型;否则返回nil
    if let objectWithArea = object as? HasArea {
        println("Area is \(objectWithArea.area)")
    } else {
        println("Something that doesn't have an area")
    }
}

// 可选协议含有可选成员，其遵循者可以选择是否实现这些成员。在协议中使用 optional 关键字作为前缀来定义可选成员。
// 可选协议在调用时使用可选链,可以在可选方法名称后加上?来检查该方法是否被实现。
// 可选方法和可选属性都会返回一个可选值(optional value)，当其不可访问时，?之后语句不会执行，并整体返回nil.
// 可选协议只能在含有 @objc 前缀的协议中生效。且 @objc 的协议只能被类遵循.
@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}

@objc class Counter {
    var count = 0
    //
    var dataSource: CounterDataSource?
    func increment() {
        // 由于dataSource可能为nil，因此在dataSource后边加上了?标记来表明只在dataSource非空时才去调用incrementForCount方法
        // 即使dataSource存在，但是也无法保证其是否实现了incrementForCount方法，因此在incrementForCount方法后边也加有 ? 标记
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement? {
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    println(counter.count)
}

class TowardsZeroSource: CounterDataSource {
    func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    println(counter.count)
}





