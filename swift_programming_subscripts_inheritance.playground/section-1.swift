// Playground - noun: a place where people can play

import UIKit

// 2.12 
// 下标脚本（Subscripts）
// 下标脚本是定义在类（Class）、结构体（structure）和枚举（enumeration）中，是访问对象、集合或序列的快捷方式，不需要再调用实例的特定的赋值和访问方法。
// 对于同一个目标可以定义多个下标脚本，通过索引值类型的不同来进行重载，而且索引值的个数可以是多个。
// 下标脚本允许你通过在实例后面的方括号中传入一个或者多个的索引值来对实例进行访问和赋值。

struct TimesTable {
    let multiplier: Int
    // 使用 subscript 关键字来修饰
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
// 像访问数组中的某个值一样， subscript 在访问的时候也是用方括号的方式来实现
println("3的6倍是\(threeTimesTable[6])")
// 输出 "3的6倍是18"

// 通常下标脚本是用来访问集合（collection），列表（list）或序列（sequence）中元素的快捷方式。你可以在你自己特定的类或结构体中自由的实现下标脚本来提供合适的功能。
// 下标脚本允许任意数量的入参索引，并且每个入参类型也没有限制。下标脚本的返回值也可以是任何类型。
// 下标脚本可以使用变量参数和可变参数，但使用写入读出（in-out）参数或给参数设置默认值都是不允许的。

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    // 关键字实现下标脚本,可以实现 get / set 方法
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
var matrix = Matrix(rows: 2, columns: 2)
matrix[1,1] = 1.5
matrix[1,1]

// 2.13
// 继承 Inheritance
// 在 Swift 中，继承是区分「类」与其它类型的一个基本特征。
// 在 Swift 中，类可以调用和访问超类的方法，属性和下标脚本（subscripts），并且可以重写（override）这些方法，属性和下标脚本来优化或修改它们的行为。
// 可以为类中继承来的属性添加属性观察器（property observer），这样一来，当属性值改变时，类就会被通知到。
// 可以为任何属性添加属性观察器，无论它原本被定义为存储型属性（stored property）还是计算型属性（computed property）

// 子类可以为继承来的实例方法（instance method），类方法（class method），实例属性（instance property），或下标脚本（subscript）提供自己定制的实现（implementation）。我们把这种行为叫重写（overriding）。
// 如果要重写某个特性，你需要在重写定义的前面加上 override 关键字。

// 通过使用super前缀来访问超类版本的方法，属性或下标脚本.
// 在属性someProperty的 getter 或 setter 的重写实现中，可以通过super.someProperty来访问超类版本的someProperty属性。
// 在下标脚本的重写实现中，可以通过super[someIndex]来访问超类版本中的相同下标脚本。

// 子类并不知道继承来的属性是存储型的还是计算型的，它只知道继承来的属性会有一个名字和类型。你在重写一个属性时，必需将它的名字和类型都写出来。
// 这样才能使编译器去检查你重写的属性是与超类中同名同类型的属性相匹配的。

// 可以将一个继承来的只读属性重写为一个读写属性，只需要你在重写版本的属性里提供 getter 和 setter 即可。但是，你不可以将一个继承来的读写属性重写为一个只读属性。

// 如果你在重写属性中提供了 setter，那么你也一定要提供 getter。
// 如果你不想在重写版本中的 getter 里修改继承来的属性值，你可以直接通过super.someProperty来返回继承来的值，其中someProperty是你要重写的属性的名字。

// 你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了。

// 不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。

// 可以通过把方法，属性或下标脚本标记为final来防止它们被重写，只需要在声明关键字前加上@final特性即可。（例如：final var, final func, final class func, 以及 final subscript）
// 通过在关键字class前添加final特性（final class）来将整个类标记为 final 的，这样的类是不可被继承的，否则会报编译错误。


