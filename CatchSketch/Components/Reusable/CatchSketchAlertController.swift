//
//  CatchSketchAlertController.swift
//  CatchSketch
//
//  Created by dopamint on 8/31/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CatchSketchAlertController: UIViewController {
    
    enum ButtonStyle {
        case clear
        case destructive
        case filled
    }
    
    private let disposeBag = DisposeBag()
    private var confirmAction: ((String) -> Observable<Void>)?
    
    private let backgroundView = UIView()
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private var titleLabel: UILabel?
    private var messageLabel: UILabel?
    private var textField: UITextField?
    private var buttons: [UIButton] = []
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(contentView)
        
        [titleLabel, messageLabel, textField].compactMap { $0 }.forEach { contentView.addSubview($0) }
        buttons.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.8)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var lastView: UIView?
        
        [titleLabel, messageLabel, textField].compactMap { $0 }.forEach { view in
            view.snp.makeConstraints { make in
                if let lastView = lastView {
                    make.top.equalTo(lastView.snp.bottom).offset(15)
                } else {
                    make.top.equalToSuperview().offset(20)
                }
                make.leading.trailing.equalToSuperview().inset(20)
                if view is UITextField {
                    make.height.equalTo(44)
                }
            }
            lastView = view
        }
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo((lastView ?? contentView).snp.bottom).offset(20)
                } else {
                    make.top.equalTo(buttons[index-1].snp.top)
                    make.width.equalTo(buttons[index-1])
                }
                
                if buttons.count == 1 {
                    make.leading.trailing.equalToSuperview().inset(20)
                } else if index == 0 {
                    make.leading.equalToSuperview().offset(20)
                    make.trailing.equalTo(view.snp.centerX).offset(-4)
                } else {
                    make.leading.equalTo(view.snp.centerX).offset(4)
                    make.trailing.equalToSuperview().offset(-20)
                }
                
                make.height.equalTo(44)
                if index == buttons.count - 1 {
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
        }
    }
    
    func addTitle(_ title: String) -> Self {
        titleLabel = UILabel().then {
            $0.text = title
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 18, weight: .bold)
        }
        return self
    }
    
    
    func addMessage(_ message: String) -> Self {
        messageLabel = UILabel().then {
            $0.text = message
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 0
        }
        return self
    }
    
    func addTextField(placeholder: String = "입력하세요") -> Self {
        textField = UITextField().then {
            $0.borderStyle = .roundedRect
            $0.placeholder = placeholder
        }
        return self
    }
    
    func getTextFieldText() -> String? {
        return textField?.text
    }
    
    func addButton(title: String,
                   style: ButtonStyle = .clear,
                   handler: (() -> Void)? = nil,
                   rxHandler: ((String) -> Observable<String>)? = nil) -> Self {
        let button = UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            switch style {
            case .clear:
                $0.setTitleColor(.mainGreen, for: .normal)
                $0.backgroundColor = .clear
            case .destructive:
                $0.setTitleColor(.white, for: .normal)
                $0.backgroundColor = .alertRed
            case .filled:
                $0.setTitleColor(.white, for: .normal)
                $0.backgroundColor = .mainGreen
            }
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = style == .clear ? 1 : 0
            $0.layer.borderColor = CatchSketch.Color.mainGreen.cgColor
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        }
        
        if let handler = handler {
            button.rx.tap
                .bind(onNext: handler)
                .disposed(by: disposeBag)
        } else if let rxHandler = rxHandler {
            button.rx.tap
                .flatMap { [weak self] _ -> Observable<String> in
                    guard let self = self, let text = self.textField?.text else {
                        return Observable.empty()
                    }
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        self.view.shake()
                        self.view.makeToast("정답을 입력해 주세요! 😝")
                        return Observable.empty()
                    } else if  text.count > 13 {
                        self.view.shake()
                        self.view.makeToast("12글자 이내로 적어주세요! 😝")
                        return Observable.empty()
                    }
                    return rxHandler(text)
                }
                .subscribe(onNext: { [weak self] _ in
                    self?.dismiss(animated: true)
                })
                .disposed(by: disposeBag)
        }
        
        buttons.append(button)
        return self
    }
    
    static func create() -> CatchSketchAlertController {
        return CatchSketchAlertController()
    }
}
