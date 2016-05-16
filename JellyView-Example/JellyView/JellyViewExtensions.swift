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

public enum PathElement {
  case MoveToPoint(CGPoint)
  case AddLineToPoint(CGPoint)
  case AddQuadCurveToPoint(CGPoint, CGPoint)
  case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
  case CloseSubpath
  
  init(element: CGPathElement) {
    switch element.type {
    case .MoveToPoint:
      self = .MoveToPoint(element.points[0])
    case .AddLineToPoint:
      self = .AddLineToPoint(element.points[0])
    case .AddQuadCurveToPoint:
      self = .AddQuadCurveToPoint(element.points[0], element.points[1])
    case .AddCurveToPoint:
      self = .AddCurveToPoint(element.points[0], element.points[1], element.points[2])
    case .CloseSubpath:
      self = .CloseSubpath
    }
  }
}


extension PathElement : CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case let .MoveToPoint(point):
      return "\(point.x) \(point.y) moveto"
    case let .AddLineToPoint(point):
      return "\(point.x) \(point.y) lineto"
    case let .AddQuadCurveToPoint(point1, point2):
      return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) quadcurveto"
    case let .AddCurveToPoint(point1, point2, point3):
      return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) \(point3.x) \(point3.y) curveto"
    case .CloseSubpath:
      return "closepath"
    }
  }
}

extension PathElement : Equatable { }

public func ==(lhs: PathElement, rhs: PathElement) -> Bool {
  switch(lhs, rhs) {
  case let (.MoveToPoint(l), .MoveToPoint(r)):
    return l == r
  case let (.AddLineToPoint(l), .AddLineToPoint(r)):
    return l == r
  case let (.AddQuadCurveToPoint(l1, l2), .AddQuadCurveToPoint(r1, r2)):
    return l1 == r1 && l2 == r2
  case let (.AddCurveToPoint(l1, l2, l3), .AddCurveToPoint(r1, r2, r3)):
    return l1 == r1 && l2 == r2 && l3 == r3
  case (.CloseSubpath, .CloseSubpath):
    return true
  case (_, _):
    return false
  }
}

extension UIBezierPath {
  var elements: [PathElement] {
    var pathElements = [PathElement]()
    withUnsafeMutablePointer(&pathElements) { elementsPointer in
      CGPathApply(CGPath, elementsPointer) { (userInfo, nextElementPointer) in
        let nextElement = PathElement(element: nextElementPointer.memory)
        let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
        elementsPointer.memory.append(nextElement)
      }
    }
    return pathElements
  }
}

extension UIBezierPath : SequenceType {
  public func generate() -> AnyGenerator<PathElement> {
    return AnyGenerator(elements.generate())
  }
}