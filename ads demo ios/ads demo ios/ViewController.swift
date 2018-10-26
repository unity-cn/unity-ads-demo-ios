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
    @IBOutlet weak var showBannerButton: UIButton!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var placementIdLabel: UILabel!
    
    var bannerView: UIView! = nil
    
    // game logic property
    let usingPlacement = Values.usingPlacement
    var frames = 0
    let checkAvailabilityInterval = 30
    var coins = 0
    let rewardCoinAmount = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameIdLabel.text = Values.gameId
        placementIdLabel.text = usingPlacement
        self.viewAdsButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.showBannerButton.titleLabel?.textAlignment = NSTextAlignment.center
        let idfaString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("idfa = " + idfaString)
//        [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        // Do any additional setup after loading the view, typically from a nib.
        
        UnityServices.setDebugMode(Values.debugMode)
        UnityAdsBanner.setDelegate(self)
        UnityMonetization.initialize(Values.gameId, delegate: self, testMode: Values.testMode)
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
        let aa/*ads available*/ = UnityServices.isInitialized() && UnityMonetization.isReady(usingPlacement)
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
        let aa = UnityServices.isInitialized() && UnityMonetization.isReady(usingPlacement)
        if aa{
            let placementContent = UnityMonetization.getPlacementContent(usingPlacement)
            if (placementContent?.isKind(of: UMONShowAdPlacementContent.self))! {
                (placementContent as! UMONShowAdPlacementContent).show(self, with: self as UMONShowAdDelegate)
        }
        
        }
    }
    
    @IBAction func showBannerButtonTapped(_sender: Any)
    {
        print("[ViewController] showBannerButtonTapped")
        if((bannerView) != nil){
            UnityAdsBanner.destroy()
        }
        else{
        UnityAdsBanner.load(Values.bannerPlacementId)
    }
    }
}



extension ViewController: UnityMonetizationDelegate, UMONShowAdDelegate, UnityAdsBannerDelegate {
    
    func placementContentReady(_ placementId: String, placementContent decision: UMONPlacementContent) {
        
        print("[UnityMonetizationDelegate] placementContentReady, placementId=" + placementId)
        viewAdsButton.isEnabled = true;
    }
    
    func placementContentStateDidChange(_ placementId: String, placementContent: UMONPlacementContent, previousState: UnityMonetizationPlacementContentState, newState: UnityMonetizationPlacementContentState) {
        
        print("[UnityMonetizationDelegate] placementContentStateDidChange, placementId=%s  state=%ld", placementId, newState)
    }
    
    func unityAdsBannerDidLoad(_ placementId: String, view: UIView) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidLoad, placementId=" + placementId)
        self.bannerView = view
        self.view.addSubview(bannerView)
    }
    
    func unityAdsBannerDidUnload(_ placementId: String) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidUnload, placementId=" + placementId)
    }
    
    func unityAdsBannerDidShow(_ placementId: String) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidShow, placementId=" + placementId)
    }
    
    func unityAdsBannerDidHide(_ placementId: String) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidHide, placementId=" + placementId)
    }
    
    func unityAdsBannerDidClick(_ placementId: String) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidClick, placementId=" + placementId)
    }
    
    func unityAdsBannerDidError(_ message: String) {
        
        print("[UnityAdsBannerDelegate] unityAdsBannerDidError, message=" + message)
    }
    
    func unityServicesDidError(_ error: UnityServicesError, withMessage message: String) {
        
        print("[UMONShowAdDelegate] unityAdsDidError=%ld, errorMessage=" + message, error);
        
    }
    
    func unityAdsDidStart(_ placementId: String) {
        print("[UMONShowAdDelegate] unityAdsDidStart, placementId=" + placementId)
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        print("[UnityAdsDelegate] unityAdsDidFinish, placementId=" + placementId)
        switch (state) {
        case .completed:
            self.messageView.text = "video completed"
        case .skipped:
            self.messageView.text = "video skipped"
        case .error:
            self.messageView.text = "error"
        }
    }
    
}

