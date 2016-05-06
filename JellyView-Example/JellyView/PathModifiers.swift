//
//  PathModifiers.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 06.05.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct PathModifiers {
  var fstStartPoint : CGPoint
  var fstEndPoint : CGPoint
  var fstControlPoint1 : CGPoint
  var fstControlPoint2 : CGPoint
  var sndStartPoint : CGPoint
  var sndEndPoint : CGPoint
  var sndControlPoint1 : CGPoint
  var sndControlPoint2 : CGPoint
}

// MARK: - Public Type Methods

public extension PathModifiers {
  
  static func currentPathModifiers(forPosition position: Position,
                                              touchPoint: CGPoint,
                                              jellyFrame: CGRect,
                                         outerPointRatio: CGFloat,
                                         innerPointRatio: CGFloat) -> PathModifiers {
    
    switch position {
    case .Left:
      return PathModifiers.leftPathModifiers(touchPoint: touchPoint,
                                             jellyFrame: jellyFrame,
                                             outerPointRatio: outerPointRatio,
                                             innerPointRatio: innerPointRatio)
    case .Right:
      return PathModifiers.rightPathModifiers(touchPoint: touchPoint,
                                              jellyFrame: jellyFrame,
                                              outerPointRatio: outerPointRatio,
                                              innerPointRatio: innerPointRatio)
    case .Top:
      return PathModifiers.topPathModifiers(touchPoint: touchPoint,
                                            jellyFrame: jellyFrame,
                                            outerPointRatio: outerPointRatio,
                                            innerPointRatio: innerPointRatio)
    case .Bottom:
      return PathModifiers.bottomPathModifiers(touchPoint: touchPoint,
                                               jellyFrame: jellyFrame,
                                               outerPointRatio: outerPointRatio,
                                               innerPointRatio: innerPointRatio)
    }
  }
  
  static func initialPathModifiers(forPosition position: Position,
                                               touchPoint: CGPoint,
                                               jellyFrame: CGRect,
                                               outerPointRatio: CGFloat,
                                               innerPointRatio: CGFloat) -> PathModifiers {
    switch position {
    case .Left:
      return PathModifiers.initiaLeftPathModifiers(touchPoint: touchPoint,
                                             jellyFrame: jellyFrame,
                                             outerPointRatio: outerPointRatio,
                                             innerPointRatio: innerPointRatio)
    case .Right:
      return PathModifiers.initialRightPathModifiers(touchPoint: touchPoint,
                                              jellyFrame: jellyFrame,
                                              outerPointRatio: outerPointRatio,
                                              innerPointRatio: innerPointRatio)
    case .Top:
      return PathModifiers.initiaTopPathModifiers(touchPoint: touchPoint,
                                            jellyFrame: jellyFrame,
                                            outerPointRatio: outerPointRatio,
                                            innerPointRatio: innerPointRatio)
    case .Bottom:
      return PathModifiers.initiaBottomPathModifiers(touchPoint: touchPoint,
                                               jellyFrame: jellyFrame,
                                               outerPointRatio: outerPointRatio,
                                               innerPointRatio: innerPointRatio)
    }
  }
}

// MARK: - PathModifiers for touchPoint

private extension PathModifiers {
  
  static func leftPathModifiers(touchPoint touchPoint: CGPoint,
                                           jellyFrame: CGRect,
                                           outerPointRatio: CGFloat,
                                           innerPointRatio: CGFloat) -> PathModifiers {
    
    let height = CGRectGetHeight(jellyFrame)
    let outerDelta = outerPointRatio * height
    
    let fstStartPoint : CGPoint = CGPointZero
    let fstEndPoint : CGPoint = CGPointMake(touchPoint.x, touchPoint.y)
    let fstControlPoint1 : CGPoint = CGPointMake(0, touchPoint.y * innerPointRatio)
    let fstControlPoint2 : CGPoint = CGPointMake(touchPoint.x, touchPoint.y - outerDelta)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(0, height)
    let sndControlPoint1 : CGPoint = CGPointMake(touchPoint.x, touchPoint.y + outerDelta)
    let sndControlPoint2 : CGPoint = CGPointMake(0, touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))
    
    let pathModifiers = PathModifiers(fstStartPoint: fstStartPoint,
                                      fstEndPoint: fstEndPoint,
                                      fstControlPoint1: fstControlPoint1,
                                      fstControlPoint2: fstControlPoint2,
                                      sndStartPoint: sndStartPoint,
                                      sndEndPoint: sndEndPoint,
                                      sndControlPoint1: sndControlPoint1,
                                      sndControlPoint2: sndControlPoint2)
    
    return pathModifiers
    
  }
  
  static func rightPathModifiers(touchPoint touchPoint: CGPoint,
                                            jellyFrame: CGRect,
                                            outerPointRatio: CGFloat,
                                            innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  static func topPathModifiers(touchPoint touchPoint: CGPoint,
                                          jellyFrame: CGRect,
                                          outerPointRatio: CGFloat,
                                          innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  static func bottomPathModifiers(touchPoint touchPoint: CGPoint,
                                             jellyFrame: CGRect,
                                             outerPointRatio: CGFloat,
                                             innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
}

// MARK: - PathModifiers for initial position

private extension PathModifiers {
  
  static func initiaLeftPathModifiers(touchPoint touchPoint: CGPoint,
                                                   jellyFrame: CGRect,
                                                   outerPointRatio: CGFloat,
                                                   innerPointRatio: CGFloat) -> PathModifiers {

    let height = CGRectGetHeight(jellyFrame)
    let outerDelta = outerPointRatio * height
    
    let centerY = height / 2
    let fstStartPoint : CGPoint = CGPointZero
    let fstEndPoint : CGPoint = CGPointMake(0, centerY)
    let fstControlPoint1 : CGPoint = CGPointMake(0, centerY * innerPointRatio)
    let fstControlPoint2 : CGPoint = CGPointMake(0, centerY - outerDelta)
    
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(0, height)
    let sndControlPoint1 : CGPoint = CGPointMake(0, centerY + outerDelta)
    let sndControlPoint2 : CGPoint = CGPointMake(0, centerY + (height - centerY) * (1.0 - innerPointRatio))
    
    
    let pathModifiers = PathModifiers(fstStartPoint: fstStartPoint,
                                      fstEndPoint: fstEndPoint,
                                      fstControlPoint1: fstControlPoint1,
                                      fstControlPoint2: fstControlPoint2,
                                      sndStartPoint: sndStartPoint,
                                      sndEndPoint: sndEndPoint,
                                      sndControlPoint1: sndControlPoint1,
                                      sndControlPoint2: sndControlPoint2)
    
    return pathModifiers
  }
  
  static func initialRightPathModifiers(touchPoint touchPoint: CGPoint,
                                            jellyFrame: CGRect,
                                            outerPointRatio: CGFloat,
                                            innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  static func initiaTopPathModifiers(touchPoint touchPoint: CGPoint,
                                                 jellyFrame: CGRect,
                                                 outerPointRatio: CGFloat,
                                                 innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  static func initiaBottomPathModifiers(touchPoint touchPoint: CGPoint,
                                                jellyFrame: CGRect,
                                                outerPointRatio: CGFloat,
                                                innerPointRatio: CGFloat) -> PathModifiers {
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
}
