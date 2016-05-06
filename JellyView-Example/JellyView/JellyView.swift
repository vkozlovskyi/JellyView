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

public final class JellyView : UIView {
  
  public weak var delegate : JellyViewDelegate?
  public var infoView : UIView?
  public var jellyColor : UIColor = UIColor.whiteColor() {
    didSet {
      shapeLayer.fillColor = jellyColor.CGColor
    }
  }
  
  public var innerPointRatio : CGFloat = 0.4
  public var outerPointRatio : CGFloat = 0.25
  public var flexibility : CGFloat = 1.0
  public var viewMass : CGFloat = 1.0
  public var springStiffness : CGFloat = 200.0
  
  private var touchPoint = CGPointZero
  private var shapeLayer = CAShapeLayer()
  private let beizerPath = UIBezierPath()
  private weak var containerView : UIView?

  private let position : Position
  private var displayLink : CADisplayLink?
  
  private var shouldStartDragging : Bool {
    if let shouldStartDragging = delegate?.jellyViewShouldStartDragging(self) {
      return shouldStartDragging
    } else {
      return true
    }
  }
  
  init(position: Position, frame: CGRect) {
    self.position = position
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
    self.layer.insertSublayer(shapeLayer, atIndex: 0)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    return self.superview
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
        stretchJellyView()
      } else if (pan.state == .Ended || pan.state == .Cancelled) {
        animateToInitialPosition()
      }
    }
    
  }
  
  private func stretchJellyView() {
    let pathModifiers = PathModifiers.currentPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.frame,
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    beizerPath.jellyPath(pathModifiers)
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.commit()
  }
  
}

// MARK: - Spring Animation

extension JellyView {
  
  func animateToInitialPosition() {
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                            touchPoint: touchPoint,
                                                            jellyFrame: self.frame,
                                                       outerPointRatio: outerPointRatio,
                                                       innerPointRatio: innerPointRatio)
    CATransaction.begin()
    self.springAnimationWillStart()
    CATransaction.setCompletionBlock { self.springAnimationDidFinish() }
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = viewMass
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = beizerPath.CGPath
    beizerPath.jellyPath(pathModifiers)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.setCompletionBlock { self.springAnimationDidFinish() }
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

