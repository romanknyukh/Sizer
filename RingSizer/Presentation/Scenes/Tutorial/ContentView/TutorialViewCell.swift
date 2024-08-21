import RxCocoa
import RxSwift
import UIKit

final class TutorialViewCell: UICollectionViewCell, ReuseIdentifiable {

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()

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

    func setup(step: TutorialStep) {
        imageView.image = step.image
        descriptionLabel.text = step.description
    }
}

//MARK: - UI Configuration
private extension TutorialViewCell {

    func assemble() {
        addSubviews()
        setConstraints()
        configureViews()
    }

    func addSubviews() {
        addSubview(imageView)
        addSubview(descriptionLabel)
    }

    func configureViews() {
        backgroundColor = .clear

        with(imageView) {
            $0.contentMode = .scaleToFill
        }

        with(descriptionLabel) {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .gilroy(ofSize: 20)
        }
    }

    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(202)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
