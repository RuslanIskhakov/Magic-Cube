//
//  CubeSide.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class CubeSide {
    let size: Int
    let side: CubeModel.Sides
    private var cells: [[CubeCell]]
    
    public static func newSolvedSide(side: CubeModel.Sides, size: Int) -> CubeSide? {
        let cubeSide = CubeSide(side: side, size: size)
        return cubeSide
    }
    
    public init?(side: CubeModel.Sides, size: Int) {
        if size>1 {
            self.side = side
            self.size = size
            cells = Array(repeating: Array(repeating: CubeCell(side: side), count: size), count: size)
        } else {
            return nil
        }
    }
    
    public func getCells() -> [[CubeCell]] {
        return cells
    }
    
    public func getLine(index: Int, orientation: CubeModel.LineOrientation, indexOrder: CubeModel.CellsIndexOrder) -> CubeLine? {
        return CubeLine(side:self, index: index, orientation: orientation, indexOrder: indexOrder)
    }
    
    // returns a line has been replaced with specified by line parameter
    public func pushLine(line: CubeLine, index: Int, orientation: CubeModel.LineOrientation, indexOrder: CubeModel.CellsIndexOrder) -> CubeLine? {
        if line.size == self.size && line.getIndex()>=0 && line.getIndex()<line.size && index>=0 && index<self.size{
            let result = getLine(index: index, orientation: orientation, indexOrder: indexOrder)
            
            for i in 0..<size {
                let columnIndex = (orientation == .Horizontal ? (indexOrder == .Forward ? i : size - i - 1) : index)
                let rowIndex = (orientation == .Vertical ? (indexOrder == .Forward ? i : size - i - 1) : index)
                cells[rowIndex][columnIndex] = line.getCells()[i]
            }
            
            return result
        } else {
            return nil
        }
    }
    
    public func turnSide(direction: CubeModel.SideTurnDirections) {
        let columnsInQuarter = size/2
        let rowsInQuarter = (size%2 == 0 ? size/2 : size/2+1)
        
        for row in 0..<rowsInQuarter {
            for column in 0..<columnsInQuarter {
                
                // from top-left quarter
                let cell1 = cells[row][column]
                let cell2 = cells[column][size - row - 1]
                let cell3 = cells[size - row - 1][size - column - 1]
                let cell4 = cells[size - column - 1][row]
                
                switch direction {
                    case .Clockwise:
                        cells[column][size - row - 1] = cell1
                        cells[size - row - 1][size - column - 1] = cell2
                        cells[size - column - 1][row] = cell3
                        cells[row][column] = cell4
                    case .CounterClockwise:
                        cells[size - column - 1][row] = cell1
                        cells[row][column] = cell2
                        cells[column][size - row - 1] = cell3
                        cells[size - row - 1][size - column - 1] = cell4
                }
            }
        }
    }
}
