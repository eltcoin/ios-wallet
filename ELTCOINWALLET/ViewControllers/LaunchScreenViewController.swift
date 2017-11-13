//
//  LaunchScreenViewController.swift
//  ELTCOINWALLET
//
//  Created by Oliver Mahoney on 06/11/2017.
//  Copyright © 2017 ELTCOIN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        self.view.backgroundColor = UIColor.black
        
        let videoURL: URL = Bundle.main.url(forResource: "eltcoin_splash_animation", withExtension: "mp4")!
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view!.bounds
        self.view!.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        player.play()
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        self.dismiss(animated: true, completion: nil)
    }
    
    func tryDisplay(){
        
        let rootVC: UIViewController = UIApplication.topViewController()!
        
        if rootVC.isKind(of: LaunchScreenViewController.self) {
            print("Launch screen already shoing")
        }else{
            
            let lastEntryDate: Date? = UserDefaults.standard.object(forKey:"UNLOCK_DATE") as? Date ?? nil
            let lastExitDate: Date? = UserDefaults.standard.object(forKey:"EXIT_DATE") as? Date ?? nil
            
            if lastEntryDate != nil {
                let elapsed = Date().timeIntervalSince(lastEntryDate!)
                let duration = Int(elapsed)
                
                print ("Time elapsed since last PIN entry: \(duration)")
                if( duration < 5){
                    print("Hasn't been 5 seconds yet")
                    return
                }
            }
            
            if lastExitDate != nil {
                let elapsed = Date().timeIntervalSince(lastExitDate!)
                let duration = Int(elapsed)
                
                print ("Time elapsed since last exiting app: \(duration)")
                if( duration < 5){
                    print("Hasn't been 5 seconds yet")
                    return
                }
            }
            
            rootVC.present(self, animated: false, completion: nil)
        }
    }
    
}
