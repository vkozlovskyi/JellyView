//
//  JellyViewExtentions.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
  
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

extension UIView {
  func translatedFrame() -> CGRect {
    var frame = CGRectZero
    if UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height {
      frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
    } else {
      frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.height, self.frame.size.width)
    }
    return frame
  }
}

extension CGPath {
  func forEach(@noescape body: @convention(block) (CGPathElement) -> Void) {
    typealias Body = @convention(block) (CGPathElement) -> Void
    func callback(info: UnsafeMutablePointer<Void>, element: UnsafePointer<CGPathElement>) {
      let body = unsafeBitCast(info, Body.self)
      body(element.memory)
    }
    let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
    CGPathApply(self, unsafeBody, callback)
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
  
  public func currentPathModifiers() -> PathModifiers? {
    
    var fstStartPoint : CGPoint?
    var fstEndPoint : CGPoint?
    var fstControlPoint1 : CGPoint?
    var fstControlPoint2 : CGPoint?
    
    var sndStartPoint : CGPoint?
    var sndEndPoint : CGPoint?
    var sndControlPoint1 : CGPoint?
    var sndControlPoint2 : CGPoint?
    
    var index = 0
    var error = false
    self.CGPath.forEach { element in
      
      if index == 0 && element.type == .MoveToPoint {
        fstStartPoint = element.points.memory
      } else if index == 1 && element.type == .AddCurveToPoint {
        fstEndPoint = element.points.advancedBy(2).memory
        fstControlPoint1 = element.points.memory
        fstControlPoint2 = element.points.advancedBy(1).memory
      } else if index == 2 && element.type == .AddCurveToPoint {
        sndStartPoint = fstEndPoint
        sndEndPoint = element.points.advancedBy(2).memory
        sndControlPoint1 = element.points.memory
        sndControlPoint2 = element.points.advancedBy(1).memory
      } else if index == 0 || index == 1 || index == 2 {
        error = true
      }
      
      index += 1
    }
    
    if error {
      return nil
    }
    
    let pathModifiers = PathModifiers(fstStartPoint: fstStartPoint!,
                                      fstEndPoint: fstEndPoint!,
                                      fstControlPoint1: fstControlPoint1!,
                                      fstControlPoint2: fstControlPoint2!,
                                      sndStartPoint: sndStartPoint!,
                                      sndEndPoint: sndEndPoint!,
                                      sndControlPoint1: sndControlPoint1!,
                                      sndControlPoint2: sndControlPoint2!)
    
    return pathModifiers
  }
}
