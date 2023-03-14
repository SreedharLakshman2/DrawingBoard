//
//  CanvasView.swift
//  DrawingBoard
//
//  Created by Sreedhar Lakshmanan on 14/03/23.
//

import UIKit

class CanvasView: UIView {

    var lineColor: UIColor!
    var lineWidth: CGFloat! = 5.0
    var path: UIBezierPath!
    var startPoint: CGPoint!
    var touchPoint: CGPoint!
    var imageCollection: [UIImage] = []
    
     override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
         var color = lineColor
        lineColor = color
        addBorderToTheCanvasView()
        addLabel()
     }
    
    func addLabel() {
        let label = UILabel()
        label.text = "Draw Here!"
        label.textColor = UIColor.systemPurple
        label.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
        label.tag = 100
        self.addSubview(label)
    }
    
    func addBorderToTheCanvasView() {
        self.layer.borderColor = UIColor.systemPurple.cgColor
        self.layer.borderWidth = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        drawShapeLayer()
    }
    
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
        
    }
    
    
    func clearCanvas() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
        addLabel()
    }
    
    func captureImage() {
        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, UIScreen.main.scale);
        guard let context = UIGraphicsGetCurrentContext() else {return }
        self.layer.render(in:context)
        if let screenShotImage = UIGraphicsGetImageFromCurrentImageContext() {
            imageCollection.append(screenShotImage)
            UIImageWriteToSavedPhotosAlbum(screenShotImage, self, #selector(saveError), nil)
            UIGraphicsEndImageContext()
        }
        print(imageCollection.count)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let error = error {
            window?.rootViewController?.presentAlertWithTitle(title: "Alert", message: "\(error.localizedDescription)/Allow access to camera, If it is not given already.", options: "OK", completion: { result in
                print(result)
            })
            print("error: \(error.localizedDescription)")
        } else {
            print("Save completed!")
            window?.rootViewController?.presentAlertWithTitle(title: "Alert", message: "Save completed!", options: "OK", completion: { result in
                print(result)
            })
        }
    }

}

