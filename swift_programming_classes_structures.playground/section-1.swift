// Playground - noun: a place where people can play

import UIKit

// 2.9
/*
类和结构体的共同点：
    Define properties to store values
    Define methods to provide functionality
    Define subscripts to provide access to their values using subscript syntax
    Define initializers to set up their initial state
    Be extended to expand their functionality beyond a default implementation
    Conform to protocols to provide standard functionality of a certain kind”
类相对结构体来说还具有：
    Inheritance enables one class to inherit the characteristics of another.
    Type casting enables you to check and interpret the type of a class instance at runtime.
    Deinitializers enable an instance of a class to free up any resources it has assigned.
    Reference counting allows more than one reference to a class instance.
*/

struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?       // 默认值为 nil
}
let someResolution = Resolution()   // 设置默认值
let vga = Resolution(width:640, height: 480)
let someVideoMode = VideoMode()

// 在 Swift 中，所有的基本类型：整数（Integer）、浮点数（floating-point）、布尔值（Booleans）、字符串（string)、数组（array）和字典（dictionaries），都是值类型，
// 并且都是以结构体的形式在后台所实现。结构体和枚举也是值类型。
// 类是引用类型,引用类型在被赋予到一个变量、常量或者被传递到一个函数时，操作的是引用，其并不是拷贝。

// 如果能够判定两个常量或者变量是否引用同一个类实例将会很有帮助。为了达到这个目的，Swift 内建了两个恒等运算符：
//      等价于 （ === ） :   两个类类型（class type）的常量或者变量引用同一个类实例。
//      不等价于 （ !== ）

// 一个 Swift 常量或者变量引用一个引用类型的实例与 C 语言中的指针类似，不同的是并不直接指向内存中的某个地址，而且也不要求你使用星号（*）来表明你在创建一个引用。
// Swift 中这些引用与其它的常量或变量的定义方式相同。

/*
按照通用的准则，当符合一条或多条以下条件时，请考虑构建结构体：
    结构体的主要目的是用来封装少量相关简单数据值。
    有理由预计一个结构体实例在赋值或传递时，封装的数据将会被拷贝而不是被引用。
    任何在结构体中储存的值类型属性，也将会被拷贝，而不是被引用。
    结构体不需要去继承另一个已存在类型的属性或者行为。
*/