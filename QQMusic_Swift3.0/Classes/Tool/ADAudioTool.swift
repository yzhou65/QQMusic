
//
//  ADAudioTool.swift
//  02-播放音效_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import AVFoundation

class ADAudioTool: NSObject {
    
    private static var soundIDs = [String: SystemSoundID]()
    private static var players = [String: AVAudioPlayer]()
    
    // MARK: 播放音乐
    class func audioPlayWith(musicName: String) {
        // 从字典取出对应musicName的player
        var p = self.players[musicName]
        
        // 如果没有取到player, 就先创建player
        if p == nil {
            let url = Bundle.main.url(forResource: musicName, withExtension: nil)
            
            do {
                p = try AVAudioPlayer(contentsOf: url!)
                p!.prepareToPlay()
            } catch {
                print(error)
            }
            
            // 创建好的player存入字典
            self.players[musicName] = p
        }
        p!.play()
    }
    
    
    class func audioPauseWith(musicName: String) {
        if let p = self.players[musicName] {
            p.pause()
        }
    }
    
    
    class func audioStopWith(musicName: String) {
        if let p = self.players[musicName] {
            p.stop()
            self.players[musicName] = nil
            self.players.removeValue(forKey: musicName)
        }
    }
    
    
    // MARK: 播放音效
    class func soundPlayWith(audioName: String) {
        // 从字典中取出对应soundID, 如果是nil, 则表示之前没有存放在字典
        var soundID: SystemSoundID? = self.soundIDs[audioName]
        
        if soundID == nil {
            soundID = 0
            let url = Bundle.main.url(forResource: audioName, withExtension: nil)
            AudioServicesCreateSystemSoundID(url as! CFURL, &soundID!)
            
            // 把audioName存入字典
            self.soundIDs[audioName] = soundID
        }
        
        // 播放
        AudioServicesPlayAlertSound(soundID!)
    }

}
