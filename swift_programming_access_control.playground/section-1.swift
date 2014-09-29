// Playground - noun: a place where people can play

import UIKit

// 2.23
// 可以明确的给类、结构体、枚举、设置访问级别，也可以给属性、函数、初始化方法、基本类型、下标索引等设置访问级别。
// 协议也可以被限定在一定的范围内使用，包括协议里的全局常量、变量和函数。

// Swift 提供了三种不同的访问级别。
// Public：可以访问自己模块或应用中源文件里的任何实体，别人也可以访问引入该模块中源文件里的所有实体。
// Internal：可以访问自己模块或应用中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。
// Private：只能在当前源文件中使用的实体，称为私有实体。使用private级别，可以用作隐藏某些功能的实现细节。

// 代码中的所有实体，如果你不明确的定义其访问级别，那么它们默认为internal级别。
// 一个public访问级别的变量，不能将它的类型定义为internal和private的类型。
// 函数的访问级别不能高于它的参数、返回类型的访问级别。

// 代码中的所有实体，它们默认为internal级别。
// Framework的内部实现细节依然可以使用默认的internal级别，或者也可以定义为private级别。只有你想将它作为 API 的实体，才将其定义为public级别。

public class SomePublicClass {}
internal class SomeInternalClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
private func somePrivateFunction() {}

// 将类申明为private类，那么该类的所有成员的默认访问级别也会成为private。
// 如果你将类申明为public或者internal类（或者不明确的指定访问级别，而使用默认的internal访问级别），那么该类的所有成员的访问级别是internal。

// 元组的访问级别遵循它里面元组中最低级的访问级别。
// 元组不同于类、结构体、枚举、函数那样有单独的定义。元组的访问级别是在它被使用时自动推导出的，而不是明确的申明。
// 比如一个元组中一个元素是 internal,另一个是 private, 则该元组类型是 private

// 函数的访问级别需要根据该函数的参数类型访问级别、返回类型访问级别得出。 如果参数类型和返回类型与函数访问类型不同，则应该修改函数访问类型。

// 枚举中成员的访问级别继承自该枚举，你不能为枚举中的成员指定访问级别。

// 子类的访问级别不得高于父类的访问级别。比如说，父类的访问级别是internal，子类的访问级别就不能申明为public。


// 只要满足子类不高于父类访问级别以及遵循各访问级别作用域的前提下（即private的作用域在同一个源文件中，internal的作用域在同一个模块下），
// 我们甚至可以在子类中，用子类成员访问父类成员，哪怕父类成员的访问级别比子类成员的要低：
public class A {
    private func someMethod() {}
}

internal class B: A {
    override internal func someMethod() {
        super.someMethod()
    }
}

// Setter的访问级别可以低于对应的Getter的访问级别，这样就可以控制变量、属性或下标索引的读写权限。
// 在var或subscript定义作用域之前，你可以通过private(set)或internal(set)先为它门的写权限申明一个较低的访问级别。

struct TrackedString {
    // 定义 set 方法为 private, 而 get 方法仍然是默认的 internal
    private(set) var numberOfEdits = 0
    
    // 定义 value 初始值为空字符串
    var value: String = "" {
        didSet {
            numberOfEdits++
        }
    }
}

// 给自定义的初始化方法指定访问级别，但是必须要低于或等于它所属类的访问级别。

// 如果结构体中的任一存储属性的访问级别为private，那么它的默认成员初始化方法访问级别就是private。尽管如此，结构体的初始化方法的访问级别依然是internal。

// 协议中的每一个必须要实现的函数都具有和该协议相同的访问级别。这样才能确保该协议的使用者可以实现它所提供的函数。
// 如果你定义了一个public访问级别的协议，那么实现该协议提供的必要函数也会是public的访问级别。

// 如果定义了一个新的协议，并且该协议继承了一个已知的协议，那么新协议拥有的访问级别最高也只和被继承协议的访问级别相同。
// 类可以采用比自身访问级别低的协议。
// 采用了协议的类的访问级别遵循它本身和采用协议中最低的访问级别。也就是说如果一个类是public级别，采用的协议是internal级别，那个采用了这个协议后，该类的访问级别也是internal。
// 如果你采用了协议，那么实现了协议必须的方法后，该方法的访问级别遵循协议的访问级别。

// 扩展成员应该具有和原始类成员一致的访问级别。
// 可以明确申明扩展的访问级别（比如使用private extension）给该扩展内所有成员指定一个新的默认访问级别。

// 如果一个扩展采用了某个协议，那么你就不能对该扩展使用访问级别修饰符来申明了。该扩展中实现协议的方法都会遵循该协议的访问级别。

// 泛型类型或泛型函数的访问级别遵循泛型类型、函数本身、泛型类型参数三者中访问级别最低的级别。

// 任何被你定义的类型别名都会被视作为不同的类型，这些类型用于访问控制。一个类型别名的访问级别可以低于或等于这个类型的访问级别。
// 一个private级别的类型别名可以设定给一个public、internal、private的类型，但是一个public级别的类型别名只能设定给一个public级别的类型，不能设定给internal或private的类类型。









