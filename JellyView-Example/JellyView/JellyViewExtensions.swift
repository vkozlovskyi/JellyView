//
//  JellyViewExtentions.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public extension UIView {
  
  public func addJellyView(position: Position) {
    let jellyView = JellyView(position: position)
    jellyView.connectGestureRecognizer(toView: self)
    self.addSubview(jellyView)
  }
}

public extension UIPanGestureRecognizer {
  
  public func touchPoint(forPosition position : Position) -> CGPoint {
    var touchPoint = CGPointZero
    switch position {
    case .Left:
      touchPoint = CGPointMake(self.translationInView(self.view).x, self.locationInView(self.view).y)
    case .Right:
      touchPoint = CGPointMake(self.translationInView(self.view).x, self.locationInView(self.view).y)
    case .Top:
      touchPoint = CGPointMake(self.locationInView(self.view).x, self.translationInView(self.view).y)
    case .Bottom:
      touchPoint = CGPointMake(self.locationInView(self.view).x, self.translationInView(self.view).y)
    }
    return touchPoint
  }
}

public extension UIBezierPath {
  
  public func jellyPathForLeftPosition(touchPoint : CGPoint) {
    
  }
  
  public func jellyPathForRightPosition(touchPoint : CGPoint) {
    
  }
  
  public func jellyPathForTopPosition(touchPoint : CGPoint) {
    
  }
  
  public func jellyPathForBottomPosition(touchPoint : CGPoint) {
    
  }
  
  public func originalPathForLeftPosition(touchPoint : CGPoint) {
    
  }
  
  public func originalPathForRightPosition(touchPoint : CGPoint) {
    
  }
  
  public func originalPathForTopPosition(touchPoint : CGPoint) {
    
  }
  
  public func originalPathForBottomPosition(touchPoint : CGPoint) {
    
  }
  
}

