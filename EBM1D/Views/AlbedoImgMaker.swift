//
//  AlbedoImgMaker.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 12/16/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import AppKit

struct AlbedoImgMaker {
    public static func imageFromAlbedos(_ hemisphereAlbedos: [Double]) -> NSImage {
        let albedos = hemisphereAlbedos.reversed() + hemisphereAlbedos
        let height = 180.0
        let imgSize = NSSize(width: 4, height: height)
        let result = NSImage(size: imgSize, flipped: false) { _ in
            if let context = NSGraphicsContext.current?.cgContext {
                // Assume a texture image gets "wrapped" from pole to pole rather than
                // projected - so each latitude ban can be the same height (have the same
                // circumferential extent).
                let numBands = albedos.count
                guard numBands > 0 else {
                    context.setFillColor(.white)
                    context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: imgSize))
                    return true
                }

                let bandHeight = CGFloat(height) / CGFloat(numBands)
                var yCurr = CGFloat(0.0)
                for albedo in albedos {
                    context.setFillColor(gray: CGFloat(albedo), alpha: 1.0)
                    context.fill(CGRect(origin: CGPoint(x: 0.0, y: yCurr), size: imgSize))
                    yCurr += bandHeight
                }
                return true
            }
            return false
        }
        return result
    }
}
