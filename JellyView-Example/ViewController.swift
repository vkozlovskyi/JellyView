//
//  ViewController.swift
//  JellyView-Example
//
//  Created by Vladimir Kozlovskyi on 28.04.16.
//  Copyright © 2016 Vladimir Kozlovskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var currentIndex = 0
  var contentLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = colors.last
    setupContentLabel()
    setupJellyView()
  }

  private func setupJellyView() {
    let jellyView = JellyView(side: .left, colors: colors)
    view.addSubview(jellyView)
    jellyView.infoView = createInfoView()
    jellyView.setupSettings = { settings in
      settings.innerViewOffset = 0
    }
    jellyView.actionDidFire = { [unowned self] in
      self.contentLabel.alpha = 1
      let text = self.getContentLabelText()
      self.applyNewText(text)
    }
    jellyView.didDrag = { [unowned self] progress in
      self.updateAlpha(forProgress: progress)
    }
    jellyView.actionDidCancel = { [unowned self] in
      UIView.animate(withDuration: 0.3) {
        self.contentLabel.alpha = 1
      }
    }
  }

  private func setupContentLabel() {
    let offset: CGFloat = 30
    contentLabel = UILabel()
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    contentLabel.numberOfLines = 0
    contentLabel.textColor = UIColor(red: 44.0/255.0, green: 49.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    applyNewText(contentStrings[0])
    view.addSubview(contentLabel)
    contentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset).isActive = true
    contentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset).isActive = true
    contentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: offset * 2).isActive = true
    contentLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset * 2).isActive = true
  }

  private func applyNewText(_ text: String) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3
    let attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraphStyle,
                                                    .font: UIFont.systemFont(ofSize: 23, weight: .medium)]
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    contentLabel.attributedText = attributedString
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

  private func updateAlpha(forProgress progress: CGFloat) {
    contentLabel.alpha = 1 - progress * 2
  }

  private func  getContentLabelText() -> String {
    currentIndex = currentIndex + 1 == contentStrings.count ? 0 : currentIndex + 1
    return contentStrings[currentIndex]
  }

  lazy var contentStrings: [String] = {
    return [
      "Lorem ipsum dolor sit amet, ne facete signiferumque mei, iisque nonumes propriae ius te, suas ubique nec ei. Eu quod labitur periculis est. Et duo albucius delectus, an rationibus percipitur consectetuer est. Ei usu autem menandri. Id nibh detraxit vim, eam ne diceret instructior, eos ex debet semper appellantur.",
      "Sumo idque suscipiantur te eos, ludus tempor suscipiantur te sed. Nec consetetur posidonium te, agam veritus prodesset an his. Aeque scaevola eu qui, usu ex mazim audire. Ei per admodum pertinacia deseruisse, sit no propriae recusabo.",
      "Sea labores mandamus at. Ea omnis zril eam, id habeo reprehendunt vix. Ut qui vivendo mediocrem, dictas labitur vis no. Id putent ocurreret vim, mea omnis persius interesset ea. Sit aperiam laboramus eu, eu cum amet quaeque dissentiet. Pro ancillae praesent id.",
      "Etiam sapientem eam ad, ex wisi adhuc splendide sit, cibo ipsum pertinax ex has. Vis at sale homero appellantur, vel augue doctus tibique et. Utroque oportere scribentur vix eu, meis sententiae eum ad. Eam timeam prodesset ex. Purto perfecto laboramus id usu.",
      "Eam ea dico habeo. Ius possit deseruisse interesset ne. In admodum pertinax sit. Omnis interesset an sit, convenire cotidieque at nec. Ne elit ancillae gloriatur ius, vix ad odio modo."
    ]
  }()

  lazy var colors: [UIColor] = {
    let colors = [
      UIColor(red: 117.0/255.0, green: 170.0/255.0, blue: 255.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 233.0/255.0, blue: 124.0/255.0, alpha: 1.0),
      UIColor(red: 194.0/255.0, green: 227.0/255.0, blue: 122.0/255.0, alpha: 1.0),
      UIColor(red: 175.0/255.0, green: 135.0/255.0, blue: 223.0/255.0, alpha: 1.0),
      UIColor(red: 255.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)]
    return colors
  }()
}
