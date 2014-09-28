// Playground - noun: a place where people can play

import UIKit

// 2.14 构造过程（Initialization）
// 与 Objective-C 中的构造器不同，Swift 的构造器无需返回值，它们的主要任务是保证新实例在第一次使用前完成正确的初始化。

// 当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观测器（property observers）。
// 可以通过输入参数和可选属性类型来定制构造过程，也可以在构造过程中修改常量属性。

// 构造器并不像函数和方法那样在括号前有一个可辨别的名字。所以在调用构造器时，主要通过构造器中的参数名和类型来确定需要调用的构造器。
// 正因为参数如此重要，如果你在定义构造器时没有提供参数的外部名字，Swift 会为每个构造器的参数自动生成一个跟内部名字相同的外部名，就相当于在每个构造参数之前加了一个哈希符号。
// 如果你不希望为构造器的某个参数提供外部名字，你可以使用下划线_来显示描述它的外部名，以此覆盖上面所说的默认行为。
struct Celsius {
    var temperatureInCelsius: Double = 0.0
    // 如果一个属性在声明的时候没有初始值，而在构造函数中也没有设置初始值，则表示该属性可能为 nil,默认值为 nil,应该声明成 optional type
    var value: String?
    // 对某个类实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。如果声明的时候没有设置初始值，则必须在构造函数中设置。
    let hello: String
    let number: Int = 0
    // 两个 init 构造函数都含有唯一的 Double 类型的参数，但是参数名称不同，所以没有冲突
    // 如果是普通的方法，不能有重复的方法名出现
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
        hello = "temperatureInCelsius"
        // 在构造函数中可以对常量重新赋值
        number = Int(fahrenheit)
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
        hello = "temperatureInCelsius"
    }
    init(_ name: String){
        println(name);
        hello = name
    }
}

// 结构体对所有存储型属性提供了默认值且自身没有提供定制的构造器，它们能自动获得一个逐一成员构造器。
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)
// 如果你为某个值类型定义了一个定制的构造器，你将无法访问到默认构造器（如果是结构体，则无法访问逐一对象构造器）。
// 这个限制可以防止你在为值类型定义了一个更复杂的，完成了重要准备构造器之后，别人还是错误的使用了那个自动生成的构造器。

// “Designated Initializers and Convenience Initializers”
// Swift 提供了两种类型的类构造器来确保所有类实例中存储型属性都能获得初始值，它们分别是指定构造器和便利构造器。

// 每一个类都必须拥有至少一个指定构造器。在某些情况下，许多类通过继承了父类中的指定构造器而满足了这个条件。

// 便利构造器是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入的实例。

// 指定构造器必须总是向上代理
// 便利构造器必须总是横向代理

// Swift 中类的构造过程包含两个阶段。
//      第一个阶段，每个存储型属性通过引入它们的类的构造器来设置初始值。当每一个存储型属性值被确定后，
//      第二阶段开始，它给每个类一次机会在新实例准备使用之前进一步定制它们的存储型属性。
// 两段式构造过程的使用让构造过程更安全，同时在整个类层级结构中给予了每个类完全的灵活性。
// 两段式构造过程可以防止属性值在初始化之前被访问；也可以防止属性被另外一个构造器意外地赋予不同的值。

// 跟 Objective-C 中的子类不同，Swift 中的子类不会默认继承父类的构造器。Swift 的这种机制可以防止一个父类的简单构造器被一个更专业的子类继承，并被错误的用来创建子类的实例。

// 如果你重载的构造器是一个指定构造器，你可以在子类里重载它的实现，并在自定义版本的构造器中调用父类版本的构造器。
// 如果你重载的构造器是一个便利构造器，你的重载过程必须通过调用同一类中提供的其它指定构造器来实现。
// 与方法、属性和下标不同，在重载构造器时你没有必要使用关键字 override 。

// 类的指定构造器的写法跟值类型简单构造器一样：
//        init(parameters) {
//            statements
//        }
// 便利构造器也采用相同样式的写法，但需要在init关键字之前放置 convenience 关键字，并使用空格将它们俩分开：
//        convenience init(parameters) {
//            statements
//        }

// 通过闭包和函数来设置属性的默认值
// 如果某个存储型属性的默认值需要特别的定制或准备，你就可以使用闭包或全局函数来为其属性提供定制的默认值。
struct Checkerboard {
    // 注意这里的闭包设置属性
    // 如果你使用闭包来初始化属性的值，请记住在闭包执行时，实例的其它部分都还没有初始化。
    // 这意味着你不能够在闭包里访问其它的属性，就算这个属性有默认值也不允许。
    // 同样，你也不能使用隐式的self属性，或者调用其它的实例方法。
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10 {
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
        }()   // 结尾括号，表示执行该闭包，只有执行了该闭包，才是真正的将执行结果赋值了
    
    func squareIsBlackAtRow(row: Int, column: Int) -> Bool {
        return boardColors[(row * 10) + column]
    }
}

// 2.15 析构过程（Deinitialization）
// 在一个类的实例被释放之前，析构函数被立即调用。用关键字deinit来标示析构函数，类似于初始化函数用init来标示。析构函数只适用于类类型。
// 在类的定义中，每个类最多只能有一个析构函数。析构函数不带任何参数，在写法上不带括号：
//        deinit {
//            // 执行析构过程
//        }
// 析构函数是在实例释放发生前一步被自动调用。不允许主动调用自己的析构函数。

struct Bank {
    static var coinsInBank = 10_000
    static func vendCoins(var numberOfCoinsToVend: Int) -> Int {
        numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receiveCoins(coins: Int) {
        coinsInBank += coins
    }
}
class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(coins: Int) {
        coinsInPurse += Bank.vendCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}
var playerOne: Player? = Player(coins: 100)
println("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
println("There are now \(Bank.coinsInBank) coins left   in the bank")
playerOne!.winCoins(2_000)
println("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
println("The bank now only has \(Bank.coinsInBank) coins left")
playerOne = nil
println("PlayerOne has left the game")
println("The bank now has \(Bank.coinsInBank) coins")