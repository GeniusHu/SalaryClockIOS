import UIKit
import SnapKit

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private let userSettings = UserDefaultsManager.shared.getUserSettings()
    private let calculator = EarningsCalculator.shared
    private var timer: Timer?
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Theme.background
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.background
        return view
    }()
    
    private lazy var userInfoCard: UserInfoCardView = {
        let view = UserInfoCardView()
        return view
    }()
    
    private lazy var countdownView: CountdownView = {
        let view = CountdownView()
        return view
    }()
    
    private lazy var earningsView: EarningsView = {
        let view = EarningsView()
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    deinit {
        timer?.invalidate()
    }
}

// MARK: - UI Setup
private extension DashboardViewController {
    func setupUI() {
        view.backgroundColor = Theme.background
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        title = NSLocalizedString("dashboard.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(userInfoCard)
        containerView.addSubview(countdownView)
        containerView.addSubview(earningsView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        userInfoCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.padding)
            make.left.right.equalToSuperview().inset(Theme.padding)
        }
        
        countdownView.snp.makeConstraints { make in
            make.top.equalTo(userInfoCard.snp.bottom).offset(Theme.padding)
            make.left.right.equalToSuperview().inset(Theme.padding)
        }
        
        earningsView.snp.makeConstraints { make in
            make.top.equalTo(countdownView.snp.bottom).offset(Theme.padding)
            make.left.right.equalToSuperview().inset(Theme.padding)
            make.bottom.equalToSuperview().offset(-Theme.padding)
        }
    }
}

// MARK: - Timer & Updates
private extension DashboardViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        let currentDate = Date()
        userInfoCard.update(with: userSettings)
        countdownView.update(with: currentDate)
        
        let earnings = calculateEarnings(for: currentDate)
        earningsView.update(with: earnings, hideAmount: userSettings.hideAllMoney)
    }
    
    func calculateEarnings(for date: Date) -> Earnings {
        // TODO: 实现具体的收入计算逻辑
        return .zero
    }
} 