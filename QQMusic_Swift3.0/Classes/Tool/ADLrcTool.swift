//
//  ADLrcTool.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADLrcTool: NSObject {

    class func lrcTool(with lrcname: String) -> [ADLrcline] {
        let lrcPath = Bundle.main.path(forResource: lrcname, ofType: nil)
        var lrclines = [ADLrcline]()
        
        // 读取歌词
        do {
            let lrcString = try String(contentsOfFile: lrcPath!, encoding: String.Encoding.utf8)
//            print(lrcString)
            // 用"\n"将一个大字符串表示的歌词分割为一行一行歌词的数组
            let lrcArray = lrcString.components(separatedBy: "\n")
            for lrclineString in lrcArray {
                // 每一行(每一句)歌词
                // 需要过滤掉以下内容
                if lrclineString.hasPrefix("[ti:") || lrclineString.hasPrefix("[ar:") || lrclineString.hasPrefix("[al:") || !lrclineString.hasPrefix("[") {
                    continue
                }
                
                
                // 将一句歌词字符串转为ADLrcline模型
                let lrcline: ADLrcline = ADLrcline(lrclineString: lrclineString)
//                print(lrcline)
                lrclines.append(lrcline)
            }
        } catch {
            print(error)
        }
        return lrclines
    }
}
