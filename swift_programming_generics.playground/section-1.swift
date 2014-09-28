// Playground - noun: a place where people can play

import UIKit

// 2.22
// 泛型是 Swift 强大特征中的其中一个，许多 Swift 标准库是通过泛型代码构建出来的。

// 通常用一单个字母T来命名类型参数。不过，你可以使用任何有效的标识符来作为类型参数名。
// 请始终使用大写字母开头的驼峰式命名法（例如T和KeyType）来给类型参数命名，以表明它们是类型的占位符，而非类型值.

// 注意函数名字之后的 <T>
func swapTwoValues<T>(inout a: T, inout b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
// 这个函数的泛型版本使用了占位类型名字（通常此情况下用字母T来表示）来代替实际类型名（如Int、String或Double）。
// 另外一个不同之处在于这个泛型函数名后面跟着的占位类型名字（T）是用尖括号括起来的（<T>）。这个尖括号告诉 Swift 那个T是swapTwoValues函数所定义的一个类型。
// 因为T是一个占位命名类型，Swift 不会去查找命名为T的实际类型。

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)

// 可支持多个类型参数，命名在尖括号中，用逗号分开。

// 使用泛型实现一个栈
// 注意：结构体名字之后 <T>
struct Stack<T> {
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

// 类型约束语法
// 在一个类型参数名后面的类型约束，通过冒号分割，来作为类型参数链的一部分
// T 必须是 SomeClass 的子类，U 必须遵循 SomeProtocol 协议
//    func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//        // function body goes here
//    }

// Swift 标准库中定义了一个Equatable协议，该协议要求任何遵循的类型实现等式符（==）和不等符（!=）对任何两个该类型进行比较。
// 所有的 Swift 标准类型自动支持Equatable协议。

func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")

// 当定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分是非常有用的。
// 一个关联类型作为协议的一部分，给定了类型的一个别名。作用于关联类型上实际类型在协议被实现前是不需要指定的。关联类型被指定为typealias关键字。
protocol Container {
    // 定义了一个关联类型 ItemType
    typealias ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct Heap<T>: Container {
    // original Stack<T> implementation
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeAtIndex(0)
    }
    // conformance to the Container protocol
    // Swift 因此可以推断出被用作这个特定容器的ItemType的T的合适类型。
    mutating func append(item: T) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> T {
        return items[i]
    }
}

// 扩展一个存在的类型为一指定关联类型
// Swift的Array已经提供append方法，一个count属性和通过下标来查找一个自己的元素。这三个功能都达到Container协议的要求。
extension Array: Container {}
// Array的append方法和下标保证Swift可以推断出ItemType所使用的适用的类型。定义了这个扩展后，你可以将任何Array当作Container来使用。

// Where 语句
// 类型约束能够确保类型符合泛型函数或类的定义约束
func allItemsMatch<
    C1: Container, C2: Container
    // 一个where语句，紧跟在在类型参数列表后面，where语句后跟一个或者多个针对关联类型的约束，以及（或）一个或多个类型和关联类型间的等价(equality)关系。
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
    (someContainer: C1, anotherContainer: C2) -> Bool {
        
        // 检查两个Container的元素个数是否相同
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // 检查两个Container相应位置的元素彼此是否相等
        for i in 0 ..< someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // 如果所有元素检查都相同则返回true
        return true
        
}

var heap = Heap<String>()
heap.push("uno")
heap.push("dos")
heap.push("tres")

var arr = ["uno", "dos", "tres"]

if allItemsMatch(heap, arr) {
    println("All items match.")
} else {
    println("Not all items match.")
}








