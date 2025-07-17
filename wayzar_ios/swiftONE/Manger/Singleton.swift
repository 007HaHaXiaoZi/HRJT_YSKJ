//
//  File.swift
//  swiftONE
//
//  Created by admin on 2021/9/13.
//
import Foundation
//创建一个单例类
//如果一个类始终只能创建一个实例，则这个类被称为单例类
@objc class Singleton: NSObject{
//    给类添加一个属性
    var action = CLLocation()
//    对于单例实例来说，需要创建一个唯一对外输出实例的方法
//    静态变量用static来处理
    @objc public static  let singleton = Singleton()
//    创建一个方法，输出实例自身的属性
    @objc public static func doSomething() {
        print("action");
    }
}


