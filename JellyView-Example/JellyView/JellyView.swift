//
//  JellyView.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public enum Position {
  case Left, Right, Top, Bottom
}

public protocol JellyViewDelegate : class {
  func jellyViewShouldStartDragging(jellyView : JellyView) -> Bool
  func jellyViewDidStartDragging(curtainControl : JellyView)
  func jellyViewDidEndDragging(curtainControl : JellyView)
  func jellyViewActionFired(curtainControl : JellyView)
}

public struct PathModifiers {
  var fstStartPoint : CGPoint
  var fstEndPoint : CGPoint
  var fstControlPoint1 : CGPoint
  var fstControlPoint2 : CGPoint
  var sndStartPoint : CGPoint
  var sndEndPoint : CGPoint
  var sndControlPoint1 : CGPoint
  var sndControlPoint2 : CGPoint
}

public final class JellyView : UIView {
  
  public weak var delegate : JellyViewDelegate?
  public var infoView : UIView?
  public var innerPointRatio : CGFloat = 0.4
  public var outerPointRatio : CGFloat = 0.2
  public var stiffness : CGFloat = 1.0
  public var jellyColor : UIColor = UIColor.whiteColor() {
    didSet {
      shapeLayer.fillColor = jellyColor.CGColor
    }
  }
  
  override public var frame: CGRect {
    didSet {
      self.frameDidChanged()
    }
  }
  
  private var touchPoint = CGPointZero
  private weak var containerView : UIView?
  private var shapeLayer = CAShapeLayer()
  private let beizerPath = UIBezierPath()
  private let position : Position
  private var shouldStartDragging : Bool {
    if let shouldStartDragging = delegate?.jellyViewShouldStartDragging(self) {
      return shouldStartDragging
    } else {
      return true
    }
  }
  
  init(position: Position) {
    self.position = position
    super.init(frame: CGRectZero)
    self.backgroundColor = UIColor.clearColor()
    self.layer.insertSublayer(shapeLayer, atIndex: 0)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension JellyView : UIGestureRecognizerDelegate {
  
  func connectGestureRecognizer(toView view : UIView) {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handlePanGesture(let pan : UIPanGestureRecognizer) {
    
    if shouldStartDragging {
      touchPoint = pan.touchPoint(forPosition: position)
      if (pan.state == .Began || pan.state == .Changed) {
        updateFrame()
      } else if (pan.state == .Ended || pan.state == .Cancelled) {
        animateToInitialPosition()
      }
    }
    
  }
  
  private func stretchJellyView() {
    guard let pathModifiers = currentPathModifiers() else { return }
    beizerPath.jellyPath(pathModifiers)
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.commit()
  }

}

// MARK: - Frame Update


extension JellyView {
  
  private func updateFrame() {
    switch position {
    case .Left:
      return updateFrameForLeftPostion()
    case .Right:
      return updateFrameForRightPostion()
    case .Top:
      return updateFrameForTopPostion()
    case .Bottom:
      return updateFrameForBottomPostion()
    }
    
  }
  
  private func animateToInitialPosition() {
//    [[UIView .animateWithDuration(<#T##duration: NSTimeInterval##NSTimeInterval#>, delay: <#T##NSTimeInterval#>, usingSpringWithDamping: <#T##CGFloat#>, initialSpringVelocity: <#T##CGFloat#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)]]
  }
  
  private func frameDidChanged() {
    stretchJellyView()
  }
  
  private func updateFrameForLeftPostion() {
    guard let superview = self.superview else { return }
    let stretchedSize = stiffness * touchPoint.x
    self.frame = CGRect(x: 0.0,
                        y: 0.0,
                    width: stretchedSize,
                   height: superview.frame.size.height)
    print(NSStringFromCGRect(self.frame))
  }
  
  private func updateFrameForRightPostion() {
    // TODO:
  }
  
  private func updateFrameForTopPostion() {
    // TODO:
  }
  
  private func updateFrameForBottomPostion() {
    // TODO:
  }
  
}


// MARK: - Calculate Path Modifiers


extension JellyView {
  
  private func currentPathModifiers() -> PathModifiers? {
    switch position {
    case .Left:
      return leftPathModifiers()
    case .Right:
      return rightPathModifiers()
    case .Top:
      return topPathModifiers()
    case .Bottom:
      return bottomPathModifiers()
    }
    
  }
  
  private func leftPathModifiers() -> PathModifiers? {
    
    guard let superview = self.superview else { return nil }
    let height = CGRectGetHeight(superview.frame)
    let outerDelta = outerPointRatio * height
    
    let fstStartPoint : CGPoint = CGPointZero
    let fstEndPoint : CGPoint = CGPointMake(self.frame.size.width, touchPoint.y)
    let fstControlPoint1 : CGPoint = CGPointMake(0, touchPoint.y * innerPointRatio)
    let fstControlPoint2 : CGPoint = CGPointMake(self.frame.size.width, touchPoint.y - outerDelta)
    let sndStartPoint : CGPoint = fstEndPoint
    let sndEndPoint : CGPoint = CGPointMake(0, height)
    let sndControlPoint1 : CGPoint = CGPointMake(self.frame.size.width, touchPoint.y + outerDelta)
    let sndControlPoint2 : CGPoint = CGPointMake(0, touchPoint.y + (height - touchPoint.y) * (1.0 - innerPointRatio))
    
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
  
  private func rightPathModifiers() -> PathModifiers { // TODO:
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  private func topPathModifiers() -> PathModifiers { // TODO:
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
  
  private func bottomPathModifiers() -> PathModifiers { // TODO:
    return PathModifiers(fstStartPoint: CGPointZero, fstEndPoint: CGPointZero, fstControlPoint1: CGPointZero, fstControlPoint2: CGPointZero, sndStartPoint: CGPointZero, sndEndPoint: CGPointZero, sndControlPoint1: CGPointZero, sndControlPoint2: CGPointZero)
  }
}

