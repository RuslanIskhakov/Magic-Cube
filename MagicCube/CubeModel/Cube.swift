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
                            turnLine(side: c1.side, index: c1.row, horizontal: true, forward: c2.column > c1.column)
                        } else if c1.row != c2.row && c1.column == c2.column {
                            turnLine(side: c1.side, index: c1.column, horizontal: false, forward: c2.row > c1.row)
                        }
                    }
                }
            }
        }
    }
    
    public func turnLine(side: CubeModel.Sides, index: Int, horizontal: Bool, forward: Bool) {
        let plane = CubeModel.SideLinesToPlanesMapping[side]![(horizontal ? CubeModel.LineOrientation.Horizontal : CubeModel.LineOrientation.Vertical)]
        let planeTurnMaps = CubeModel.PlanesTurnMaps[plane!]
        var invertedDirection = false
        var planeIndex = 0
        for lineTurnInfo in planeTurnMaps! {
            if lineTurnInfo.side == side {
                invertedDirection = CubeModel.isInvertedDirection(gestureIsForward: forward, indexOrder: lineTurnInfo.cellsIndexOrder)
                planeIndex = getFinalLineIndex(index: index, order: lineTurnInfo.indexOrder)
                break
            }
        }
        
        var line = sides[planeTurnMaps![0].side]!.getLine(
            index: getFinalLineIndex(index: planeIndex, order: planeTurnMaps![0].indexOrder),
            orientation: planeTurnMaps![0].lineOrientation,
            indexOrder: CubeModel.getFinalIndexOrder(isInvertedDirection: invertedDirection, indexOrder: planeTurnMaps![0].cellsIndexOrder))
        for i in 0...3 {
            let sideindex = getFinalSideIndex(index: i, invertedDirection: invertedDirection)
            line = sides[planeTurnMaps![sideindex].side]!.pushLine(
                line: line!,
                index: getFinalLineIndex(index: planeIndex, order: planeTurnMaps![sideindex].indexOrder),
                orientation: planeTurnMaps![sideindex].lineOrientation,
                indexOrder: CubeModel.getFinalIndexOrder(isInvertedDirection: invertedDirection, indexOrder: planeTurnMaps![sideindex].cellsIndexOrder))
        }
        
        if 0 == index || index == size - 1 {
            let sideToTurn: CubeModel.Sides
            let direction: CubeModel.SideTurnDirections
            if 0 == index {
                sideToTurn = CubeModel.neighboringSides[side]![!horizontal ? 0 : 1]
                direction = (horizontal ? (forward ? CubeModel.SideTurnDirections.CounterClockwise : CubeModel.SideTurnDirections.Clockwise) : ((forward ? CubeModel.SideTurnDirections.Clockwise : CubeModel.SideTurnDirections.CounterClockwise)))
            } else {
                sideToTurn = CubeModel.neighboringSides[side]![!horizontal ? 2 : 3]
                direction = (horizontal ? (forward ? CubeModel.SideTurnDirections.Clockwise : CubeModel.SideTurnDirections.CounterClockwise) : ((forward ? CubeModel.SideTurnDirections.CounterClockwise : CubeModel.SideTurnDirections.Clockwise)))
            }
            sides[sideToTurn]!.turnSide(direction: direction)
        }
    }
    
    private func getFinalLineIndex(index: Int, order: CubeModel.CellsIndexOrder) -> Int {
        return (order == .Forward ? index : size - index - 1)
    }
    
    private func getFinalSideIndex(index: Int, invertedDirection: Bool) -> Int {
        var result = (invertedDirection ? 3 - index : index + 1)
        if result > 3 {
            result = 0
        }
        return result
    }
}
