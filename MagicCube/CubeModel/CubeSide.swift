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
    private var cells: [CubeCell]
    
    public static func newSolvedSide(side: CubeModel.Sides, size: Int) -> CubeSide? {
        let cubeSide = CubeSide(side: side, size: size)
        if nil != cubeSide {
            for i in 0..<size {
                for j in 0..<size {
                    cubeSide?.cells.insert(CubeCell(side: side, row: i, column: j, cubeSize: size)!, at: i*size + j)
                }
            }
        }
        return cubeSide
    }
    
    public init?(side: CubeModel.Sides, size: Int) {
        if size>1 {
            self.side = side
            self.size = size
            self.cells = [CubeCell]()
        } else {
            return nil
        }
    }
    
    public func getCells() -> [CubeCell] {
        return cells
    }
}
