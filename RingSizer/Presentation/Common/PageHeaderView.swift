import RxCocoa
import RxSwift
import UIKit

final class PageHeaderView: UIView {
    private let titleLabel = UILabel()
    private let separatorLine = UIView()
    fileprivate let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(button)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(button.snp.leading).offset(-8)
        }

        button.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(48)
        }

        separatorLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.textColor = .black
        titleLabel.font = .gilroy(ofSize: 32, weight: .bold)

        button.backgroundColor = .athensGray
        button.layer.cornerRadius = 24
        button.tintColor = .black

        separatorLine.backgroundColor = .athensGray
    }

    func setup(title: String, isButtonHidden: Bool = false, icon: UIImage?) {
        titleLabel.text = title
        button.isHidden = isButtonHidden
        button.setImage(icon, for: .normal)

    }
}

// MARK: - Reactive wrapper
extension Reactive where Base: PageHeaderView {
    var buttonTrigger: ControlEvent<Void> {
        return base.button.rx.tap
    }
}
