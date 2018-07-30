//
// Created by Vladimir Kozlovskyi on 7/17/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import Foundation
import UIKit

class CurvePointCalculator {

  func pointFromCubicBezierCurve(delta t: CGFloat,
                                 curve: Curve) -> CGPoint {

    let x = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: curve.startPoint.x,
                                           controlPoint1: curve.controlPoint1.x,
                                           controlPoint2: curve.controlPoint2.x,
                                           endPoint: curve.endPoint.x)

    let y = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: curve.startPoint.y,
                                           controlPoint1: curve.controlPoint1.y,
                                           controlPoint2: curve.controlPoint2.y,
                                           endPoint: curve.endPoint.y)
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