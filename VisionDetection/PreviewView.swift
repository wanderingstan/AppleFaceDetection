//
//  PreviewView.swift
//  VisionDetection
//
//  Created by Wei Chieh Tseng on 09/06/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class PreviewView: UIView {
    
    private var maskLayer = [CAShapeLayer]()
    
    
    // MARK: AV capture properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    func createLayer(in rect: CGRect) -> CAShapeLayer{
        
        let mask = CAShapeLayer()
        mask.frame = rect
        
//        mask.backgroundColor = UIColor.yellow.cgColor
        mask.cornerRadius = 10
        mask.opacity = 0.75
        mask.borderColor = UIColor.yellow.cgColor
        mask.borderWidth = 2.0
        
        return mask
    }
    
    func drawFaceWithLandmarks(face: VNFaceObservation ) {
        
        let translate = CGAffineTransform.identity.scaledBy(x: layer.frame.width, y: layer.frame.height)
        let transform = CGAffineTransform(scaleX: -1, y: -1).translatedBy(x: -layer.frame.width, y: -layer.frame.height)
        let faceRect = face.boundingBox.applying(translate).applying(transform)
        
        // Draw the bounding rect
        let faceLayer = self.createLayer(in: faceRect)
        maskLayer.append(faceLayer)
        layer.insertSublayer(faceLayer, at: 1)
        
        // Draw the landmarks
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.nose)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.noseCrest)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.medianLine)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.leftEye)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.leftPupil)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.leftEyebrow)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.rightEye)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.rightPupil)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.rightEye)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.rightEyebrow)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.innerLips)!)
        self.drawLandmarks(in: faceRect, on: faceLayer, faceLandmarkRegion: (face.landmarks?.outerLips)!)
    }
    
    func drawLandmarks(in rect: CGRect, on targetLayer:CALayer, faceLandmarkRegion: VNFaceLandmarkRegion2D) {
        var points: [CGPoint] = []
        for i in 0..<faceLandmarkRegion.pointCount {
            let point = faceLandmarkRegion.point(at: i)
            let p = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
            points.append(p)
        }
        
        let landmarkLayer = self.drawPointsOnLayer(rect: rect, landmarkPoints: points)
        
        landmarkLayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform.identity
                .translatedBy(x: rect.width, y: 0)
                .scaledBy(x: -1, y: 1)
                .scaledBy(x: rect.width, y:rect.height)
                .scaledBy(x: 1, y: -1)
                .translatedBy(x: 0, y: -1)
        )
        
        targetLayer.insertSublayer(landmarkLayer, at: 1)
    }
    
    func drawPointsOnLayer(rect:CGRect, landmarkPoints: [CGPoint]) -> CALayer {
        let linePath = UIBezierPath()
        linePath.move(to: landmarkPoints.first!)
        for point in landmarkPoints.dropFirst() {
            linePath.addLine(to: point)
        }
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        lineLayer.opacity = 1.0
        lineLayer.strokeColor = UIColor.green.cgColor
        lineLayer.lineWidth = 0.02
        
        return lineLayer
    }
    
    func removeMask() {
        for mask in maskLayer {
            mask.removeFromSuperlayer()
        }
        maskLayer.removeAll()
    }
    
}
