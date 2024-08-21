import RxCocoa
import RxSwift
import UIKit
import BetterSegmentedControl

final class MainView: UIViewController {
    var viewModel: MainViewModel!

    private let pageHeaderView = PageHeaderView()
    private lazy var modeSwitcherControl = BetterSegmentedControl(
        frame: .zero,
        segments: [
            IconSegment(
                icon: .ringSizerIcon,
                iconSize: .init(width: 24, height: 24),
                normalIconTintColor: .shuttleGray,
                selectedIconTintColor: .white
            ),
            IconSegment(
                icon: .fingerSizerIcon,
                iconSize: .init(width: 24, height: 24),
                normalIconTintColor: .shuttleGray,
                selectedIconTintColor: .white
            )
        ]
    )
    private let sizerContainer = UIView()
    private let ringSizerView = RingSizerView()
    private let fingerSizerView = FingerSizerView()
    private let ringSizeCaptionLabel = UILabel()
    private let ringSizeLabel = UILabel()
    private let metricsButton = MetricsButton(type: .system)
    private let sizeSlider = SizeSlider()
    private let minCaptionLabel = UILabel()
    private let maxCaptionLabel = UILabel()
    private let saveButton = UIButton(type: .system)

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = UIView()

        view.addSubview(pageHeaderView)
        pageHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }

        view.addSubview(modeSwitcherControl)
        modeSwitcherControl.snp.makeConstraints {
            $0.top.equalTo(pageHeaderView.snp.bottom).offset(24)
            $0.height.equalTo(48)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(sizerContainer)
        sizerContainer.snp.makeConstraints {
            $0.top.equalTo(modeSwitcherControl.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(sizerContainer.snp.width).multipliedBy(176.0 / 327.0)
        }
        view.addSubview(ringSizerView)
        ringSizerView.snp.makeConstraints {
            $0.edges.equalTo(sizerContainer)
        }

        view.addSubview(fingerSizerView)
        fingerSizerView.snp.makeConstraints {
            $0.edges.equalTo(sizerContainer)
        }
        fingerSizerView.isHidden = true

        view.addSubview(ringSizeCaptionLabel)
        ringSizeCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(sizerContainer.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }

        let ringSizeContainer = UIView()
        view.addSubview(ringSizeContainer)
        ringSizeContainer.snp.makeConstraints {
            $0.top.equalTo(ringSizeCaptionLabel.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }

        ringSizeContainer.addSubview(metricsButton)
        metricsButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(44)
        }

        ringSizeContainer.addSubview(ringSizeLabel)
        ringSizeLabel.snp.makeConstraints {
            $0.centerY.equalTo(metricsButton)
            $0.top.greaterThanOrEqualToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.trailing.equalTo(metricsButton.snp.leading).offset(-10)
        }

        view.addSubview(sizeSlider)
        sizeSlider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(ringSizeContainer.snp.bottom).offset(20)
        }

        view.addSubview(minCaptionLabel)
        minCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(sizeSlider.snp.bottom)
            $0.leading.equalTo(sizeSlider)
        }

        view.addSubview(maxCaptionLabel)
        maxCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(sizeSlider.snp.bottom)
            $0.trailing.equalTo(sizeSlider)
        }

        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(sizeSlider.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(64)
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

        saveButton.applyGradient(with: [.aqua, .electricViolet], gradient: .vertical)
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        pageHeaderView.setup(title: "Finger Sizer", icon: UIImage(named: "question.icon"))

        modeSwitcherControl.indicatorViewInset = 6
        modeSwitcherControl.cornerRadius = 24
        modeSwitcherControl.indicatorViewBackgroundColor = .dodgerBlue

        sizerContainer.backgroundColor = .dodgerBlue.withAlphaComponent(0.1)
        sizerContainer.layer.cornerRadius = 24

        ringSizeCaptionLabel.text = "Your Ring Size is:"
        ringSizeCaptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ringSizeCaptionLabel.textColor = .black

        ringSizeLabel.font = .systemFont(ofSize: 28, weight: .bold)
        ringSizeLabel.textColor = .black

        metricsButton.setTitle(from: .us) // TEST

        sizeSlider.minimumValue = 14.86 / Constants.millimetresPerPoint // 19.40315
        sizeSlider.maximumValue = 22.33 / Constants.millimetresPerPoint // 27.5244
        sizeSlider.tintColor = .dodgerBlue

        minCaptionLabel.text = "Min."
        minCaptionLabel.textAlignment = .left
        minCaptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        minCaptionLabel.textColor = .black

        maxCaptionLabel.text = "Max."
        maxCaptionLabel.textAlignment = .right
        maxCaptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        maxCaptionLabel.textColor = .black

        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 32
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.tintColor = .white
        saveButton.setTitle("Save size", for: .normal)
    }

    private func bindViewModel() {
        sizeSlider.rx.value
            .do(onNext: { [weak self] value in
                self?.ringSizerView.currentRadius = CGFloat(value)
                self?.fingerSizerView.currentRadius = CGFloat(value - 8)
            })
            .map { $0 * Constants.millimetresPerPoint }
            .bind(to: viewModel.ringDiameterInMM)
            .disposed(by: disposeBag)
        metricsButton.rx.tap
            .bind(to: viewModel.metricsTrigger)
            .disposed(by: disposeBag)
        saveButton.rx.tap
            .bind(to: viewModel.saveTrigger)
            .disposed(by: disposeBag)
        pageHeaderView.rx.buttonTrigger
            .bind(to: viewModel.tutorialTrigger)
            .disposed(by: disposeBag)
        viewModel.metrics
            .subscribe(onNext: { [weak self] metrics in
                self?.metricsButton.setTitle(from: metrics)
            })
            .disposed(by: disposeBag)
        viewModel.ringSize
            .bind(to: ringSizeLabel.rx.text)
            .disposed(by: disposeBag)
        modeSwitcherControl.addTarget(self, action: #selector(didChangedMode), for: .valueChanged)
    }

    @objc func didChangedMode(_ sender: BetterSegmentedControl) {
        ringSizerView.isHidden = sender.index != 0
        fingerSizerView.isHidden = sender.index == 0
        sender.index == 0 ? viewModel.sizerType.onNext(.ring) : viewModel.sizerType.onNext(.finger)
    }

    private func bindTableView() {

    }
}
