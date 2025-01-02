//
//  Face.swift
//  Homework1
//
//  Created by Mohak Tamhane on 10/3/24.
//

import Foundation
import Vision

struct Face {
    var landmarks: VNFaceLandmarks2D
    var faceBoundBox: CGRect
}
