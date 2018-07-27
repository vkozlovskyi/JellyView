//
// Created by Vladimir Kozlovskyi on 7/26/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct LeftSidePathBuilder: PathBuilder {

  func buildCurrentPath(inputData: PathInputData) -> Path {

    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * height
    let extraSpace = inputData.frame.height / Constants.extraSpaceDivider

    let fstStartPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y)
    let fstControlPoint1 = CGPoint(x: 0, y: inputData.touchPoint.y * inputData.innerPointRatio)
    let fstControlPoint2 = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y - outerDelta)
    let sndStartPoint = fstEndPoint
    let sndEndPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1 = CGPoint(x: inputData.touchPoint.x, y: inputData.touchPoint.y + outerDelta)
    let sndControlPoint2 = CGPoint(x: 0, y: inputData.touchPoint.y + (height - inputData.touchPoint.y) * (1.0 - inputData.innerPointRatio))

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

    let height = inputData.frame.height
    let outerDelta = inputData.outerPointRatio * height
    let extraSpace = inputData.frame.height / Constants.extraSpaceDivider

    let centerY = height / 2
    let fstStartPoint: CGPoint = CGPoint(x: 0, y: -extraSpace)
    let fstEndPoint: CGPoint = CGPoint(x: 0, y: centerY)
    let fstControlPoint1: CGPoint = CGPoint(x: 0, y: centerY * inputData.innerPointRatio)
    let fstControlPoint2: CGPoint = CGPoint(x: 0, y: centerY - outerDelta)
    let sndStartPoint: CGPoint = fstEndPoint
    let sndEndPoint: CGPoint = CGPoint(x: 0, y: height + extraSpace)
    let sndControlPoint1: CGPoint = CGPoint(x: 0, y: centerY + outerDelta)
    let sndControlPoint2: CGPoint = CGPoint(x: 0, y: centerY + (height - centerY) * (1.0 - inputData.innerPointRatio))

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

    let extraSpace = inputData.frame.height / Constants.extraSpaceDivider
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
