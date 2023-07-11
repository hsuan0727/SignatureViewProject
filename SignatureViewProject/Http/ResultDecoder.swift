import Foundation

public class ResultDecoder {
    
    public static func parser<T>(_ data:Data) throws -> T where T:Decodable {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        }catch{
            let errorText = "error:\(error)Json_Decoder_Error : "+String(decoding: data, as: UTF8.self)
            throw AppError(errorText)
        }
        
    }
    
}
