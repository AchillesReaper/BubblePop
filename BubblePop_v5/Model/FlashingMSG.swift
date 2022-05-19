//
//  FlashingMSG.swift
//  BubblePop_v5
//
//  Created by Donald Ho on 25/4/2022.
//

import Foundation
import UIKit

class FlashingMSG: UILabel{
    var screenWidth = Int(UIScreen.main.bounds.width)
    var screenHeight = Int(UIScreen.main.bounds.height)
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let labelWidth = Int(self.intrinsicContentSize.width)
        let xPos = (screenWidth - labelWidth)/2
        self.frame = CGRect(x: xPos, y: (screenHeight/2), width: labelWidth, height: 120)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.3
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.2
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 1
        springAnimation.damping = 1
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = false
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
}
