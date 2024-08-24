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
    
    let toolPicker = PKToolPicker().then {
        let penTool = PKInkingTool(.pen, color: .black, width: 10)
        $0.selectedTool = PKInkingTool(.pen, color: .black, width: 10)
    }
    
    override func configureHierarchy() {
        addSubview(canvasView)
    }
    
    override func configureLayout() {
        canvasView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).multipliedBy(0.91)
            
        }
    }
}
