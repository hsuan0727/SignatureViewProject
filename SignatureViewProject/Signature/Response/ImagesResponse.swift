//
//  ImagesResponse.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/11.
//

import Foundation


class ImagesResponse:Decodable {
    
    var status: String = ""
    
    
    init() {}
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    
    public func encode(to encoder: Encoder) throws {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
    }
    
}
