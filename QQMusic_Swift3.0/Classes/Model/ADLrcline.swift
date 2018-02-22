//
//  ADLrcline.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADLrcline: NSObject {
    
    var text: String?
    var time: TimeInterval?
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "time: \(time!), text: \(text!)"
    }
    
    init(lrclineString: String) {
        super.init()
        
        let objs = lrclineString.components(separatedBy: "]")
        self.text = objs[1]
        
        let index1 = objs[0].index(after: objs[0].startIndex)
        self.time = self.timeInterval(with: objs[0].substring(from: index1))
    }

    
    class func line(with lrclineString: String) -> ADLrcline {
        let line = ADLrcline()
        let objs = lrclineString.components(separatedBy: "]")
        line.text = objs[1]
        
        let index1 = objs[0].index(after: objs[0].startIndex)
        line.time = line.timeInterval(with: objs[0].substring(from: index1))
        return line
    }
    
    
    /**
     * 根据传入的时间字符串, 返回TimeInterval, 即秒数
     */
    private func timeInterval(with timeString: String) -> TimeInterval {
        // 01:24.55
        let time = timeString.components(separatedBy: ":")
        let min = Double(time[0])
        
        let secs = time[1].components(separatedBy: ".")
        let sec = Double(secs[0])
        let milisec = Double(secs[1])
        
        return min! * 60.0 + sec! + milisec! * 0.01
    }
}
