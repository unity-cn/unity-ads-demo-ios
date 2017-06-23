//
//  ViewController.swift
//  ads demo ios
//
//  Created by Solomon Li on 04/01/2017.
//  Copyright © 2017 Unity Technologies. All rights reserved.
//

import UIKit
import UnityAds
import AdSupport

class ViewController: GameViewController {

    // view outlets
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var viewAdsButton: UIButton!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var placementIdLabel: UILabel!
    
    
    // game logic property
    let usingPlacement = Values.usingPlacement
    var frames = 0
    let checkAvailabilityInterval = 30
    var coins = 0
    let rewardCoinAmount = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UnityAds.setDebugMode(Values.debugMode)
        UnityAds.setDelegate(self)
        gameIdLabel.text = Values.gameId
        placementIdLabel.text = usingPlacement
        self.viewAdsButton.titleLabel?.textAlignment = NSTextAlignment.center
        let idfaString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("idfa = " + idfaString)
//        [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func update() {
        frames += 1
        if frames >= checkAvailabilityInterval {
            frames = 0
            checkUnityAdsAvailability()
        }
    }
    
    func rewardPlayer() {
        coins += rewardCoinAmount
        self.coinsLabel.text = String(coins)
    }
    
    func checkUnityAdsAvailability() {
        let aa/*ads available*/ = UnityAds.isInitialized() && UnityAds.isReady(usingPlacement)
        setButtonState(enabled: aa)
    }
    
    func setButtonState(enabled: Bool) {
        self.viewAdsButton.isEnabled = enabled
        self.viewAdsButton.isUserInteractionEnabled = enabled
        let text = enabled ? "Get free coins" : "Free coins not available yet"
        self.viewAdsButton.setTitle(text, for: UIControlState.normal)
    }
    
    @IBAction func viewAdsButtonTapped(_ sender: Any) {
        print("[ViewController] viewAdsButtonTapped")
        let aa = UnityAds.isInitialized() && UnityAds.isReady(usingPlacement)
        if aa {
            UnityAds.show(self, placementId: usingPlacement)
        }
    }
}


extension ViewController: UnityAdsDelegate {
    func unityAdsReady(_ placementId: String) {
        print("[UnityAdsDelegate] unityAdsReady, placementId=" + placementId)
    }
    
    func unityAdsDidStart(_ placementId: String) {
        print("[UnityAdsDelegate] unityAdsDidStart, placementId=" + placementId)
        setButtonState(enabled: false)
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        print("[UnityAdsDelegate] unityAdsDidFinish, placementId=" + placementId)
        switch (state) {
        case .completed:
            rewardPlayer()
            self.messageView.text = "video completed"
        case .skipped:
            self.messageView.text = "video skipped"
        case .error:
            self.messageView.text = "error"
        }
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print("[UnityAdsDelegate] unityAdsDidError, errorMessage=" + message)
//        self.messageView.text = error.rawValue
    }
}
