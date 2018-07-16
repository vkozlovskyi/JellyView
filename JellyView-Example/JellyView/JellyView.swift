
//
//  JellyView.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public enum Position {
  case left, right, top, bottom
}

@objc public protocol JellyViewDelegate : class {
  @objc optional func jellyViewShouldStartDragging(_ jellyView : JellyView) -> Bool
  @objc optional func jellyViewDidStartDragging(_ curtainControl : JellyView)
  @objc optional func jellyViewDidEndDragging(_ curtainControl : JellyView)
  @objc optional func jellyViewActionFired(_ curtainControl : JellyView)
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
  public var jellyMass : CGFloat = 1.0
  public var springStiffness : CGFloat = 400.0
  public var offset : CGFloat = 0
  
  fileprivate let innerView = UIView()
  fileprivate var touchPoint = CGPoint.zero
  fileprivate var shapeLayer = CAShapeLayer()
  fileprivate let bezierPath = UIBezierPath()
  fileprivate weak var containerView : UIView?
  fileprivate let position : Position
  fileprivate var displayLink : CADisplayLink!
  fileprivate var colorIndex : NSInteger = 0
  fileprivate let colorsArray : Array<UIColor>
  fileprivate let gestureRecognizer = UIPanGestureRecognizer()
  fileprivate var shouldDisableAnimation = true
  fileprivate var shouldStartDragging : Bool {
    if let shouldStartDragging = delegate?.jellyViewShouldStartDragging?(self) {
      return shouldStartDragging
    } else {
      return true
    }
  }
  
  // constants
  fileprivate let beizerCurveDelta : CGFloat = 0.3
  fileprivate let innerViewSize : CGFloat = 100
  fileprivate let maxDegreesTransform : CGFloat = 40
  
  init(position: Position, colors: Array<UIColor>) {
    self.position = position
    self.colorsArray = colors
    super.init(frame: CGRect.zero)
    shapeLayer.fillColor = colorsArray[colorIndex].cgColor
    setupDisplayLink()
    self.backgroundColor = UIColor.clear
    self.layer.insertSublayer(shapeLayer, at: 0)
    self.addSubview(innerView)
  }
  
  fileprivate func setupDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(JellyView.animationInProgress))
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    displayLink.isPaused = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    return self.superview
  }
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let superview = self.superview else { return }
    connectGestureRecognizer(toView: superview)
    self.frame = superview.bounds
  }
  
  public override func removeFromSuperview() {
    displayLink.invalidate()
    guard let superview = self.superview else { return }
    disconnectGestureRecognizer(fromView: superview)
    super.removeFromSuperview()
  }
}

extension JellyView {
  
  fileprivate func updateColors() {
    guard let superview = self.superview else { return }
    let currentColor = colorsArray[colorIndex]
    superview.backgroundColor = currentColor
    
    colorIndex += 1
    if colorIndex > colorsArray.count - 1 {
      colorIndex = 0
    }
    
    shapeLayer.fillColor = colorsArray[colorIndex].cgColor
  }
  
}

// MARK: - Stretching JellyView

extension JellyView : UIGestureRecognizerDelegate {
  
  func connectGestureRecognizer(toView view : UIView) {
    gestureRecognizer.addTarget(self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  func disconnectGestureRecognizer(fromView view : UIView) {
    gestureRecognizer.removeTarget(self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = nil
    view.removeGestureRecognizer(gestureRecognizer)
  }
  
  @objc fileprivate func handlePanGesture(_ pan : UIPanGestureRecognizer) {
    
    if shouldStartDragging {
      touchPoint = pan.touchPoint(forPosition: position, flexibility: flexibility)
      
      if (pan.state == .began) {
        self.delegate?.jellyViewDidStartDragging?(self)
        modifyShapeLayerForTouch()
      } else if (pan.state == .changed) {
        modifyShapeLayerForTouch()
      } else if (pan.state == .ended || pan.state == .cancelled) {
        
        self.delegate?.jellyViewDidEndDragging?(self)
        
        if shouldInitiateAction() {
          animateToFinalPosition()
        } else {
          animateToInitialPosition()
        }
      }
    }
  }
  
  fileprivate func shouldInitiateAction() -> Bool {
    var size : CGFloat
    var currentProgress: CGFloat
    switch position {
    case .left:
      size = self.translatedFrame().size.width
      currentProgress = touchPoint.x
    case .right:
      size = self.translatedFrame().size.width
      currentProgress = -touchPoint.x
    case .top:
      size = self.translatedFrame().size.height
      currentProgress = touchPoint.y
    case .bottom:
      size = self.translatedFrame().size.height
      currentProgress = -touchPoint.y
    }
    
    let maxProgress = size * triggerThreshold
    if currentProgress >= maxProgress {
      return true
    } else {
      return false
    }
  }
  
  fileprivate func modifyShapeLayerForTouch() {
    let pathModifiers = PathModifiers.currentPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  fileprivate func modifyShapeLayerForInitialPosition() {
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  fileprivate func applyPathModifiers(_ pathModifiers : PathModifiers) {
    bezierPath.jellyPath(pathModifiers)
    updateInnerViewPosition(fromPathModifiers: pathModifiers)
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    shapeLayer.path = bezierPath.cgPath
    CATransaction.commit()
  }
}

// MARK: - Animations

extension JellyView {
  
  func animateToInitialPosition() {
    
    shouldDisableAnimation = displayLink.isPaused
    
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    CATransaction.begin()
    self.animationToInitialWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = jellyMass
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = bezierPath.cgPath
    bezierPath.jellyPath(pathModifiers)
    shapeLayer.path = bezierPath.cgPath
    CATransaction.setCompletionBlock { self.animationToInitialDidFinish() }
    shapeLayer.add(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  func animateToFinalPosition() {
    
    shouldDisableAnimation = displayLink.isPaused
    
    let pathModifiers = PathModifiers.expandedPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: self.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    CATransaction.begin()
    self.animationToFinalWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = jellyMass
    springAnimation.damping = 1000
    springAnimation.stiffness = springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = bezierPath.cgPath
    bezierPath.jellyPath(pathModifiers)
    shapeLayer.path = bezierPath.cgPath
    CATransaction.setCompletionBlock { self.animationToFinalDidFinish() }
    shapeLayer.add(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  fileprivate func animationToInitialWillStart() {
    displayLink.isPaused = false
  }
  
  @objc fileprivate func animationToInitialDidFinish() {
    if shouldDisableAnimation {
      displayLink.isPaused = true
    }
  }
  
  fileprivate func animationToFinalWillStart() {
    gestureRecognizer.isEnabled = false
    displayLink.isPaused = false
  }
  
  @objc fileprivate func animationToFinalDidFinish() {
    displayLink.isPaused = true
    gestureRecognizer.isEnabled = true
    updateColors()
    modifyShapeLayerForInitialPosition()
  }
  
  @objc fileprivate func animationInProgress() {
    guard let presentationLayer = self.shapeLayer.presentation() else { return }
    guard let path = presentationLayer.path else { return }
    let bezierPath = UIBezierPath(cgPath: path)
    if let pathModifiers = bezierPath.currentPathModifiers() {
      updateInnerViewPosition(fromPathModifiers: pathModifiers)
    }
  }
}

// MARK: - Inner View Processing

extension JellyView {
    
  fileprivate func updateInnerViewPosition(fromPathModifiers pathModifiers: PathModifiers) {
    
    let fstDelta = 1 - beizerCurveDelta
    let sndDelta = beizerCurveDelta
    let point1 = pointFromCubicBezierCurve(delta: fstDelta,
                                           startPoint: pathModifiers.fstStartPoint,
                                           controlPoint1: pathModifiers.fstControlPoint1,
                                           controlPoint2: pathModifiers.fstControlPoint2,
                                           endPoint: pathModifiers.fstEndPoint)
    let point2 = pointFromCubicBezierCurve(delta: sndDelta,
                                           startPoint: pathModifiers.sndStartPoint,
                                           controlPoint1: pathModifiers.sndControlPoint1,
                                           controlPoint2: pathModifiers.sndControlPoint2,
                                           endPoint: pathModifiers.sndEndPoint)
    
    var x, y, width, height : CGFloat
    
    switch position {
    case .left:
      width = innerViewSize
      height = point2.y - point1.y
      x = point1.x - width + offset
      y = point1.y
    case .right:
      width = innerViewSize
      height = point2.y - point1.y
      x = point1.x - offset
      y = point1.y
    case .top:
      width = point2.x - point1.x
      height = innerViewSize
      x = point1.x
      y = point1.y - height + offset
    case .bottom:
      width = point2.x - point1.x
      height = innerViewSize
      x = point1.x
      y = point1.y - offset
    }
    
    innerView.frame = CGRect(x: x, y: y, width: width, height: height)
    if let view = infoView {
      view.center = CGPoint(x: innerView.frame.size.width / 2, y: innerView.frame.size.height / 2)
      transformInfoView()
    }
  }
  
  fileprivate func transformInfoView() {
    let tpValue = touchPointValue()
    var degrees : CGFloat = maxDegreesTransform * tpValue
    if position == .right || position == .bottom {
      degrees *= -1
    }
    infoView!.transform = CGAffineTransform(rotationAngle: CGFloat(degrees.degreesToRadians))
  }
  
  fileprivate func touchPointValue() -> CGFloat {
    
    var touchCoord = touchPoint.y
    var touchAreaSize = self.translatedFrame().size.height
    if position == .top || position == .bottom {
      touchCoord = touchPoint.x
      touchAreaSize = self.translatedFrame().size.width
    }
    
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    return result
  }
}

// MARK: - Coordinates Calculation

extension JellyView {
  
  fileprivate func pointFromCubicBezierCurve(delta t : CGFloat,
                                             startPoint p0 : CGPoint,
                                             controlPoint1 p1 : CGPoint,
                                             controlPoint2 p2 : CGPoint,
                                             endPoint p3 : CGPoint) -> CGPoint {
    
    let x = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: p0.x,
                                           controlPoint1: p1.x,
                                           controlPoint2: p2.x,
                                           endPoint: p3.x)
    
    let y = coordinateFromCubicBezierCurve(delta: t,
                                           startPoint: p0.y,
                                           controlPoint1: p1.y,
                                           controlPoint2: p2.y,
                                           endPoint: p3.y)
    return CGPoint(x: x, y: y)
  }
  
  fileprivate func coordinateFromCubicBezierCurve(delta t : CGFloat,
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
  var degreesToRadians: Double { return Double(self) * .pi / 180 }
  var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

