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
        $0.backgroundColor = .clear
        $0.isOpaque = false
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "paper1")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let toolPicker = PKToolPicker().then {
        let penTool = PKInkingTool(.pen, color: .black, width: 10)
        $0.selectedTool = penTool
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        addSubview(canvasView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(canvasView)
        }
        
        canvasView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).multipliedBy(0.91)
        }
    }
}
