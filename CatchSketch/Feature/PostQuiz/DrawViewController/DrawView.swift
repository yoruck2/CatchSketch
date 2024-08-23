//
//  DrawView.swift
//  CatchSketch
//
//  Created by dopamint on 8/22/24.
//

import Foundation
import Then
import PencilKit

class DrawView: BaseView {
    let canvasView = PKCanvasView().then {
        $0.drawingPolicy = .anyInput
    }
    
    let toolPicker = PKToolPicker()
    
    override func configureHierarchy() {
        addSubview(canvasView)
    }
    
    override func configureLayout() {
        canvasView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalToSuperview().inset(50)
        }
    }
}
