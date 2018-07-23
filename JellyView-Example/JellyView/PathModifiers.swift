//
//  PathModifiers.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 06.05.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct CurveModifiers {
  let startPoint: CGPoint
  let endPoint: CGPoint
  let controlPoint1: CGPoint
  let controlPoint2: CGPoint
}

public struct PathModifiers {
  let fstCurveModifiers: CurveModifiers
  let sndCurveModifiers: CurveModifiers
  private static let extraSpaceDivider: CGFloat = 4
}

// MARK: - Public Type Methods

public extension PathModifiers {
  
  static func currentPathModifiers(forPosition position: Position,
                                              touchPoint: CGPoint,
                                              jellyFrame: CGRect,
                                         outerPointRatio: CGFloat,
                                         innerPointRatio: CGFloat) -> PathModifiers {
    
    switch position {
    case .left:
      return PathModifiers.leftPathModifiers(touchPoint: touchPoint,
                                             jellyFrame: jellyFrame,
                                             outerPointRatio: outerPointRatio,
                                             innerPointRatio: innerPointRatio)
    case .right:
      return PathModifiers.rightPathModifiers(touchPoint: touchPoint,
                                              jellyFrame: jellyFrame,
                                              outerPointRatio: outerPointRatio,
                                              innerPointRatio: innerPointRatio)
    case .top:
      return PathModifiers.topPathModifiers(touchPoint: touchPoint,
                                            jellyFrame: jellyFrame,
                                            outerPointRatio: outerPointRatio,
                                            innerPointRatio: innerPointRatio)
    case .bottom:
      return PathModifiers.bottomPathModifiers(touchPoint: touchPoint,
                                               jellyFrame: jellyFrame,
                                               outerPointRatio: outerPointRatio,
                                               innerPointRatio: innerPointRatio)
    }
  }
  
  static func initialPathModifiers(forPosition position: Position,
                                               jellyFrame: CGRect,
                                               outerPointRatio: CGFloat,
                                               innerPointRatio: CGFloat) -> PathModifiers {
    switch position {
    case .left:
      return PathModifiers.initialLeftPathModifiers(jellyFrame: jellyFrame,
                                                    outerPointRatio: outerPointRatio,
                                                    innerPointRatio: innerPointRatio)
    case .right:
      return PathModifiers.initialRightPathModifiers(jellyFrame: jellyFrame,
                                                     outerPointRatio: outerPointRatio,
                                                     innerPointRatio: innerPointRatio)
    case .top:
      return PathModifiers.initialTopPathModifiers(jellyFrame: jellyFrame,
                                                   outerPointRatio: outerPointRatio,
                                                   innerPointRatio: innerPointRatio)
    case .bottom:
      return PathModifiers.initialBottomPathModifiers(jellyFrame: jellyFrame,
                                                      outerPointRatio: outerPointRatio,
                                                      innerPointRatio: innerPointRatio)
    }
  }
  
  static func expandedPathModifiers(forPosition position: Position,
                                               jellyFrame: CGRect,
                                               outerPointRatio: CGFloat,
                                               innerPointRatio: CGFloat) -> PathModifiers {
    switch position {
    case .left:
      return PathModifiers.expandedLeftPathModifiers(jellyFrame: jellyFrame,
                                                   outerPointRatio: outerPointRatio,
                                                   innerPointRatio: innerPointRatio)
    case .right:
      return PathModifiers.expandedRightPathModifiers(jellyFrame: jellyFrame,
                                                     outerPointRatio: outerPointRatio,
                                                     innerPointRatio: innerPointRatio)
    case .top:
      return PathModifiers.expandedTopPathModifiers(jellyFrame: jellyFrame,
                                                  outerPointRatio: outerPointRatio,
                                                  innerPointRatio: innerPointRatio)
    case .bottom:
      return PathModifiers.expandedBottomPathModifiers(jellyFrame: jellyFrame,
                                                     outerPointRatio: outerPointRatio,
                                                     innerPointRatio: innerPointRatio)
    }
  }
}

// MARK: - PathModifiers for touchPoint

private extension PathModifiers {

  static func leftPathModifiers(touchPoint: CGPoint,
                                jellyFrame: CGRect,
                                outerPointRatio: CGFloat,
                                innerPointRatio: CGFloat) -> PathModifiers {

    let height = jellyFrame.height
    let outerDelta = outerPointRatio * height
    let extraSpace = jellyFrame.height / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint = CGPoint(x: touchPoint.x, y: touchPoint.y)
    let fstControlPoint1 = CGPoint(x: 0, y: touchPoint.y * innerPointRatio)
    let fstControlPoint2 = CGPoint(x: touchPoint.x, y: touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: touchPoint.x, y: touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPoint(x: 0, y: touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)
    
    return pathModifiers
  }

  static func rightPathModifiers(touchPoint: CGPoint,
                                 jellyFrame: CGRect,
                                 outerPointRatio: CGFloat,
                                 innerPointRatio: CGFloat) -> PathModifiers {

    let height = jellyFrame.height
    let width = jellyFrame.width
    let outerDelta = outerPointRatio * height
    let curvePointX = width + touchPoint.x
    let extraSpace = jellyFrame.height / extraSpaceDivider

    let fstStartPoint = CGPoint(x: width, y: -extraSpace)
    let fstEndPoint = CGPoint(x: curvePointX, y: touchPoint.y)
    let fstControlPoint1 = CGPoint(x: width, y: touchPoint.y * innerPointRatio)
    let fstControlPoint2 = CGPoint(x: curvePointX, y: touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: curvePointX, y: touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPoint(x: width, y: touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }

  static func topPathModifiers(touchPoint: CGPoint,
                               jellyFrame: CGRect,
                               outerPointRatio: CGFloat,
                               innerPointRatio: CGFloat) -> PathModifiers {

    let width = jellyFrame.width
    let outerDelta = outerPointRatio * width
    let extraSpace = jellyFrame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: touchPoint.x, y: touchPoint.y)
    let fstControlPoint1 = CGPoint(x: touchPoint.x * innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: touchPoint.x - outerDelta, y: touchPoint.y)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: touchPoint.x + outerDelta, y: touchPoint.y)
    let sndControlPoint2 = CGPoint(x: touchPoint.x + (width - touchPoint.x) * (1.0 - innerPointRatio), y: 0)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }

  static func bottomPathModifiers(touchPoint: CGPoint,
                                  jellyFrame: CGRect,
                                  outerPointRatio: CGFloat,
                                  innerPointRatio: CGFloat) -> PathModifiers {

    let width = jellyFrame.width
    let height = jellyFrame.height
    let outerDelta = outerPointRatio * width
    let curvePointY = height + touchPoint.y
    let extraSpace = jellyFrame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: height)
    let fstEndPoint = CGPoint(x: touchPoint.x, y: curvePointY)
    let fstControlPoint1 = CGPoint(x: touchPoint.x * innerPointRatio, y: height)
    let fstControlPoint2 = CGPoint(x: touchPoint.x - outerDelta, y: curvePointY)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: height)
    let sndControlPoint1 = CGPoint(x: touchPoint.x + outerDelta, y: curvePointY)
    let sndControlPoint2 = CGPoint(x: touchPoint.x + (width - touchPoint.x) * (1.0 - innerPointRatio), y: height)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
}

// MARK: - PathModifiers for initial position

private extension PathModifiers {
  
  static func initialLeftPathModifiers(jellyFrame: CGRect,
                                       outerPointRatio: CGFloat,
                                       innerPointRatio: CGFloat) -> PathModifiers {
    
    let height = jellyFrame.height
    let outerDelta = outerPointRatio * height
    let extraSpace = jellyFrame.height / extraSpaceDivider
    
    let centerY = height / 2
    let fstStartPoint: CGPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint: CGPoint = CGPoint(x: 0, y: centerY)
    let fstControlPoint1: CGPoint = CGPoint(x: 0, y: centerY * innerPointRatio)
    let fstControlPoint2: CGPoint = CGPoint(x: 0, y: centerY - outerDelta)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1: CGPoint = CGPoint(x: 0, y: centerY + outerDelta)
    let sndControlPoint2: CGPoint = CGPoint(x: 0, y: centerY + (height - centerY) * (1.0 - innerPointRatio))

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
  static func initialRightPathModifiers(jellyFrame: CGRect,
                                        outerPointRatio: CGFloat,
                                        innerPointRatio: CGFloat) -> PathModifiers {
    
    let height = jellyFrame.height
    let width = jellyFrame.width
    let outerDelta = outerPointRatio * height
    let extraSpace = jellyFrame.height / extraSpaceDivider

    let centerY = height / 2
    let fstStartPoint = CGPoint(x: width, y: -extraSpace)
    let fstEndPoint = CGPoint(x: width, y: centerY)
    let fstControlPoint1 = CGPoint(x: width, y: centerY * innerPointRatio)
    let fstControlPoint2 = CGPoint(x: width, y: centerY - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: width, y: centerY + outerDelta)
    let sndControlPoint2 = CGPoint(x: width, y: centerY + (height - centerY) * (1.0 - innerPointRatio))

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
  static func initialTopPathModifiers(jellyFrame: CGRect,
                                      outerPointRatio: CGFloat,
                                      innerPointRatio: CGFloat) -> PathModifiers {
    let width = jellyFrame.width
    let outerDelta = outerPointRatio * width
    let centerY = width / 2
    let extraSpace = jellyFrame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: centerY, y: 0)
    let fstControlPoint1 = CGPoint(x: centerY * innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: centerY - outerDelta, y: 0)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: centerY + outerDelta, y: 0)
    let sndControlPoint2: CGPoint = CGPoint(x: centerY + (width - centerY) * (1.0 - innerPointRatio), y: 0)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
  static func initialBottomPathModifiers(jellyFrame: CGRect,
                                         outerPointRatio: CGFloat,
                                         innerPointRatio: CGFloat) -> PathModifiers {
    let width = jellyFrame.width
    let height = jellyFrame.height
    let outerDelta = outerPointRatio * width
    let centerY = width / 2
    let extraSpace = jellyFrame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: height)
    let fstEndPoint = CGPoint(x: centerY, y: height)
    let fstControlPoint1 = CGPoint(x: centerY * innerPointRatio, y: height)
    let fstControlPoint2 = CGPoint(x: centerY - outerDelta, y: height)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: height)
    let sndControlPoint1 = CGPoint(x: centerY + outerDelta, y: height)
    let sndControlPoint2 = CGPoint(x: centerY + (width - centerY) * (1.0 - innerPointRatio), y: height)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
}

// MARK: - PathModifiers for final position

private extension PathModifiers {
  
  static func expandedLeftPathModifiers(jellyFrame: CGRect,
                                        outerPointRatio: CGFloat,
                                        innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = jellyFrame.height / extraSpaceDivider
    let height = jellyFrame.height
    let width = jellyFrame.width * 2
    let centerY = height / 2
    
    let fstStartPoint: CGPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint: CGPoint = CGPoint(x: width, y: centerY)
    let fstControlPoint1: CGPoint = CGPoint(x: width / 2, y: -extraSpace)
    let fstControlPoint2: CGPoint = CGPoint(x: width, y: centerY / 2)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1: CGPoint = CGPoint(x: width, y: centerY + extraSpace)
    let sndControlPoint2: CGPoint = CGPoint(x: width / 2, y: height + extraSpace)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
  static func expandedRightPathModifiers(jellyFrame: CGRect,
                                         outerPointRatio: CGFloat,
                                         innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = jellyFrame.height / extraSpaceDivider
    let height = jellyFrame.height
    let width = jellyFrame.width
    let widthFinalPoint = width - (width * 2)
    let centerY = height / 2
    
    let delta = (width * 2) / 2 + widthFinalPoint
    
    let fstStartPoint: CGPoint = CGPoint(x: width, y: -extraSpace)
    let fstEndPoint: CGPoint = CGPoint(x: widthFinalPoint, y: centerY)
    let fstControlPoint1: CGPoint = CGPoint(x: delta / 2, y: -extraSpace)
    let fstControlPoint2: CGPoint = CGPoint(x: widthFinalPoint, y: centerY / 2)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: width, y: height + extraSpace)
    let sndControlPoint1: CGPoint = CGPoint(x: widthFinalPoint, y: centerY + extraSpace)
    let sndControlPoint2: CGPoint = CGPoint(x: delta / 2, y: height + extraSpace)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
  
  static func expandedTopPathModifiers(jellyFrame: CGRect,
                                       outerPointRatio: CGFloat,
                                       innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = jellyFrame.width / extraSpaceDivider
    let height = jellyFrame.height * 2
    let width = jellyFrame.width
    let centerX = width / 2
    
    let fstStartPoint: CGPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint: CGPoint = CGPoint(x: centerX, y: height)
    let fstControlPoint1: CGPoint = CGPoint(x: -extraSpace, y: height / 2)
    let fstControlPoint2: CGPoint = CGPoint(x: centerX / 2, y: height)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1: CGPoint = CGPoint(x: centerX + extraSpace, y: height)
    let sndControlPoint2: CGPoint = CGPoint(x: width + extraSpace, y: height / 2)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
    
  }
  
  static func expandedBottomPathModifiers(jellyFrame: CGRect,
                                          outerPointRatio: CGFloat,
                                          innerPointRatio: CGFloat) -> PathModifiers {
    
    let extraSpace = jellyFrame.width / extraSpaceDivider
    let height = jellyFrame.height
    let heightFinalPoint = height - (height * 2)
    let width = jellyFrame.width
    let centerX = width / 2
    
    let delta = (height * 2) / 2 + heightFinalPoint
    
    let fstStartPoint: CGPoint = CGPoint(x: -extraSpace, y: height)
    let fstEndPoint: CGPoint = CGPoint(x: centerX, y: heightFinalPoint)
    let fstControlPoint1: CGPoint = CGPoint(x: -extraSpace, y: delta)
    let fstControlPoint2: CGPoint = CGPoint(x: centerX / 2, y: heightFinalPoint)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: width + extraSpace, y: height)
    let sndControlPoint1: CGPoint = CGPoint(x: centerX + extraSpace, y: heightFinalPoint)
    let sndControlPoint2: CGPoint = CGPoint(x: width + extraSpace, y: delta)

    let fstCurveModifiers = CurveModifiers(startPoint: fstStartPoint,
                                           endPoint: fstEndPoint,
                                           controlPoint1: fstControlPoint1,
                                           controlPoint2: fstControlPoint2)

    let sndCurveModifiers = CurveModifiers(startPoint: sndStartPoint,
                                           endPoint: sndEndPoint,
                                           controlPoint1: sndControlPoint1,
                                           controlPoint2: sndControlPoint2)

    let pathModifiers = PathModifiers(fstCurveModifiers: fstCurveModifiers, sndCurveModifiers: sndCurveModifiers)

    return pathModifiers
  }
}
