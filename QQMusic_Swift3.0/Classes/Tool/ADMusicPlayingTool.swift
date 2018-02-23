//
//  ADMusicPlayingTool.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADMusicPlayingTool: NSObject {

    private static var allMusic: [ADMusic] = ADMusic.objectsWithFile(named: "Musics.plist") as! [ADMusic]
    
    private static var curIndex = 3
    private static var playingMusic: ADMusic = ADMusicPlayingTool.allMusic[curIndex]
    
    
    /**
     * 设置当前正在播放的歌曲
     */
    class func setPlayingMusic(with music: ADMusic) {
        ADMusicPlayingTool.curIndex = allMusic.index(of: music)!
        ADMusicPlayingTool.playingMusic = music
    }
    
    /**
     * 返回当前正在播放的歌曲
     */
    class func getPlayingMusic() -> ADMusic {
        return ADMusicPlayingTool.playingMusic
    }
    
    /**
     * 返回下一首歌
     */
    class func nextMusic() -> ADMusic {
        // 拿到当前playingMusic的index
        let cur = allMusic.index(of: playingMusic)!
        
        // 下一首歌
        curIndex = cur + 1 >= allMusic.count ? 0 : cur + 1
        return allMusic[cur + 1 >= allMusic.count ? 0 : cur + 1]
    }
    
    /**
     * 返回上一首歌
     */
    class func previousMusic() -> ADMusic {
        // 拿到当前playingMusic的index
        let cur = allMusic.index(of: playingMusic)!
        
        // 上一首歌
        curIndex = cur - 1 < 0 ? allMusic.count - 1 : cur - 1
        return allMusic[cur - 1 < 0 ? allMusic.count - 1 : cur - 1]
    }
    
    /**
     * 随机返回一首歌
     */
    class func randomMusic() -> ADMusic {
        var random = arc4random_uniform(UInt32(allMusic.count))
        while random == UInt32(curIndex) {
            random = arc4random_uniform(UInt32(allMusic.count))
        }
        
        curIndex = Int(random)
        return allMusic[Int(random)]
    }
}
