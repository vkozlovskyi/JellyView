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
  
  public func jellyPath(_ pm: Path) {
    self.removeAllPoints()
    self.move(to: pm.fstCurve.startPoint)
    self.addCurve(to: pm.fstCurve.endPoint,
                  controlPoint1: pm.fstCurve.controlPoint1,
                  controlPoint2: pm.fstCurve.controlPoint2)
    self.addCurve(to: pm.sndCurve.endPoint,
                  controlPoint1: pm.sndCurve.controlPoint1,
                  controlPoint2: pm.sndCurve.controlPoint2)
    self.close()
  } 
  
  public func currentPathModifiers() -> Path? {
    
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

    let fstCurve = Curve(startPoint: fstStartPoint!,
                         endPoint: fstEndPoint!,
                         controlPoint1: fstControlPoint1!,
                         controlPoint2: fstControlPoint2!)

    let sndCurve = Curve(startPoint: sndStartPoint!,
                         endPoint: sndEndPoint!,
                         controlPoint1: sndControlPoint1!,
                         controlPoint2: sndControlPoint2!)

    let pathModifiers = Path(fstCurve: fstCurve, sndCurve: sndCurve)

    return pathModifiers
  }
}

extension CGFloat {
  var degreesToRadians: Double { return Double(self) * .pi / 180 }
}