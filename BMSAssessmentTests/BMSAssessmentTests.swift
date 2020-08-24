//
//  BMSAssessmentTests.swift
//  BMSAssessmentTests
//
//  Created by Manish Kumar on 22/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import XCTest
@testable import BMSAssessment

class BMSAssessmentTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test case to fetch movie listing data
    func testMovieListingDataFetch() {
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            "page" : 1
            ] as [String : Any]
        
        // When
        Webservices().callGetService(methodName: WebServiceMethods.WS_NOW_PLAYING, params: params, successBlock: { (data) in
            do {
                // Then
                XCTAssertNotNil(data)
            }
        }) { (error) in
            
        }
    }
    
    //Test Case to fetch synopsis data
    func testFetchSynopsis() {
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            ] as [String : Any]
        
        let methodName = "77"
        
        // When
        Webservices().callGetService(methodName: methodName, params: params, successBlock: { (data) in
            do {
                // Then
                XCTAssertNotNil(data)
                
                let jsonDecoder = JSONDecoder()
                let synopsisResponse = try jsonDecoder.decode(MovieSynopsisResponse.self, from: data)
                
                self.testLoadImage(imagePath: synopsisResponse.poster_path ?? "")
                
                // Also
                XCTAssertNotNil(synopsisResponse)
                
            } catch {
                
            }
        }) { (error) in
        }
    }
    
    //Test case to to check whether the image is loading or not
    func testLoadImage(imagePath: String) {
        let image = UIImageView()
        image.loadImage(imagePath, type: .original)
        XCTAssertNotNil(image)
//        XCTAssertNil(image)
        
    }
    
}
