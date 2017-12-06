//
//  Presenter.swift
//  MagicCube
//
//  Created by Ruslan Iskhakov on 10.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import Foundation

class ViewPresenter: PresenterProtocol {

    private static var sharedInstance: PresenterProtocol?
    
    public static func newSharedInstance(model: ModelProtocol) -> PresenterProtocol? {
        if (nil == sharedInstance) {
            sharedInstance = ViewPresenter(model: model)
        }
        return sharedInstance
    }
    
    private let model: ModelProtocol?
    private weak var view: ViewProtocol?
    private var isBound = false
    
    required init(model: ModelProtocol) {
        print("Presenter Init")
        self.model = model
        model.setPresenter(presenter: self)
    }
    
    func bindView(view: ViewProtocol) {
        let isNewViewInstance = (nil == self.view ? true : (self.view !== view))
        self.view = view
        isBound = true
        if isNewViewInstance {
            newViewInstanceDidBound()
        }
    }
    
    private func newViewInstanceDidBound() {
        if nil != view && nil != model {
            view!.setUpView()
            view!.renderCube(cubeToRender: model!.getCube())
        }
    }
    
    func unbindView(view: ViewProtocol) {
        isBound = false
    }
    
    deinit {
        print("Presenter Deinit")
    }
    
    func cellHit(cellName: String) {
        model?.cellHit(cellName)
    }
    
    func cellHitsDidEnd() {
        model?.cellHitsDidEnd()
    }
    
    func renderCube() {
        view?.renderCube(cubeToRender: model?.getCube())
    }
}
