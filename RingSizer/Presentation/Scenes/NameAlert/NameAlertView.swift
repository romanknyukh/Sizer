import RxCocoa
import RxSwift
import RxGesture
import UIKit

final class NameAlertView: UIViewController {
    var viewModel: NameAlertViewModel!

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let textFieldBackgroundView = UIView()
    private let textField = UITextField()
    private let confirmButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = UIView()

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(60)
        }

        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }

        containerView.addSubview(textFieldBackgroundView)
        textFieldBackgroundView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        textFieldBackgroundView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }

        containerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(textFieldBackgroundView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32

        titleLabel.text = "Enter Name"
        titleLabel.textAlignment = .center
        titleLabel.font = .gilroy(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2

        descriptionLabel.text = "Give a name for your size"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .gilroy(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .shuttleGray
        descriptionLabel.numberOfLines = 0

        textFieldBackgroundView.backgroundColor = .athensGray
        textFieldBackgroundView.layer.cornerRadius = 24
        textFieldBackgroundView.layer.masksToBounds = true

        textField.placeholder = "Name"
        textField.font = .gilroy(ofSize: 16, weight: .regular)
        textField.backgroundColor = .clear
        textField.textColor = .black

        confirmButton.setTitle("Save", for: .normal)
        confirmButton.titleLabel?.font = .gilroy(ofSize: 17, weight: .bold)
        confirmButton.layer.cornerRadius = 24
        confirmButton.layer.masksToBounds = true
        confirmButton.tintColor = .white
        confirmButton.backgroundColor = .red

        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = .black
    }

    private func bindViewModel() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.cancelTrigger)
            .disposed(by: disposeBag)
        cancelButton.rx.tap
            .bind(to: viewModel.cancelTrigger)
            .disposed(by: disposeBag)
        confirmButton.rx.tap
            .bind(to: viewModel.saveTrigger)
            .disposed(by: disposeBag)
        textField.rx.text
            .bind(to: viewModel.nameInputText)
            .disposed(by: disposeBag)
        viewModel.isSaveButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.confirmButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        confirmButton.layoutIfNeeded()
        confirmButton.applyGradient(with: [.aqua, .electricViolet], gradient: .vertical)
    }
}
