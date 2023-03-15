//
//  CanvasView.swift
//  DrawingBoard
//
//  Created by Sreedhar Lakshmanan on 14/03/23.
//

import UIKit

//Global access variable
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

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
         let color = lineColor
        lineColor = color
        addBorderToTheCanvasView()
        //addLabel()
     }
    
    func addLabel() {
        let label = UILabel()
        label.text = "Draw Board"
        label.textColor = lineColor
        label.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
        label.tag = 100
        self.addSubview(label)
    }
    
    func addBorderToTheCanvasView() {
        self.layer.borderColor = UIColor.black.cgColor
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
        if let path = self.path {
            path.removeAllPoints()
            self.layer.sublayers = nil
            self.setNeedsDisplay()
        }
        else {
            print("Nothing to delete")
        }
    }
    
    func captureImage(share: Bool) {
        if  !path.isEmpty {
            UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, UIScreen.main.scale);
            guard let context = UIGraphicsGetCurrentContext() else {return }
            self.layer.render(in:context)
            if let screenShotImage = UIGraphicsGetImageFromCurrentImageContext() {
                imageCollection.append(screenShotImage)
                if share {
                    let image = screenShotImage
                    let imageShare = [ image ]
                    let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self
                    window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }
                else {
                    UIImageWriteToSavedPhotosAlbum(screenShotImage, self, #selector(saveError), nil)
                }
                UIGraphicsEndImageContext()
            }
            print(imageCollection.count)
        }
        else {
            window?.rootViewController?.presentAlertWithTitle(title: "Alert", message: share ? "Please draw something before share to some one." : "Please draw something before save it to photoAlbum.", options: "OK", completion: { result in
                print(result)
            })
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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

