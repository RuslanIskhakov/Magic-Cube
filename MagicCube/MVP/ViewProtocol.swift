//
//  ViewProtocol.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

protocol ViewProtocol: class {
    func applicationDidEnterBackground()
    func isViewSetUp() -> Bool
    func setUpView()
    func renderCube(cubeToRender: Cube?)
}
