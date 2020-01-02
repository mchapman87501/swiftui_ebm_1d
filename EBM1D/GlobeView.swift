//
//  GlobeView.swift
//  LearnSwiftUI1
//
//  Created by Mitchell Chapman on 12/16/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

// See https://stackoverflow.com/q/59318581 for clues about
// embedding SceneKit views.
// Big trick for my feeble mind: on macOS you use NSViewRepresentable
import SwiftUI
import SceneKit

struct GlobeView: NSViewRepresentable {
    var albedos = [Double]()

    func makeNSView(context: NSViewRepresentableContext<GlobeView>) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = NSColor.black
        sceneView.frame = CGRect(x: 0.0, y: 0.0, width: 128, height: 128)

        return sceneView
    }

    func updateNSView(_ nsView: SCNView, context: NSViewRepresentableContext<GlobeView>) {
        eraseNodes(nsView)
        let globe = SCNSphere(radius: 10.0)
        let globeNode = SCNNode(geometry: globe)
        globeNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)

        let textureImg = AlbedoImgMaker.imageFromAlbedos(albedos)
        globe.firstMaterial?.diffuse.contents = textureImg

        nsView.scene?.rootNode.addChildNode(globeNode)
    }

    func eraseNodes(_ nsView: SCNView) {
        nsView.scene?.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}
