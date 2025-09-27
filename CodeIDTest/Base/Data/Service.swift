//
//  Service.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import RxSwift
import Alamofire

public protocol Service {
  
  func request<T: Codable>(
    of type: T.Type,
    with url: String,
    withMethod method: Method?,
    withHeaders headers: [String: String],
    withParameter parameters: [String: Any],
    withEncoding encoding: Encoding?
  ) -> Single<T>
  
}

public enum Method {
  case get
  case post
  case put
  case delete
  case patch
}

public enum Encoding {
  case url
  case json
}

public protocol HeaderProtocol {
  var headers: [String: String] { get }
}

extension Method {
  func getMethod() -> HTTPMethod {
    switch self {
    case .get:
      return HTTPMethod.get
    case .post:
      return HTTPMethod.post
    case .put:
      return HTTPMethod.put
    case .delete:
      return HTTPMethod.delete
    case .patch:
      return HTTPMethod.patch
    }
  }
}

extension Encoding {
  func getEncoding() -> ParameterEncoding {
    switch self {
    case .url:
      return URLEncoding.default
    case .json:
      return JSONEncoding.default
    }
  }
}


public class NetworkService: Service {
  
  public func request<T>(
    of type: T.Type,
    with url: String,
    withMethod method: Method?,
    withHeaders headers: [String : String],
    withParameter parameters: [String : Any],
    withEncoding encoding: Encoding?
  ) -> Single<T> where T : Decodable, T : Encodable {
    
    var httpHeaders: HTTPHeaders = []
    for (k, v) in headers {
      httpHeaders.add(name: k, value: v)
    }
    
    return self.createSingle(
      with: url,
      withMethod: method?.getMethod() ?? .get,
      withHeaders: httpHeaders,
      withParameter: parameters,
      withEncoding: encoding?.getEncoding() ?? URLEncoding.default
    )
    .flatMap { data -> Single<T> in
      do {
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return .just(decoded)
      } catch {
        return .error(ErrorMessage(title: "error", message: error.localizedDescription))
      }
    }
  }
  
  private func createSingle(
    with url: String,
    withMethod method: HTTPMethod = .get,
    withHeaders headers: HTTPHeaders = [:],
    withParameter parameters: Parameters = [:],
    withEncoding encoding: ParameterEncoding = URLEncoding.default
  ) -> Single<Data> {
    
    return Single.create { [weak self] single in
      let request = AF.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
      ) { $0.timeoutInterval = 30 }
        .responseString(queue: .main, encoding: .utf8) { response in
          self?.log(response)
          self?.validateStatusCode(response) { result in
            switch result {
            case .success(let data):
              single(.success(data))
            case .failure(let error):
              single(.failure(error))
            }
          }
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  fileprivate func validateStatusCode(
    _ response: AFDataResponse<String>,
    completion: @escaping (Result<Data, ErrorMessage>) -> Void
  ) {
    
    guard let code = response.response?.statusCode else {
      completion(.failure(ErrorMessage(title: "error", message: "bad response")))
      return
    }
    
    if 200 ... 299 ~= code  {
      //success
      guard let data = response.data else {
        completion(.failure(ErrorMessage(title: "error", message: "data not found")))
        return
      }
      completion(.success(data))
    } else if code == 400 {
      completion(.failure(ErrorMessage(title: "error", message: "bad request")))
    } else if code == 401 {
      guard let data = response.data else { return }
      do {
        let message = try self.parseError(data: data)
        completion(.failure(ErrorMessage(title: "error", message: message)))
      } catch {
        completion(.failure(ErrorMessage(title: "error", message: "Parse Rrror")))
      }
    } else if 402 ... 499 ~= code {
      guard let data = response.data else { return }
      do {
        let message = try self.parseError(data: data)
        completion(.failure(ErrorMessage(title: "error", message: message)))
      }catch {
        completion(.failure(ErrorMessage(title: "error", message: "Parse Error")))
      }
    } else if 500 ... 599 ~= code {
      //internal server error
      completion(.failure(ErrorMessage(title: "error", message: "Server Problem")))
    } else {
      // throw unknown error
      completion(.failure(ErrorMessage(title: "error", message: "Unknown Error")))
    }
  }
  
  private func parseError(data: Data) throws -> String{
    do {
      if let json = try JSONSerialization.jsonObject(
        with: data,
        options: []
      ) as? [String: Any] {
        if let message = json["message"] as? String {
          return message
        }
      }
    } catch {
      throw ErrorMessage(title: "error", message: "Parse Error")
    }
    
    return ""
  }
  
  private func log(_ response: AFDataResponse<String>) {
    var str = ""
    str += "URL: \(String(describing: response.request!.url)) \n"
    str += "StatusCode: \(String(describing: response.response?.statusCode)) \n"
    str += "Headers: \(String(describing: response.request!.allHTTPHeaderFields!)) \n"
    if let httpBody = response.request?.httpBody,
       let parameters = NSString(
        data: httpBody,
        encoding: String.Encoding.utf8.rawValue
       ) as? String{
      
      str += "Parameters: \(parameters) \n"
    }
    let jsonStr = String(data: response.data ?? Data(), encoding: .utf8)!
    str += "Response: \(jsonStr.replacingOccurrences(of: "\\", with: "")) \n"
    
    GLogger(
      .debug,
      layer: "Networking",
      message: str
    )
  }
  
}
