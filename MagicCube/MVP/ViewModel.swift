//
//  Model.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class ViewModel: ModelProtocol{

    private weak var presenter: PresenterProtocol?
    private var cube: Cube?
    private var cubeSize: Int
    private var cellHits: [String] = ["", ""]
    
    required init?(cubeSize: Int) {
        self.cubeSize = cubeSize
        cube = Cube.newSolvedCube(size: cubeSize)
        if nil == cube {
            return nil
        }
    }

    public func setPresenter(presenter: PresenterProtocol?) {
        self.presenter = presenter
    }
    
    func getCubeSize() -> Int {
        return cubeSize
    }
    
    func getCube() -> Cube? {
        return cube
    }
    
    func cellHit(_ cellName: String) {
        if ("" == cellHits[0]) {
            cellHits[0] = cellHits[1]
            cellHits[1] = cellName
            
            if "" != cellHits[0] {
                cube?.turnLine(cellHits)
                presenter?.renderCube()
            }
        }
    }
    
    func cellHitsDidEnd() {
        cellHits = ["", ""]
    }
}
