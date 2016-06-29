//
//  JSONTests.swift
//  RxPokeTV
//
//  Created by Erik LaManna on 6/29/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import RxPokeCore

class JSONTests: XCTestCase {

    struct TestJSONContainer: JSONDecodable {
        let testObjects: [TestObject]

        static func decodeJSON(json: AnyObject) throws -> TestJSONContainer {
            let json = try JSON.dictionary(json)
            let objectData = try json.requiredArray("objects")
            let testObjects = try objectData.map{ return try TestObject.decodeJSON($0) }

            return TestJSONContainer(testObjects: testObjects)
        }
    }

    struct TestObject: JSONDecodable {
        let aString: String
        let anInt: Int
        let aDouble: Double

        static func decodeJSON(json: AnyObject) throws -> TestObject {
            let json = try JSON.dictionary(json)
            let aString = try json.requiredString("string")
            let anInt = try json.requiredInt("int")
            let aDouble = try json.requiredDouble("double")

            return TestObject(aString: aString, anInt: anInt, aDouble: aDouble)
        }
    }

    func testRequiredJSONDecode() {
        let jsonData = [ "objects" : [[ "string": "Test String", "int": 1, "double": 1.1],
            [ "string": "Test String 2", "int": 2, "double": 2.2],
            [ "string": "Test String 3", "int": 3, "double": 3.3]]]

        let container = try! TestJSONContainer.decodeJSON(jsonData)
        XCTAssertEqual(3, container.testObjects.count)
        XCTAssertEqual("Test String 2", container.testObjects[1].aString)
        XCTAssertEqual(2, container.testObjects[1].anInt)
        XCTAssertEqual(2.2, container.testObjects[1].aDouble)
    }

    // MARK: Exception tests
    func testRequiredMissingFieldDecode() {
        // missing away city
        let jsonData = [ "objects" : [[ "string": "Test String", "int": 1, "double": 1.1],
            [ "string": "Test String 2", "double": 2.2],
            [ "string": "Test String 3", "int": 3, "double": 3.3]]]

        do {
            _ = try TestJSONContainer.decodeJSON(jsonData)
            XCTFail("decodeJSON should have thrown a missing field exception")
        } catch JSON.Error.MissingRequiredElement(let key) {
            XCTAssertEqual("int", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }

    func testInvalidStringType() {
        let rawJSON = ["string": 1]

        do {
            let json = try JSON.dictionary(rawJSON)
            _ = try json.requiredString("string")
            XCTFail("Invalid string exception was not thrown")
        } catch JSON.Error.MustBeAString(let key) {
            XCTAssertEqual("string", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }

    func testInvalidIntType() {
        let rawJSON = ["int": "1"]

        do {
            let json = try JSON.dictionary(rawJSON)
            _ = try json.requiredInt("int")
            XCTFail("Invalid int exception was not thrown")
        } catch JSON.Error.MustBeAnInt(let key) {
            XCTAssertEqual("int", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }

    func testInvalidDoubleType() {
        let rawJSON = ["double": "1"]

        do {
            let json = try JSON.dictionary(rawJSON)
            _ = try json.requiredDouble("double")
            XCTFail("Invalid double exception was not thrown")
        } catch JSON.Error.MustBeADouble(let key) {
            XCTAssertEqual("double", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }

    func testInvalidArrayType() {
        let rawJSON = ["string": 1]

        do {
            let json = try JSON.dictionary(rawJSON)
            _ = try json.requiredString("string")
            XCTFail("Invalid string exception was not thrown")
        } catch JSON.Error.MustBeAString(let key) {
            XCTAssertEqual("string", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }

    func testInvalidDictionaryType() {
        let rawJSON = ["string": 1]

        do {
            let json = try JSON.dictionary(rawJSON)
            _ = try json.requiredString("string")
            XCTFail("Invalid string exception was not thrown")
        } catch JSON.Error.MustBeAString(let key) {
            XCTAssertEqual("string", key)
        } catch _ {
            XCTFail("Unexpected error type")
        }
    }
}
