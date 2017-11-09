//
//  Cell.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import UIKit
import Foundation

class CubeCell {
    let color: UIColor
    
    private var position: CellPosition? {
        didSet {
            edgeType = position?.getCellEdgeType()
        }
    }
    private var edgeType: CubeModel.CellEdgeType?
    
    public init?(color: UIColor) {
        if CubeModel.sideColors.values.contains(color) {
            self.color = color
            self.position = nil
            self.edgeType = nil
        } else {
            return nil
        }
    }
    
    public init(side: CubeModel.Sides) {
        self.color = CubeModel.sideColors[side]!
        self.position = nil
        self.edgeType = nil
    }
    
    public init?(side: CubeModel.Sides, row: Int, column: Int, cubeSize: Int) {
        if cubeSize>1 && row>=0 && row<cubeSize && column>=0 && column<cubeSize {
            self.color = CubeModel.sideColors[side]!
            self.position = CellPosition(row: row, column: column, cubeSize: cubeSize)
            self.edgeType = nil
        } else {
            return nil
        }
    }
    
    public func getPosition() -> CellPosition? {
        return position
    }
    
    public func getEdgeType() -> CubeModel.CellEdgeType? {
        return edgeType
    }
}
