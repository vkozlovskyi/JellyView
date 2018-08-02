
//
//  JellyView.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

public final class JellyView: UIView {

  public enum Side {
    case left, right, top, bottom
  }

  public class Settings {
    public var triggerThreshold: CGFloat = 0.4
    public var innerPointRatio: CGFloat = 0.4
    public var outerPointRatio: CGFloat = 0.25
    public var flexibility: CGFloat = 0.7
    public var jellyMass: CGFloat = 1.0
    public var springStiffness: CGFloat = 400.0
    public var innerViewOffset: CGFloat = 0
  }

  // Interface

  public var isEnabled: Bool = true
  public var didStartDragging: () -> Void = { }
  public var actionDidFire: () -> Void = { }
  public var didEndDragging: () -> Void = { }
  public var setupSettings: (Settings) -> Void = { _ in }
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

  // Private

  private let settings: Settings
  private let pathBuilder: PathBuilder
  private let innerViewFrameCalculator: InnerViewFrameCalculator
  private let gestureRecognizer: JellyPanGestureRecognizer
  private let innerView = UIView()
  private var shapeLayer = CAShapeLayer()
  private let bezierPath = UIBezierPath()
  private weak var containerView: UIView?
  private var displayLink: CADisplayLink!
  private var colorIndex: Int = 0
  private let colors: Array<UIColor>
  private var shouldDisableAnimation = true
  private var isRendered = false
  private var pathInputData: PathInputData {
    return PathInputData(touchPoint: gestureRecognizer.touchPoint(flexibility: settings.flexibility),
                         frame: frame.translatedFrame(),
                         innerPointRatio: settings.innerPointRatio,
                         outerPointRatio: settings.outerPointRatio)
  }

  init(side: Side,
       colors: Array<UIColor>,
       settings: Settings = Settings()) {
    self.colors = colors
    self.settings = settings
    self.pathBuilder = createPathBuilder(side: side)
    self.innerViewFrameCalculator = InnerViewFrameCalculator(side: side)
    self.gestureRecognizer = createJellyPanGestureRecognizer(with: side)
    super.init(frame: CGRect.zero)
    shapeLayer.fillColor = colors[colorIndex].cgColor
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

  public override func layoutSubviews() {
    super.layoutSubviews()
    if !isRendered {
      isRendered = true
      setInnerViewInitialPosition()
    }
  }

  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let superview = self.superview else { return }
    connectGestureRecognizer(toView: superview)
    self.frame = superview.bounds
    setInnerViewInitialPosition()
  }
  
  public override func removeFromSuperview() {
    displayLink.invalidate()
    guard let superview = self.superview else { return }
    disconnectGestureRecognizer(fromView: superview)
    super.removeFromSuperview()
  }
}

extension JellyView {

  private func setInnerViewInitialPosition() {
    setupSettings(settings)
    let path = pathBuilder.buildInitialPath(inputData: pathInputData)
    updateInnerViewPosition(with: path)
  }

  private func updateColors() {
    guard let superview = self.superview else { return }
    let currentColor = colors[colorIndex]
    superview.backgroundColor = currentColor
    
    colorIndex += 1
    if colorIndex > colors.count - 1 {
      colorIndex = 0
    }
    
    shapeLayer.fillColor = colors[colorIndex].cgColor
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
    switch pan.state {
    case .began:
      setupSettings(settings)
      didStartDragging()
      modifyShapeLayerForTouch()
    case .changed:
      modifyShapeLayerForTouch()
    case .ended, .cancelled:
      didEndDragging()
      if shouldInitiateAction() {
        animateToFinalPosition()
      } else {
        animateToInitialPosition()
      }
    default: break
    }
  }

  private func shouldInitiateAction() -> Bool {
    let maxProgress = gestureRecognizer.totalProgressSize * settings.triggerThreshold
    if gestureRecognizer.currentProgress(flexibility: settings.flexibility) >= maxProgress {
      return true
    } else {
      return false
    }
  }
  
  private func modifyShapeLayerForTouch() {
    let path = pathBuilder.buildCurrentPath(inputData: pathInputData)
    applyPath(path)
  }
  
  private func modifyShapeLayerForInitialPosition() {
    let path = pathBuilder.buildInitialPath(inputData: pathInputData)
    applyPath(path)
  }

  private func applyPath(_ path: Path) {
    bezierPath.setPath(path)
    updateInnerViewPosition(with: path)
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
    
    let path = pathBuilder.buildInitialPath(inputData: pathInputData)
    CATransaction.begin()
    self.animationToInitialWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = settings.jellyMass
    springAnimation.stiffness = settings.springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = bezierPath.cgPath
    bezierPath.setPath(path)
    shapeLayer.path = bezierPath.cgPath
    CATransaction.setCompletionBlock { self.animationToInitialDidFinish() }
    shapeLayer.add(springAnimation, forKey: "path")
    CATransaction.commit()
  }
  
  func animateToFinalPosition() {
    
    shouldDisableAnimation = displayLink.isPaused
    
    let path = pathBuilder.buildExpandedPath(inputData: pathInputData)
    CATransaction.begin()
    self.animationToFinalWillStart()
    let springAnimation = CASpringAnimation(keyPath: "path")
    springAnimation.mass = settings.jellyMass
    springAnimation.damping = 1000
    springAnimation.stiffness = settings.springStiffness
    springAnimation.duration = springAnimation.settlingDuration
    springAnimation.fromValue = bezierPath.cgPath
    bezierPath.setPath(path)
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
    actionDidFire()
  }
  
  @objc private func animationInProgress() {
    guard let presentationLayer = self.shapeLayer.presentation() else { return }
    guard let path = presentationLayer.path else { return }
    let bezierPath = UIBezierPath(cgPath: path)
    if let path = bezierPath.currentPath() {
      updateInnerViewPosition(with: path)
    }
  }
}

// MARK: - Inner View Processing

extension JellyView {
    
  private func updateInnerViewPosition(with path: Path) {
    let frame = innerViewFrameCalculator.calculateFrame(with: path, offset: settings.innerViewOffset)
    innerView.frame = frame
    if let view = infoView {
      view.center = CGPoint(x: innerView.frame.size.width / 2, y: innerView.frame.size.height / 2)
      view.transform = CGAffineTransform(rotationAngle: gestureRecognizer.innerViewRotationAngle(flexibility: settings.flexibility))
    }
  }
}
