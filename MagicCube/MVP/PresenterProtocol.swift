//
//  PresenterProtocol.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

protocol PresenterProtocol: class {
    init(model: ModelProtocol)
    func bindView(view: ViewProtocol)
    func unbindView(view: ViewProtocol)
    func cellHit(cellName: String)
    func cellHitsDidEnd()
    func renderCube()
}
