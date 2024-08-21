import RxCocoa
import RxSwift
import UIKit

final class RootView: UIViewController {
    var viewModel: RootViewModel!

    private let logoImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let disposeBag = DisposeBag()

    //MARK: - VC LifeCycle
    override func loadView() {
        view = UIView()

        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
}

//MARK: - ViewModel Binding
private extension RootView {

    func bindViewModel() {
        viewModel.didLoadTrigger.onNext(())
    }
}

//MARK: - Configure UI
private extension RootView {

    func setupUI() {
        with(self) {
            $0.view.backgroundColor = .white
        }

        with(logoImageView) {
            $0.image = UIImage(named: "defIcon")
            $0.contentMode = .scaleAspectFit
        }
    }
}
