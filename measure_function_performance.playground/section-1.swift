// Playground - noun: a place where people can play

import UIKit

// https://medium.com/swift-programming/secret-of-swift-performance-a8ee86060843

// want to analyze this code:
//func doSomeWork(){
//    var ar = [String]()
//    for i in 0...10000{
//        ar.append("New elem \(i)")
//    }
//    
//    let url = NSURL(string: "http://lorempixel.com/1920/1920/")
//    let image = UIImage(data: NSData(contentsOfURL: url!)!)
//}

// measure function
func measure(title: String!, call: () -> Void){
    let startTime = CACurrentMediaTime()
    call()
    let endTime = CACurrentMediaTime()
    if let title = title{
        print("\(title): ")
    }
    
    println("Time - \(endTime - startTime)")
    
}

func doSomeWork(){
    measure("Array"){
        var ar = [String]()
        for i in 0...10000{
            ar.append("New elem \(i)")
        }
    }
    
    measure("Image"){
        let url = NSURL(string: "http://lorempixel.com/1920/1920/")
        let image = UIImage(data: NSData(contentsOfURL: url!)!)
    }
}

// DO NOT RUN THIS TEST ON PLAYGROUND, THE CALCULATING TAKES A MUCH LONG TIME, MAY FREEZE YOUR XCODE
//doSomeWork()
