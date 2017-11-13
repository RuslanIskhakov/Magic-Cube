//
//  ViewController.swift
//  Magic Cube
//
//  Created by Ruslan Iskhakov on 09.11.17.
//  Copyright © 2017 Ruslan Iskhakov. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController, ViewProtocol {
    
    @IBOutlet var sceneView: SCNView! {
        willSet {
            newValue.allowsCameraControl = true
        }
    }
    
    private var presenter: PresenterProtocol?
    private var isSetUp = false
    
    var currentAngle: Float = 0.0
    var cameraNode: SCNNode = SCNNode()
    var geometryNode: SCNNode = SCNNode()
    var scene: SCNScene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel: ViewModel? = ViewModel(cubeSize: 3)
        if let model = viewModel {
            presenter = ViewPresenter.newSharedInstance(model: model)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if nil != presenter {
            presenter?.bindView(view: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if nil != presenter {
            presenter?.unbindView(view: self)
        }
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func applicationDidEnterBackground() {
        
    }
    
    func isViewSetUp() -> Bool {
        return isSetUp
    }
    
    func setUpView() {
        sceneSetup()
        isSetUp = true
    }
    
    func sceneSetup() {
        //let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(sender:)))
        //sceneView.addGestureRecognizer(panRecognizer)
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
    }
    
    @objc
    func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        var newAngle = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(sender.state == UIGestureRecognizerState.ended) {
            currentAngle = newAngle
        }
    }

    func renderCube(cubeToRender: Cube?) {
        
        if let cube = cubeToRender {
            let cubeSize = cube.size
            
            renderCubeBase(cubeSize: cubeSize)
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Front])
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Top])
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Bottom])
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Rear])
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Left])
            renderCubeSide(sideToRender: cube.getSides()[CubeModel.Sides.Right])
        }
    }
    
    private func renderCubeBase(cubeSize: Int) {
        
        cameraNode.position = SCNVector3Make(0.0, 0.0, CubeModel.ScaleUnit * Float(cubeSize*3))
        
        let positionShift = CubeModel.getCubeRenderingCoordinatesShift(cubeSize: cubeSize)
        
        for z in 0..<cubeSize {
            for y in 0..<cubeSize {
                for x in 0..<cubeSize {
                    let boxGeometry = SCNBox(width: CubeModel.CellBaseSize,
                                             height: CubeModel.CellBaseSize,
                                             length: CubeModel.CellBaseSize,
                                             chamferRadius: CubeModel.CellbaseChamferRadius)
                    boxGeometry.firstMaterial?.diffuse.contents = UIColor.black
                    boxGeometry.firstMaterial?.specular.contents = UIColor.white
                    
                    let boxNode = SCNNode(geometry: boxGeometry)
                    boxNode.position = SCNVector3Make(
                        CubeModel.ScaleUnit * Float(x) - positionShift,
                        CubeModel.ScaleUnit * Float(y) - positionShift,
                        CubeModel.ScaleUnit * Float(z) - positionShift)
                    scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }
    
    private func renderCubeSide(sideToRender: CubeSide?) {
        if let side = sideToRender {
            let positionShift = CubeModel.getCubeRenderingCoordinatesShift(cubeSize: side.size)
            for y in 0..<side.size {
                for x in 0..<side.size {

                    let sizes = CubeModel.Cell3DSizes[side.side]!
                    let cellGeometry = SCNBox(width: sizes.xSize,
                                              height: sizes.ySize,
                                              length: sizes.zSize,
                                              chamferRadius: CubeModel.CellChamferRadius)
                    cellGeometry.firstMaterial?.diffuse.contents = side.getCells()[y*side.size+x].color
                    cellGeometry.firstMaterial?.specular.contents = UIColor.white
                    
                    let cellPosition = CubeModel.getCellRenderCoordinates(side: side.side, cubeSize: side.size, x: x, y: y, shift: positionShift)
                    let cellNode = SCNNode(geometry: cellGeometry)
                    cellNode.position = SCNVector3Make(cellPosition.x, cellPosition.y, cellPosition.z)
                    scene.rootNode.addChildNode(cellNode)
                }
            }
        }
    }
}

