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
  var innerPointRatio : CGFloat
  var outerPointRatio : CGFloat
  var superviewWidth : CGFloat
  var superviewHeight : CGFloat
}

public final class JellyView : UIView {
  
  public weak var delegate : JellyViewDelegate?
  public var infoView : UIView?
  public var innerPointRatio : CGFloat = 0.4
  public var outerPointRatio : CGFloat = 0.2
  public var viewMass : CGFloat = 1.0
  public var springStiffness : CGFloat = 200.0
  public var offset : CGFloat = 0.0
  public var jellyColor : UIColor = UIColor.whiteColor() {
    didSet {
      shapeLayer.fillColor = jellyColor.CGColor
    }
  }
  
  private let pathModifiers : PathModifiers
  private weak var containerView : UIView?
  private var shapeLayer = CAShapeLayer()
  private let beizerPath = UIBezierPath()
  private let position : Position
  private var displayLink : CADisplayLink?
  private var shouldStartDragging : Bool {
    if let shouldStartDragging = delegate?.jellyViewShouldStartDragging(self) {
      return shouldStartDragging
    } else {
      return true
    }
  }
  
  init(position: Position) {
    self.position = position
    self.pathModifiers = PathModifiers(innerPointRatio: 0, outerPointRatio: 0, superviewWidth: 0, superviewHeight: 0)
    super.init(frame: CGRectZero)
    self.layer.insertSublayer(layer, atIndex: 0)
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
      
      let touchPoint = pan.touchPoint(forPosition: position)
      
      if (pan.state == .Began || pan.state == .Changed) {
        stretchJellyView(toPoint: touchPoint)
      } else if (pan.state == .Ended || pan.state == .Cancelled) {
        animateJellyViewToInitialPosition(touchPoint: touchPoint)
      }
    }
  }
  
  private func stretchJellyView(let toPoint touchPoint :CGPoint) {
    guard let pathModifiers = currentPathModifiers() else { return }
    beizerPath.jellyPath(forPosition: position, touchPoint: touchPoint, pathModifiers: pathModifiers)
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.commit()
  }
  
  private func currentPathModifiers() -> PathModifiers? {
    guard let width = self.superview?.frame.size.width else { return nil }
    guard let height = self.superview?.frame.size.height else { return nil }
    return PathModifiers(innerPointRatio: innerPointRatio, outerPointRatio: outerPointRatio, superviewWidth: width, superviewHeight: height)
  }
  
}

// MARK: - Spring Animation

extension JellyView {
  
  func animateJellyViewToInitialPosition(let touchPoint touchPoint :CGPoint) {
    guard let pathModifiers = currentPathModifiers() else { return }
    CATransaction.begin()
    self.springAnimationWillStart()
    CATransaction.setCompletionBlock { self.springAnimationDidFinish() }
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = viewMass
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = beizerPath.CGPath
    beizerPath.originalPath(forPosition: position, touchPoint: touchPoint, pathModifiers: pathModifiers)
    springAnimation.toValue = beizerPath.CGPath
    CATransaction.setCompletionBlock { self.springAnimationDidFinish() }
    shapeLayer.path = beizerPath.CGPath
    shapeLayer.addAnimation(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  private func springAnimationWillStart() {
    if displayLink == nil {
      print("started")
      displayLink = CADisplayLink(target: self, selector: #selector(JellyView.springAnimationInProgress))
      displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
  }
  
  @objc private func springAnimationDidFinish() {
    if displayLink != nil {
      print("finished")
      displayLink?.invalidate()
      displayLink = nil
    }
  }
  
  @objc private func springAnimationInProgress() {
    
  }
  
}





