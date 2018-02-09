//
//  Bundle+AppUIKit.swift
//  AppUIKit
//
//  Created by 德志 on 2018/2/9.
//

import UIKit

public extension Bundle{
    public static func aiiBundle() -> Bundle{
        return Bundle(for:AiiClass.self)
    }
    
    @objc public class func aiiResourceBundle() -> Bundle{
        let ailbundle = self.aiiBundle()
        let url = ailbundle.url(forResource:"AiiGestureLockView",withExtension: "bundle")!
        return Bundle(url:url)!
    }
}

fileprivate class AiiClass{}

