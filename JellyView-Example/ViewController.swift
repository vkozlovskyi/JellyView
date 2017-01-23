//
//  ViewController.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

struct Quote {
  let text: String
  let author: String
}

class ViewController: UIViewController {
  
  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  var quotes: [Quote] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = colorsArray().last
    setupQuotes()
    setupJellyView()
  }
  
  func setupQuotes() {
    let quote1 = Quote(text: "My model for business is The Beatles. They were four guys who kept each other’s kind of negative tendencies in check. They balanced each other and the total was greater than the sum of the parts. That’s how I see business: great things in business are never done by one person, they’re done by a team of people.", author: "Steve Jobs")
    let quote2 = Quote(text: "We're very simple people at Apple. We focus on making the world's best products and enriching people's lives.", author: "Tim Cook")
    let quote3 = Quote(text: "There's no learning without trying lots of ideas and failing lots of times. ", author: "Jonathan Ive")
    let quote4 = Quote(text: "You can make something big when young that will carry you through life. Look at all the big startups like Microsoft, Apple, Google, Facebook, Twitter, etc. They were all started by very young people who stumbled on something of unseen value. You'll know it when you hit a home run.", author: "Steve Wozniak")
    let quote5 = Quote(text: "Why join the navy if you can be a pirate?", author: "Steve Jobs")
    quotes = [quote1, quote2, quote3, quote4, quote5]
  }
  
  func setupJellyView() {
    let jellyView = JellyView(position: .left, colors: colorsArray())
    self.view.addSubview(jellyView)
    let appleImage = UIImage(named: "apple-logo")!
    let appleView = UIImageView(image: appleImage)
    jellyView.infoView = appleView
    jellyView.offset = 10
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
}
