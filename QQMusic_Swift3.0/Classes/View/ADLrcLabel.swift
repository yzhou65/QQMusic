//
//  ADLrcLabel.swift
//  QQMusic_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADLrcLabel: UILabel {

    var progress: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        print(progress)
        
        // 按照progress, 把已播放进度的部分自身用绿色填充
        let fillRect = CGRect(x: 0, y: 0, width: self.bounds.width * self.progress, height: self.bounds.height)
        UIColor.green.set()
//        UIRectFill(rect)  // 这句话会把整个label的矩形框填充

        UIRectFillUsingBlendMode(fillRect, CGBlendMode.sourceIn)
    }
}
