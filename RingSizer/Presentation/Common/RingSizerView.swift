import UIKit

final class RingSizerView: UIView {
    private let ringLayer = CAShapeLayer()
    private let outlineLayer = CAShapeLayer()

    var currentRadius: CGFloat = 80 {
        didSet {
            redrawLayers()
        }
    }
    var maxRadius: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(ringLayer)
        layer.addSublayer(outlineLayer)

        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.black.cgColor
        ringLayer.lineWidth = 6


        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.strokeColor = UIColor.black.cgColor
        outlineLayer.lineWidth = 1
        outlineLayer.lineDashPattern = [6, 6]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func path(radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(ovalIn: .init(
            x: bounds.midX - radius,
            y: bounds.midY - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        redrawLayers()
    }

    private func redrawLayers() {
        ringLayer.path = path(radius: currentRadius).cgPath
        outlineLayer.path = path(radius: currentRadius - 8).cgPath
    }
}
