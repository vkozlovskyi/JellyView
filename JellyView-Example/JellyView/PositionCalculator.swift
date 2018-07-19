//
// Created by Vladimir Kozlovskyi on 7/17/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import Foundation
import UIKit

class PositionCalculator {

  func pointFromCubicBezierCurve(delta t: CGFloat,
                                 curveModifiers: CurveModifiers) -> CGPoint {

    let x = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: curveModifiers.startPoint.x,
                                           controlPoint1: curveModifiers.controlPoint1.x,
                                           controlPoint2: curveModifiers.controlPoint2.x,
                                           endPoint: curveModifiers.endPoint.x)

    let y = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: curveModifiers.startPoint.y,
                                           controlPoint1: curveModifiers.controlPoint1.y,
                                           controlPoint2: curveModifiers.controlPoint2.y,
                                           endPoint: curveModifiers.endPoint.y)
    return CGPoint(x: x, y: y)
  }

  private func coordinateFromCubicBezierCurve(delta t: CGFloat,
                                              startPoint p0: CGFloat,
                                              controlPoint1 p1: CGFloat,
                                              controlPoint2 p2: CGFloat,
                                              endPoint p3: CGFloat) -> CGFloat {

    var x = pow(1 - t, 3) * p0
    x += 3 * pow(1 - t, 2) * t * p1
    x += 3 * (1 - t) * pow(t, 2) * p2
    x += pow(t, 3) * p3
    return x
  }
}