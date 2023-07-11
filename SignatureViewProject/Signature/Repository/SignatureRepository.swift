//
//  SignatureRepository.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/10.
//

import Foundation
import RxSwift

class SignatureRepository {
    private let apiManager:IServiceManager
    
    init(apiManager:ApiManager) {
        self.apiManager = apiManager
    }
    
    func triggerDigitalSignatureApi(parameter:[String:String],image:UIImage) -> Single<HttpStatus<ImagesResponse>> {
        apiManager.callAddOrUpdateDigitaSignaturePic(parameter, image: image).flatMap { [weak self] signatureModelStatus in
            self?.apiSignatureSuccess(status: signatureModelStatus) ?? .just(.data(ImagesResponse()))
        }.observe(on: MainScheduler.instance)
    }
    
    private func apiSignatureSuccess(status:HttpStatus<ImagesResponse>) -> Single<HttpStatus<ImagesResponse>> {
        switch status {
        case .data(let data):
            return .just(.data(data))
        case .error(let error):
            return .just(.error(error))
        }
        
    }
}
