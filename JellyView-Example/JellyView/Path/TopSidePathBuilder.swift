//
// Created by Vladimir Kozlovskyi on 7/26/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct TopSidePathBuilder: PathBuilder {

  func buildCurrentPath(inputData: PathInputData) -> Path {

    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * width
    let extraSpace = inputData.frame.width / Constants.extraSpaceDivider

    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y)
    let fstControlPoint1 = CGPoint(x: inputData.touchPoint.x * inputData.innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: inputData.touchPoint.x - outerDelta, y: inputData.touchPoint.y)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: inputData.touchPoint.x + outerDelta, y: inputData.touchPoint.y)
    let sndControlPoint2 = CGPoint(x: inputData.touchPoint.x + (width - inputData.touchPoint.x) * (1.0 - inputData.innerPointRatio), y: 0)

    let fstCurve = Curve(startPoint: fstStartPoint,
                         endPoint: fstEndPoint,
                         controlPoint1: fstControlPoint1,
                         controlPoint2: fstControlPoint2)

    let sndCurve = Curve(startPoint: sndStartPoint,
                         endPoint: sndEndPoint,
                         controlPoint1: sndControlPoint1,
                         controlPoint2: sndControlPoint2)

    let path = Path(fstCurve: fstCurve, sndCurve: sndCurve)
    return path
  }


  func buildInitialPath(inputData: PathInputData) -> Path {

    let width = inputData.frame.width
    let outerDelta = inputData.outerPointRatio * width
    let centerY = width / 2
    let extraSpace = inputData.frame.width / Constants.extraSpaceDivider

    let fstStartPoint = CGPoint(x: -extraSpace, y: 0)
    let fstEndPoint = CGPoint(x: centerY, y: 0)
    let fstControlPoint1 = CGPoint(x: centerY * inputData.innerPointRatio, y: 0)
    let fstControlPoint2 = CGPoint(x: centerY - outerDelta, y: 0)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: width + extraSpace, y: 0)
    let sndControlPoint1 = CGPoint(x: centerY + outerDelta, y: 0)
    let sndControlPoint2: CGPoint = CGPoint(x: centerY + (width - centerY) * (1.0 - inputData.innerPointRatio), y: 0)

    let fstCurve = Curve(startPoint: fstStartPoint,
                         endPoint: fstEndPoint,
                         controlPoint1: fstControlPoint1,
                         controlPoint2: fstControlPoint2)

    let sndCurve = Curve(startPoint: sndStartPoint,
                         endPoint: sndEndPoint,
                         controlPoint1: sndControlPoint1,
                         controlPoint2: sndControlPoint2)

    let path = Path(fstCurve: fstCurve, sndCurve: sndCurve)
    return path
  }


  func buildExpandedPath(inputData: PathInputData) -> Path {

    let extraSpace = inputData.frame.width / Constants.extraSpaceDivider
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

    let fstCurve = Curve(startPoint: fstStartPoint,
                         endPoint: fstEndPoint,
                         controlPoint1: fstControlPoint1,
                         controlPoint2: fstControlPoint2)

    let sndCurve = Curve(startPoint: sndStartPoint,
                         endPoint: sndEndPoint,
                         controlPoint1: sndControlPoint1,
                         controlPoint2: sndControlPoint2)

    let path = Path(fstCurve: fstCurve, sndCurve: sndCurve)
    return path
  }
}
