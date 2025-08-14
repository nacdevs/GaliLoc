//
//  NetworkManager.swift
//  GaliLoc
//
//  Created by Nestor Camela on 13/08/2025.
//

import Foundation
import CoreLocation

public class NetworkManager: NSObject {
    public static let shared = NetworkManager()
    private let baseURL = Constants.baseURL //Should be in fastfile or similar but to show the concept
    
    
    public func postLocation(coord: CLLocationCoordinate2D, status: LocationStatus) {
        guard let url = URL(string: baseURL+"location/post") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body = [String:Any]()
        let location: [String: Double] = [
            "latitude": coord.latitude,
            "longitude": coord.longitude
        ]
        body["location"] = location
        body["status"] = status.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error en POST: \(error)")
            } else {
                print("POST enviado correctamente")
            }
        }.resume()
    }
    
    
    public func getLocations(completion: @escaping ([RemoteLocation]?) -> ()) {
        guard let url = URL(string: baseURL+"location/get") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error endpoint: \(error)")
                return
            }
            guard let data = data else { return }
            
            do {
                let remoteLocations = try JSONDecoder().decode(Response.self, from: data)
                completion(remoteLocations.locations)
            } catch {
                print("Error parse JSON: \(error)")
            }
        }.resume()
    }
}


public struct RemoteLocation: Codable {
    let latitude: Double
    let longitude: Double
    let radius: Double
}

struct Response: Decodable{
    let locations: [RemoteLocation]
}

public enum LocationStatus: String {
    case enter = "enter", exit = "exit"
}
