//
// Created by Vladimir Kozlovskyi on 7/30/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

typealias JellyPanGestureRecognizer = UIPanGestureRecognizer & JellyGestureDataProvider

protocol JellyGestureDataProvider {
  var totalProgressSize: CGFloat { get }
  func innerViewRotationAngle(flexibility flx: CGFloat) -> CGFloat
  func currentProgress(flexibility flx: CGFloat) -> CGFloat
  func touchPoint(flexibility flx: CGFloat) -> CGPoint
}

func createJellyPanGestureRecognizer(with side: JellyView.Side) -> JellyPanGestureRecognizer {
  switch side {
    case .left: return LeftSideGestureRecognizer()
    case .right: return RightSideGestureRecognizer()
    case .top: return TopSideGestureRecognizer()
    case .bottom: return BottomSideGestureRecognizer()
  }
}

private class LeftSideGestureRecognizer: JellyPanGestureRecognizer {

  func innerViewRotationAngle(flexibility flx: CGFloat) -> CGFloat {
    let touchCoord = touchPoint(flexibility: flx).y
    let touchAreaSize = view!.frame.translatedFrame().size.height
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    let degrees: CGFloat = Constants.maxDegreesTransform * result
    return degrees.degreesToRadians
  }

  func currentProgress(flexibility flx: CGFloat) -> CGFloat {
    return touchPoint(flexibility: flx).x
  }

  var totalProgressSize: CGFloat {
    return view?.frame.translatedFrame().size.width ?? 0
  }

  func touchPoint(flexibility flx: CGFloat) -> CGPoint {
    return CGPoint(x: translation(in: view).x * flx, y: location(in: view).y)
  }
}

private class RightSideGestureRecognizer: JellyPanGestureRecognizer {

  func innerViewRotationAngle(flexibility flx: CGFloat) -> CGFloat {
    let touchCoord = touchPoint(flexibility: flx).y
    let touchAreaSize = view!.frame.translatedFrame().size.height
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    let degrees: CGFloat = -(Constants.maxDegreesTransform * result)
    return degrees.degreesToRadians
  }

  func currentProgress(flexibility flx: CGFloat) -> CGFloat {
    return -touchPoint(flexibility: flx).x
  }

  var totalProgressSize: CGFloat {
    return view?.frame.translatedFrame().size.width ?? 0
  }

  func touchPoint(flexibility flx: CGFloat) -> CGPoint {
    return CGPoint(x: translation(in: view).x * flx, y: location(in: view).y)
  }
}

private class TopSideGestureRecognizer: JellyPanGestureRecognizer {

  func innerViewRotationAngle(flexibility flx: CGFloat) -> CGFloat {
    let touchCoord = touchPoint(flexibility: flx).x
    let touchAreaSize = view!.frame.translatedFrame().size.width
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    let degrees: CGFloat = Constants.maxDegreesTransform * result
    return degrees.degreesToRadians
  }

  func currentProgress(flexibility flx: CGFloat) -> CGFloat {
    return touchPoint(flexibility: flx).y
  }

  var totalProgressSize: CGFloat {
    return view?.frame.translatedFrame().size.height ?? 0
  }

  func touchPoint(flexibility flx: CGFloat) -> CGPoint {
    return CGPoint(x: self.location(in: self.view).x, y: self.translation(in: self.view).y * flx)
  }
}

private class BottomSideGestureRecognizer: JellyPanGestureRecognizer {

  func innerViewRotationAngle(flexibility flx: CGFloat) -> CGFloat {
    let touchCoord = touchPoint(flexibility: flx).x
    let touchAreaSize = view!.frame.translatedFrame().size.width
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    let degrees: CGFloat = -(Constants.maxDegreesTransform * result)
    return degrees.degreesToRadians
  }

  func currentProgress(flexibility flx: CGFloat) -> CGFloat {
    return -touchPoint(flexibility: flx).y
  }

  var totalProgressSize: CGFloat {
    return view?.frame.translatedFrame().size.height ?? 0
  }

  func touchPoint(flexibility flx: CGFloat) -> CGPoint {
    return CGPoint(x: self.location(in: self.view).x, y: self.translation(in: self.view).y * flx)
  }
}
