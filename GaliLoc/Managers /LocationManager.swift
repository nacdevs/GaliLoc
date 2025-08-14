//
//  LocationManager.swift
//  GaliLoc
//
//  Created by Nestor Camela on 13/08/2025.
//

import Foundation
import CoreLocation
import CoreData

public class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private var persistentContainer: NSPersistentContainer!
    public var context: NSManagedObjectContext! //public for testing purposes
    
    
    func configureCoreData(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.context = persistentContainer.viewContext
    }
    
    func startMonitoring() {
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        //If CoreData is empty retrieves from API, a better approach would be to have an expire property on the list
        if(isCoreDataEntityEmpty(entityName: Constants.LocationEntity, context: context)){
            saveLocationsToCoreData()
        }
    }
    
    
    
    //MARK: Location Manager Delegates
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entraste a region: \(region.identifier)")
        
        NetworkManager.shared.postLocation(coord: manager.location?.coordinate ?? CLLocationCoordinate2D(),
                                           status: region.notifyOnEntry ? .enter : .exit)
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Saliste de la region: \(region.identifier)")
        
        NetworkManager.shared.postLocation(coord: manager.location?.coordinate ?? CLLocationCoordinate2D(),
                                           status: region.notifyOnExit ? .exit : .enter)
    }
    
    
    
    //MARK: CoreData interaction
    func loadRegionsFromCoreData() {
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        
        do {
            let locations = try context.fetch(request)
            for loc in locations {
                let coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
                let region = CLCircularRegion(center: coordinate, radius: loc.radius, identifier: UUID().uuidString)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                manager.startMonitoring(for: region)
            }
        } catch {
            print("Error fetching locations: \(error)")
        }
    }
    
    
    func saveLocationsToCoreData() {
        NetworkManager.shared.getLocations { locations in
            guard let locations = locations else { return }
            
            let fetch: NSFetchRequest<NSFetchRequestResult> = LocationEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            
            for loc in locations {
                let entity = LocationEntity(context: self.context)
                entity.latitude = loc.latitude
                entity.longitude = loc.longitude
                entity.radius = loc.radius
            }
            
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
                self.loadRegionsFromCoreData()
            } catch {
                print("Error guardando en Core Data: \(error)")
            }
        }
        
    }
    
    
    func isCoreDataEntityEmpty(entityName: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Error fetching count for entity \(entityName): \(error)")
            return false 
        }
    }
}
