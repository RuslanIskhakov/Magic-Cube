//
//  CubeModel.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import UIKit
import Foundation

struct CubeModel {
    
    public static let ScaleUnit: Float = 2
    public static let CellThicknessMultiplier: Float = 0.075
    public static let CellBaseChamferMultiplier: Float = 0.05
    public static let CellBaseSizeMultiplier: Float = 1.01
    public static let CellChamferMultiplier: Float = 0.1
    public static let CellWidthMultiplier: Float = 0.85
    
    public static let CellBaseSize = CGFloat(ScaleUnit * CellBaseSizeMultiplier)
    public static let CellbaseChamferRadius = CGFloat(ScaleUnit * CellBaseChamferMultiplier)
    public static let CellWidth = CGFloat(ScaleUnit * CellWidthMultiplier)
    public static let CellChamferRadius = CGFloat(ScaleUnit * CellChamferMultiplier)
    public static let CellThickness = CGFloat(ScaleUnit * CellThicknessMultiplier)
    
    enum Sides {
        case Top
        case Front
        case Rear
        case Left
        case Right
        case Bottom
    }
    
    enum LineOrientation {
        case Horizontal
        case Vertical
    }
    
    enum PanGestureType {
        case None
        case CubeMove
        case GeometryRotate
    }
    
    enum SideTurnDirections {
        case Clockwise
        case CounterClockwise
    }
    
    public static let neighboringSides: Dictionary<Sides, [Sides]> = [
        Sides.Top: [.Left, .Rear, .Right, .Front],
        Sides.Front: [.Left, .Top, .Right, .Bottom],
        Sides.Rear: [.Right, .Top, .Left, .Bottom],
        Sides.Left: [.Rear, .Top, .Front, .Bottom],
        Sides.Right: [.Front, .Top, .Rear, .Bottom],
        Sides.Bottom: [.Left, .Front, .Right, .Rear]
    ]
    
    enum Colors {
        case White
        case Red
        case Orange
        case Green
        case Blue
        case Yellow
    }
    
    public static let cellColors: [Colors: UIColor] = [
        .White: UIColor.white,
        .Red: UIColor.red,
        .Orange: UIColor.orange,
        .Green: UIColor.green,
        .Blue: UIColor.blue,
        .Yellow: UIColor.yellow
    ]
    
    public static let sideColors: Dictionary<Sides, Colors> = [
        Sides.Top: .White,
        Sides.Front: .Red,
        Sides.Rear: .Orange,
        Sides.Left: .Green,
        Sides.Right: .Blue,
        Sides.Bottom: .Yellow
    ]
    
    public static let sideToCodeName: Dictionary<Sides, String> = [
        Sides.Top: "Top",
        Sides.Front: "Front",
        Sides.Rear: "Rear",
        Sides.Left: "Left",
        Sides.Right: "Right",
        Sides.Bottom: "Bottom"
    ]
    
    public static let codeNameToSide: Dictionary<String, Sides> = [
        "Top": Sides.Top,
        "Front": Sides.Front,
        "Rear": Sides.Rear,
        "Left": Sides.Left,
        "Right": Sides.Right,
        "Bottom": Sides.Bottom
    ]
    
    public static func getCubeRenderingCoordinatesShift(cubeSize: Int) -> Float {
        return Float(cubeSize - 1)*CubeModel.ScaleUnit*0.5
    }
    
    // x and y - cell coordinates within a side, starting from left top corner of the side
    // parameters of function:
    public static func getCellRenderCoordinates(side: Sides, cubeSize: Int, x: Int, y: Int, shift: Float) -> (x: Float, y: Float, z: Float) {
        switch side {
            case .Top:
                return (
                    ScaleUnit * Float(x) - shift,
                    ScaleUnit * (Float(cubeSize) - 0.5) - shift,
                    ScaleUnit * Float(y) - shift
            )
            case .Bottom:
                return (
                    ScaleUnit * Float(x) - shift,
                    ScaleUnit * (0.5 - Float(cubeSize)) + shift,
                    -ScaleUnit * Float(y) + shift
                )
            case .Front:
                return (
                    ScaleUnit * Float(x) - shift,
                    ScaleUnit * Float(cubeSize - y - 1) - shift,
                    ScaleUnit * (Float(cubeSize) - 0.5) - shift
            )
            case .Rear:
                return (
                    ScaleUnit * Float(cubeSize - x - 1) - shift,
                    ScaleUnit * Float(cubeSize - y - 1) - shift,
                    ScaleUnit * (0.5 - Float(cubeSize)) + shift
                )
            case .Left:
                return (
                    ScaleUnit * (0.5 - Float(cubeSize)) + shift,
                    ScaleUnit * Float(cubeSize - y - 1) - shift,
                    ScaleUnit * Float(x) - shift
                )
            case .Right:
                return (
                    ScaleUnit * (Float(cubeSize) - 0.5) - shift,
                    ScaleUnit * Float(cubeSize - y - 1) - shift,
                    -ScaleUnit * Float(x) + shift
                )
        
        }
    }
    
    public static let Cell3DSizes: [Sides: (xSize: CGFloat, ySize: CGFloat, zSize: CGFloat)] = [
        .Top: (CellWidth, CellThickness, CellWidth),
        .Bottom: (CellWidth, CellThickness, CellWidth),
        .Front: (CellWidth, CellWidth, CellThickness),
        .Rear: (CellWidth, CellWidth, CellThickness),
        .Left: (CellThickness, CellWidth, CellWidth),
        .Right: (CellThickness, CellWidth, CellWidth)
    ]
    
    public static func getCellName(side: Sides, row: Int, column:Int) -> String {
        var result = sideToCodeName[side]
        result! += "," + String(row)
        result! += "," + String(column)
        return result!
    }
    
    public static func parceCellName(name: String) -> (side: Sides, row: Int, column: Int)? {
        let parsedItems = name.components(separatedBy: ",")
        if 3==parsedItems.count {
            if  codeNameToSide.keys.contains(parsedItems[0]) {
                let row = Int(parsedItems[1])
                let column = Int(parsedItems[2])
                if nil != row && nil != column {
                    return (codeNameToSide[parsedItems[0]]!, row!, column!)
                }
            }
        }
        return nil
    }
    
    enum CellsIndexOrder {
        case Forward
        case Backward
    }
    
    struct LineTurnInfo {
        let side: Sides
        let lineOrientation: LineOrientation //within a side
        let indexOrder: CellsIndexOrder //Starting from plane
        let cellsIndexOrder: CellsIndexOrder //Clockwise direction
    }
    
    enum Planes {
        case VerticalFront
        case VerticalSide
        case Horizontal
    }
    
    public static let SidesToPlainMapping: [Sides: Planes] = [
        .Front: .VerticalFront,
        .Rear: .VerticalFront,
        .Top: .Horizontal,
        .Bottom: .Horizontal,
        .Left: .VerticalSide,
        .Right: .VerticalSide
    ]
    
    public static let SideLinesToPlanesMapping: [Sides: [LineOrientation: Planes]] = [
        .Front: [
            .Vertical: .VerticalSide,
            .Horizontal: .Horizontal
        ],
        .Rear: [
            .Vertical: .VerticalSide,
            .Horizontal: .Horizontal
        ],
        .Top: [
            .Vertical: .VerticalSide,
            .Horizontal: .VerticalFront
        ],
        .Bottom: [
            .Vertical: .VerticalSide,
            .Horizontal: .VerticalFront
        ],
        .Left: [
            .Vertical: .VerticalFront,
            .Horizontal: .Horizontal
        ],
        .Right: [
            .Vertical: .VerticalFront,
            .Horizontal: .Horizontal
        ],
    ]
    
    public static let PlanesTurnMaps: [Planes: [LineTurnInfo]] = [
        .VerticalFront: [
            LineTurnInfo(side: .Top, lineOrientation: .Horizontal, indexOrder: .Backward, cellsIndexOrder: .Forward),
            LineTurnInfo(side: .Right, lineOrientation: .Vertical, indexOrder: .Forward, cellsIndexOrder: .Forward),
            LineTurnInfo(side: .Bottom, lineOrientation: .Horizontal, indexOrder: .Forward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Left, lineOrientation: .Vertical, indexOrder: .Backward, cellsIndexOrder: .Backward)
        ],
        .VerticalSide: [
            LineTurnInfo(side: .Top, lineOrientation: .Vertical, indexOrder: .Backward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Rear, lineOrientation: .Vertical, indexOrder: .Forward, cellsIndexOrder: .Forward),
            LineTurnInfo(side: .Bottom, lineOrientation: .Vertical, indexOrder: .Backward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Front, lineOrientation: .Vertical, indexOrder: .Backward, cellsIndexOrder: .Backward)
        ],
        .Horizontal: [
            LineTurnInfo(side: .Right, lineOrientation: .Horizontal, indexOrder: .Forward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Front, lineOrientation: .Horizontal, indexOrder: .Forward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Left, lineOrientation: .Horizontal, indexOrder: .Forward, cellsIndexOrder: .Backward),
            LineTurnInfo(side: .Rear, lineOrientation: .Horizontal, indexOrder: .Forward, cellsIndexOrder: .Backward)
        ],
    ]
    
    public static func isInvertedDirection(gestureIsForward: Bool, indexOrder: CubeModel.CellsIndexOrder) -> Bool {
        return (gestureIsForward != (indexOrder == .Forward))
    }
    
    public static func getFinalIndexOrder(isInvertedDirection: Bool, indexOrder: CubeModel.CellsIndexOrder) -> CubeModel.CellsIndexOrder {
        return (isInvertedDirection ? (indexOrder == .Forward ? .Backward : .Forward) : indexOrder)
    }
    
    struct LineTurnParameters {
        let side: Sides
        let index: Int
        let horizontal: Bool
        let forward: Bool
        
        public func getReverseTurnParameters() -> LineTurnParameters {
            return LineTurnParameters(side: side, index: index, horizontal: horizontal, forward: !forward)
        }
        
        public func debugDescription() -> String {
            return "Side: \(side), index: \(index), horizontal: \(horizontal), forward: \(forward)"
        }
    }
}
