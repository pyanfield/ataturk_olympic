// Playground - noun: a place where people can play

import UIKit

// 2.24
// 不同于C语言中的数值计算，Swift的数值计算默认是不可溢出的。溢出行为会被捕获并报告为错误。
// 你可以使用Swift为你准备的另一套默认允许溢出的数值运算符，如可溢出的加号为&+。所有允许溢出的运算符都是以&开始的。

// 可定制的运算符并不限于那些预设的运算符，你可以自定义中置，前置，后置及赋值运算符，当然还有优先级和结合性。

// 按位异或运算符 ^ 比较两个数，然后返回一个数，这个数的每个位设为1的条件是两个输入数的同一位不同，如果相同就设为0。

// 你有意在溢出时对有效位进行截断，你可采用溢出运算，而非错误处理。Swfit为整型计算提供了5个&符号开头的溢出运算符。
//    溢出加法 &+
//    溢出减法 &-
//    溢出乘法 &*
//    溢出除法 &/
//    溢出求余 &%

var overFlow = UInt8.max
// overFlow += 1
overFlow = overFlow &+ 1

var x = 1
var y = x &/ 0

// 让已有的运算符也可以对自定义的类和结构进行运算，这称为运算符重载。
struct Vector2D{
    var x = 0.0, y = 0.0
}

// 需要定义和实现一个中置运算的时候,不需要添加 infix 关键字
func + (letf: Vector2D, right: Vector2D) -> Vector2D{
    return Vector2D(x: letf.x + right.x, y: letf.y + right.y)
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector

// 实现一个前置或后置运算符时，在定义该运算符的时候于关键字func之前标注 prefix 或 postfix 属性。
prefix func - (v: Vector2D) -> Vector2D{
    return Vector2D(x: -v.x, y: -v.y)
}
let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive

// 组合赋值是其他运算符和赋值运算符一起执行的运算。如+=把加运算和赋值运算组合成一个操作。
// 实现一个组合赋值符号需要把运算符的左参数设置成 inout，因为这个参数会在运算符函数内直接修改它的值。
// 不需要 assignment 关键字
func += (inout left: Vector2D, right: Vector2D) {
    left = left + right
}
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd

// 默认的赋值符(=)是不可重载的。只有组合赋值符可以重载。三目条件运算符 a？b：c 也是不可重载。

// 自定义运算符
// 标准的运算符不够玩，那你可以声明一些个性的运算符，但个性的运算符只能使用这些字符 / = - + * % < > ! & | ^ . ~
// 新的运算符声明需在全局域使用 operator 关键字声明，然后用 prefix, infix, postfix 来标记。
prefix operator +++ {}

prefix func +++ (inout vector: Vector2D) -> Vector2D {
    vector += vector
    return vector
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled

// 自定义中置运算符的优先级和结合性
// 结合性(associativity)的值默认为none，优先级(precedence)默认为100。
// 以下例子定义了一个新的中置符+-，是左结合的left，优先级为140
// 注意这里用 infix
infix operator +- { associativity left precedence 140 }
func +- (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y - right.y)
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// 这个运算符把两个向量的x相加，把向量的y相减。












