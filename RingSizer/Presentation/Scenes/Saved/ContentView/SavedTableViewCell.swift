import RxSwift
import UIKit

protocol AccordionViewModel {
    var selectTrigger: AnyObserver<Bool> { get }
}

final class SavedTableViewCell: UITableViewCell, ReuseIdentifiable {
    private let containerView = UIView()

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let sizeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        assemble()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with model: HistoryRecord) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateString = dateFormatter.string(from: model.date)
        let iconImage = SizerType.finger.rawValue == model.type.rawValue
        ? UIImage(named: "finger.color.icon")
        : UIImage(named: "ring.color.icon")
        iconImageView.image = iconImage
        titleLabel.text = model.name
        dateLabel.text = dateString
        sizeLabel.text = model.size
     }
}

private extension SavedTableViewCell {
    func assemble() {
        addSubviews()
        setConstraints()
        configureViews()
    }

    func addSubviews() {
        addSubview(containerView)

        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(sizeLabel)
    }

    func configureViews() {
        with(self) {
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }

        with(containerView) {
            $0.backgroundColor = .dodgerBlue.withAlphaComponent(0.1)
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }

        with(titleLabel) {
            $0.textColor = .black
            $0.font = .gilroy(ofSize: 16, weight: .bold)
        }

        with(dateLabel) {
            $0.textColor = .shuttleGray
            $0.font = .gilroy(ofSize: 14, weight: .regular)
        }

        with(sizeLabel) {
            $0.textColor = .black
            $0.font = .gilroy(ofSize: 16, weight: .bold)
        }
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(48)
        }

        sizeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top).offset(4.5)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(sizeLabel.snp.leading).offset(-12).priority(750)
        }

        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconImageView.snp.bottom).offset(-4.5)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
    }
}
