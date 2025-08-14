//
//  GaliLocTests.swift
//  GaliLocTests
//
//  Created by Nestor Camela on 13/08/2025.
//

import XCTest
@testable import GaliLoc

class GaliLocTests: XCTestCase {
    
    
    func test_getLocations () {
        // given
        let exp = XCTestExpectation(description: "loading locations")
        let netWorkManager = NetworkManager.shared
        var locations:[RemoteLocation]?
        
        //when
        netWorkManager.getLocations { locs in
            locations = locs
            exp.fulfill()
        }
        //then
        wait(for: [exp], timeout: 5.0)
        XCTAssertNotNil(locations)
    }
    

    func test_loadRegions () {
        // given
        let locationManager = LocationManager.shared
        
        //when
        locationManager.loadRegionsFromCoreData()
       
        //then
        XCTAssertFalse((locationManager.isCoreDataEntityEmpty(entityName: Constants.LocationEntity , context: locationManager.context)))
    }

}
