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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        john = Person(name: "John Appleseed")
        number73 = Apartment(number: 73)
        
        // 想成循环强引用
        john!.apartment = number73
        number73!.tenant = john
        
        // 当你把这两个变量设为nil时，没有任何一个析构函数被调用。
        // 强引用循环阻止了Person和Apartment类实例的销毁，并在你的应用程序中造成了内存泄漏。
        john = nil
        number73 = nil
    }
}

// 2.16 ARC
// 引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递。

// 在两个类实例互相保持对方的强引用，并让对方不被销毁。这就是所谓的循环强引用。

class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { println("\(name) is being deinitialized") }
}

class Apartment {
    let number: Int
    init(number: Int) { self.number = number }
    var tenant: Person?
    deinit { println("Apartment #\(number) is being deinitialized") }
}