//
//  Magic_Cube_Tests.swift
//  Magic CubeTests
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import XCTest
@testable import MagicCube

class Magic_Cube_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolvedCube() {
        
        func checkSolvedCube(size: Int) {
            
            func checkSide(side: CubeModel.Sides, sides: [CubeModel.Sides: CubeSide]) {
                XCTAssert(sides.keys.contains(side))
                let cubeSide = sides[side]
                XCTAssertNotNil(cubeSide)
                XCTAssert(size==cubeSide?.size)
                XCTAssert(side==cubeSide?.side)
                let cells = cubeSide?.getCells()
                XCTAssertNotNil(cells)
                let cellsNumber = cells?.count
                XCTAssertNotNil(cellsNumber)
                XCTAssert(size*size == cellsNumber!)
                
                var nonEdgeCells = 0
                var edgeCells = 0
                var cornerCells = 0
                
                var cellPositionsCounter = Array(repeating: 0, count: size*size)
                
                for cubeCell in cells! {
                    XCTAssert(CubeModel.sideColors[side] == cubeCell.color)
                    let position = cubeCell.getPosition()
                    XCTAssertNotNil(position)
                    XCTAssert(size==position?.cubeSize)
                    let row = position?.row
                    let column = position?.column
                    let edgeType = position?.getCellEdgeType()
                    XCTAssertNotNil(row)
                    XCTAssertNotNil(column)
                    XCTAssertNotNil(edgeType)
                    XCTAssert(row!>=0 && row!<size)
                    XCTAssert(column!>=0 && column!<size)
                    if (0 == row || row == size-1) {
                        if (0 == column || column == size-1) {
                            XCTAssert(CubeModel.CellEdgeType.Corner == edgeType)
                            cornerCells+=1
                        } else {
                            XCTAssert(CubeModel.CellEdgeType.Edge == edgeType)
                            edgeCells+=1
                        }
                    } else if (0 == column || column == size-1){
                        XCTAssert(CubeModel.CellEdgeType.Edge == edgeType)
                        edgeCells+=1
                    } else {
                        XCTAssert(CubeModel.CellEdgeType.NonEdge == edgeType)
                        nonEdgeCells+=1
                    }
                    cellPositionsCounter[row!*size + column!] += 1
                }
                XCTAssert(cornerCells == 4)
                XCTAssert(edgeCells == 4*(size - 2))
                XCTAssert(nonEdgeCells == size*size - 4*(size - 1))
                
                for count in cellPositionsCounter {
                    XCTAssert(1==count)
                }
            }
            
            var cube = Cube.newSolvedCube(size: size)
            XCTAssertNotNil(cube)
            XCTAssert(size==cube?.size)
            
            let sides = cube?.getSides()
            XCTAssertNotNil(sides)
            
            XCTAssert(6==sides?.count)
            checkSide(side: CubeModel.Sides.Top, sides: sides!)
            checkSide(side: CubeModel.Sides.Bottom, sides: sides!)
            checkSide(side: CubeModel.Sides.Front, sides: sides!)
            checkSide(side: CubeModel.Sides.Rear, sides: sides!)
            checkSide(side: CubeModel.Sides.Left, sides: sides!)
            checkSide(side: CubeModel.Sides.Right, sides: sides!)
        }
        
        var wrongCube = Cube.newSolvedCube(size: -1)
        XCTAssertNil(wrongCube)
        wrongCube = Cube.newSolvedCube(size: 0)
        XCTAssertNil(wrongCube)
        wrongCube = Cube.newSolvedCube(size: 1)
        XCTAssertNil(wrongCube)
        
        checkSolvedCube(size: 2)
        checkSolvedCube(size: 3)
        checkSolvedCube(size: 4)
    }
}
