//
//  CubeLine.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class CubeLine {
    let size: Int
    private var orientation: CubeModel.LineOrientation
    private var index: Int
    private var cells: [CubeCell]
    
    public init?(side: CubeSide, index: Int, orientation: CubeModel.LineOrientation, indexOrder: CubeModel.CellsIndexOrder) {
        if side.size>1 && index>=0 && index<side.size{
            self.index = index
            self.orientation = orientation
            self.size = side.size
            cells = Array(repeating: CubeCell(side: side.side), count: size)
            for i in 0..<size {
                let columnIndex = (orientation == .Horizontal ? (indexOrder == .Forward ? i : size - i - 1) : index)
                let rowIndex = (orientation == .Vertical ? (indexOrder == .Forward ? i : size - i - 1) : index)
                let cell = side.getCells()[rowIndex][columnIndex]
                cells[i] = cell
            }
        } else {
            return nil
        }
    }
    
    public func getOrientation() -> CubeModel.LineOrientation {
        return orientation
    }
    
    public func getIndex() -> Int {
        return index
    }
    
    public func getCells() -> [CubeCell] {
        return cells
    }
}
