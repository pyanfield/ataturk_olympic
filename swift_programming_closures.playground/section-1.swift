// Playground - noun: a place where people can play
// when import UIKit, there is error when using sorted. 
// http://stackoverflow.com/questions/26249784/implicit-returns-from-single-expression-closures-in-swift-playground
//import UIKit

// 2.7
// 闭包是自包含的函数代码块，可以在代码中被传递和使用。 Swift 中的闭包与 C 和 Objective-C 中的代码块（blocks）以及其他一些编程语言中的 lambdas 函数比较相似。
// 闭包可以捕获和存储其所在上下文中任意常量和变量的引用。

// Swift 标准库提供了sorted函数，会根据您提供的基于输出类型排序的闭包函数将已知类型数组中的值进行排序。
// sorted 传入两个参数，其一是一个数组，其二是一个闭包函数，该函数有两个参数，参数类型与数组相同，且返回一个布尔值，即 (type, type) -> Bool 的函数类型。
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = sorted(names, backwards)             // [String], (String,String) -> Bool

// 如果闭包函数作为另一个函数的最后一个参数传递的时候，可以使用闭包表达式语法来表示：
// { (parameters) -> returnType in
//      statements
// }
// 所以上面的写法可以改进为：
reversed = sorted(names,{
    (s1: String, s2:String) -> Bool in
    return s1 > s2
})

// 闭包表达式语法可以使用常量、变量和inout类型作为参数，不提供默认值。 也可以在参数列表的最后使用可变参数。 元组也可以作为参数和返回值。

// 实际上任何情况下，通过内联闭包表达式构造的闭包作为参数传递给函数时，都可以推断出闭包的参数和返回值类型，这意味着您几乎不需要利用完整格式构造任何内联闭包。
// 所以对上面的写法进一步改进为：
reversed = sorted(names,{
    s1, s2 in
    return s1 > s2
})

// 单行表达式闭包可以通过隐藏return关键字来隐式返回单行表达式的结果
var reversed1 = sorted(names, {
    s1, s2 in
    s1 > s2 // 闭包函数体只包含了一个表达式
})

// Swift 自动为内联函数提供了参数名称缩写功能，您可以直接通过$0,$1,$2来顺序调用闭包的参数。
// 如果您在闭包表达式中使用参数名称缩写，您可以在闭包参数列表中省略对其的定义，并且对应参数名称缩写的类型会通过函数类型进行推断。
// in关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成：
var reversed2 = sorted(names, { $0 > $1 })

// 而对于 sorted 还可以使用运算符函数
reversed2 = sorted(names, >)
// 其实只要是因为 String 类型定义了关于 > 的字符串实现，而 > 作为一个函数，起类型正好是 (String, String) -> Bool 类型，所以 Swift 自动推断出具体的实现过程。

// 需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。
// 尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用。
func someFunctionThatTakesAClosure(closure: () -> ()) {
    // 函数体部分
}
// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure({
    // 闭包主体部分
})
// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}
// 所以上面的 sorted 可以写成：
var reversed3 = sorted(names,{ $0 > $1 })
var reversed4 = sorted(names){ $0 > $1 }
// 如果函数只有闭包表达式一个参数，那么可以省略掉 (), 直接写成:
someFunctionThatTakesAClosure{
    // 闭包主体部分
}

// 捕获值（Capturing Values）
// 闭包可以在其定义的上下文中捕获常量或变量。 即使定义这些常量和变量的原域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。
func makeIncrementor(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementor() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementor
}
let incrementByTen = makeIncrementor(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()
// incrementor函数并没有获取任何参数，但是在函数体内访问了runningTotal和amount变量。这是因为其通过捕获在包含它的函数体内已经存在的runningTotal和amount变量而实现。
// 由于没有修改amount变量，incrementor实际上捕获并存储了该变量的一个副本，而该副本随着incrementor一同被存储。
// 每次调用该函数的时候都会修改runningTotal的值，incrementor捕获了当前runningTotal变量的引用，而不是仅仅复制该变量的初始值。
// 捕获一个引用保证了当makeIncrementor结束时候并不会消失，也保证了当下一次执行incrementor函数时，runningTotal可以继续增加。
// 如果您将闭包赋值给一个类实例的属性，并且该闭包通过指向该实例或其成员来捕获了该实例，您将创建一个在闭包和实例间的强引用环。 Swift 使用捕获列表来打破这种强引用环。
// 无论您将函数/闭包赋值给一个常量还是变量，您实际上都是将常量/变量的值设置为对应函数/闭包的引用。
// incrementByTen指向闭包的引用是一个常量，而并非闭包内容本身。
// 这也意味着如果您将闭包赋值给了两个不同的常量/变量，两个值都会指向同一个闭包：
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
