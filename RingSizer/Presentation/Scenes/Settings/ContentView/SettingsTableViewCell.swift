import UIKit
import RxCocoa
import RxSwift

final class SettingsTableViewCell: UITableViewCell, ReuseIdentifiable {
    private let containerView = UIView()
    private let leftStackView = UIStackView()
    private let image = UIImageView()
    private let title = UILabel()
    private let accessoryImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        assemble()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        title.text = nil
    }

    func bind(model: SettingsModel) {
        title.text = model.title
        image.image = model.image
    }
}

//MARK: - Configure UI
private extension SettingsTableViewCell {

    func assemble() {
        addSubviews()
        setConstraints()
        configureViews()
    }

    func addSubviews() {
        leftStackView.addArrangedSubview(image)
        leftStackView.addArrangedSubview(title)
        containerView.addSubview(leftStackView)
        containerView.addSubview(accessoryImageView)
        contentView.addSubview(containerView)
    }

    func configureViews() {
        with(self) {
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }

        with(containerView) {
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .dodgerBlue.withAlphaComponent(0.1)
        }

        with(leftStackView) {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }

        with(image) {
            $0.contentMode = .scaleAspectFit
        }

        with(title) {
            $0.font = .gilroy(ofSize: 16, weight: .regular)
            $0.textAlignment = .left
            $0.textColor = .black
        }

        with(accessoryImageView) {
            $0.image = UIImage(named: "arrowRight")
            $0.contentMode = .scaleAspectFit
        }
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }

        leftStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalTo(containerView.snp.leading).offset(16)
        }

        image.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }

        accessoryImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

