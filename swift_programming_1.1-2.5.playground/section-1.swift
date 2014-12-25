import UIKit

var str = "Hello, playground"

let label = "This is a test"
let width = 4
// 这里要显示转换 width 到 string
let widthLabel = label + String(width)

let bookSummary = "I have \(width) books"

//

// 这里声明类的时候，使用方括号包含类型的方式，后面的小括号是做初始化
var fruites = [String]()
fruites = ["apple","peach","orange","banana"]
fruites.append("kaka")
println(fruites)

// 可变参量是保存在一个数组中
func sumOf(numbers: Int...) -> Int{
    var sum=0
    for number in numbers{
        sum += number
    }
    return sum
}

sumOf(11,22,33)

//
func makeIncrease() -> (Int -> Int){
    func addOne(number : Int) -> Int{
        return number + 1
    }
    return addOne
}

var increse = makeIncrease()
increse(7)

//
func hasAnyMatches(list :[Int], condition: Int -> Bool) -> Bool{
    for item in list{
        // if 后必须要跟一个明确的 bool 值
        if condition(item) {
            return true
        }
    }
    return false
}

func lessThanTen(number :Int) -> Bool{
    return number < 10
}

var numbers = [10,20,5,2,30]
// 这里调用函数作为参数的时候，这里的 lessThanTen 是不带小括号的，有小括号表示调用
var matched = hasAnyMatches(numbers, lessThanTen)

// map 的参数就是 transform: (T) -> U，所以可以使用 (number :Int) -> Int
numbers.map({
    (number :Int) -> Int in
    let result = 3*number
    return result
})

//
numbers.map({number in 3*number})

// 如果闭包作为最后一个参数传给一个函数的时候，可以直接跟在括号后面，这里 sort 最后一个参数是 isOrderedBefore: (T, T) -> Bool
numbers.map(){
    (number :Int) -> Int in
    let result = 3*number
    return result
}

sort(&numbers){
    (a :Int, b :Int) -> Bool in
    return a > b
}
sort(&numbers){$0 > $1}
//
class Shape{
    var numberOfSides = 0
    var name :String
    
    // 构造函数是没有 func 关键字定义的
    // 析构函数是 deinit
    init(name :String){
        self.name = name
    }
    
    func simpleDescription() -> String{
        return "A shape with \(numberOfSides) sides."
    }
}

class Square :Shape{
    var sideLength: Double
    
    init(sideLength :Double, name :String){
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    var perimeter :Double{
        get{
            return sideLength * Double(numberOfSides)
        }
        set{
            // 默认新值是 newValue，可以在 set 之后自定义
            sideLength = newValue / Double(numberOfSides)
        }
    }
    // 含有 willSet 和 didSet 方法
    
    func area() -> Double{
        return sideLength * sideLength
    }
    
    // 函数重写关键字  override
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}

let square = Square(sideLength: 5.0, name: "mini square")
square.area()
square.simpleDescription()
square.perimeter
square.perimeter = 10

//
enum Rank: Int {
    // 枚举的原始值是 Int 类型，只需要设置第一个原始值,也可以不设置原始值
    // 注意这里的 case 关键字
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
// toRaw() ,fromRaw() 实现枚举值和原始值的转换
let ace = Rank.Ace
let aceRawValue = ace.rawValue
Rank(rawValue: 11)?.simpleDescription()
Rank.Five.simpleDescription()

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
    
}
let hearts = Suit.Hearts
let heartsDescription = hearts.simpleDescription()

// 使用struct来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。它们之间最大的一个区别就是 结构体是传值，类是传引用
struct Card {
    var rank: Rank
    var suit: Suit
    
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

// 一个枚举成员的实例可以有实例值。相同枚举成员的实例可以有不同的值。创建实例的时候传入值即可。
// 实例值和原始值是不同的：枚举成员的原始值对于所有实例都是相同的，而且你是在定义枚举的时候设置原始值。
enum ServerResponse {
    case Result(String, String)
    case Error(String)
}

let success = ServerResponse.Result("6:00 am", "8:09 pm")
let failure = ServerResponse.Error("Out of cheese.")

switch success {
    // 注意这里的取值
    case let .Result(sunrise, sunset):
        let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)."
    case let .Error(error):
        let serverResponse = "Failure...  \(error)"
}

// 类、枚举和结构体都可以实现协议。
protocol ExampleProtocol{
    var simpleDes: String { get }
    mutating func adjust()
}

class SimpleClass:ExampleProtocol {
    var simpleDes: String = "A Simple Class"
    
    // 这里不用声明 mutating 是因为类中的方法经常会修改
    func adjust() {
        simpleDes += " Should Be Adjusted"
    }
}

var sc = SimpleClass()
sc.adjust()

struct SimpleStruct:ExampleProtocol {
    var simpleDes: String = "Simple Struct"
    
    // 标记会修改结构体的方法
    mutating func adjust() {
        simpleDes += " (adjusted)"
    }
}

var ss = SimpleStruct()
ss.adjust()
let ts = ss.simpleDes

// 使用extension来为现有的类型添加功能，比如新的方法和参数。
// 你可以使用扩展来改造定义在别处，甚至是从外部库或者框架引入的一个类型，使得这个类型遵循某个协议。

extension Int: ExampleProtocol{
    var simpleDes: String{
        return "The Number is \(self)"
    }
    
    mutating func adjust(){
        self += 50
    }
}

7.simpleDes

//
func repeat<ItemType>(item: ItemType, times: Int) -> [ItemType]{
    var result = [ItemType]()
    // 注意这里 ..< 和 ... 的区别
    for i in 0 ..< times{
        result.append(item)
    }
    return result
}

repeat("ok", 7)

// 泛型也可用于 类，枚举，结构体

// where 用来指定对类型的需求，简单起见，你可以忽略where，只在冒号后面写协议或者类名。<T: Equatable>和<T where T: Equatable>是等价的。
func anyCommonElements <T, U where T: SequenceType, U: SequenceType, T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element> (lhs: T, rhs: U) -> Bool {
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElements([1, 2, 3], [3])


// 与其他大部分编程语言不同，Swift 并不强制要求你在每条语句的结尾处使用分号（;），当然，你也可以按照你自己的习惯添加分号。有一种情况下必须要用分号，即你打算在同一行内写多条独立的语句.

// 尽量不要使用UInt，除非你真的需要存储一个和当前平台原生字长相同的无符号整数。除了这种情况，最好使用Int，即使你要存储的值已知是非负的。
// 统一使用Int可以提高代码的可复用性，避免不同类型数字之间的转换，并且匹配数字的类型推断，请参考类型安全和类型推断。

// Double表示64位浮点数,Float表示32位浮点数
// Double精确度很高，至少有15位数字，而Float最少只有6位数字。

// Swift 是一个类型安全（type safe）的语言。它会在编译你的代码时进行类型检查（type checks），并把不匹配的类型标记为错误。

// 当推断浮点数的类型时，Swift 总是会选择Double而不是Float。

// 浮点字面量可以是十进制（没有前缀）或者是十六进制（前缀是0x）。小数点两边必须有至少一个十进制数字（或者是十六进制的数字）。
// 浮点字面量还有一个可选的指数（exponent），在十进制浮点数中通过大写或者小写的e来指定，在十六进制浮点数中通过大写或者小写的p来指定。
// 如果一个十进制数的指数为exp，那这个数相当于基数和10^exp的乘积：1.25e2 表示 1.25 × 10^2，等于 125.0
println(1.25e2)
println(1.25e-2)
// 如果一个十六进制数的指数为exp，那这个数相当于基数和2^exp的乘积:0xFp2 表示 15 × 2^2，等于 60.0
println(0xFp2)
println(0xFp-2)

// 数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

// 类型别名（type aliases）就是给现有类型定义另一个名字。你可以使用typealias关键字来定义类型别名。
typealias MyInt8 = UInt8
let mi16: MyInt8 = 0
println(MyInt8.max)

// 元组（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。
let http404Error = (404, "Not Found")
// 可以将一个元组的内容分解（decompose）成单独的常量和变量，然后你就可以正常使用它们了：
let (statusCode, statusMessage) = http404Error
println("The status code is \(statusCode)")
println("The status message is \(statusMessage)")
// 只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：
let (justTheStatusCode, _) = http404Error
println("The status code is \(justTheStatusCode)")
// 还可以通过下标来访问元组中的单个元素，下标从零开始：
println("The status code is \(http404Error.0)")
println("The status message is \(http404Error.1)")
// 可以在定义元组的时候给单个元素命名：
let http200Status = (statusCode: 200, description: "OK")
println("The status code is \(http200Status.statusCode)")
println("The status message is \(http200Status.description)")
// 元组在临时组织值的时候很有用，但是并不适合创建复杂的数据结构。如果你的数据结构并不是临时使用，请使用类或者结构体而不是元组。

let possibleNumber = "123"
let convertedNumber = possibleNumber.toInt()
// convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int",而不是一个Int。
// 当你确定可选类型确实包含值之后，你可以在可选的名字后面加一个感叹号（!）来获取值。这个惊叹号表示“我知道这个可选有值，请使用它。”这被称为可选值的强制解析（forced unwrapping）
if (convertedNumber != nil) {
    println("\(possibleNumber) has an integer value of \(convertedNumber!)")
} else {
    println("\(possibleNumber) could not be converted to an integer")
}

// 使用可选绑定（optional binding）来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。
if let actualNumber = possibleNumber.toInt() {
    println("\(possibleNumber) has an integer value of \(actualNumber)")
} else {
    println("\(possibleNumber) could not be converted to an integer")
}
// 如果转换成功，actualNumber常量可以在if语句的第一个分支中使用。它已经被可选类型包含的值初始化过，所以不需要再使用!后缀来获取它的值.
// 你可以在可选绑定中使用常量和变量。如果你想在if语句的第一个分支中操作actualNumber的值，你可以改成if var actualNumber，这样可选类型包含的值就会被赋给一个变量而非常量。

// 你可以给可选变量赋值为nil来表示它没有值：
var serverResponseCode: Int? = 404
serverResponseCode = nil
// nil不能用于非可选的常量和变量。如果你声明一个可选常量或者变量但是没有赋值，它们会自动被设置为nil.

// 有时候在程序架构中，第一次被赋值之后，可以确定一个可选类型总会有值。在这种情况下，每次都要判断和解析可选值是非常低效的，因为可以确定它总会有值。
// 这种类型的可选状态被定义为隐式解析可选类型（implicitly unwrapped optionals）。把想要用作可选的类型的后面的问号（String?）改成感叹号（String!）来声明一个隐式解析可选类型。
// 当可选类型被第一次赋值之后就可以确定之后一直有值的时候，隐式解析可选类型非常有用。隐式解析可选类型主要被用在 Swift 中类的构造过程中，请参考类实例之间的循环强引用。

// 断言会在运行时判断一个逻辑条件是否为true。从字面意思来说，断言“断言”一个条件是否为真。
// 你可以使用断言来保证在运行其他代码之前，某些重要的条件已经被满足。如果条件判断为true，代码运行会继续进行；如果条件判断为false，代码运行停止，你的应用被终止。

/* 当条件可能为假时使用断言，但是最终一定要保证条件为真，这样你的代码才能继续运行。断言的适用情景：
    1.整数类型的下标索引被传入一个自定义下标脚本实现，但是下标索引值可能太小或者太大。
    2.需要给函数传入一个值，但是非法的值可能导致函数不能正常执行。
    3.一个可选值现在是nil，但是后面的代码运行需要一个非nil值。 */

// 不同于 C 语言和 Objective-C，Swift 中是可以对浮点数进行求余的。
println(9%2)
println(8%2.5)

// Swift 也提供恒等===和不恒等!==这两个比较符来判断两个对象是否引用同一个对象实例。更多细节在类与结构。

// 空合运算符(a ?? b)将对可选类型a进行空判断，如果a包含一个值就进行解封，否则就返回一个默认值b.这个运算符有两个条件:
//      表达式a必须是Optional类型
//      默认值b的类型必须要和a存储值的类型保持一致
// 空合并运算符是对以下代码的简短表达方法 a != nil ? a! : b

// 闭区间运算符（a...b）定义一个包含从a到b(包括a和b)的所有值的区间
for index in 1...5 {
    println("\(index) * 5 = \(index * 5)")
}
// 半开区间（a..<b）定义一个从a到b但不包括b的区间

// 2.3
// isEmpty 判断字符串是否为空，注意这里不是 isEmpty()
var emptyString = ""
var anotherEmptyString = String()
if emptyString.isEmpty{
    println("empty string")
}
if anotherEmptyString.isEmpty{
    println("another empty string")
}

// Swift 的String类型是值类型。NSString 是指针传递，传的时一个引用。

// Swift 的String类型表示特定序列的Character（字符） 类型值的集合。
for cha in "Anfield"{
    println(cha)
}

// 通过标明一个Character类型注解并通过字符字面量进行赋值，可以建立一个独立的字符常量或变量：
let cha: Character = "7"

// 通过调用全局countElements函数，并将字符串作为参数进行传递，可以获取该字符串的字符数量。
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
println("unusualMenagerie has \(countElements(unusualMenagerie)) characters")

unusualMenagerie.utf16Count
unusualMenagerie.lowercaseString

// 不同的 Unicode 字符以及相同 Unicode 字符的不同表示方式可能需要不同数量的内存空间来存储。
// 所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间。因此字符串的长度不得不通过迭代字符串中每一个字符的长度来进行计算。
// 如果您正在处理一个长字符串，需要注意countElements函数必须遍历字符串中的字符以精准计算字符串的长度。 
// 另外需要注意的是通过countElements返回的字符数量并不总是与包含相同字符的NSString的length属性相同。
// NSString的length属性是基于利用 UTF-16 表示的十六位代码单元数字，而不是基于 Unicode 字符。
// 为了解决这个问题，NSString的length属性在被 Swift 的String访问时会成为utf16count。

let 🐌 = "蜗牛"
println(🐌)

// 您不能将一个字符串或者字符添加到一个已经存在的字符变量上，因为字符变量只能包含一个字符。

// 通过调用字符串的 hasPrefix/hasSuffix 方法来检查字符串是否拥有特定前缀/后缀。 两个方法均需要以字符串作为参数传入并传出Boolean值
// 可以通过字符串的 uppercaseString 和 lowercaseString 属性来访问大写/小写版本的字符串。
// 可以通过字符串的 utf8,utf16,unicodeScalars 来访问它的 UTF-8, UTF-16, 21位的 Unicode (Unicode Scalars)
for c in "Anfield".utf8{
    println(c)
}

// 2.4
// Swift 语言里的数组和字典中存储的数据值类型必须明确。数据值在被存储进入某个数组之前类型必须明确，方法是通过显式的类型标注或类型推断，而且不是必须是class类型。
// 声明数组可以用 Array<type> 或者 [type] 的方式
var shoppingList: [String] = ["iPhone","iPad","Mac"]    // 通过类型推断也可以直接 var shoppingList = ["iPhone","iPad","Mac"]

if !shoppingList.isEmpty{
    shoppingList.append("iMac")
    shoppingList += ["MBA","MBP"]
}
println(shoppingList.count)

shoppingList[2...5] = ["Google","Facebook"]
shoppingList

shoppingList.insert("Apple", atIndex: 2)
shoppingList

shoppingList.removeAtIndex(1)
shoppingList.removeLast()
shoppingList

for (index, value) in enumerate(shoppingList){
    println("\(index+1) : \(value)")
}

// 创建数组
var testArr1 = [Int]()
var testArr2: [Int] = []
var testArr3 = [Int](count: 7, repeatedValue: 0)
var testArr4 = Array(count: 7, repeatedValue: 0.0)

// Swift 的字典使用Dictionary<KeyType, ValueType> ( 或者 [KeyType:ValueType] )定义,其中KeyType是字典中键的数据类型，ValueType是字典中对应于这些键所存储值的数据类型。
// KeyType的唯一限制就是可哈希的，这样可以保证它是独一无二的，所有的 Swift 基本类型（例如String，Int， Double和Bool）都是默认可哈希的，并且所有这些类型都可以在字典中当做键使用。
// 未关联值的枚举成员（参见枚举）也是默认可哈希的。

// Dictionary 的 updateValue(forKey:) 方法可以设置或者更新特定键对应的值,返回的时一个可选值，如果该键之前设置过值，那么返回之前的旧值，否则返回 nil

var dic = [String:String]()
dic = ["Name":"Liverpool","Location":"England","History":"Great","Fans":"KOP"]

//  返回可选类型
var oldValue: String? = dic.updateValue("Steven", forKey:"Captain")
dic
dic.count

// 返回可选类型
var cap: String? = dic["Captain"]
// 可以通过设置 nil 值的方式，清除一个键值对
dic["Captain"] = nil
dic

// 返回可选类型
var history: String? = dic.removeValueForKey("History")
dic

dic.keys
dic.values

// 清空 Dictionary
dic = [:]
dic

// 对字典来说，不可变性也意味着我们不能替换其中任何现有键所对应的值。不可变字典的内容在被首次设定之后不能更改。 
// 不可变性对数组来说有一点不同，当然我们不能试着改变任何不可变数组的大小，但是我们可以重新设定相对现存索引所对应的值。

// Nil Coalescing Operator  (a ?? b)
// The nil coalescing operator is shorthand for the code below:
//      a != nil ? a! : b
let defaultColorName = "red"
var userDefinedColorName: String?   // defaults to nil
var colorNameToUse = userDefinedColorName ?? defaultColorName


// 2.5
for index in 1...5 {
    println("\(index) times 5 is \(index * 5)")
}

// 不需要知道区间内每一项的值，可以使用下划线（_）替代变量名来忽略对值的访问：
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
println("\(base) to the power of \(power) is \(answer)")

// Swift 不需要使用圆括号将“initialization; condition; increment”包括起来。
for var index = 0; index < 3; ++index {
    println("index is \(index)")
}

// while循环的另外一种形式是do-while，它和while的区别是在判断循环条件之前，先执行一次循环的代码块，然后重复循环直到条件为false。

// 与 C 语言和 Objective-C 中的switch语句不同，在 Swift 中，当匹配的 case 分支中的代码执行完毕后，程序会终止switch语句，而不会继续执行下一个 case 分支。
// 这也就是说，不需要在 case 分支中显式地使用break语句。
// 每一个 case 分支都必须包含至少一条语句.
let anotherCharacter: Character = "a"
switch anotherCharacter {
    case "a":
        println("The letter a")     // 如果注释掉这行的话，会报编译错误
    case "A":
        println("The letter A")
    default:
        println("Not the letter A")
}

// case 分支的模式也可以是一个值的区间。
let count = 3_000_000_000_000
let countedThings = "stars in the Milky Way"
var naturalCount: String
switch count {
    case 0:
        naturalCount = "no"
    case 1...3:
        naturalCount = "a few"
    case 4...9:
        naturalCount = "several"
    case 10...99:
        naturalCount = "tens of"
    case 100...999:
        naturalCount = "hundreds of"
    case 1000...999_999:
        naturalCount = "thousands of"
    default:
        naturalCount = "millions and millions of"
}
println("There are \(naturalCount) \(countedThings).")

// 可以使用元组在同一个switch语句中测试多个值。元组中的元素可以是值，也可以是区间。另外，使用下划线（_）来匹配所有可能的值。
let somePoint = (1, 1)
switch somePoint {
    case (0, 0):
        println("(0, 0) is at the origin")
    case (_, 0):
        println("(\(somePoint.0), 0) is on the x-axis")
    case (0, _):
        println("(0, \(somePoint.1)) is on the y-axis")
    case (-2...2, -2...2):
        println("(\(somePoint.0), \(somePoint.1)) is inside the box")
    default:
        println("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}
// 不像 C 语言，Swift 允许多个 case 匹配同一个值。实际上，在这个例子中，点(0, 0)可以匹配所有四个 case。但是，如果存在多个匹配，那么只会执行第一个被匹配到的 case 分支。

// case 值绑定
let anotherPoint = (2, 0)
switch anotherPoint {
    case (let x, 0):
        println("on the x-axis with an x value of \(x)")
    case (0, let y):
        println("on the y-axis with a y value of \(y)")
    case let (x, y):
        println("somewhere else at (\(x), \(y))")
}

// case 分支的模式可以使用where语句来判断额外的条件。
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
    case let (x, y) where x == y:
        println("(\(x), \(y)) is on the line x == y")
    case let (x, y) where x == -y:
        println("(\(x), \(y)) is on the line x == -y")
    case let (x, y):
        println("(\(x), \(y)) is just some arbitrary point")
}

// 其他关键字 continue, break, fallthrough

// 带标签的语句 
let finalSquare = 25
var board = [Int](count: finalSquare + 1, repeatedValue: 0)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square1 = 0
var diceRoll = 0
// 声明一个标签
gameLoop: while square1 != finalSquare {
    if ++diceRoll == 7 { diceRoll = 1 }
    switch square1 + diceRoll {
    case finalSquare:
        // 到达最后一个方块，游戏结束
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // 超出最后一个方块，再掷一次骰子
        continue gameLoop
    default:
        // 本次移动有效
        square1 += diceRoll
        square1 += board[square1]
    }
}
println("Game over!")

