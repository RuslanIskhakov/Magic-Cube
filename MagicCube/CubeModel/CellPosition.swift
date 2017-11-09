//
//  CellPosition.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

struct CellPosition {
    var row: Int
    var column: Int
    var cubeSize: Int
    
    public func getCellEdgeType() -> CubeModel.CellEdgeType? {
        if (cubeSize>1) {
            if 0==row || row==cubeSize-1 {
                if 0==column || column==cubeSize-1 {
                    return CubeModel.CellEdgeType.Corner
                }
                return CubeModel.CellEdgeType.Edge
            } else if 0==column || column==cubeSize-1 {
                return CubeModel.CellEdgeType.Edge
            } else {
                return CubeModel.CellEdgeType.NonEdge
            }
        } else {
            return nil
        }
    }
}
