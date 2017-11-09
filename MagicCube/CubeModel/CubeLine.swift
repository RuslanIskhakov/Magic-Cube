//
//  CubeLine.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class CubeLine {
    let size: Int
    var orientation: CubeModel.LineOrientation
    var position: Int
    var cells: [CubeCell]
    
    public init?(position: Int, orientation: CubeModel.LineOrientation, size: Int) {
        if size>1 && position>=0 && position<size {
            self.position = position
            self.orientation = orientation
            self.size = size
            cells = [CubeCell]()
        } else {
            return nil
        }
    }
}
