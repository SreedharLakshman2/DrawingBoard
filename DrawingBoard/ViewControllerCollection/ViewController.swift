//
//  ViewController.swift
//  DrawingBoard
//
//  Created by Sreedhar Lakshmanan on 14/03/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var strokeSizeSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var pencilColorButtonOutlet: UIButton!
    
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliderValueLabel.text = "Line Width = 5"
        strokeSizeSlider.tintColor = UIColor.black
        strokeSizeSlider.isUserInteractionEnabled = true
        strokeSizeSlider.isSelected = true
        strokeSizeSlider.layoutIfNeeded()
        canvasView.lineColor = UIColor.black
        pencilColorButtonOutlet.layer.borderWidth = 1.0
        pencilColorButtonOutlet.layer.borderColor = UIColor.black.cgColor
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
        picker.selectedColor = self.view.backgroundColor!
        
        //  Subscribing selectedColor property changes.
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                
                //  Changing view color on main thread.
                DispatchQueue.main.async {
                    self.canvasView.lineColor = color
                    self.pencilColorButtonOutlet.tintColor = color
                    self.canvasView.layoutSubviews()
                }
            }
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareImageButtonAction(_ sender: UIButton) {
        //Share Image
        self.canvasView.captureImage(share: true)
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

