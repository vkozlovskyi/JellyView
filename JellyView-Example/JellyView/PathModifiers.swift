//
//  PathModifiers.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 06.05.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct PathInputData {
  let touchPoint: CGPoint
  let frame: CGRect
  let innerPointRatio: CGFloat
  let outerPointRatio: CGFloat
}

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
  
  static func currentPathModifiers(forPosition position: Position, inputData: PathInputData) -> PathModifiers {
    switch position {
    case .left:
      return PathModifiers.leftPathModifiers(inputData: inputData)
    case .right:
      return PathModifiers.rightPathModifiers(inputData: inputData)
    case .top:
      return PathModifiers.topPathModifiers(inputData: inputData)
    case .bottom:
      return PathModifiers.bottomPathModifiers(inputData: inputData)
    }
  }
  
  static func initialPathModifiers(forPosition position: Position, inputData: PathInputData) -> PathModifiers {
    switch position {
    case .left:
      return PathModifiers.initialLeftPathModifiers(inputData: inputData)
    case .right:
      return PathModifiers.initialRightPathModifiers(inputData: inputData)
    case .top:
      return PathModifiers.initialTopPathModifiers(inputData: inputData)
    case .bottom:
      return PathModifiers.initialBottomPathModifiers(inputData: inputData)
    }
  }
  
  static func expandedPathModifiers(forPosition position: Position, inputData: PathInputData) -> PathModifiers {
    switch position {
    case .left:
      return PathModifiers.expandedLeftPathModifiers(inputData: inputData)
    case .right:
      return PathModifiers.expandedRightPathModifiers(inputData: inputData)
    case .top:
      return PathModifiers.expandedTopPathModifiers(inputData: inputData)
    case .bottom:
      return PathModifiers.expandedBottomPathModifiers(inputData: inputData)
    }
  }
}

// MARK: - PathModifiers for touchPoint

private extension PathModifiers {

  static func leftPathModifiers(inputData: PathInputData) -> PathModifiers {

    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * height
    let extraSpace = inputData.frame.height / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y)
    let fstControlPoint1 = CGPoint(x: 0, y: inputData.touchPoint.y * inputData.innerPointRatio)
    let fstControlPoint2 = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPoint(x: 0, y: inputData.touchPoint.y + (height - inputData.touchPoint.y) * (1.0 - inputData.innerPointRatio))

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

  static func rightPathModifiers(inputData: PathInputData) -> PathModifiers {

    let height = inputData.frame.height
    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * height
    let curvePointX = width + inputData.touchPoint.x
    let extraSpace = inputData.frame.height / extraSpaceDivider

    let fstStartPoint = CGPoint(x: width, y: -extraSpace)
    let fstEndPoint = CGPoint(x: curvePointX, y: inputData.touchPoint.y)
    let fstControlPoint1 = CGPoint(x: width, y: inputData.touchPoint.y * inputData.innerPointRatio)
    let fstControlPoint2 = CGPoint(x: curvePointX, y: inputData.touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: curvePointX, y: inputData.touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPoint(x: width, y: inputData.touchPoint.y + (height - inputData.touchPoint.y) * (1.0 - inputData.innerPointRatio))

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

  static func topPathModifiers(inputData: PathInputData) -> PathModifiers {

    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * width
    let extraSpace = inputData.frame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y)
    let fstControlPoint1 = CGPoint(x: inputData.touchPoint.x * inputData.innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: inputData.touchPoint.x - outerDelta, y: inputData.touchPoint.y)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: inputData.touchPoint.x + outerDelta, y: inputData.touchPoint.y)
    let sndControlPoint2 = CGPoint(x: inputData.touchPoint.x + (width - inputData.touchPoint.x) * (1.0 - inputData.innerPointRatio), y: 0)

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

  static func bottomPathModifiers(inputData: PathInputData) -> PathModifiers {

    let width = inputData.frame.width
    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * width
    let curvePointY = height + inputData.touchPoint.y
    let extraSpace = width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: height)
    let fstEndPoint = CGPoint(x: inputData.touchPoint.x, y: curvePointY)
    let fstControlPoint1 = CGPoint(x: inputData.touchPoint.x * inputData.innerPointRatio, y: height)
    let fstControlPoint2 = CGPoint(x: inputData.touchPoint.x - outerDelta, y: curvePointY)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: height)
    let sndControlPoint1 = CGPoint(x: inputData.touchPoint.x + outerDelta, y: curvePointY)
    let sndControlPoint2 = CGPoint(x: inputData.touchPoint.x + (width - inputData.touchPoint.x) * (1.0 - inputData.innerPointRatio), y: height)

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
  
  static func initialLeftPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * height
    let extraSpace = inputData.frame.height / extraSpaceDivider
    
    let centerY = height / 2
    let fstStartPoint: CGPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint: CGPoint = CGPoint(x: 0, y: centerY)
    let fstControlPoint1: CGPoint = CGPoint(x: 0, y: centerY * inputData.innerPointRatio)
    let fstControlPoint2: CGPoint = CGPoint(x: 0, y: centerY - outerDelta)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1: CGPoint = CGPoint(x: 0, y: centerY + outerDelta)
    let sndControlPoint2: CGPoint = CGPoint(x: 0, y: centerY + (height - centerY) * (1.0 - inputData.innerPointRatio))

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
  
  static func initialRightPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let height = inputData.frame.height
    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * height
    let extraSpace = inputData.frame.height / extraSpaceDivider

    let centerY = height / 2
    let fstStartPoint = CGPoint(x: width, y: -extraSpace)
    let fstEndPoint = CGPoint(x: width, y: centerY)
    let fstControlPoint1 = CGPoint(x: width, y: centerY * inputData.innerPointRatio)
    let fstControlPoint2 = CGPoint(x: width, y: centerY - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: width, y: centerY + outerDelta)
    let sndControlPoint2 = CGPoint(x: width, y: centerY + (height - centerY) * (1.0 - inputData.innerPointRatio))

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
  
  static func initialTopPathModifiers(inputData: PathInputData) -> PathModifiers {
    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * width
    let centerY = width / 2
    let extraSpace = inputData.frame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: centerY, y: 0)
    let fstControlPoint1 = CGPoint(x: centerY * inputData.innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: centerY - outerDelta, y: 0)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: centerY + outerDelta, y: 0)
    let sndControlPoint2: CGPoint = CGPoint(x: centerY + (width - centerY) * (1.0 - inputData.innerPointRatio), y: 0)

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
  
  static func initialBottomPathModifiers(inputData: PathInputData) -> PathModifiers {
    let width = inputData.frame.width
    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * width
    let centerY = width / 2
    let extraSpace = inputData.frame.width / extraSpaceDivider
    
    let fstStartPoint = CGPoint(x: -extraSpace, y: height)
    let fstEndPoint = CGPoint(x: centerY, y: height)
    let fstControlPoint1 = CGPoint(x: centerY * inputData.innerPointRatio, y: height)
    let fstControlPoint2 = CGPoint(x: centerY - outerDelta, y: height)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: height)
    let sndControlPoint1 = CGPoint(x: centerY + outerDelta, y: height)
    let sndControlPoint2 = CGPoint(x: centerY + (width - centerY) * (1.0 - inputData.innerPointRatio), y: height)

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
  
  static func expandedLeftPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let extraSpace = inputData.frame.height / extraSpaceDivider
    let height = inputData.frame.height
    let width = inputData.frame.width * 2
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
  
  static func expandedRightPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let extraSpace = inputData.frame.height / extraSpaceDivider
    let height = inputData.frame.height
    let width = inputData.frame.width
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
  
  static func expandedTopPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let extraSpace = inputData.frame.width / extraSpaceDivider
    let height = inputData.frame.height * 2
    let width = inputData.frame.width
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
  
  static func expandedBottomPathModifiers(inputData: PathInputData) -> PathModifiers {
    
    let extraSpace = inputData.frame.width / extraSpaceDivider
    let height = inputData.frame.height
    let heightFinalPoint = height - (height * 2)
    let width = inputData.frame.width
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
