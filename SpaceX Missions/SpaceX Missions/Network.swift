//
//  Network.swift
//  SpaceX Missions
//
//  Created by Oliver Paray on 3/29/20.
//  Copyright © 2020 Oliver Paray. All rights reserved.
//
import Foundation
import Apollo

// MARK: - Singleton Wrapper

class Network {
    static let shared = Network()

    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport: HTTPNetworkTransport = {
        let transport = HTTPNetworkTransport(url: URL(string: "https://api.spacex.land/graphql")!)
        transport.delegate = self
        return transport
    }()

    // Use the configured network transport in your Apollo client.
    private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)
}

// MARK: - Pre-flight delegate

extension Network: HTTPNetworkTransportPreflightDelegate {

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {

        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()

        // Add any new headers you need

        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers

    }
}

// MARK: - Task Completed Delegate

extension Network: HTTPNetworkTransportTaskCompletedDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          didCompleteRawTaskForRequest request: URLRequest,
                          withData data: Data?,
                          response: URLResponse?,
                          error: Error?) {

        if let error = error {
            debugPrint("Error: \(error)")
        }

        if let response = response {
            debugPrint("Response: \(response)")
        } else {
            debugPrint("Error: No Response...")
        }

        if let data = data {
            debugPrint("Data: \(data)")
        } else {
            debugPrint("Error: No Data...")
        }
    }
}

// MARK: - Retry Delegate

extension Network: HTTPNetworkTransportRetryDelegate {

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          receivedError error: Error,
                          for request: URLRequest,
                          response: URLResponse?,
                          retryHandler: @escaping (_ shouldRetry: Bool) -> Void) {

        retryHandler(false)

        /* Check if the error and/or response you've received are something that requires authentication
        guard UserManager.shared.requiresReAuthentication(basedOn: error, response: response) else {
            // This is not something this application can handle, do not retry.
            retryHandler(false)
            return
        } */

        /* Attempt to re-authenticate asynchronously
        UserManager.shared.reAuthenticate { success in
            // If re-authentication succeeded, try again. If it didn't, don't.
            retryHandler(success)
        } */
    }
}
