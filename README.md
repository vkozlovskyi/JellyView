# JellyView

[![Version](https://img.shields.io/cocoapods/v/JellyView.svg?style=flat)](http://cocoapods.org/pods/JellyView)
[![License](https://img.shields.io/cocoapods/l/JellyView.svg?style=flat)](http://cocoapods.org/pods/JellyView)
[![Platform](https://img.shields.io/cocoapods/p/JellyView.svg?style=flat)](http://cocoapods.org/pods/JellyView)

## Overview

JellyView represents a simple, colorful pull-to-refresh pattern for updating content in a fun animated way. You can set an array of colors that will be changing along with the content. Several options available for customizing animation.

<img src="JellyView.gif" width="320" height="692">

## Requirements

iOS 10

## Installation

 JellyView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:
 
 ```ruby
 pod 'JellyView'
 ```
 
 ## Manual installation

Just add JellyView folder into your project.

## Usage

```swift
import JellyView

// Choose the side of the screen: .left, .right, .top or .bottom
// Provide an array of colors for the background
let jellyView = JellyView(side: .left, colors: colors)
view.addSubview(jellyView)

// Add custom view inside:
jellyView.infoView = createInfoView()

// Change various settings for customizing animation and the shape, like this:
jellyView.settings.jellyMass = 1.1
jellyView.settings.innerViewOffset = -20

// Use closures for tracking events:
jellyView.didStartDragging { … }
jellyView.actionDidFire { … }
jellyView.actionDidCancel { … }
jellyView.didEndDragging { … }
```

## Demo

Check out the Example project.

## Author

Vladimir Kozlovskyi, vlad.kozlovskyi@gmail.com

## Licence

JellyView is available under the MIT license. See the LICENSE file for more info.
