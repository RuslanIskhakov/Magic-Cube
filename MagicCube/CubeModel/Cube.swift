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
}
