//
//  ModelProtocol.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

protocol ModelProtocol: class {
    init?(cubeSize: Int)
    func getCubeSize() -> Int
    func getCube() -> Cube?
}
