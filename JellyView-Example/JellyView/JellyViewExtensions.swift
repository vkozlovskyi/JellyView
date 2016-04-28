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
  
  public func jellyPath(forPosition position : Position, touchPoint : CGPoint) {
    switch position {
    case .Left:
      jellyPathForLeftPosition(touchPoint)
    case .Right:
      jellyPathForRightPosition(touchPoint)
    case .Top:
      jellyPathForTopPosition(touchPoint)
    case .Bottom:
      jellyPathForBottomPosition(touchPoint)
    }
  }
  
  public func originalPath(forPosition position : Position, touchPoint : CGPoint) {
    switch position {
    case .Left:
      originalPathForLeftPosition(touchPoint)
    case .Right:
      originalPathForRightPosition(touchPoint)
    case .Top:
      originalPathForTopPosition(touchPoint)
    case .Bottom:
      originalPathForBottomPosition(touchPoint)
    }
  }
  
  private func jellyPathForLeftPosition(touchPoint : CGPoint) {
    
  }
  
  private func jellyPathForRightPosition(touchPoint : CGPoint) {
    
  }
  
  private func jellyPathForTopPosition(touchPoint : CGPoint) {
    
  }
  
  private func jellyPathForBottomPosition(touchPoint : CGPoint) {
    
  }
  
  private func originalPathForLeftPosition(touchPoint : CGPoint) {
    
  }
  
  private func originalPathForRightPosition(touchPoint : CGPoint) {
    
  }
  
  private func originalPathForTopPosition(touchPoint : CGPoint) {
    
  }
  
  private func originalPathForBottomPosition(touchPoint : CGPoint) {
    
  }
  
}

