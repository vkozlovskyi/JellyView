//
// Created by Vladimir Kozlovskyi on 7/28/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

class InnerViewFrameCalculator {

  private let side: JellyView.Side
  private let curvePointCalculator: CurvePointCalculator

  init(side: JellyView.Side, curvePointCalculator: CurvePointCalculator = CurvePointCalculator()) {
    self.side = side
    self.curvePointCalculator = curvePointCalculator
  }

  func calculateFrame(with path: Path, offset: CGFloat) -> CGRect {

    let fstDelta = 1 - Constants.bezierCurveDelta
    let sndDelta = Constants.bezierCurveDelta
    let point1 = curvePointCalculator.pointFromCubicBezierCurve(delta: fstDelta,
                                                              curve: path.fstCurve)
    let point2 = curvePointCalculator.pointFromCubicBezierCurve(delta: sndDelta,
                                                              curve: path.sndCurve)

    var x, y, width, height: CGFloat

    switch side {
    case .left:
      width = Constants.innerViewSize
      height = point2.y - point1.y
      x = point1.x - width + offset
      y = point1.y
    case .right:
      width = Constants.innerViewSize
      height = point2.y - point1.y
      x = point1.x - offset
      y = point1.y
    case .top:
      width = point2.x - point1.x
      height = Constants.innerViewSize
      x = point1.x
      y = point1.y - height + offset
    case .bottom:
      width = point2.x - point1.x
      height = Constants.innerViewSize
      x = point1.x
      y = point1.y - offset
    }

    return CGRect(x: x, y: y, width: width, height: height)
  }
}
