import UIKit

class PlaceholderInfoView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        titleLabel.font = .gilroy(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        descriptionLabel.font = .gilroy(ofSize: 16, weight: .light)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .shuttleGray
        descriptionLabel.textAlignment = .center
    }

    func setup(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
