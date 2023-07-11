//
//  ImagesParameter.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/11.
//

import Foundation


class ImagesParameter  {
    var imagesDatas:[Data] = []
    var fileNames:[String] = []
    
    init(imagesDatas: [Data], fileNames: [String]) {
        self.imagesDatas = imagesDatas
        self.fileNames = fileNames
    }
}
