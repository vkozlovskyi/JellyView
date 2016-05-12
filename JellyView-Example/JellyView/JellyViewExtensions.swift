//
//  JellyViewExtentions.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public extension UIPanGestureRecognizer {
  
  public func touchPoint(forPosition position : Position, flexibility flx : CGFloat) -> CGPoint {
    var touchPoint = CGPointZero
    switch position {
    case .Left:
      touchPoint = CGPointMake(self.translationInView(self.view).x * flx, self.locationInView(self.view).y)
    case .Right:
      touchPoint = CGPointMake(self.translationInView(self.view).x * flx, self.locationInView(self.view).y)
    case .Top:
      touchPoint = CGPointMake(self.locationInView(self.view).x, self.translationInView(self.view).y * flx)
    case .Bottom:
      touchPoint = CGPointMake(self.locationInView(self.view).x, self.translationInView(self.view).y * flx)
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
    self.closePath()
  }
  
}