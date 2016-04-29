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
    jellyView.backgroundColor = UIColor.blueColor()
    jellyView.jellyColor = UIColor.greenColor()
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
  
  public func jellyPath(pm : PathModifiers) {
    self.removeAllPoints()
    self.moveToPoint(pm.fstStartPoint)
    self.addCurveToPoint(pm.fstEndPoint, controlPoint1: pm.fstControlPoint1, controlPoint2: pm.fstControlPoint2)
    self.addCurveToPoint(pm.sndEndPoint, controlPoint1: pm.sndControlPoint1, controlPoint2: pm.sndControlPoint2)
  }
  
}

