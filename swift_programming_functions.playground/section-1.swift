import UIKit

// 2.6
// 函数无返回值，虽然没有返回值被定义，函数依然返回了特殊的值，叫 Void。它其实是一个空的元组（tuple），没有任何元素，可以写成()。

func count(string: String) -> (vowels: Int, consonants: Int, others: Int) {
    var vowels = 0, consonants = 0, others = 0
    for character in string {
        switch String(character).lowercaseString {
        case "a", "e", "i", "o", "u":
            ++vowels
        case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
        "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
            ++consonants
        default:
            ++others
        }
    }
    return (vowels, consonants, others)
}
let total = count("some arbitrary string!")
// 注意这里对返回值各个参数的调用 total.xxx
println("\(total.vowels) vowels and \(total.consonants) consonants")

// 外部参数名 func someFunction(externalParameterName localParameterName: Int)
// 当其他人在第一次读你的代码，函数参数的意图显得不明显时，考虑使用外部参数名。如果函数参数名的意图是很明显的，那就不需要定义外部参数名了.

// 如果你需要提供外部参数名，但是局部参数名已经定义好了，那么你不需要写两次参数名。相反，只写一次参数名，并用井号（#）作为前缀就可以了。
// 这告诉 Swift 使用这个参数名作为局部和外部参数名。
func containsCharacter(#string: String, #characterToFind: Character) -> Bool {
    for character in string {
        if character == characterToFind {
            return true
        }
    }
    return false
}
let containsAVee = containsCharacter(string: "aardvark", characterToFind: "v")

// 可以在函数体中为每个参数定义默认值。当默认值被定义后，调用这个函数时可以忽略这个参数。
// 将带有默认值的参数放在函数参数列表的最后。这样可以保证在函数调用时，非默认参数的顺序是一致的，同时使得相同的函数在不同情况下调用时显得更为清晰。
func join(string s1: String, toString s2: String, withJoiner joiner: String = " ") -> String {
    return s1 + joiner + s2
}
join(string: "hello", toString: "world", withJoiner: "-")
join(string: "hello", toString: "world")

// 当你未给带默认值的参数提供外部参数名时，Swift 会自动提供外部名字。此时外部参数名与局部名字是一样的，就像你已经在局部参数名前写了井号（#）一样。
// 可以使用下划线（_）作为默认值参数的外部参数名，这样可以在调用时不用提供外部参数名。但是给带默认值的参数命名总是更加合适的。

// 通过在变量类型名后面加入（...）的方式来定义可变参数,一个函数至多能有一个可变参数，而且它必须是参数表中最后的一个。这样做是为了避免函数调用时出现歧义。
func arithmeticMean(numbers: Double...) -> Double {
    var total: Double = 0
    // 注意这里调用可变参数的方法
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// 如果函数有一个或多个带默认值的参数，而且还有一个可变参数，那么把可变参数放在参数表的最后。

// 函数参数默认是常量。通过在参数名前加关键字 var 来定义变量参数:
func alignRight(var string: String, count: Int, pad: Character) -> String {
    let amountToPad = count - countElements(string)
    if amountToPad < 1 {
        return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
        // 这里 string 是变量，不是常量
        string = padString + string
    }
    return string
}
let originalString = "hello"
// originalString 并不会改变
let paddedString = alignRight(originalString, 10, "-")
originalString

// 想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（In-Out Parameters）。
// 定义一个输入输出参数时，在参数定义前加 inout 关键字。
// 当传入的参数作为输入输出参数时，需要在参数前加&符，表示这个值可以被函数修改。
// 输入输出参数不能有默认值，而且可变参数不能用 inout 标记。
func swapTwoInts(inout a: Int, inout b: Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
println("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

// 每个函数都有种特定的函数类型，由函数的参数类型和返回类型组成。
// 没有参数，而且返回值为空的函数的类型是：() -> ()，或者叫“没有参数，并返回 Void 类型的函数”。没有指定返回类型的函数总返回 Void。在Swift中，Void 与空的元组是一样的。
// 在 Swift 中，使用函数类型就像使用其他类型一样。
func addTwoInts(a: Int, b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts

// 你可以用(Int, Int) -> Int这样的函数类型作为另一个函数的参数类型。这样你可以将函数的一部分实现交由给函数的调用者。
func printMathResult(mathFunction: (Int, Int) -> Int, a: Int, b: Int) {
    println("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

// 可以用函数类型作为另一个函数的返回类型。你需要做的是在返回箭头（->）后写一个完整的函数类型。
func stepForward(input: Int) -> Int {
    return input + 1
}
func stepBackward(input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    return backwards ? stepBackward : stepForward
}
var currentValue = 3
let moveNearerToZero = chooseStepFunction(currentValue > 0)
println("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    println("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
println("zero!")

// 可以把函数定义在别的函数体中，称作嵌套函数（nested functions）。上面的 chooseStepFunction 可以通过以下方式替换。
//func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
//    func stepForward(input: Int) -> Int { return input + 1 }
//    func stepBackward(input: Int) -> Int { return input - 1 }
//    return backwards ? stepBackward : stepForward
//}
