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
    let color: CubeModel.Colors
    
    public init(color: CubeModel.Colors) {
        self.color = color
    }
    
    public init(side: CubeModel.Sides) {
        self.color = CubeModel.sideColors[side]!
    }
}
