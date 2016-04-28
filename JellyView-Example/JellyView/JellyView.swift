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
  
  private weak var containerView : UIView?
  private var shapeLayer = CAShapeLayer()
  private let beizerPath = UIBezierPath()
  private let position : Position
  private var shouldStartDragging : Bool = true
  
  init(position: Position) {
    self.position = position
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
    
  }
}









