// Playground - noun: a place where people can play

import UIKit

// 2.10
// 由于结构体（struct）属于值类型。当值类型的实例被声明为常量的时候，它的所有属性也就成了常量。
// 引用类型的类（class）则不一样，把一个引用类型的实例赋给一个常量后，仍然可以修改实例的变量属性。

// 延迟存储属性
// 延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用 lazy 来标示一个延迟存储属性。
// 必须将延迟存储属性声明成变量（使用 var 关键字），因为属性的值在实例构造完成之前可能无法得到。
// 而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性。
// 延迟属性很有用，当属性的值依赖于在实例的构造过程结束前无法知道具体值的外部因素时，或者当属性的值需要复杂或大量计算时，可以只在需要的时候来计算它。
// 因为对于某些诸如导入文件等消耗时间的操作，可以将其声明为 lazy 属性，这样只有在用的时候再去实例化。

class DataImporter {
    /*
    DataImporter 是一个将外部文件中的数据导入的类。
    这个类的初始化会消耗不少时间。
    */
    var fileName = "data.txt"
    // 这是提供数据导入功能
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // 这是提供数据管理功能
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// DataImporter 实例的 importer 属性还没有被创建

println(manager.importer.fileName)
// DataImporter 实例的 importer 属性现在被创建了
// 输出 "data.txt”

// 计算属性
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {        // 如果不设置 newCenter，将自动使用 newValue 作为设置的新值的参数名
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                    size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
println("square.origin is now at (\(square.origin.x), \(square.origin.y))")

// 只读计算属性
// 只有 getter 没有 setter 的计算属性就是只读计算属性。只读计算属性总是返回一个值，可以通过点运算符访问，但不能设置新的值。
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    // 只读属性，可以省略 get 关键字和花括号
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
println("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")

// 属性观察器
// 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，甚至新的值和现在的值相同的时候也不例外。
// willSet 在设置新的值之前调用
// didSet 在新的值被设置之后立即调用, 如果在didSet观察器里为属性赋值，这个值会替换观察器之前设置的值。
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {        // 如果不设置参数名，则默认是  newValue
            println("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {                        // 可以自定义参数名称，如果不设置参数名，则默认是 oldValue
            if totalSteps > oldValue  {
                println("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps

// 计算属性和属性观察器所描述的模式也可以用于全局变量和局部变量.
// 全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy特性。
// 局部范围的常量或变量不会延迟计算。

// 类型属性
// 类型属性用于定义特定类型所有实例共享的数据，比如所有实例都能用的一个常量（就像 C 语言中的静态常量），或者所有实例都能访问的一个变量（就像 C 语言中的静态变量）。
// 使用关键字static来定义值类型的类型属性，关键字class来为类（class）定义类型属性。
struct SomeStructure {
    // 对于 struct , enum 这样值类型的，可以定义存储型，也可以是计算类型属性
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int{
        return 999
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty = 2
}
class SomeClass {
    // 对于类，只能定义计算类型属性
    class var computedTypeProperty: Int{
        return 999
    }
}
SomeClass.computedTypeProperty
SomeEnumeration.storedTypeProperty
SomeStructure.computedTypeProperty

// 2.11
class Counter {
    var count: Int = 0
    // 默认第二个参数如果没有设置外部参数名，则外部参数名和内部参数名一致，类似默认条件了 #
    func incrementBy(amount: Int, numberOfTimes: Int) {
        // 该处可以使用 self.count, 如果参数名中有 count ，则必须使用 self.count
        count += amount * numberOfTimes
    }
    // 设置外部参数名给第二个参数
    // 默认调用的时候可以省略第一参数名
    func add(number: Int, toNumber number2: Int) -> Int{
        return number + number2
    }
    // 强制第一个参数名内外一致， 第二个参数省略参数名
    func subduction(#number:Int, _ second:Int) -> Int{
        return number - second
    }
}

let counter = Counter()
counter.incrementBy(10, numberOfTimes: 2)
counter.count
counter.add(10, toNumber: 10)
counter.subduction(number: 10, 10)

// 结构体和枚举是值类型。一般情况下，值类型的属性不能在它的实例方法中被修改。
// 如果你确实需要在某个具体的方法中修改结构体或者枚举的属性，你可以选择变异(mutating)这个方法，然后方法就可以从方法内部改变它的属性
struct MutablePoint {
    var x = 0.0, y = 0.0
    // 注意这里用 mutating 来修饰
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
    mutating func moveBackBy(deltaX: Double, deltaY: Double){
        // mutating 方法能赋值给隐含属性 self 一个全新的实例
        self = MutablePoint(x: x-deltaX, y: y-deltaY)
    }
}
var somePoint = MutablePoint(x: 1.0, y: 1.0)
somePoint.moveByX(2.0, y: 3.0)
println("The point is now at (\(somePoint.x), \(somePoint.y))")
somePoint.moveBackBy(1.0, deltaY: 1.0)
println("The point is now at (\(somePoint.x), \(somePoint.y))")

enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case Off:
            self = Low
        case Low:
            self = High
        case High:
            self = Off
        }
    }
}
var ovenLight = TriStateSwitch.Low
ovenLight.next()
// ovenLight 现在等于 .High
ovenLight.next()
// ovenLight 现在等于 .Off

// 类型方法(Type Methods)
// 声明类的类型方法，在方法的func关键字之前加上关键字class；声明结构体和枚举的类型方法，在方法的func关键字之前加上关键字static。
class SomeClassA {
    class func someTypeMethod() {
        println("called from class method")
    }
}
SomeClassA.someTypeMethod()

// 游戏初始时，所有的游戏等级（除了等级 1）都被锁定。每次有玩家完成一个等级，这个等级就对这个设备上的所有玩家解锁。
// 同时检测玩家的当前等级。
struct LevelTracker {
    static var highestUnlockedLevel = 1
    // 类型方法
    static func unlockLevel(level: Int) {
        if level > highestUnlockedLevel {
            // bug here: 在 playground 中，如果直接给 highestUnlockedLevel = level ,会报错  EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
            // 但是如果在 Application 中就不会有这个错误
            LevelTracker.highestUnlockedLevel = level
        }
    }
    static func levelIsUnlocked(level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    var currentLevel = 1
    mutating func advanceToLevel(level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    // 注意这里是 let 定义的常量，在 init 初始化的时候可以设置初始值，之后就不能改变了。
    let playerName: String
    func completedLevel(level: Int) {
        LevelTracker.unlockLevel(level + 1)
        tracker.advanceToLevel(level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.completedLevel(2)
player.playerName
//println("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")




