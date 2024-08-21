import RxCocoa
import RxSwift
import RxGesture
import UIKit

final class DeleteAlertView: UIViewController {
    var viewModel: DeleteAlertViewModel!

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
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

        containerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        viewModel.didLoadTrigger.onNext(())
    }

    private func setupUI() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32

        titleLabel.textAlignment = .center
        titleLabel.font = .gilroy(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2

        confirmButton.setTitle("Yes", for: .normal)
        confirmButton.titleLabel?.font = .gilroy(ofSize: 17, weight: .semibold)
        confirmButton.layer.cornerRadius = 24
        confirmButton.layer.masksToBounds = true
        confirmButton.tintColor = .white
        confirmButton.backgroundColor = .red

        cancelButton.setTitle("No", for: .normal)
        cancelButton.titleLabel?.font = .gilroy(ofSize: 17, weight: .semibold)
        cancelButton.layer.cornerRadius = 24
        cancelButton.layer.masksToBounds = true
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
            .bind(to: viewModel.confirmTrigger)
            .disposed(by: disposeBag)
        viewModel.alertTitle
            .drive { [weak self] title in
                self?.titleLabel.text = title
            }
            .disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        confirmButton.layoutIfNeeded()
        confirmButton.applyGradient(with: [.mandy, .roofTerracotta], gradient: .vertical)
    }
}
