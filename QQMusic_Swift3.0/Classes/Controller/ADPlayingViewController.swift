//
//  ADPlayingViewController.swift
//  QQMusic_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADPlayingViewController: UIViewController {
    
    @IBOutlet weak var albumView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var lrcLabel: ADLrcLabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var lrcView: ADLrcView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func next(_ sender: UIButton) {
        
    }

    @IBAction func previous(_ sender: UIButton) {
        
    }
    
    @IBAction func startSlider(_ sender: UISlider) {
    }
    
    @IBAction func endSlider(_ sender: UISlider) {
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
    }
    
    
    
}
