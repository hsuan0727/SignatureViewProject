//
//  SignatureViewModel.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/10.
//

import Foundation
import RxSwift
import RxCocoa

class SignatureViewModel {
    private var disposeBag = DisposeBag()
    private var signatureRepository:SignatureRepository
    
    struct Output {
        let isLoading:BehaviorRelay<Bool> = .init(value: false)
        let showAlertText = PublishRelay<String>.init()
    }
    
    let output = Output()
    
    init(signatureRepository:SignatureRepository) {
        self.signatureRepository = signatureRepository
    }
    
    func readSigntureApi(parameter:[String:String],image:UIImage) {
        output.isLoading.accept(true)
        signatureRepository.triggerDigitalSignatureApi(parameter: parameter, image: image ).subscribe(with: self) { (vm, status) in
            switch status {
            case .data(let data):
                let text = self.dataToText(data: data)
                vm.output.showAlertText.accept(text)
            case .error( _):
                vm.output.showAlertText.accept("系統錯誤")
            }
            vm.output.isLoading.accept(false)
        }.disposed(by: disposeBag)
    }
    
    private func dataToText(data:ImagesResponse) -> String {
        if data.status == "1" {
            return "上傳成功"
        }else {
            return "上傳失敗"
        }
    }
}

