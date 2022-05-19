//
//  Bubble.swift
//  BubblePop_v5
//
//  Created by Donald Ho on 24/4/2022.
//

import UIKit

class Bubble: UIButton {
    
    
    var value: Double = 0
    var screenWidth = Int(UIScreen.main.bounds.width)
    var screenHeight = Int(UIScreen.main.bounds.height)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bubbleDiameter = 60
        //bubble will be generated randomly inside the safe area and avoid overlapping with the top label area
        let xPos = Int.random(in: 0...(screenWidth - bubbleDiameter))
        let yPos = Int.random(in: 160...(screenHeight - bubbleDiameter - 40))
        self.frame = CGRect(x: xPos, y: yPos, width: bubbleDiameter, height: bubbleDiameter)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        //To generate bubbles with random color and assign score to each color
        let possibility = Int(arc4random_uniform(100))
        switch possibility {
        case 0...39:
            self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.value = 1
        case 40...69:
            self.backgroundColor = #colorLiteral(red: 0.8867238626, green: 0.290980173, blue: 0.9032632292, alpha: 1)
            self.value = 2
        case 70...84:
            self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.value = 5
        case 85...94:
            self.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            self.value = 8
        case 95...99:
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.value = 10
        default:
            print("error")
        }
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
