//
//  JellyViewExtentions.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
  
  public func touchPoint(forPosition position: Position, flexibility flx: CGFloat) -> CGPoint {
    var touchPoint = CGPoint.zero
    switch position {
    case .left:
      touchPoint = CGPoint(x: self.translation(in: self.view).x * flx, y: self.location(in: self.view).y)
    case .right:
      touchPoint = CGPoint(x: self.translation(in: self.view).x * flx, y: self.location(in: self.view).y)
    case .top:
      touchPoint = CGPoint(x: self.location(in: self.view).x, y: self.translation(in: self.view).y * flx)
    case .bottom:
      touchPoint = CGPoint(x: self.location(in: self.view).x, y: self.translation(in: self.view).y * flx)
    }
    return touchPoint
  }
  
}

extension CGRect {
  func translatedFrame() -> CGRect {
    var frame = CGRect.zero
    if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
      frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    } else {
      frame = CGRect(x: origin.x, y: origin.y, width: size.height, height: size.width)
    }
    return frame
  }
}

extension CGPath {
  func forEach( body: @convention(block) (CGPathElement) -> Void) {
    typealias Body = @convention(block) (CGPathElement) -> Void
    func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
      let body = unsafeBitCast(info, to: Body.self)
      body(element.pointee)
    }
    let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
    self.apply(info: unsafeBody, function: callback)
  }
}

public extension UIBezierPath {
  
  public func jellyPath(_ pm: PathModifiers) {
    self.removeAllPoints()
    self.move(to: pm.fstStartPoint)
    self.addCurve(to: pm.fstEndPoint, controlPoint1: pm.fstControlPoint1, controlPoint2: pm.fstControlPoint2)
    self.addCurve(to: pm.sndEndPoint, controlPoint1: pm.sndControlPoint1, controlPoint2: pm.sndControlPoint2)
    self.close()
  } 
  
  public func currentPathModifiers() -> PathModifiers? {
    
    var fstStartPoint: CGPoint?
    var fstEndPoint: CGPoint?
    var fstControlPoint1: CGPoint?
    var fstControlPoint2: CGPoint?
    
    var sndStartPoint: CGPoint?
    var sndEndPoint: CGPoint?
    var sndControlPoint1: CGPoint?
    var sndControlPoint2: CGPoint?
    
    var index = 0
    var error = false
    self.cgPath.forEach { element in
      
      if index == 0 && element.type == .moveToPoint {
        fstStartPoint = element.points.pointee
      } else if index == 1 && element.type == .addCurveToPoint {
        fstEndPoint = element.points.advanced(by: 2).pointee
        fstControlPoint1 = element.points.pointee
        fstControlPoint2 = element.points.advanced(by: 1).pointee
      } else if index == 2 && element.type == .addCurveToPoint {
        sndStartPoint = fstEndPoint
        sndEndPoint = element.points.advanced(by: 2).pointee
        sndControlPoint1 = element.points.pointee
        sndControlPoint2 = element.points.advanced(by: 1).pointee
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

extension CGFloat {
  var degreesToRadians: Double { return Double(self) * .pi / 180 }
}