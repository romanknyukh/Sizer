import RxCocoa
import RxSwift
import UIKit

final class TutorialView: UIViewController {
    var viewModel: TutorialViewModel!

    private let containerView = UIView()
    private var carouselLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = {
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        return collectionVIew
    }()
    private let pageControl = UIPageControl()
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let button = UIButton()

    private let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(504)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }

        containerView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }

        containerView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(button.snp.top).offset(-28)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }

        containerView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        viewModel.didLoadTrigger.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        button.applyGradient(with: [.aqua, .electricViolet], gradient: .vertical)
    }

    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        carouselLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = carouselLayout
        collectionView.register(TutorialViewCell.self, forCellWithReuseIdentifier: TutorialViewCell.reuseId)

        pageControl.pageIndicatorTintColor = .frenchGray
        pageControl.currentPageIndicatorTintColor = .dodgerBlue
        pageControl.isUserInteractionEnabled = false

        with(containerView) {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.masksToBounds = true
        }

        with(titleLabel) {
            $0.text = "Tutorial"
            $0.textColor = .black
            $0.font = .gilroy(ofSize: 20, weight: .bold)
        }

        with(backButton) {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .black
        }

        with(button) {
            $0.backgroundColor = .dodgerBlue
            $0.layer.cornerRadius = 32
            $0.layer.masksToBounds = true
            $0.titleLabel?.font = .gilroy(ofSize: 17, weight: .bold)
            $0.tintColor = .white
            $0.setTitle("Next", for: .normal)
        }
    }

    private func bindViewModel() {
        button.rx.tap
            .map { [weak self] in
                self?.collectionView.indexPathsForVisibleItems.first ?? IndexPath()
            }
            .bind(to: viewModel.nextTrigger)
            .disposed(by: disposeBag)
        backButton.rx.tap
            .bind(to: viewModel.backTrigger)
            .disposed(by: disposeBag)
        viewModel.pagesNumber
            .drive(pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        viewModel.currentPage
            .skip(1)
            .drive { [weak self] page in
                self?.pageControl.currentPage = page
                self?.collectionView.scrollToItem(
                    at: IndexPath(item: page, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        viewModel.steps
            .drive(collectionView.rx.items(
                cellIdentifier: TutorialViewCell.reuseId,
                cellType: TutorialViewCell.self)
            ) { row, item, cell in
                cell.setup(step: item)
            }
            .disposed(by: disposeBag)
        viewModel.currentPage
            .withLatestFrom(viewModel.steps) { ($0, $1) }
            .map { pageIndex, steps in
                if pageIndex == (steps.count - 1) {
                    return "Got It"
                } else {
                    return "Next"
                }
            }
            .drive(onNext: { [weak self] title in
                self?.button.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

extension TutorialView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
}
