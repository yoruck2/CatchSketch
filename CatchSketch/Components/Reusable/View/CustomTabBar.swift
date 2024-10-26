import UIKit

class CustomTabBar: UITabBar {
    private var shapeLayer: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor(patternImage: UIImage(named: CatchSketch.AssetImage.tornPaper)!).cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - 30), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: -20),
                      controlPoint1: CGPoint(x: (centerWidth - 25), y: 0),
                      controlPoint2: CGPoint(x: (centerWidth - 25), y: -20))
        
        path.addCurve(to: CGPoint(x: (centerWidth + 30), y: 0),
                      controlPoint1: CGPoint(x: (centerWidth + 25), y: -20),
                      controlPoint2: CGPoint(x: (centerWidth + 25), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        
        return nil
    }
}
