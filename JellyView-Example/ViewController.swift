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
    self.view.backgroundColor = colorsArray().last
    let jellyView = JellyView(position: .Top, forView: self.view, colors: colorsArray())
    self.view.addSubview(jellyView)
    
    let infoLabel = UILabel(frame: CGRectMake(0.0, 0.0, 150.0, 50))
    infoLabel.font = UIFont.systemFontOfSize(30)
    infoLabel.text = "Test"
//    infoLabel.backgroundColor = UIColor.greenColor()
    infoLabel.textAlignment = NSTextAlignment.Center
    jellyView.infoView = infoLabel
  }
  
  func colorsArray() -> Array<UIColor> {
    let colorsArray = [
      UIColor(red: 117.0/255.0, green: 170.0/255.0, blue: 255.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 233.0/255.0, blue: 124.0/255.0, alpha: 1.0),
      UIColor(red: 194.0/255.0, green: 227.0/255.0, blue: 122.0/255.0, alpha: 1.0),
      UIColor(red: 175.0/255.0, green: 135.0/255.0, blue: 223.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)]
    return colorsArray
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
