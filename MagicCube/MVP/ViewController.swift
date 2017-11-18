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
    
    var currentXAngle: Float = 0.0
    var currentYAngle: Float = 0.0
    var cameraNode: SCNNode = SCNNode()
    var geometryNode1: SCNNode = SCNNode()
    var geometryNode2: SCNNode = SCNNode()
    var scene: SCNScene = SCNScene()
    var gestureType: CubeModel.PanGestureType = .None
    var hitCellName: String = ""
    
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
        let boxGeometry = SCNBox(
            width: CGFloat(0.1*CubeModel.ScaleUnit),
            height: CGFloat(0.1*CubeModel.ScaleUnit),
            length: CGFloat(0.1*CubeModel.ScaleUnit),
            chamferRadius: 0.0)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.white
        boxGeometry.firstMaterial?.specular.contents = UIColor.white
        
        geometryNode1 = SCNNode(geometry: boxGeometry)
        geometryNode2 = SCNNode(geometry: boxGeometry)
        scene.rootNode.addChildNode(geometryNode1)
        geometryNode1.addChildNode(geometryNode2)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(sender:)))
        sceneView.addGestureRecognizer(panRecognizer)
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        addOmniLight(0, 50, 50)
        addOmniLight(0, 50, -50)
        addOmniLight(0, -50, 50)
        addOmniLight(0, -50, -50)
        addOmniLight(0, 0, 50)
        addOmniLight(0, 0, -50)
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func addOmniLight(_ x: Float, _ y: Float, _ z: Float) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.5, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(x, y, z)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    @objc
    func panGesture(sender: UIPanGestureRecognizer) {
        
        
        
        if sender.state == UIGestureRecognizerState.began {
            let location = sender.location(in: sceneView)
            let hitNodes = sceneView.hitTest(location)
            if hitNodes.count>0 {
                gestureType = .CubeMove
            } else {
                gestureType = .GeometryRotate
            }
        }
        
        if .GeometryRotate == gestureType {
            let translation = sender.translation(in: sceneView)
            let newXAngle = -(Float)(translation.y)*(Float)(Double.pi)/180.0
            let newYAngle = -(Float)(translation.x)*(Float)(Double.pi)/180.0
            let xAngle = SCNMatrix4MakeRotation(currentXAngle + newXAngle, 1, 0, 0)
            let yAngle = SCNMatrix4MakeRotation(currentYAngle + newYAngle, 0, 1, 0)
            let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 0)
            
            let rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
            geometryNode1.pivot = rotationMatrix
            
            if sender.state == UIGestureRecognizerState.ended {
                currentXAngle += newXAngle
                currentYAngle += newYAngle
                gestureType = .None
            }
        }
        
        if .CubeMove == gestureType {
            let location = sender.location(in: sceneView)
            let hitNodes = sceneView.hitTest(location)
            if let firstNode = hitNodes.first {
                if nil != firstNode.node.name && hitCellName != firstNode.node.name {
                    hitCellName = firstNode.node.name!
                    presenter?.cellHit(cellName: hitCellName)
                }
            }
            
            if sender.state == UIGestureRecognizerState.ended {
                gestureType = .None
                hitCellName = ""
                presenter?.cellHitsDidEnd()
            }
        }
    }

    func renderCube(cubeToRender: Cube?) {
        
        if let cube = cubeToRender {
            
            let childnodes = geometryNode2.childNodes
            if childnodes.count>0 {
                for node in childnodes {
                    node.removeFromParentNode()
                }
            }
            
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
                    boxGeometry.firstMaterial!.diffuse.contents = UIColor.black
                    boxGeometry.firstMaterial!.specular.contents = UIColor.white
                    
                    let boxNode = SCNNode(geometry: boxGeometry)
                    boxNode.position = SCNVector3Make(
                        CubeModel.ScaleUnit * Float(x) - positionShift,
                        CubeModel.ScaleUnit * Float(y) - positionShift,
                        CubeModel.ScaleUnit * Float(z) - positionShift)
                    geometryNode2.addChildNode(boxNode)
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
                    cellGeometry.firstMaterial!.diffuse.contents = CubeModel.cellColors[side.getCells()[y][x].color]!
                    cellGeometry.firstMaterial!.specular.contents = UIColor.white
                    
                    let cellPosition = CubeModel.getCellRenderCoordinates(side: side.side, cubeSize: side.size, x: x, y: y, shift: positionShift)
                    let cellNode = SCNNode(geometry: cellGeometry)
                    cellNode.position = SCNVector3Make(cellPosition.x, cellPosition.y, cellPosition.z)
                    cellNode.name = CubeModel.getCellName(side: side.side, row: y, column: x)
                    geometryNode2.addChildNode(cellNode)
                }
            }
        }
    }
}

