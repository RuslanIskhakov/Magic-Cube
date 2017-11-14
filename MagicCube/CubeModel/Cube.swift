//
//  Cube.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import UIKit
import Foundation

class Cube {
    let size: Int
    private var sides: [CubeModel.Sides: CubeSide]
    
    public static func newSolvedCube(size: Int) -> Cube?{
        let cube = Cube(size: size)
        if nil != cube {
            cube?.sides[CubeModel.Sides.Top] = CubeSide.newSolvedSide(side: CubeModel.Sides.Top, size: size)
            cube?.sides[CubeModel.Sides.Bottom] = CubeSide.newSolvedSide(side: CubeModel.Sides.Bottom, size: size)
            cube?.sides[CubeModel.Sides.Front] = CubeSide.newSolvedSide(side: CubeModel.Sides.Front, size: size)
            cube?.sides[CubeModel.Sides.Rear] = CubeSide.newSolvedSide(side: CubeModel.Sides.Rear, size: size)
            cube?.sides[CubeModel.Sides.Left] = CubeSide.newSolvedSide(side: CubeModel.Sides.Left, size: size)
            cube?.sides[CubeModel.Sides.Right] = CubeSide.newSolvedSide(side: CubeModel.Sides.Right, size: size)
        }
        return cube
    }
    
    init?(size: Int) {
        if size>1 {
            self.size = size
            self.sides = [CubeModel.Sides: CubeSide]()
        } else {
            return nil
        }
    }
    
    public func getSides() -> [CubeModel.Sides: CubeSide] {
        return sides
    }
    
    public func turnLine(_ cells: [String]){
        if cells.count == 2 {
            let cell1 = CubeModel.parceCellName(name: cells[0])
            let cell2 = CubeModel.parceCellName(name: cells[1])
            
            if let c1 = cell1 {
                if let c2 = cell2 {
                    if c1.side == c2.side {
                        if c1.row == c2.row && c1.column != c2.column {
                            turnHorizontalLine(side: c1.side, row: c1.row, forward: c2.column > c1.column)
                        } else if c1.row != c2.row && c1.column == c2.column {
                            turnVerticalLine(side: c1.side, column: c1.column, forward: c2.row > c1.row)
                        }
                    }
                }
            }
        }
    }
    
    private func turnHorizontalLine(side: CubeModel.Sides, row: Int, forward: Bool) {
        print("Turn horizontal line: \(side), \(row), \(forward)")
    }
    
    private func turnVerticalLine(side: CubeModel.Sides, column: Int, forward: Bool) {
        print("Turn vertical line: \(side), \(column), \(forward)")
    }
}
