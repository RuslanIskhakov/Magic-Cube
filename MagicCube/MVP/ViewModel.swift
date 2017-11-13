//
//  Model.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class ViewModel: ModelProtocol{

    private var cube: Cube?
    private var cubeSize: Int
    
    required init?(cubeSize: Int) {
        self.cubeSize = cubeSize
        cube = Cube.newSolvedCube(size: cubeSize)
        if nil == cube {
            return nil
        }
    }

    func getCubeSize() -> Int {
        return cubeSize
    }
    
    func getCube() -> Cube? {
        return cube
    }
}
