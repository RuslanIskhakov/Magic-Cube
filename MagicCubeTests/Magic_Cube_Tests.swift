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
        
        var wrongCube = Cube.newSolvedCube(size: -1)
        XCTAssertNil(wrongCube)
        wrongCube = Cube.newSolvedCube(size: 0)
        XCTAssertNil(wrongCube)
        wrongCube = Cube.newSolvedCube(size: 1)
        XCTAssertNil(wrongCube)
        
        checkSolvedCube(cube: Cube.newSolvedCube(size: 2))
        checkSolvedCube(cube: Cube.newSolvedCube(size: 3))
        checkSolvedCube(cube: Cube.newSolvedCube(size: 4))
    }
    
    private func checkSolvedCube(cube: Cube?) {
        
        func checkSide(side: CubeModel.Sides, sides: [CubeModel.Sides: CubeSide]) {
            XCTAssert(sides.keys.contains(side))
            let cubeSide = sides[side]
            XCTAssertNotNil(cubeSide)
            XCTAssert(side==cubeSide?.side)
            let cells = cubeSide?.getCells()
            XCTAssertNotNil(cells)

            for row in 0..<cube!.size {
                for column in 0..<cube!.size{
                    let cell = cells![row][column]
                    XCTAssert(cell.color == CubeModel.sideColors[side])
                }
            }
        }
        
        XCTAssertNotNil(cube)
        
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
    
    func testCellName() {
        XCTAssertEqual("Top,0,0", CubeModel.getCellName(side: .Top, row: 0, column: 0))
        XCTAssertEqual("Top,3,1", CubeModel.getCellName(side: .Top, row: 3, column: 1))
        XCTAssertEqual("Bottom,10,2", CubeModel.getCellName(side: .Bottom, row: 10, column: 2))
        XCTAssertEqual("Left,18,13", CubeModel.getCellName(side: .Left, row: 18, column: 13))
        XCTAssertEqual("Right,5,11", CubeModel.getCellName(side: .Right, row: 5, column: 11))
        XCTAssertEqual("Front,7,7", CubeModel.getCellName(side: .Front, row: 7, column: 7))
        XCTAssertEqual("Rear,2,10", CubeModel.getCellName(side: .Rear, row: 2, column: 10))
        
        XCTAssert((CubeModel.Sides.Top, 0, 0) == CubeModel.parceCellName(name: "Top,0,0")!)
        XCTAssert((CubeModel.Sides.Bottom, 1, 0) == CubeModel.parceCellName(name: "Bottom,1,0")!)
        XCTAssert((CubeModel.Sides.Left, 20, 10) == CubeModel.parceCellName(name: "Left,20,10")!)
        XCTAssert((CubeModel.Sides.Right, 12, 10) == CubeModel.parceCellName(name: "Right,12,10")!)
        XCTAssert((CubeModel.Sides.Front, 0, 4) == CubeModel.parceCellName(name: "Front,0,4")!)
        XCTAssert((CubeModel.Sides.Rear, 14, 2) == CubeModel.parceCellName(name: "Rear,14,2")!)
        XCTAssert(nil == CubeModel.parceCellName(name: "First,0,0"))
        XCTAssert(nil == CubeModel.parceCellName(name: "Top,,0"))
        XCTAssert(nil == CubeModel.parceCellName(name: "Top,"))
        XCTAssert(nil == CubeModel.parceCellName(name: "Top,Second,Third"))
        XCTAssert(nil == CubeModel.parceCellName(name: ""))
        
    }
    
    func testCubeLine() {
        
        // red side
        let frontSide = CubeSide(side: .Front, size: 3)
        
        //white side
        let topSide = CubeSide(side: .Top, size: 3)
        
        //green side
        let leftSide = CubeSide(side: .Left, size: 3)
        
        var sidecells = frontSide?.getCells()
        for row in 0...2 {
            for column in 0...2 {
                let cell = sidecells?[row][column]
                XCTAssert(cell?.color == .Red)
            }
        }
        
        sidecells = topSide?.getCells()
        for row in 0...2 {
            for column in 0...2 {
                let cell = sidecells?[row][column]
                XCTAssert(cell?.color == .White)
            }
        }
        
        // red line
        let line1 = frontSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        var linecells = line1?.getCells()
        for i in 0...2 {
            let cell = linecells?[i]
            XCTAssert(cell?.color == .Red)
        }
        
        // in white side replace bottom line with red one
        let line2 = topSide?.pushLine(line: line1!, index: 2, orientation: .Horizontal, indexOrder: .Forward)
        linecells = line2?.getCells()
        for i in 0...2 {
            let cell = linecells?[i]
            XCTAssert(cell?.color == .White)
        }
        sidecells = topSide?.getCells()
        for row in 0...2 {
            for column in 0...2 {
                let cell = sidecells?[row][column]
                XCTAssert(cell?.color == (row==2 ? .Red : .White))
            }
        }
        
        // 1st column of white side, from bottom to top
        let line3 = topSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Backward)
        linecells = line3?.getCells()
        XCTAssert(linecells?[0].color == .Red)
        XCTAssert(linecells?[1].color == .White)
        XCTAssert(linecells?[2].color == .White)
        
        // 1st column of white side, from top to bottom
        let line4 = topSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        linecells = line4?.getCells()
        XCTAssert(linecells?[0].color == .White)
        XCTAssert(linecells?[1].color == .White)
        XCTAssert(linecells?[2].color == .Red)
        
        // replace central horizontal line of red side with line4, from left to right
        let line5 = frontSide?.pushLine(line: line4!, index: 1, orientation: .Horizontal, indexOrder: .Forward)
        linecells = line5?.getCells()
        for i in 0...2 {
            let cell = linecells?[i]
            XCTAssert(cell?.color == .Red)
        }
        sidecells = frontSide?.getCells()
        for row in 0...2 {
            if row==1 {
                linecells = sidecells?[1]
                XCTAssert(linecells?[0].color == .White)
                XCTAssert(linecells?[1].color == .White)
                XCTAssert(linecells?[2].color == .Red)
            } else {
                for column in 0...2 {
                    let cell = sidecells?[row][column]
                    XCTAssert(cell?.color == .Red)
                }
            }
        }
        
        // replace central horizontal line of red side with line4, from right to left
        let line6 = frontSide?.pushLine(line: line4!, index: 1, orientation: .Horizontal, indexOrder: .Backward)
        linecells = line6?.getCells()
        XCTAssert(linecells?[0].color == .Red)
        XCTAssert(linecells?[1].color == .White)
        XCTAssert(linecells?[2].color == .White)
        sidecells = frontSide?.getCells()
        for row in 0...2 {
            if row==1 {
                linecells = sidecells?[1]
                XCTAssert(linecells?[0].color == .Red)
                XCTAssert(linecells?[1].color == .White)
                XCTAssert(linecells?[2].color == .White)
            } else {
                for column in 0...2 {
                    let cell = sidecells?[row][column]
                    XCTAssert(cell?.color == .Red)
                }
            }
        }
        
        // replace 1st vertical line of red side with green cells, from top to bottom
        let line7 = leftSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        linecells = line7?.getCells()
        XCTAssert(linecells?[0].color == .Green)
        XCTAssert(linecells?[1].color == .Green)
        XCTAssert(linecells?[2].color == .Green)
        let line8 = frontSide?.pushLine(line: line7!, index: 0, orientation: .Vertical, indexOrder: .Forward)
        linecells = line8?.getCells()
        XCTAssert(linecells?[0].color == .Red)
        XCTAssert(linecells?[1].color == .Red)
        XCTAssert(linecells?[2].color == .Red)
        sidecells = frontSide?.getCells()
        for row in 0...2 {
            if row==1 {
                linecells = sidecells?[1]
                XCTAssert(linecells?[0].color == .Green)
                XCTAssert(linecells?[1].color == .White)
                XCTAssert(linecells?[2].color == .White)
            } else {
                for column in 0...2 {
                    let cell = sidecells?[row][column]
                    XCTAssert(cell?.color == (column == 0 ? .Green : .Red))
                }
            }
        }
    }
    
    func testSideTurn() {
        
        //cube of size 3
        // red side
        let frontSide = CubeSide(side: .Front, size: 3)
        
        //white side
        let topSide = CubeSide(side: .Top, size: 3)
        
        //green side
        let leftSide = CubeSide(side: .Left, size: 3)
        
        //blue side
        let rightSide = CubeSide(side: .Right, size: 3)
        
        var line = topSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        let _ = frontSide?.pushLine(line: line!, index: 0, orientation: .Vertical, indexOrder: .Forward)
        line = leftSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        let _ = frontSide?.pushLine(line: line!, index: 2, orientation: .Vertical, indexOrder: .Forward)
        line = rightSide?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        let _ = frontSide?.pushLine(line: line!, index: 1, orientation: .Horizontal, indexOrder: .Forward)
        
        XCTAssert(frontSide!.getCells()[0][0].color == .White)
        XCTAssert(frontSide!.getCells()[0][1].color == .Red)
        XCTAssert(frontSide!.getCells()[0][2].color == .Green)
        XCTAssert(frontSide!.getCells()[1][0].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][2].color == .Blue)
        XCTAssert(frontSide!.getCells()[2][0].color == .White)
        XCTAssert(frontSide!.getCells()[2][1].color == .Red)
        XCTAssert(frontSide!.getCells()[2][2].color == .Green)
        
        frontSide?.turnSide(direction: .Clockwise)
        
        XCTAssert(frontSide!.getCells()[0][0].color == .White)
        XCTAssert(frontSide!.getCells()[0][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[0][2].color == .White)
        XCTAssert(frontSide!.getCells()[1][0].color == .Red)
        XCTAssert(frontSide!.getCells()[1][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][2].color == .Red)
        XCTAssert(frontSide!.getCells()[2][0].color == .Green)
        XCTAssert(frontSide!.getCells()[2][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[2][2].color == .Green)
        
        frontSide?.turnSide(direction: .CounterClockwise)
        
        XCTAssert(frontSide!.getCells()[0][0].color == .White)
        XCTAssert(frontSide!.getCells()[0][1].color == .Red)
        XCTAssert(frontSide!.getCells()[0][2].color == .Green)
        XCTAssert(frontSide!.getCells()[1][0].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][2].color == .Blue)
        XCTAssert(frontSide!.getCells()[2][0].color == .White)
        XCTAssert(frontSide!.getCells()[2][1].color == .Red)
        XCTAssert(frontSide!.getCells()[2][2].color == .Green)
        
        frontSide?.turnSide(direction: .CounterClockwise)
        
        XCTAssert(frontSide!.getCells()[0][0].color == .Green)
        XCTAssert(frontSide!.getCells()[0][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[0][2].color == .Green)
        XCTAssert(frontSide!.getCells()[1][0].color == .Red)
        XCTAssert(frontSide!.getCells()[1][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[1][2].color == .Red)
        XCTAssert(frontSide!.getCells()[2][0].color == .White)
        XCTAssert(frontSide!.getCells()[2][1].color == .Blue)
        XCTAssert(frontSide!.getCells()[2][2].color == .White)
        
        //cube of size 4
        
        // red side
        let frontSide4 = CubeSide(side: .Front, size: 4)
        
        //white side
        let topSide4 = CubeSide(side: .Top, size: 4)
        
        let line4 = topSide4?.getLine(index: 0, orientation: .Vertical, indexOrder: .Forward)
        for i in 0...3 {
            let cell = line4?.getCells()[i]
            XCTAssert(cell!.color == .White)
        }
        
        let line5 = frontSide4?.pushLine(line: line4!, index: 0, orientation: .Horizontal, indexOrder: .Forward)
        XCTAssert(nil != line5)
        
        for row in 0...3 {
            for column in 0...3 {
                let cell = frontSide4?.getCells()[row][column]
                if 0==row {
                    XCTAssert(cell!.color == .White)
                } else {
                    XCTAssert(cell!.color == .Red)
                }
            }
        }
        
        frontSide4?.turnSide(direction: .Clockwise)
        for row in 0...3 {
            for column in 0...3 {
                let cell = frontSide4?.getCells()[row][column]
                if 3==column {
                    XCTAssert(cell!.color == .White)
                } else {
                    XCTAssert(cell!.color == .Red)
                }
            }
        }
        
        frontSide4?.turnSide(direction: .Clockwise)
        for row in 0...3 {
            for column in 0...3 {
                let cell = frontSide4?.getCells()[row][column]
                if 3==row {
                    XCTAssert(cell!.color == .White)
                } else {
                    XCTAssert(cell!.color == .Red)
                }
            }
        }
        
        frontSide4?.turnSide(direction: .Clockwise)
        for row in 0...3 {
            for column in 0...3 {
                let cell = frontSide4?.getCells()[row][column]
                if 0==column {
                    XCTAssert(cell!.color == .White)
                } else {
                    XCTAssert(cell!.color == .Red)
                }
            }
        }
        
        frontSide4?.turnSide(direction: .Clockwise)
        for row in 0...3 {
            for column in 0...3 {
                let cell = frontSide4?.getCells()[row][column]
                if 0==row {
                    XCTAssert(cell!.color == .White)
                } else {
                    XCTAssert(cell!.color == .Red)
                }
            }
        }
    }
    
    func testFinalIndexOrder() {
        XCTAssert(CubeModel.isInvertedDirection(gestureIsForward: true, indexOrder: .Forward) == false)
        XCTAssert(CubeModel.isInvertedDirection(gestureIsForward: true, indexOrder: .Backward) == true)
        XCTAssert(CubeModel.isInvertedDirection(gestureIsForward: false, indexOrder: .Forward) == true)
        XCTAssert(CubeModel.isInvertedDirection(gestureIsForward: false, indexOrder: .Backward) == false)
        
        XCTAssert(CubeModel.getFinalIndexOrder(isInvertedDirection: true, indexOrder: .Forward) == .Backward)
        XCTAssert(CubeModel.getFinalIndexOrder(isInvertedDirection:true, indexOrder: .Backward) == .Forward)
        XCTAssert(CubeModel.getFinalIndexOrder(isInvertedDirection:false, indexOrder: .Forward) == .Forward)
        XCTAssert(CubeModel.getFinalIndexOrder(isInvertedDirection: false, indexOrder: .Backward) == .Backward)
    }
    
    func testRandomTurns() {
        randomTurns(size: 2)
        randomTurns(size: 3)
        randomTurns(size: 4)
        randomTurns(size: 5)
        randomTurns(size: 6)
    }
    
    private func randomTurns(size: Int) {
        
        
        
        func checkTurnsForCube(_ cube: Cube?) {
            
            func checkTurnsForSide(cube: Cube?, side: CubeModel.Sides) {
                
                func makeSideForwardTurn(cube: Cube?, side: CubeModel.Sides) {
                    cube?.turnLine(side: side, index: 0, horizontal: true, forward: true)
                    cube?.turnLine(side: side, index: 0, horizontal: false, forward: true)
                }
                func makeSideBackwardTurn(cube: Cube?, side: CubeModel.Sides) {
                    cube?.turnLine(side: side, index: 0, horizontal: false, forward: false)
                    cube?.turnLine(side: side, index: 0, horizontal: true, forward: false)
                }
                
                makeSideForwardTurn(cube: cube, side: side)
                makeSideForwardTurn(cube: cube, side: side)
                makeSideForwardTurn(cube: cube, side: side)
                makeSideForwardTurn(cube: cube, side: side)
                
                makeSideBackwardTurn(cube: cube, side: side)
                makeSideBackwardTurn(cube: cube, side: side)
                makeSideBackwardTurn(cube: cube, side: side)
                makeSideBackwardTurn(cube: cube, side: side)
                
            }
            
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Top)
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Bottom)
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Left)
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Right)
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Front)
            checkSolvedCube(cube: cube)
            checkTurnsForSide(cube: cube, side: .Rear)
            checkSolvedCube(cube: cube)
        }
        
        let cube = Cube.newSolvedCube(size: size)
        checkTurnsForCube(cube)
        
        
        let sides = [CubeModel.Sides.Top, CubeModel.Sides.Bottom, CubeModel.Sides.Front, CubeModel.Sides.Rear, CubeModel.Sides.Left, CubeModel.Sides.Right]
        
        var turns = [CubeModel.LineTurnParameters]()
        
        for _ in 0...59 {
            turns.append(CubeModel.LineTurnParameters(
                side: sides[Int(arc4random_uniform(6))],
                index: Int(arc4random_uniform(UInt32(size))),
                horizontal: (Int(arc4random_uniform(2)) == 1),
                forward: (Int(arc4random_uniform(2)) == 1)
            ))
        }
        
        for i in 0...59 {
            print(turns[i])
            let turn = turns[i]
            cube?.turnLine(side: turn.side, index: turn.index, horizontal: turn.horizontal, forward: turn.forward)
        }
        for i in 0...59 {
            let turn = turns[59 - i].getReverseTurnParameters()
            cube?.turnLine(side: turn.side, index: turn.index, horizontal: turn.horizontal, forward: turn.forward)
        }
        checkSolvedCube(cube: cube)
 
    }
}
