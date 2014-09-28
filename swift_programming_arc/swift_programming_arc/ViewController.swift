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
    
    var country: Country?
    
    var paragraph: HTMLElement?
    
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
        kaka = nil
        // 此时 Customer 和 CreditCard 都被析构掉了
        
        //
        country = Country(name: "Canada", capitalName: "Ottawa")
        // capitalCity的属性能被直接访问，而不需要通过感叹号来展开它的可选值
        println("\(country!.name)'s capital city is called \(country!.capitalCity.name)")
        country = nil
        
        //
        paragraph = HTMLElement(name: "p", text: "hello, world")
        println(paragraph!.asHTML())
        paragraph = nil
        // HTMLElement 实例没有被析构
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

// 无主引用以及隐式解析可选属性
// 存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后不能为nil。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析可选属性。
class Country {
    let name: String
    // 通常情况下，只有当类初始化完成之后才能访问 self, 为了实现能在构造函数中访问 self, 可以将该变量声明成隐式解析可选类型的属性,在后面加 !
    // Country的构造函数调用了City的构造函数。然而，只有Country的实例完全初始化完后，Country的构造函数才能把self传给City的构造函数。
    let capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        // 如果不声明成隐式解析可选类型，这里不能将 self 作为参数传入
        self.capitalCity = City(name: capitalName, country: self)
    }
    deinit{
        println("Country : \(name) is being deinitialized")
    }
}
class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit{
        println("City : \(name) is being deinitialized")
    }
}


// 闭包引起的循环强引用
// 循环强引用的产生，是因为闭包和类相似，都是引用类型。当你把一个闭包赋值给某个属性时，你也把一个引用赋值给了这个闭包。
// Swift 提供了一种优雅的方法来解决这个问题，称之为闭包占用列表（closuer capture list）
// 捕获列表中的每个元素都是由weak或者unowned关键字和实例的引用（如self或someInstance）成对组成。每一对都在方括号中，通过逗号分开。
/*
@lazy var someClosure: (Int, String) -> String = {
    [unowned self] (index: Int, stringToProcess: String) -> String in
    // closure body goes here
}
@lazy var someClosure: () -> String = {
    [unowned self] in
    // closure body goes here
}
*/

// 当闭包和捕获的实例总是互相引用时并且总是同时销毁时，将闭包内的捕获定义为无主引用。
// 相反的，当捕获引用有时可能会是nil时，将闭包内的捕获定义为弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为nil。这使我们可以在闭包内检查它们是否存在。
// 注意:如果捕获的引用绝对不会置为nil，应该用无主引用，而不是弱引用。

class HTMLElement {
    
    let name: String
    let text: String?
    
    // 这里声明了一个 lazy 属性，只有当初始化完成以及 self 确实存在时候，才能访问 lazy 属性。所以在闭包里面可以访问到 self
    lazy var asHTML: () -> String = {
        // 这里引用了 self.text, self.name 等，所以该闭包持有 HTMLElement 实例，形成了循环强引用
        // 通过添加捕获列表来打破强循环引用
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        println("\(name) is being deinitialized")
    }
}