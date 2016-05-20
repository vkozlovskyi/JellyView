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

@objc public protocol JellyViewDelegate : class {
  optional func jellyViewShouldStartDragging(jellyView : JellyView) -> Bool
  optional func jellyViewDidStartDragging(curtainControl : JellyView)
  optional func jellyViewDidEndDragging(curtainControl : JellyView)
  optional func jellyViewActionFired(curtainControl : JellyView)
}

public final class JellyView : UIView {
  
  public weak var delegate : JellyViewDelegate?
  public var infoView : UIView? {
    
    willSet {
      if let view = infoView {
        view.removeFromSuperview()
      }
    }
    didSet {
      innerView.addSubview(infoView!)
    }
  }
  public var triggerThreshold : CGFloat = 0.4
  public var innerPointRatio : CGFloat = 0.4
  public var outerPointRatio : CGFloat = 0.25
  public var flexibility : CGFloat = 0.7
  public var viewMass : CGFloat = 1.0
  public var springStiffness : CGFloat = 400.0
  public var offset : CGFloat = 0
  
  private let innerView = UIView()
  private var touchPoint = CGPointZero
  private var shapeLayer = CAShapeLayer()
  private let beizerPath = UIBezierPath()
  private weak var containerView : UIView?
  private let position : Position
  private var displayLink : CADisplayLink!
  private var colorIndex : NSInteger = 0
  private let colorsArray : Array<UIColor>
  private let gestureRecognizer = UIPanGestureRecognizer()
  private var shouldDisableAnimation = true
  private var shouldStartDragging : Bool {
    if let shouldStartDragging = delegate?.jellyViewShouldStartDragging?(self) {
      return shouldStartDragging
    } else {
      return true
    }
  }
  
  // constants
  private let beizerCurveDelta : CGFloat = 0.3
  private let innerViewSize : CGFloat = 100
  private let maxDegreesTransform : CGFloat = 40
  init(position: Position, forView view: UIView, colors: Array<UIColor>) {
    self.position = position
    self.colorsArray = colors
    super.init(frame: view.bounds)
    connectGestureRecognizer(toView: view)
    shapeLayer.fillColor = colorsArray[colorIndex].CGColor
    setupDisplayLink()
    self.backgroundColor = UIColor.clearColor()
    self.layer.insertSublayer(shapeLayer, atIndex: 0)
    
//    innerView.backgroundColor = UIColor.redColor()
    self.addSubview(innerView)
  }
  
  private func setupDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(JellyView.animationInProgress))
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    displayLink.paused = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    return self.superview
  }
  
}

extension JellyView {
  
  private func updateColors() {
    guard let superview = self.superview else { return }
    let currentColor = colorsArray[colorIndex]
    superview.backgroundColor = currentColor
    
    colorIndex += 1
    if colorIndex > colorsArray.count - 1 {
      colorIndex = 0
    }
    
    shapeLayer.fillColor = colorsArray[colorIndex].CGColor
  }
  
}

// MARK: - Stretching JellyView

extension JellyView : UIGestureRecognizerDelegate {
  
  func connectGestureRecognizer(toView view : UIView) {
    gestureRecognizer.addTarget(self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handlePanGesture(let pan : UIPanGestureRecognizer) {
    
    if shouldStartDragging {
      touchPoint = pan.touchPoint(forPosition: position, flexibility: flexibility)
      
      if (pan.state == .Began) {
        self.delegate?.jellyViewDidStartDragging?(self)
        modifyShapeLayerForTouch()
      } else if (pan.state == .Changed) {
        modifyShapeLayerForTouch()
      } else if (pan.state == .Ended || pan.state == .Cancelled) {
        
        self.delegate?.jellyViewDidEndDragging?(self)
        
        if shouldInitiateAction() {
          animateToFinalPosition()
        } else {
          animateToInitialPosition()
        }
      }
    }
  }
  
  private func shouldInitiateAction() -> Bool {
    var size : CGFloat
    var currentProggress : CGFloat
    if position == .Left || position == .Right {
      size = self.frame.size.width
      currentProggress = fabs(touchPoint.x)
    } else {
      size = self.frame.size.height
      currentProggress = fabs(touchPoint.y)
    }
    
    let maxProggress = size * triggerThreshold
    if currentProggress >= maxProggress {
      return true
    } else {
      return false
    }
  }
  
  private func modifyShapeLayerForTouch() {
    let pathModifiers = PathModifiers.currentPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.frame,
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  private func modifyShapeLayerForInitialPosition() {
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.frame,
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  private func applyPathModifiers(pathModifiers : PathModifiers) {
    beizerPath.jellyPath(pathModifiers)
    updateInnerViewPosition(fromPathModifiers: pathModifiers)
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.commit()
  }
}

// MARK: - Animations

extension JellyView {
  
  func animateToInitialPosition() {
    
    shouldDisableAnimation = displayLink.paused
    
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.frame,
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    CATransaction.begin()
    self.animationToInitialWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = viewMass
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = beizerPath.CGPath
    beizerPath.jellyPath(pathModifiers)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.setCompletionBlock { self.animationToInitialDidFinish() }
    shapeLayer.addAnimation(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  func animateToFinalPosition() {
    
    shouldDisableAnimation = displayLink.paused
    
    let pathModifiers = PathModifiers.expandedPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.frame,
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    CATransaction.begin()
    self.animationToFinalWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = viewMass
    springAnimation.damping = 1000
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    print(springAnimation.duration)
    springAnimation.fromValue = beizerPath.CGPath
    beizerPath.jellyPath(pathModifiers)
    shapeLayer.path = beizerPath.CGPath
    CATransaction.setCompletionBlock { self.animationToFinalDidFinish() }
    shapeLayer.addAnimation(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  private func animationToInitialWillStart() {
    displayLink.paused = false
  }
  
  @objc private func animationToInitialDidFinish() {
    if shouldDisableAnimation {
      displayLink.paused = true
    }
  }
  
  private func animationToFinalWillStart() {
    gestureRecognizer.enabled = false
    displayLink.paused = false
  }
  
  @objc private func animationToFinalDidFinish() {
    displayLink.paused = true
    gestureRecognizer.enabled = true
    updateColors()
    modifyShapeLayerForInitialPosition()
  }
  
  @objc private func animationInProgress() {
    guard let presentationLayer = self.shapeLayer.presentationLayer() as? CAShapeLayer else { return }
    guard let path = presentationLayer.path else { return }
    let beizerPath = UIBezierPath(CGPath: path)
    if let pathModifiers = beizerPath.currentPathModifiers() {
      updateInnerViewPosition(fromPathModifiers: pathModifiers)
    }
  }
}

// MARK: - Inner View Processing

extension JellyView {
    
  private func updateInnerViewPosition(fromPathModifiers pathModifiers: PathModifiers) {
    
    let fstDelta = 1 - beizerCurveDelta
    let sndDelta = beizerCurveDelta
    let point1 = pointFromCubicBeizerCurve(delta: fstDelta,
                                      startPoint: pathModifiers.fstStartPoint,
                                   controlPoint1: pathModifiers.fstControlPoint1,
                                   controlPoint2: pathModifiers.fstControlPoint2,
                                        endPoint: pathModifiers.fstEndPoint)
    let point2 = pointFromCubicBeizerCurve(delta: sndDelta,
                                           startPoint: pathModifiers.sndStartPoint,
                                           controlPoint1: pathModifiers.sndControlPoint1,
                                           controlPoint2: pathModifiers.sndControlPoint2,
                                           endPoint: pathModifiers.sndEndPoint)
    
    var x, y, width, height : CGFloat
    
    switch position {
    case .Left:
      width = innerViewSize
      height = point2.y - point1.y
      x = point1.x - width
      y = point1.y
    case .Right:
      width = innerViewSize
      height = point2.y - point1.y
      x = point1.x
      y = point1.y
    case .Top:
      width = point2.x - point1.x
      height = innerViewSize
      x = point1.x
      y = point1.y - height
    case .Bottom:
      width = point2.x - point1.x
      height = innerViewSize
      x = point1.x
      y = point1.y
    }
    
    innerView.frame = CGRectMake(x + offset, y, width, height)
    if let view = infoView {
      view.center = CGPointMake(innerView.frame.size.width / 2, innerView.frame.size.height / 2)
      transformInfoView()
    }
  }
  
  private func transformInfoView() {
    let tpValue = touchPointValue()
    var degrees : CGFloat = maxDegreesTransform * tpValue
    if position == .Right || position == .Bottom {
      degrees *= -1
    }
    infoView!.transform = CGAffineTransformMakeRotation(CGFloat(degrees.degreesToRadians))
  }
  
  private func touchPointValue() -> CGFloat {
    
    var touchCoord = touchPoint.y
    var touchAreaSize = self.frame.size.height
    if position == .Top || position == .Bottom {
      touchCoord = touchPoint.x
      touchAreaSize = self.frame.size.width
    }
    
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    return result
  }
}

// MARK: - Coordinates Calculation

extension JellyView {
  
  private func pointFromCubicBeizerCurve(delta t : CGFloat,
                                   startPoint p0 : CGPoint,
                                controlPoint1 p1 : CGPoint,
                                controlPoint2 p2 : CGPoint,
                                     endPoint p3 : CGPoint) -> CGPoint {
    
    let x = coordinateFromCubicBeizerCurve(delta: t,
                                      startPoint: p0.x,
                                   controlPoint1: p1.x,
                                   controlPoint2: p2.x,
                                        endPoint: p3.x)
    
    let y = coordinateFromCubicBeizerCurve(delta: t,
                                      startPoint: p0.y,
                                   controlPoint1: p1.y,
                                   controlPoint2: p2.y,
                                        endPoint: p3.y)
    return CGPointMake(x, y)
  }
  
  private func coordinateFromCubicBeizerCurve(delta t : CGFloat,
                                        startPoint p0 : CGFloat,
                                     controlPoint1 p1 : CGFloat,
                                     controlPoint2 p2 : CGFloat,
                                          endPoint p3 : CGFloat) -> CGFloat {
    
    // I had to split expression to several parts to stop the compiler's whining
    var x = pow(1 - t, 3) * p0
    x += 3 * pow(1 - t, 2) * t * p1
    x += 3 * (1 - t) * pow(t, 2) * p2
    x += pow(t, 3) * p3
    return x
  }
}

extension CGFloat {
  var degreesToRadians: Double { return Double(self) * M_PI / 180 }
  var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

