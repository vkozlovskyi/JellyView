//
// Created by Vladimir Kozlovskyi on 7/26/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public struct PathInputData {
  let touchPoint: CGPoint
  let frame: CGRect
  let innerPointRatio: CGFloat
  let outerPointRatio: CGFloat
}

public struct Curve {
  let startPoint: CGPoint
  let endPoint: CGPoint
  let controlPoint1: CGPoint
  let controlPoint2: CGPoint
}

public struct Path {
  let fstCurve: Curve
  let sndCurve: Curve
}
