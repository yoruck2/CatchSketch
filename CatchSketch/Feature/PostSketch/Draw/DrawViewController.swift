//
//  DrawViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/22/24.
//

import UIKit
import PencilKit
import RxSwift
import RxCocoa

class DrawViewController: BaseViewController<DrawView> {
    let viewModel = DrawViewModel()
    private let disposeBag = DisposeBag()
    
    private let drawingChanged = PublishSubject<PKDrawing>()
    private let canvasRect = BehaviorSubject<CGRect>(value: .zero)
    var saveCompletionHandler: ((PKDrawing, UIImage) -> Void)?
    
    private lazy var saveButton: UIBarButtonItem = {
        UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        UIBarButtonItem(title: "뒤로", style: .plain, target: nil, action: nil)
    }()
    
    init(rootView: DrawView, initialDrawing: PKDrawing?) {
        super.init(rootView: rootView)
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = backButton
        
        bindViewModel(initialDrawing: initialDrawing)
        setupCanvas()
    }
    
    // 화면 레이아웃이 완료되면, 캔버스의 현재 크기와 위치 정보를 가지고 구독한 곳에 알려준다
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvasRect.onNext(rootView.canvasView.bounds)
    }
    
    private func setupCanvas() {
        rootView.canvasView.delegate = self
        rootView.toolPicker.addObserver(rootView.canvasView)
        rootView.toolPicker.setVisible(true, forFirstResponder: rootView.canvasView)
        rootView.canvasView.becomeFirstResponder()
    }
    
    private func bindViewModel(initialDrawing: PKDrawing?) {
        let input = DrawViewModel.Input(
            saveButtonTapped: saveButton.rx.tap,
            backButtonTapped: backButton.rx.tap,
            drawingChanged: drawingChanged,
            viewWillAppear: rx.viewWillAppear,
            canvasBounds: canvasRect,
            initialDrawing: initialDrawing
        )
        
        let output = viewModel.transform(input: input)
        
        output.initialDrawing
            .drive(onNext: { [weak self] drawing in
                self?.rootView.canvasView.drawing = drawing ?? PKDrawing()
            })
            .disposed(by: disposeBag)
        
        output.dismissTrigger
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.savedDrawingAndImage
            .drive(onNext: { [weak self] drawing, image in
                self?.saveCompletionHandler?(drawing, image)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showBackAlert
            .drive(onNext: { [weak self] in
                self?.showBackAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func showBackAlert() {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let backAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        showAlert(title: "그리기 취소", message: "그리던 내용이 사라집니다\n그래도 뒤로갈래요?",actions: [cancelAction, backAction])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged.onNext(canvasView.drawing)
    }
}
