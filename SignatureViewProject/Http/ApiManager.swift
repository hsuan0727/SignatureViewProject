//
//  ApiManager.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/10.
//

import Foundation
import RxSwift

protocol IServiceManager {
   
    func callAddOrUpdateDigitaSignaturePic(_ parameter:[String:String],image:UIImage) -> Single<HttpStatus<ImagesResponse>>

    func callUploadImages(_ parameter:ImagesParameter) -> Single<HttpStatus<ImagesResponse>>

}

extension ApiManager: IServiceManager {
    var http:HttpRequest {
        HttpRequest.Singleton
    }
    
}


struct ApiManager {
    
    func callAddOrUpdateDigitaSignaturePic(_ parameter: [String:String],image:UIImage) -> Single<HttpStatus<ImagesResponse>> {
        let url = "http"
        return http.postDecodeImageApiResult(url: url, parameter: parameter, image: image)
    }
    
    
    func callUploadImages(_ parameter: ImagesParameter) -> Single<HttpStatus<ImagesResponse>> {
        let url = "http"
        return http.postDecodeMediaImagesApiResult(url: url, datas: parameter.imagesDatas, fileNames: parameter.fileNames, parameters: ["type": "file"])
    }
    
   
    
}
