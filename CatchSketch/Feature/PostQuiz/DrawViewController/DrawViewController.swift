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
    private let viewModel: DrawViewModel
    private let disposeBag = DisposeBag()
    private let drawingChangedSubject = PublishSubject<PKDrawing>()
    var saveCompletionHandler: ((PKDrawing, UIImage) -> Void)?
    
    private lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    }()

    init(rootView: DrawView, viewModel: DrawViewModel) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupNavigationItem()
        bindViewModel()
    }
    
    private func setupCanvas() {
        rootView.canvasView.delegate = self
        rootView.toolPicker.addObserver(rootView.canvasView)
        rootView.toolPicker.setVisible(true, forFirstResponder: rootView.canvasView)
        rootView.canvasView.becomeFirstResponder()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    private func bindViewModel() {
        let input = DrawViewModel.Input(
            saveButtonTapped: saveButton.rx.tap.asObservable(),
            drawingChanged: drawingChangedSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.initialDrawing
            .compactMap { $0 }
            .take(1)
            .subscribe(onNext: { [weak self] drawing in
                self?.rootView.canvasView.drawing = drawing
            })
            .disposed(by: disposeBag)
        
        output.dismissTrigger
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.savedDrawingAndImage
            .subscribe(onNext: { [weak self] drawing, image in
                self?.saveCompletionHandler?(drawing, image)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backButtonTapped() {
        let alertController = UIAlertController(title: "그리기 취소", message: "그리던 내용이 사라집니다\n그래도 뒤로갈래요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let backAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(backAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension DrawViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        viewModel.currentDrawing.accept(canvasView.drawing)
    }
}

//extension Reactive where Base: PKCanvasView {
//    var drawing: Binder<PKDrawing> {
//        return Binder(self.base) { canvasView, drawing in
//            canvasView.drawing = drawing
//        }
//    }
//    
//    var drawingChanged: Observable<PKDrawing> {
//        return Observable.create { [weak base] observer in
//            guard let base = base else {
//                observer.onCompleted()
//                return Disposables.create()
//            }
//            
//            let delegate = PKCanvasViewDelegateProxy.proxy(for: base)
//            delegate.drawingChangedHandler = { drawing in
//                observer.onNext(drawing)
//            }
//            
//            return Disposables.create()
//        }
//    }
//}
//
//class PKCanvasViewDelegateProxy: DelegateProxy<PKCanvasView, PKCanvasViewDelegate>, DelegateProxyType, PKCanvasViewDelegate {
//    var drawingChangedHandler: ((PKDrawing) -> Void)?
//    
//    static func registerKnownImplementations() {
//        self.register { PKCanvasViewDelegateProxy(parentObject: $0, delegateProxy: PKCanvasViewDelegateProxy.self) }
//    }
//    
//    static func currentDelegate(for object: PKCanvasView) -> PKCanvasViewDelegate? {
//        return object.delegate
//    }
//    
//    static func setCurrentDelegate(_ delegate: PKCanvasViewDelegate?, to object: PKCanvasView) {
//        object.delegate = delegate
//    }
//    
//    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
//        drawingChangedHandler?(canvasView.drawing)
//    }
//}
