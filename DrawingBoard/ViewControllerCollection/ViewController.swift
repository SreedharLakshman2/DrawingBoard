//
//  ViewController.swift
//  DrawingBoard
//
//  Created by Sreedhar Lakshmanan on 14/03/23.
//

import UIKit
import Combine
import GoogleMobileAds

class ViewController: UIViewController {
    

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var strokeSizeSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var pencilColorButtonOutlet: UIButton!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    @IBOutlet weak var viewForButton: UIView!
    
    var cancellable: AnyCancellable?
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliderValueLabel.text = "Line Width = 5"
        strokeSizeSlider.isUserInteractionEnabled = true
        strokeSizeSlider.isSelected = true
        strokeSizeSlider.layoutIfNeeded()
        canvasView.lineColor = UIColor.black
        pencilColorButtonOutlet.layer.borderWidth = 1.0
        pencilColorButtonOutlet.layer.borderColor = UIColor.black.cgColor
        pencilColorButtonOutlet.layer.cornerRadius = 10
        pencilColorButtonOutlet.clipsToBounds = true
        canvasView.backgroundColor = segmentControlOutlet.selectedSegmentIndex == 0 ? UIColor.white : UIColor.black
        // In this case, we instantiate the banner with desired ad size.
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
        bannerView = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView)
        //Test UnitID
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        //OurApp adUnitID
        //bannerView.adUnitID = "ca-app-pub-9471606055191983~4147205904"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
       
    @IBAction func clearButtonTapped(_ sender: Any) {
        self.canvasView.clearCanvas()
    }
    
    
    @IBAction func captureImageTapped(_ sender: UIButton) {
        self.canvasView.captureImage(share: false)
    }
    
    @IBAction func slideLineWidthAction(_ sender: UISlider) {
        print(sender.value)
        sliderValueLabel.text = "Line Width = \(Int(sender.value))"
        self.canvasView.lineWidth = (CGFloat(sender.value))
    }
    
    @IBAction func pencilButtonTapped(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor.black
        
        //  Subscribing selectedColor property changes.
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                
                //  Changing view color on main thread.
                DispatchQueue.main.async {
                    print(color)
                    self.canvasView.lineColor = color
                    self.canvasView.layoutSubviews()
                }
            }
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareImageButtonAction(_ sender: UIButton) {
        //Share Image
        self.canvasView.captureImage(share: true)
    }
    
    @IBAction func segmentControlTapAction(_ sender: UISegmentedControl) {
        canvasView.backgroundColor = segmentControlOutlet.selectedSegmentIndex == 0 ? UIColor.white : UIColor.black
        self.canvasView.changeBoardColor()
    }
    
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            self.view.backgroundColor = viewController.selectedColor
    }
    
}


extension UIViewController {

    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (_, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(option)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension ViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      bannerView.alpha = 0
      UIView.animate(withDuration: 1, animations: {
        bannerView.alpha = 1
      })
    }
}
