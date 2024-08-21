import UIKit

final class FingerSizerView: UIView {
    private let fingerLayer = CAShapeLayer()
    private let nailLayer = CAShapeLayer()

    var currentRadius: CGFloat = 50 {
        didSet {
            redrawLayers()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(fingerLayer)
        layer.addSublayer(nailLayer)

        fingerLayer.fillColor = UIColor.clear.cgColor
        fingerLayer.strokeColor = UIColor.dodgerBlue.cgColor
        fingerLayer.lineWidth = 2
        fingerLayer.lineDashPattern = [6, 6]

        nailLayer.fillColor = UIColor.clear.cgColor
        nailLayer.strokeColor = UIColor.dodgerBlue.cgColor
        nailLayer.lineWidth = 2
        nailLayer.lineDashPattern = [6, 6]

        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fingerPath(radius: CGFloat) -> CGPath {
        return CGPath(
            roundedRect: .init(
                x: -40,
                y: bounds.midY - radius,
                width: bounds.width - 7,
                height: radius * 2
            ),
            cornerWidth: min(radius, 40),
            cornerHeight: min(radius, 40),
            transform: nil
        )
    }

    func nailPath(radius: CGFloat) -> CGPath {
        return CGPath(
            roundedRect: .init(
                x: bounds.midX,
                y: bounds.midY - radius + radius / 5,
                width: 101.0 / 327.0 * bounds.width,
                height: radius * 2 - radius / 2.5
            ),
            cornerWidth: min(radius - radius / 5, 24),
            cornerHeight: min(radius - radius / 5, 24),
            transform: nil
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        redrawLayers()
    }

    private func redrawLayers() {
        fingerLayer.path = fingerPath(radius: currentRadius)
        nailLayer.path = nailPath(radius: currentRadius)
    }
}
