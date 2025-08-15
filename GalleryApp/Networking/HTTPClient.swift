//
//  HTTPClient.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 10.03.2024.
//

import Foundation

struct HTTPClient {
    enum Method: String {
        case GET, POST
    }

    enum Header {
        case authorization(token: String)

        var headerData: (value: String, field: String) {
            switch self {
                case .authorization(let token): ("Client-ID \(token)", "Authorization")
            }
        }

        private static let contentType = "Content-Type"
    }


    enum ResponseError: Error {
        case internalServerError
        case toManyRequests
        case somethingWrong
        case wrongInput(CommonErrorResponse)
        case unauthorized(CommonErrorResponse)
        case notFound(CommonErrorResponse)
        case serverError(CommonErrorResponse)
        case failedToDecode
        
        var description: String {
            switch self {
            case .internalServerError:
                return "Internal server error occurred. Please try again later."
            case .toManyRequests:
                return "Too many requests. Please slow down and try again."
            case .somethingWrong:
                return "Something went wrong. Please check your connection or try again."
            case .wrongInput(let error):
                    return "Invalid input: \(error.errors.joined(separator: ", "))"
            case .unauthorized(let error):
                return "Unauthorized: \(error.errors.joined(separator: ", "))"
            case .notFound(let error):
                    return "Not found: \(error.errors.joined(separator: ", "))"
            case .serverError(let error):
                return "Server error: \(error.errors.joined(separator: ", "))"
            case .failedToDecode:
                return "Failed to decode the response from the server."
            }
        }
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func handleRequest<Response: Decodable>(
        url: URL,
        method: Method,
        token: String?
    ) async -> Result<Response, ResponseError> {
        do {
            let result: Result<Response, ResponseError> = try await request(
                url: url,
                method: method,
                token: token
            )
            return result
        } catch {
            print("### HTTPClient request error:", error)
            return .failure(
                .somethingWrong
            )
        }
    }

    private func request<Response: Decodable>(
        url: URL,
        method: Method,
        token: String?
    ) async throws -> Result<Response, ResponseError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let requestToken = token {
            let access_key = Header.authorization(token: requestToken)
            setHeader(request: &request, header: access_key)
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw ResponseError.somethingWrong }
        print(
            """
            ### httpResponse:
            ### url: \(String(describing: httpResponse.url))
            ### code: \(httpResponse.statusCode)
            ### responseBody: \(String(describing: String(data: data, encoding: .utf8)))
            """
        )

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        switch httpResponse.statusCode {
        case 500...599:
            do {
                let decodedData = try decoder.decode(CommonErrorResponse.self, from: data)
                return .failure(.serverError(decodedData))
            } catch {
                return .failure(.failedToDecode)
            }
        case 200...299:
            do {
                let decodedData = try decoder.decode(Response.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.failedToDecode)
            }
        case 400:
            do {
                let decodedData = try decoder.decode(CommonErrorResponse.self, from: data)
                return .failure(.wrongInput(decodedData))
            } catch {
                return .failure(.failedToDecode)
            }
        case 401:
            do {
                let decodedData = try decoder.decode(CommonErrorResponse.self, from: data)
                return .failure(.unauthorized(decodedData))
            } catch {
                return .failure(.failedToDecode)
            }
        case 403:
            do {
                let decodedData = try decoder.decode(CommonErrorResponse.self, from: data)
                return .failure(.unauthorized(decodedData))
            } catch {
                return .failure(.failedToDecode)
            }
        case 404:
            do {
                let decodedData = try decoder.decode(CommonErrorResponse.self, from: data)
                return .failure(.notFound(decodedData))
            } catch {
                return .failure(.failedToDecode)
            }
        case 429:
            return .failure(.toManyRequests)
        default:
            return .failure(
                .somethingWrong
            )
        }
    }

    private func setHeader(request: inout URLRequest, header: Header) {
        request.setValue(header.headerData.value, forHTTPHeaderField: header.headerData.field)
    }
}
