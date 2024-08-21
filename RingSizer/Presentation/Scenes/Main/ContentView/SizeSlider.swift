import UIKit

final class SizeSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setThumbImage(.sliderThumb, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(
            forBounds: bounds,
            trackRect: .init(
                origin: .init(x: -2, y: rect.minY),
                size: .init(width: bounds.width + 4, height: rect.height)
            ),
            value: value
        )
    }
}
