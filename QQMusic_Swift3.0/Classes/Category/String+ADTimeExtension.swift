//
//  String+ADTimeExtension.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import Foundation

extension String {
    
    public init(time: TimeInterval) {
        let min = Int(time) / 60
        let sec = Int(time) % 60    // double cannot do %
        
        self.init(format: "%02ld:%02ld", min, sec)
    }
}
