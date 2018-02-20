//
//  NSObject+ADKeyValue.swift
//
//  Created by Yue Zhou on 2/15/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

extension NSObject {
    
    class func objectsWithDictionaries(dictArr: [[String: Any]]) -> [NSObject] {
        var objects = [NSObject]()
        
        for dict in dictArr {
            objects.append(objectWithDictionary(dict: dict))
        }
        return objects
    }
    
    
    class func objectsWithFile(named: String) -> [NSObject] {
        var objects = [NSObject]()
        let file = Bundle.main.path(forResource: named, ofType: nil)
        let dictArr = NSArray(contentsOfFile: file!)!
        
        for dict in dictArr as! [[String: Any]] {
            objects.append(objectWithDictionary(dict: dict))
        }
        return objects
    }
    
    
    class func objectWithDictionary(dict: [String: Any]) -> Self {
        let obj = self.init()
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self.classForCoder();
        
        // member fields
//        let properties = class_copyPropertyList(myClass, &count)!
        let ivars = class_copyIvarList(myClass, &count)!
        
        for i: UInt32 in 0 ..< count {
//            let property = properties[Int(i)]
//            let cname = property_getName(property)
            
            let cname = ivar_getName(ivars[Int(i)])
            let key = String(cString: cname!)
            
            if let val: Any = dict[key] {
//                print("key = \(key), value = \(val)")
                
                obj.setValue(val, forKeyPath: key)
            }
        }
        
//        free(properties)
        free(ivars)
        return obj
    }
}
