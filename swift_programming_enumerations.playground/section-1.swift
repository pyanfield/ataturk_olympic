// Playground - noun: a place where people can play

import UIKit

// 2.8
// 在 C 语言中枚举指定相关名称为一组整型值。Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。
// 如果一个值（被认为是“原始”值）被提供给每个枚举成员，则该值可以是一个字符串，一个字符，或是一个整型值或浮点值。
// 枚举也可以定义构造函数（initializers）来提供一个初始成员值；可以在原始的实现基础上扩展它们的功能；可以遵守协议（protocols）来提供标准的功能。
enum CompassPoint {
    case North      // 必须大写
    case South
    case East
    case West
}
// 不像 C 和 Objective-C 一样，Swift 的枚举成员在被创建时不会被赋予一个默认的整数值。
// 在上面的CompassPoints例子中，North，South，East和West不是隐式的等于0，1，2和3。相反的，这些不同的枚举成员在CompassPoint的一种显示定义中拥有各自不同的值。

enum Planet {
    case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune      // 可以写在一行
}
var planet: Planet = .Mars

// 可以是不同类型的枚举值
enum Barcode {
    case UPCA(Int, Int, Int)
    case QRCode(String)
    case Customized(Int, String, Double)
}
var productBarcode = Barcode.UPCA(8, 85909_51226, 3)
switch productBarcode {
    // 提取枚举成员的相关值可以用 let 也可以用 var 来提取变量
case .UPCA(let numberSystem, let identifier, let check):
    println("UPC-A with value of \(numberSystem), \(identifier), \(check).")
case .QRCode(let productCode):
    println("QR code with value of \(productCode).")
case var .Customized(id, name, value):              // 如果提取全部成员值，方便起见，也可以将 let/var 放在之前
    println("This is a customized bar code,id:\(id), name:\(name), value:\(value)")
}

// 可指定枚举类型设置初始值
enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}

