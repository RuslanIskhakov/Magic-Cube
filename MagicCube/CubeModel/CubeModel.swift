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
    
    enum CellEdgeType {
        case Edge
        case Corner
        case NonEdge
    }
    
    enum LineOrientation {
        case Horizontal
        case Vertical
    }
    
    public static let neighboringSides: Dictionary<Sides, [Sides]> = [
        Sides.Top: [.Left, .Rear, .Right, .Front],
        Sides.Front: [.Left, .Top, .Right, .Bottom],
        Sides.Rear: [.Right, .Top, .Left, .Bottom],
        Sides.Left: [.Rear, .Top, .Front, .Bottom],
        Sides.Right: [.Front, .Top, .Rear, .Bottom],
        Sides.Bottom: [.Left, .Front, .Right, .Rear]
    ]
    
    public static let sideColors: Dictionary<Sides, UIColor> = [
        Sides.Top: UIColor.white,
        Sides.Front: UIColor.red,
        Sides.Rear: UIColor.orange,
        Sides.Left: UIColor.green,
        Sides.Right: UIColor.blue,
        Sides.Bottom: UIColor.yellow
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
}
