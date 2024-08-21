import RxCocoa
import RxSwift
import UIKit

final class OnboardingView: UIViewController {
    var viewModel: OnboardingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
}

//MARK: - ViewModel Binding
private extension OnboardingView {
    
    func bindViewModel() {
        viewModel.didLoadTrigger.onNext(())
    }
}

//MARK: - Configure UI
private extension OnboardingView {
    
    func setupUI() { }
}
