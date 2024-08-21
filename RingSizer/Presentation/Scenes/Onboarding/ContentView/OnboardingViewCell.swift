import RxCocoa
import RxSwift
import UIKit

final class OnboardingViewCell: UICollectionViewCell, ReuseIdentifiable {

    fileprivate let closeButton = UIButton()
    fileprivate let restoreButton = UIButton()
    private let containerView = UIView()
    private let backgroundImageView = UIImageView()

    private(set) var reuseBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        assemble()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        reuseBag = DisposeBag()
    }

    func setup(step: OnboardingStep) {
        switch step.stepType {
        case .info:
            closeButton.isHidden = true
            restoreButton.isHidden = true
        case .restore(let delay, let alpha):
            DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(delay)) {
                self.closeButton.isHidden = false
            }
            self.closeButton.alpha = alpha
            restoreButton.isHidden = false
        }
        backgroundImageView.image = UIImage(named: step.backgroundImage)
    }
}

//MARK: - UI Configuration
private extension OnboardingViewCell {

    func assemble() {
        addSubviews()
        setConstraints()
        configureViews()
    }

    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(closeButton)
        containerView.addSubview(restoreButton)
    }

    func configureViews() {
        with(containerView) {
            $0.backgroundColor = .clear
        }

        with(backgroundImageView) {
            $0.contentMode = .scaleAspectFill
        }

        with(closeButton) {
            $0.setImage(UIImage(named: "close")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        }

        with(restoreButton) {
            $0.setTitle("Restore", for: .normal)
//            $0.titleLabel?.font = .outfit(ofSize: 14)
//            $0.setTitleColor(.silver, for: .normal)
        }
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(24)
        }

        restoreButton.snp.makeConstraints {
            $0.centerY.equalTo(closeButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}

// MARK: - Reactive extension
extension Reactive where Base: OnboardingViewCell {
    var closeTrigger: ControlEvent<Void> {
        return base.closeButton.rx.tap
    }

    var restoreTrigger: ControlEvent<Void> {
        return base.restoreButton.rx.tap
    }
}
