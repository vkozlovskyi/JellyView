//
//  ViewController.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = colors.last
    setupJellyView()
  }

  private func setupJellyView() {
    let jellyView = JellyView(side: .left, colors: colors)
    view.addSubview(jellyView)
    jellyView.infoView = createInfoView()
    jellyView.setupSettings = { settings in
      settings.innerViewOffset = 0
    }
  }

  private func createInfoView() -> UIView {
    let size: CGFloat = 100
    let alpha: CGFloat = 0.5

    let infoView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
    infoView.backgroundColor = .clear

    let imageView = UIImageView(image: UIImage(named: "refresh-button")!)
    imageView.alpha = alpha
    imageView.frame = CGRect(x: size / 4, y: 0, width: size / 2, height: size / 2)
    infoView.addSubview(imageView)

    let pullLabel = UILabel(frame: CGRect(x: 0, y: 40, width: size, height: size / 2))
    pullLabel.font = UIFont(name: "Noteworthy-Bold", size: 30)!
    pullLabel.text = "Pull"
    pullLabel.textAlignment = .center
    pullLabel.alpha = alpha
    infoView.addSubview(pullLabel)
    return infoView
  }
  
  private var colors: [UIColor] {
    let colors = [
      UIColor(red: 117.0/255.0, green: 170.0/255.0, blue: 255.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 233.0/255.0, blue: 124.0/255.0, alpha: 1.0),
      UIColor(red: 194.0/255.0, green: 227.0/255.0, blue: 122.0/255.0, alpha: 1.0),
      UIColor(red: 175.0/255.0, green: 135.0/255.0, blue: 223.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)]
    return colors
  }
}
