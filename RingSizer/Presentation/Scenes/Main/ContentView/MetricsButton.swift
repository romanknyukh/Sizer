import UIKit

final class MetricsButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .athensGray
        setImage(.chevronDown, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        tintColor = .black
    }

    func setTitle(from metrics: RingSizeMetric) {
        setTitle(metrics.name, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
