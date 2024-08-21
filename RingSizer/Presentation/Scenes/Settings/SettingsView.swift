import RxCocoa
import RxSwift
import UIKit

final class SettingsView: UIViewController {
    var viewModel: SettingsViewModel!

    private let pageHeaderView = PageHeaderView()
    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        viewModel.didLoadTrigger.onNext(())
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        assemble()
    }

    private func bindViewModel() {
        bindTableView()
    }

    private func bindTableView() {
        //MARK: - Input
        tableView.rx.itemSelected
            .bind(to: viewModel.selectTrigger)
            .disposed(by: disposeBag)

        viewModel.settings
            .drive(tableView.rx.items(
                cellIdentifier: SettingsTableViewCell.reuseId,
                cellType: SettingsTableViewCell.self)
            ) { row, item, cell in
                cell.bind(model: item)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Configure UI
private extension SettingsView {
    func assemble() {
        addSubviews()
        configureViews()
        setConstraints()
    }

    func addSubviews() {
        view.addSubview(pageHeaderView)
        view.addSubview(tableView)
    }

    func configureViews() {
        with(tableView) {
            $0.backgroundColor = .clear
            $0.register(SettingsTableViewCell.self,
                        forCellReuseIdentifier: SettingsTableViewCell.reuseId)
            $0.separatorColor = .clear
            $0.separatorStyle = .none
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderTopPadding = 0
            $0.keyboardDismissMode = .onDrag
            $0.alwaysBounceVertical = true
            $0.sectionHeaderTopPadding = 10
        }

        with(pageHeaderView) {
            $0.setup(title: "Settings", isButtonHidden: true, icon: nil)
        }
    }

    func setConstraints() {
        pageHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(pageHeaderView.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}

