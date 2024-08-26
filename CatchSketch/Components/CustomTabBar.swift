//
//  CustomTabBar.swift
//  CatchSketch
//
//  Created by dopamint on 8/22/24.
//

//import UIKit
//
//class CustomTabBar: UITabBar {
//    private var shapeLayer: CALayer?
//    
//    private func addShape() {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = createPath()
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.lineWidth = 1.0
//        
//        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
//        shapeLayer.shadowRadius = 10
//        shapeLayer.shadowColor = UIColor.gray.cgColor
//        shapeLayer.shadowOpacity = 0.3
//        
//        if let oldShapeLayer = self.shapeLayer {
//            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
//        } else {
//            self.layer.insertSublayer(shapeLayer, at: 0)
//        }
//        self.shapeLayer = shapeLayer
//    }
//    
//    override func draw(_ rect: CGRect) {
//        self.addShape()
//    }
//    
//    func createPath() -> CGPath {
//        let height: CGFloat = 60.0 // 깊이를 더 깊게 만듭니다
//        let path = UIBezierPath()
//        let centerWidth = self.frame.width / 2
//        
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
//        
//        // 곡선의 control point를 조정하여 더 부드럽고 깊은 곡선을 만듭니다
//        path.addCurve(to: CGPoint(x: centerWidth, y: height),
//                      controlPoint1: CGPoint(x: (centerWidth - 40), y: 0),
//                      controlPoint2: CGPoint(x: centerWidth - 45, y: height))
//        
//        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + 45, y: height),
//                      controlPoint2: CGPoint(x: (centerWidth + 40), y: 0))
//        
//        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
//        path.close()
//        
//        return path.cgPath
//    }
//}
