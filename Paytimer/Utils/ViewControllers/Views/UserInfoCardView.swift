import UIKit
import SnapKit

class UserInfoCardView: UIView {
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var currentTimeLabel = createInfoLabel()
    private lazy var joinDateLabel = createInfoLabel()
    private lazy var salaryLabel = createInfoLabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func update(with settings: UserSettings) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentTimeLabel.text = "当前时间：" + dateFormatter.string(from: Date())
        
        joinDateLabel.text = "入职时间：" + settings.joinDate
        
        let salary = settings.hideAllMoney ? "****" : String(format: "¥%.2f", settings.monthlySalary)
        salaryLabel.text = "月薪：" + salary
    }
}

// MARK: - Private Methods
private extension UserInfoCardView {
    func setupUI() {
        backgroundColor = Theme.cardBackground
        layer.cornerRadius = Theme.cornerRadius
        layer.shadowColor = Theme.cardShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.padding)
        }
        
        [currentTimeLabel, joinDateLabel, salaryLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func createInfoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Theme.textPrimary
        label.font = .systemFont(ofSize: 16)
        return label
    }
} 