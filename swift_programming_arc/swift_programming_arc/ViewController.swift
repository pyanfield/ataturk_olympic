//
//  ViewController.swift
//  swift_programming_arc
//
//  Created by WeiShuai Han on 9/28/14.
//  Copyright (c) 2014 WeiShuai Han. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var reference1: Person?
    var reference2: Person?
    var reference3: Person?
    override func viewDidLoad() {
        super.viewDidLoad()
        reference1 = Person(name: "John Appleseed")
        reference2 = reference1
        reference3 = reference1
        // 现在这个Person实例已经有三个强引用了。
        reference1 = nil
        reference2 = nil
        // 通过给两个变量赋值nil的方式断开两个强引用（）包括最先的那个强引用），只留下一个强引用，Person实例不会被销毁
        
        reference3 = nil
        // 此时可以销毁 Person 实例了
    }
}

// 2.16 ARC
// 引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递。

class Person {
    let name: String
    init(name: String) {
        self.name = name
        println("\(name) >> is being initialized")
    }
    deinit {
        println("\(name) >> is being deinitialized")
    }
}