import RxCocoa
import RxSwift
import UIKit

final class SavedView: UIViewController {
    var viewModel: SavedViewModel!

    private let disposeBag = DisposeBag()

    private let pageHeaderView = PageHeaderView()
    private let placeholderView = PlaceholderInfoView()
    private let tableView = UITableView(frame: .zero)

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
        rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }
            .bind(to: viewModel.willAppearTrigger)
            .disposed(by: disposeBag)
        viewModel.historyRecords.asObservable()
            .subscribe(onNext:{ [weak self] items in
                let areItemsEmpty = items.isEmpty
                self?.tableView.isHidden = areItemsEmpty
                self?.placeholderView.isHidden = !areItemsEmpty
            })
            .disposed(by: disposeBag)
        pageHeaderView.rx.buttonTrigger
            .bind(to: viewModel.deleteAllTrigger)
            .disposed(by: disposeBag)

        bindTableView()
    }

    private func bindTableView() {
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        viewModel.historyRecords
            .drive(tableView.rx.items(
                cellIdentifier: SavedTableViewCell.reuseId, cellType: SavedTableViewCell.self)
            ) { row, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Configure UI
private extension SavedView {
    func assemble() {
        addSubviews()
        configureViews()
        setConstraints()
    }

    func addSubviews() {
        view.addSubview(pageHeaderView)
        view.addSubview(placeholderView)
        view.addSubview(tableView)
    }

    func configureViews() {
        with(pageHeaderView) {
            $0.setup(title: "History", icon: UIImage(named: "basket.icon"))
        }

        with(placeholderView) {
            $0.setup(
                title: "No results saved",
                description: "Please make a measurement first"
            )
        }

        with(tableView) {
            $0.register(SavedTableViewCell.self)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 80
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }
    }

    func setConstraints() {
        pageHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }

        placeholderView.snp.makeConstraints {
            $0.top.equalTo(pageHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(pageHeaderView.snp.bottom).offset(0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SavedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        tableView.beginUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self, indexPath] _, _, success in
                success(true)
                self?.viewModel.deleteTrigger.onNext(indexPath)
            }
        )
        deleteAction.image = UIImage(named: "delete.icon")
        deleteAction.backgroundColor = .white
        let editAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self, indexPath] _, _, success in
                success(true)
                self?.viewModel.editTrigger.onNext(indexPath)
            }
        )
        editAction.image = UIImage(named: "edit.icon")
        editAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
