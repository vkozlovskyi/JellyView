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
    self.view.backgroundColor = UIColor(red: 194.0/255.0, green: 227.0/255.0, blue: 122.0/255.0, alpha: 1.0)
    
    let jellyView = JellyView(position: .Left, forView: self.view)
    jellyView.jellyColor = UIColor(red: 175.0/255.0, green: 135.0/255.0, blue: 223.0/255.0, alpha: 1.0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
