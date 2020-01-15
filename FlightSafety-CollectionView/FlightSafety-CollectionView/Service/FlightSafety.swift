//
//  FlightSafety.swift
//  FlightSafety-CollectionView
//
//  Created by Michael Alexander on 1/15/20.
//  Copyright © 2020 Michael Alexander. All rights reserved.
//

import Foundation

class FlightSafety: NSObject {
    static let shared = FlightSafety()
    
    typealias FSUsersResponseHandler = (_ error: Error?, _ users: [User]?) -> Void

    private func buildURLForRoute(route: String) -> URL? {
        let string = "\(RequestConstants.BASE_URL)\(route)"
        return URL(string: string)
    }
    
    func fetchUsers(completion: @escaping FSUsersResponseHandler) {
        let route = RequestConstants.GET_USERS_ROUTE
        guard let url = buildURLForRoute(route: route) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(error, nil)
                print("Failed to fetch users:", error)
                return
            }

            guard let data = data else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    completion(nil, users)
                }
            } catch let jsonError {
                print("Failed to decode:", jsonError)
            }
            }.resume()
    }
}
