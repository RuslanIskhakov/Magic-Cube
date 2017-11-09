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
}
