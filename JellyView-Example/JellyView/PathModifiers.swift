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
  private static let extraSpaceDivider : CGFloat = 4
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
  
  static func expandedPathModifiers(forPosition position: Position,
                                               touchPoint: CGPoint,
                                               jellyFrame: CGRect,
                                               outerPointRatio: CGFloat,
                                               innerPointRatio: CGFloat) -> PathModifiers {
    switch position {
    case .Left:
      return PathModifiers.expandedLeftPathModifiers(touchPoint: touchPoint,
                                                   jellyFrame: jellyFrame,
                                                   outerPointRatio: outerPointRatio,
                                                   innerPointRatio: innerPointRatio)
    case .Right:
      return PathModifiers.expandedRightPathModifiers(touchPoint: touchPoint,
                                                     jellyFrame: jellyFrame,
                                                     outerPointRatio: outerPointRatio,
                                                     innerPointRatio: innerPointRatio)
    case .Top:
      return PathModifiers.expandedTopPathModifiers(touchPoint: touchPoint,
                                                  jellyFrame: jellyFrame,
                                                  outerPointRatio: outerPointRatio,
                                                  innerPointRatio: innerPointRatio)
    case .Bottom:
      return PathModifiers.expandedBottomPathModifiers(touchPoint: touchPoint,
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
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider
    
    let fstStartPoint = CGPointMake(0, -extraSpace)
    let fstEndPoint = CGPointMake(touchPoint.x, touchPoint.y)
    let fstControlPoint1 = CGPointMake(0, touchPoint.y * innerPointRatio)
    let fstControlPoint2 = CGPointMake(touchPoint.x, touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(0, height + extraSpace)
    let sndControlPoint1 = CGPointMake(touchPoint.x, touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPointMake(0, touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))
    
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
    
    let height = CGRectGetHeight(jellyFrame)
    let width = CGRectGetWidth(jellyFrame)
    let outerDelta = outerPointRatio * height
    let curvePointX = width + touchPoint.x
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider

    let fstStartPoint = CGPointMake(width, -extraSpace)
    let fstEndPoint = CGPointMake(curvePointX, touchPoint.y)
    let fstControlPoint1 = CGPointMake(width, touchPoint.y * innerPointRatio)
    let fstControlPoint2 = CGPointMake(curvePointX, touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width, height + extraSpace)
    let sndControlPoint1 = CGPointMake(curvePointX, touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPointMake(width, touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))
    
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
  
  static func topPathModifiers(touchPoint touchPoint: CGPoint,
                                          jellyFrame: CGRect,
                                          outerPointRatio: CGFloat,
                                          innerPointRatio: CGFloat) -> PathModifiers {
    
    let width = CGRectGetWidth(jellyFrame)
    let outerDelta = outerPointRatio * width
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    
    let fstStartPoint = CGPointMake(-extraSpace, 0)
    let fstEndPoint = CGPointMake(touchPoint.x, touchPoint.y)
    let fstControlPoint1 = CGPointMake(touchPoint.x * innerPointRatio, 0)
    let fstControlPoint2 = CGPointMake(touchPoint.x - outerDelta, touchPoint.y)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width + extraSpace, 0)
    let sndControlPoint1 = CGPointMake(touchPoint.x + outerDelta, touchPoint.y)
    let sndControlPoint2 = CGPointMake(touchPoint.x + (width - touchPoint.x) * (1.0 - innerPointRatio), 0)
    
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
  
  static func bottomPathModifiers(touchPoint touchPoint: CGPoint,
                                             jellyFrame: CGRect,
                                             outerPointRatio: CGFloat,
                                             innerPointRatio: CGFloat) -> PathModifiers {
    
    let width = CGRectGetWidth(jellyFrame)
    let height = CGRectGetHeight(jellyFrame)
    let outerDelta = outerPointRatio * width
    let curvePointY = height + touchPoint.y
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    
    let fstStartPoint = CGPointMake(-extraSpace, height)
    let fstEndPoint = CGPointMake(touchPoint.x, curvePointY)
    let fstControlPoint1 = CGPointMake(touchPoint.x * innerPointRatio, height)
    let fstControlPoint2 = CGPointMake(touchPoint.x - outerDelta, curvePointY)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width + extraSpace, height)
    let sndControlPoint1 = CGPointMake(touchPoint.x + outerDelta, curvePointY)
    let sndControlPoint2 = CGPointMake(touchPoint.x + (width - touchPoint.x) * (1.0 - innerPointRatio), height)
    
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
  
}

// MARK: - PathModifiers for initial position

private extension PathModifiers {
  
  static func initiaLeftPathModifiers(touchPoint touchPoint: CGPoint,
                                                   jellyFrame: CGRect,
                                                   outerPointRatio: CGFloat,
                                                   innerPointRatio: CGFloat) -> PathModifiers {

    let height = CGRectGetHeight(jellyFrame)
    let outerDelta = outerPointRatio * height
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider
    
    let centerY = height / 2
    let fstStartPoint : CGPoint = CGPointMake(0, -extraSpace)
    let fstEndPoint : CGPoint = CGPointMake(0, centerY)
    let fstControlPoint1 : CGPoint = CGPointMake(0, centerY * innerPointRatio)
    let fstControlPoint2 : CGPoint = CGPointMake(0, centerY - outerDelta)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(0, height + extraSpace)
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
    
    let height = CGRectGetHeight(jellyFrame)
    let width = CGRectGetWidth(jellyFrame)
    let outerDelta = outerPointRatio * height
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider

    let centerY = height / 2
    let fstStartPoint = CGPointMake(width, -extraSpace)
    let fstEndPoint = CGPointMake(width, centerY)
    let fstControlPoint1 = CGPointMake(width, centerY * innerPointRatio)
    let fstControlPoint2 = CGPointMake(width, centerY - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width, height + extraSpace)
    let sndControlPoint1 = CGPointMake(width, centerY + outerDelta)
    let sndControlPoint2 = CGPointMake(width, centerY + (height - centerY) * (1.0 - innerPointRatio))
    
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
  
  static func initiaTopPathModifiers(touchPoint touchPoint: CGPoint,
                                                 jellyFrame: CGRect,
                                                 outerPointRatio: CGFloat,
                                                 innerPointRatio: CGFloat) -> PathModifiers {
    let width = CGRectGetWidth(jellyFrame)
    let outerDelta = outerPointRatio * width
    let centerY = width / 2
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    
    let fstStartPoint = CGPointMake(-extraSpace, 0)
    let fstEndPoint = CGPointMake(centerY, 0)
    let fstControlPoint1 = CGPointMake(centerY * innerPointRatio, 0)
    let fstControlPoint2 = CGPointMake(centerY - outerDelta, 0)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width + extraSpace, 0)
    let sndControlPoint1 = CGPointMake(centerY + outerDelta, 0)
    let sndControlPoint2 : CGPoint = CGPointMake(centerY + (width - centerY) * (1.0 - innerPointRatio), 0)
    
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
  
  static func initiaBottomPathModifiers(touchPoint touchPoint: CGPoint,
                                                jellyFrame: CGRect,
                                                outerPointRatio: CGFloat,
                                                innerPointRatio: CGFloat) -> PathModifiers {
    let width = CGRectGetWidth(jellyFrame)
    let height = CGRectGetHeight(jellyFrame)
    let outerDelta = outerPointRatio * width
    let centerY = width / 2
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    
    let fstStartPoint = CGPointMake(-extraSpace, height)
    let fstEndPoint = CGPointMake(centerY, height)
    let fstControlPoint1 = CGPointMake(centerY * innerPointRatio, height)
    let fstControlPoint2 = CGPointMake(centerY - outerDelta, height)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPointMake(width + extraSpace, height)
    let sndControlPoint1 = CGPointMake(centerY + outerDelta, height)
    let sndControlPoint2 = CGPointMake(centerY + (width - centerY) * (1.0 - innerPointRatio), height)
    
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
  
}

// MARK: - PathModifiers for final position

private extension PathModifiers {
  
  static func expandedLeftPathModifiers(touchPoint touchPoint: CGPoint,
                                                 jellyFrame: CGRect,
                                                 outerPointRatio: CGFloat,
                                                 innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider
    let height = CGRectGetHeight(jellyFrame)
    let width = CGRectGetWidth(jellyFrame) * 2
    let centerY = height / 2
    
    let fstStartPoint : CGPoint = CGPointMake(0, -extraSpace)
    let fstEndPoint : CGPoint = CGPointMake(width, centerY)
    let fstControlPoint1 : CGPoint = CGPointMake(width / 2, -extraSpace)
    let fstControlPoint2 : CGPoint = CGPointMake(width, centerY / 2)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(0, height + extraSpace)
    let sndControlPoint1 : CGPoint = CGPointMake(width, centerY + extraSpace)
    let sndControlPoint2 : CGPoint = CGPointMake(width / 2, height + extraSpace)
    
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
  
  static func expandedRightPathModifiers(touchPoint touchPoint: CGPoint,
                                                   jellyFrame: CGRect,
                                                   outerPointRatio: CGFloat,
                                                   innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = CGRectGetHeight(jellyFrame) / extraSpaceDivider
    let height = CGRectGetHeight(jellyFrame)
    let width = CGRectGetWidth(jellyFrame)
    let widthFinalPoint = width - (width * 2)
    let centerY = height / 2
    
    let delta = (width * 2) / 2 + widthFinalPoint
    
    let fstStartPoint : CGPoint = CGPointMake(width, -extraSpace)
    let fstEndPoint : CGPoint = CGPointMake(widthFinalPoint, centerY)
    let fstControlPoint1 : CGPoint = CGPointMake(delta / 2, -extraSpace)
    let fstControlPoint2 : CGPoint = CGPointMake(widthFinalPoint, centerY / 2)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(width, height + extraSpace)
    let sndControlPoint1 : CGPoint = CGPointMake(widthFinalPoint, centerY + extraSpace)
    let sndControlPoint2 : CGPoint = CGPointMake(delta / 2, height + extraSpace)
    
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
  
  static func expandedTopPathModifiers(touchPoint touchPoint: CGPoint,
                                                jellyFrame: CGRect,
                                                outerPointRatio: CGFloat,
                                                innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    let height = CGRectGetHeight(jellyFrame) * 2
    let width = CGRectGetWidth(jellyFrame)
    let centerX = width / 2
    
    let fstStartPoint : CGPoint = CGPointMake(-extraSpace, 0)
    let fstEndPoint : CGPoint = CGPointMake(centerX, height)
    let fstControlPoint1 : CGPoint = CGPointMake(-extraSpace, height / 2)
    let fstControlPoint2 : CGPoint = CGPointMake(centerX / 2, height)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(width + extraSpace, 0)
    let sndControlPoint1 : CGPoint = CGPointMake(centerX + extraSpace, height)
    let sndControlPoint2 : CGPoint = CGPointMake(width + extraSpace, height / 2)
    
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
  
  static func expandedBottomPathModifiers(touchPoint touchPoint: CGPoint,
                                                   jellyFrame: CGRect,
                                                   outerPointRatio: CGFloat,
                                                   innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = CGRectGetWidth(jellyFrame) / extraSpaceDivider
    let height = CGRectGetHeight(jellyFrame)
    let heightFinalPoint = height - (height * 2)
    let width = CGRectGetWidth(jellyFrame)
    let centerX = width / 2
    
    let delta = (height * 2) / 2 + heightFinalPoint
    
    let fstStartPoint : CGPoint = CGPointMake(-extraSpace, height)
    let fstEndPoint : CGPoint = CGPointMake(centerX, heightFinalPoint)
    let fstControlPoint1 : CGPoint = CGPointMake(-extraSpace, delta)
    let fstControlPoint2 : CGPoint = CGPointMake(centerX / 2, heightFinalPoint)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(width + extraSpace, height)
    let sndControlPoint1 : CGPoint = CGPointMake(centerX + extraSpace, heightFinalPoint)
    let sndControlPoint2 : CGPoint = CGPointMake(width + extraSpace, delta)
    
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
}
