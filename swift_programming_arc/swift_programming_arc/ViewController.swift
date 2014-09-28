//
//  ViewController.swift
//  swift_programming_arc
//
//  Created by WeiShuai Han on 9/28/14.
//  Copyright (c) 2014 WeiShuai Han. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var john: Person?
    var number73: Apartment?
    
    var kaka: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        john = Person(name: "John Appleseed")
        number73 = Apartment(number: 73)
        
        john!.apartment = number73
        number73!.tenant = john
        
        // 当你把这两个变量设为nil时，两个析构函数被调用。打破了强应用循环
        john = nil
        number73 = nil
        
        // 无主引用的实例
        kaka = Customer(name: "John Appleseed")
        kaka!.card = CreditCard(number: 1234_5678_9012_3456, customer: kaka!)
        
        //
        kaka = nil
    }
}

// 2.16 ARC
// 引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递。

// 在两个类实例互相保持对方的强引用，并让对方不被销毁。这就是所谓的循环强引用。

// Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）。
// 弱引用和无主引用允许循环引用中的一个实例引用另外一个实例而不保持强引用。这样实例能够互相引用而不产生循环强引用。
// 对于生命周期中会变为nil的实例使用弱引用。相反的，对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用。

// 弱引用不会牢牢保持住引用的实例，并且不会阻止 ARC 销毁被引用的实例。这种行为阻止了引用变为循环强引用。
// 声明属性或者变量时，在前面加上weak关键字表明这是一个弱引用。

// 在实例的生命周期中，如果某些时候引用没有值，那么弱引用可以阻止循环强引用。如果引用总是有值，则可以使用无主引用

// 弱引用必须被声明为变量，表明其值能在运行时被修改。弱引用不能被声明为常量。
// 因为弱引用可以没有值，你必须将每一个弱引用声明为可选类型。

// 和弱引用类似，无主引用不会牢牢保持住引用的实例。
// 和弱引用不同的是，无主引用是永远有值的。因此，无主引用总是被定义为非可选类型（non-optional type）。
// 你可以在声明属性或者变量时，在前面加上关键字 unowned 表示这是一个无主引用。
// 无主引用总是可以被直接访问。不过 ARC 无法在实例被销毁后将无主引用设为nil，因为非可选类型的变量不允许被赋值为nil。

// 如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。使用无主引用，你必须确保引用始终指向一个未销毁的实例。
// 还需要注意的是如果你试图访问实例已经被销毁的无主引用，程序会直接崩溃，而不会发生无法预期的行为。所以你应当避免这样的事情发生



class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { println("\(name) is being deinitialized") }
}

class Apartment {
    let number: Int
    init(number: Int) { self.number = number }
    // 声明成弱引用
    weak var tenant: Person?
    deinit { println("Apartment #\(number) is being deinitialized") }
}

// 无主引用，用以避免循环强引用
class Customer {
    let name: String
    // 可能会有信用卡
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { println("\(name) is being deinitialized") }
}

class CreditCard {
    let number: Int
    // 但是每个信用卡肯定会有一个客户，一旦设置，将不能成为 nil
    unowned let customer: Customer
    init(number: Int, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { println("Card #\(number) is being deinitialized") }
}