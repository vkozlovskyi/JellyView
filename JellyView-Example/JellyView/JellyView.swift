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

public protocol VKJellyViewDelegate : class {
  func jellyViewShouldStartDragging(jellyView : VKJellyView) -> Bool
  func jellyViewDidStartDragging(curtainControl : VKJellyView)
  func jellyViewDidEndDragging(curtainControl : VKJellyView)
  func jellyViewActionFired(curtainControl : VKJellyView)
}

public extension UIView {
  public func addJellyView(position: Position) {
    let jellyView = VKJellyView(position: position)
    jellyView.connectGestureRecognizer(toView: self)
    self.addSubview(jellyView)
  }
}

public final class VKJellyView : UIView {
  
  public var infoView : UIView?
  public var innerPointRatio : CGFloat = 0.4
  public var outerPointRatio : CGFloat = 0.2
  public var viewMass : CGFloat = 1.0
  public var springStiffness : CGFloat = 200.0
  public var offset : CGFloat = 0.0
  
  private weak var containerView : UIView?
  private weak var shapeLayer : CAShapeLayer?
  private let position : Position
  private let beizerPath = UIBezierPath()
  
  init(position: Position) {
    self.position = position
    super.init(frame: CGRectZero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension VKJellyView : UIGestureRecognizerDelegate {
  
  func connectGestureRecognizer(toView view : UIView) {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(VKJellyView.handlePanGesture(_:)))
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handlePanGesture(let pan : UIPanGestureRecognizer) {
    
  }
}
