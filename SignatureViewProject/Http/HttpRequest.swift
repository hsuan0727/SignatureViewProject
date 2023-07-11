//
//  HttpRequest.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/10.
//

import Foundation
import Alamofire
import RxSwift

public class HttpRequest{
    public static let Singleton = HttpRequest()
    private let manager:Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return Alamofire.Session(configuration: configuration)
    }()
    
    
    /*上傳單圖(後端使用form-data傳圖)*/
    public func postImage(url:String,parameters:[String: String],image:UIImage) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create { closure in
            let urlConvertible = URL(string: url)!
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                if let imageData = image.jpegData(compressionQuality: 1) {
                      multipartFormData.append(imageData, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
            }, to: urlConvertible).response { response in
                switch response.result {
                case .success(let data):
                    if let d = data {
                       return closure(.success(.data(d)))
                    } else {
                       return closure(.failure(AppError("http data == nil")))
                    }
                case .failure(let error):
                    return closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
               print("http end")
            }
        }
    }
    
    /*上傳多圖(後端使用form-data傳圖)*/
    public func postImages(url: String,
                           datas: [Data],
                           fileNames: [String],
                           parameters: [String : Any]) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create { closure in
            let urlConvertible = URL(string: url)!
            AF.upload(multipartFormData: { formData in
                for i in 0 ..< datas.count {
                    let imageName = "image[\(i)]"
                    formData.append(datas[i], withName: imageName, fileName: fileNames[i], mimeType: "image/jpeg")
                }
                print(formData)
            }, to: urlConvertible).response { response in
                switch response.result {
                case .success(let data):
                    if let d = data {
                       return closure(.success(.data(d)))
                    } else {
                       return closure(.failure(AppError("http data == nil")))
                    }
                case .failure(let error):
                    return closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
               print("http end")
            }
        }
    }
    
    /*解析單圖result*/
    public func postDecodeImageApiResult<T:Decodable>(url:String,parameter:[String: String],image:UIImage) -> Single<HttpStatus<T>> {
        postImage(url: url, parameters: parameter, image: image).flatMap { status -> Single<HttpStatus<T>> in
            switch status {
            case .data(let d):
                do{
                    let result:T = try ResultDecoder.parser(d)
                    return Single.just(HttpStatus<T>.data(result))
                }catch let error as AppError {
                    return Single.just(HttpStatus<T>.error(error))
                }
            case .error(let e):
                return Single.just(HttpStatus<T>.error(e))
            }
        }
    }
    
    /*解析多圖result*/
    public func postDecodeMediaImagesApiResult<T:Decodable>(url:String,datas:[Data],fileNames:[String],parameters: [String : Any]) -> Single<HttpStatus<T>> {
        postImages(url: url, datas: datas, fileNames: fileNames, parameters: parameters).flatMap { status -> Single<HttpStatus<T>> in
            switch status {
            case .data(let d):
                do{
                    let result:T = try ResultDecoder.parser(d)
                    return Single.just(HttpStatus<T>.data(result))
                }catch let error as AppError {
                    return Single.just(HttpStatus<T>.error(error))
                }
            case .error(let e):
                return Single.just(HttpStatus<T>.error(e))
            }
        }
    }
    
}


