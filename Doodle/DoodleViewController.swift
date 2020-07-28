//
//  ViewController.swift
//  Doodle
//
//  Created by Kushagra on 28/07/20.
//  Copyright © 2020 Kushagra Sinha. All rights reserved.
//

import UIKit

class DoodleViewController: UIViewController {
    
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  
  var selectedImage = UIImage()
    
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false

  override func viewDidLoad() {
    mainImageView.image = selectedImage
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    makeRoundButtons()  }
  
  
  func makeRoundButtons()
  {
    resetBtn.layer.cornerRadius = 10
    resetBtn.clipsToBounds = true
    resetBtn.layer.borderColor = UIColor.black.cgColor
    resetBtn.layer.borderWidth = 1
    
    settingsBtn.layer.cornerRadius = 10
    settingsBtn.clipsToBounds = true
    settingsBtn.layer.borderColor = UIColor.black.cgColor
    settingsBtn.layer.borderWidth = 1
    
    share.layer.cornerRadius = 10
    share.clipsToBounds = true
    share.layer.borderColor = UIColor.black.cgColor
    share.layer.borderWidth = 1
  }
  

  

  
  // MARK: - Actions
    
    
    @IBAction func backPressed(_ sender: Any) {
      print("Back presses")
      self.dismiss(animated: true, completion: nil)
    }
    
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = selectedImage
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    guard let image = mainImageView.image else {
      return
    }
    let activity = UIActivityViewController(activityItems: [image],
                                            applicationActivities: nil)
    present(activity, animated: true)

  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
    // 1
    guard let pencil = Pencil(tag: sender.tag) else {
      return
    }

    // 2
    color = pencil.color

    // 3
    if pencil == .eraser {
      opacity = 1.0
    }

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let navController = segue.destination as? UINavigationController,
      let settingsController = navController.topViewController as? SettingsViewController
    else {
        return
    }
    settingsController.delegate = self
    settingsController.brush = brushWidth
    settingsController.opacity = opacity
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: nil)
    settingsController.red = red
    settingsController.green = green
    settingsController.blue = blue

  }

  
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    // 1
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
      
    // 2
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    // 3
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    // 4
    context.strokePath()
    
    // 5
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }

    // 6
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)
      
    // 7
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      // draw a single point
      print("Drawing a single Point")
      drawLine(from: lastPoint, to: lastPoint)
    }
      
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
      
    tempImageView.image = nil
    print("Merging image")
  }

}

// MARK: - SettingsViewControllerDelegate

extension DoodleViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
    brushWidth = settingsViewController.brush
    opacity = settingsViewController.opacity
    color = UIColor(red: settingsViewController.red,
    green: settingsViewController.green,
    blue: settingsViewController.blue,
    alpha: opacity)
    dismiss(animated: true)
  }
}


