
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

public final class JellyView: UIView {

  public var infoView: UIView? {
    willSet {
      if let view = infoView {
        view.removeFromSuperview()
      }
    }
    didSet {
      innerView.addSubview(infoView!)
    }
  }

  public var isEnabled: Bool = true
  public var didStartDragging: () -> Void = { }
  public var actionFired: () -> Void = { }
  public var didEndDragging: () -> Void = { }

  public var triggerThreshold: CGFloat = 0.4
  public var innerPointRatio: CGFloat = 0.4
  public var outerPointRatio: CGFloat = 0.25
  public var flexibility: CGFloat = 0.7
  public var jellyMass: CGFloat = 1.0
  public var springStiffness: CGFloat = 400.0
  public var offset: CGFloat = 0
  
  private let innerView = UIView()
  private var touchPoint = CGPoint.zero
  private var shapeLayer = CAShapeLayer()
  private let bezierPath = UIBezierPath()
  private weak var containerView: UIView?
  private let position: Position
  private var displayLink: CADisplayLink!
  private var colorIndex: NSInteger = 0
  private let colorsArray: Array<UIColor>
  private let gestureRecognizer = UIPanGestureRecognizer()
  private var shouldDisableAnimation = true
  private var positionCalculator = PositionCalculator()

  // constants
  private let bezierCurveDelta: CGFloat = 0.3
  private let innerViewSize: CGFloat = 100
  private let maxDegreesTransform: CGFloat = 40
  
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
  
  private func setupDisplayLink() {
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
  
  private func updateColors() {
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

extension JellyView: UIGestureRecognizerDelegate {

  override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer == self.gestureRecognizer {
      return isEnabled
    } else {
      return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
  }

  func connectGestureRecognizer(toView view: UIView) {
    gestureRecognizer.addTarget(self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  func disconnectGestureRecognizer(fromView view: UIView) {
    gestureRecognizer.removeTarget(self, action: #selector(JellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = nil
    view.removeGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {

    touchPoint = pan.touchPoint(forPosition: position, flexibility: flexibility)

    if (pan.state == .began) {
      self.didStartDragging()
      modifyShapeLayerForTouch()
    } else if (pan.state == .changed) {
      modifyShapeLayerForTouch()
    } else if (pan.state == .ended || pan.state == .cancelled) {
      self.didEndDragging()

      if shouldInitiateAction() {
        animateToFinalPosition()
      } else {
        animateToInitialPosition()
      }
    }
  }
  
  private func shouldInitiateAction() -> Bool {
    var size: CGFloat
    var currentProgress: CGFloat
    switch position {
    case .left:
      size = frame.translatedFrame().size.width
      currentProgress = touchPoint.x
    case .right:
      size = frame.translatedFrame().size.width
      currentProgress = -touchPoint.x
    case .top:
      size = frame.translatedFrame().size.height
      currentProgress = touchPoint.y
    case .bottom:
      size = frame.translatedFrame().size.height
      currentProgress = -touchPoint.y
    }
    
    let maxProgress = size * triggerThreshold
    if currentProgress >= maxProgress {
      return true
    } else {
      return false
    }
  }
  
  private func modifyShapeLayerForTouch() {
    let pathModifiers = PathModifiers.currentPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: frame.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  private func modifyShapeLayerForInitialPosition() {
    let pathModifiers = PathModifiers.initialPathModifiers(forPosition: position,
                                                           touchPoint: touchPoint,
                                                           jellyFrame: frame.translatedFrame(),
                                                           outerPointRatio: outerPointRatio,
                                                           innerPointRatio: innerPointRatio)
    applyPathModifiers(pathModifiers)
  }
  
  private func applyPathModifiers(_ pathModifiers: PathModifiers) {
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
                                                           jellyFrame: frame.translatedFrame(),
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
                                                           jellyFrame: frame.translatedFrame(),
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
  
  private func animationToInitialWillStart() {
    displayLink.isPaused = false
  }
  
  @objc private func animationToInitialDidFinish() {
    if shouldDisableAnimation {
      displayLink.isPaused = true
    }
  }
  
  private func animationToFinalWillStart() {
    gestureRecognizer.isEnabled = false
    displayLink.isPaused = false
  }
  
  @objc private func animationToFinalDidFinish() {
    displayLink.isPaused = true
    gestureRecognizer.isEnabled = true
    updateColors()
    modifyShapeLayerForInitialPosition()
    actionFired()
  }
  
  @objc private func animationInProgress() {
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
    
  private func updateInnerViewPosition(fromPathModifiers pathModifiers: PathModifiers) {
    
    let fstDelta = 1 - bezierCurveDelta
    let sndDelta = bezierCurveDelta
    let point1 = positionCalculator.pointFromCubicBezierCurve(delta: fstDelta,
                                                              curveModifiers: pathModifiers.fstCurveModifiers)
    let point2 = positionCalculator.pointFromCubicBezierCurve(delta: sndDelta,
                                                              curveModifiers: pathModifiers.sndCurveModifiers)
    
    var x, y, width, height: CGFloat
    
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
  
  private func transformInfoView() {
    let tpValue = touchPointValue()
    var degrees: CGFloat = maxDegreesTransform * tpValue
    if position == .right || position == .bottom {
      degrees *= -1
    }
    infoView!.transform = CGAffineTransform(rotationAngle: CGFloat(degrees.degreesToRadians))
  }
  
  private func touchPointValue() -> CGFloat {
    
    var touchCoord = touchPoint.y
    var touchAreaSize = frame.translatedFrame().size.height
    if position == .top || position == .bottom {
      touchCoord = touchPoint.x
      touchAreaSize = frame.translatedFrame().size.width
    }
    
    let difference = touchAreaSize - touchCoord
    let result = 1 - (difference / (touchAreaSize / 2))
    return result
  }
}
