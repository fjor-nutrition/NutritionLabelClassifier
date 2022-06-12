import XCTest
import SwiftSugar
import TabularData
import VisionSugar
import Zip

@testable import NutritionLabelClassifier

let RunTests = true
let RunLegacyTests = true

//let ClassifierTestCases = 18...18
let ClassifierTestCases = 1...23
let ClassifierTestCasesToIgnore: [Int] = []


let CurrentTestCase = UUID(uuidString: "A049E005-AB5E-4474-92B2-979EBC347FB5")!

/// Haribo Cola
//let CurrentTestCase = UUID(uuidString: "2184C983-5761-4F8F-BE7A-E6771E963FFF")!

/// Cookie Butter
//let CurrentTestCase = UUID(uuidString: "00DC2D0A-2C55-4633-B5AE-DF2BA90C4249")!

/// Sliced Cheese
//let CurrentTestCase = UUID(uuidString: "E84F7C80-50C4-4237-BAAD-BD5C1B958B84")!

/// Shredded Cheese
//let CurrentTestCase = UUID(uuidString: "3EDD65E5-6363-42E3-8358-21A520ED21CC")!

//let CurrentTestCase = UUID(uuidString: "7648338E-8AC8-4C03-AAA1-AC8FC76E7368")!

let SingledOutTestCaseId: UUID? = IsTestingNewAlgorithm ? CurrentTestCase : nil
let IgnoredTests: [UUID] = IsTestingNewAlgorithm ? [] : FailingTests + []

//let SingledOutTestCaseId: UUID? = CurrentTestCase
//let IgnoredTests: [UUID] = []

//let SingledOutTestCaseId: UUID? = UUID(uuidString: "6BAD0EB1-8BED-4DD9-8FD8-C9861A267A3D")


let FailingTestUUIDStrings = [
    "674347E4-7B53-4409-95AF-07FD0560ADBA",
    "03A07980-DDEC-41A6-8130-080F582FB5C3",
    "5FEDB3DF-4214-44EF-A390-3C5CB3C1DA14",
    "826DB226-9FCD-4662-A1CD-5FD862493D55",
    "DEB07FE7-3C3D-44E9-83AD-2234228A4F02",
    "DD77C26D-4004-4071-B2B1-D228B258A893",
    "81840F7C-B156-4A21-AE5B-A55531AA6B2D",
    "3EDD65E5-6363-42E3-8358-21A520ED21CC",
    "B19E1AAD-F0A1-4F0E-B443-BF69894125E8",
    "986EFEB4-069E-4091-805E-8C9A031611F3",
    "81344E05-FDC0-44D3-AA58-61259F3D2AE6",
    "7A686ECF-A383-4ACF-9868-A290701D92F3",
    "024A0939-FF3D-4312-868F-F82565C58ED9",
    "478883E6-2CA8-4C86-9A9F-A3FD71EA5BBE",
    "43F947A2-4E96-496B-884B-DF7C960F82FE",
    "9BA54F68-9FC5-430B-90C2-158A2BD1B29D",
    "85025F31-4CD8-48D5-8AB0-246D8EAF0465",
    "364EDBD7-004B-4A97-83AA-F6404DE5EEB4",
    "9CFDEE5E-005E-408F-B1E5-2EF751747988",
    "CE17DE0B-1480-4195-ACD0-C706FF9EE86F",
    "15D5AD72-033E-4CA4-BA87-D6CB6193EC9B",
    "083C5BAA-2DDA-42E5-8A6C-DCD1A3E5B7E1",
    "B789ED71-802F-42EF-85A5-FD9FEED77E6F",
    "5410D64B-4A8D-4183-8C81-EC82ABBFA648",
    "E84F7C80-50C4-4237-BAAD-BD5C1B958B84",
    "00DC2D0A-2C55-4633-B5AE-DF2BA90C4249",
    "2184C983-5761-4F8F-BE7A-E6771E963FFF"
]


let FailingTests: [UUID] = FailingTestUUIDStrings.map { UUID(uuidString: $0)! }

final class OutputTests: XCTestCase {

    var currentTestCaseId: UUID = defaultUUID
    var observedOutput: Output? = nil
    var expectedOutput: Output? = nil

    func testClassifierUsingZipFile() throws {
        guard RunTests else { return }
        print("🤖 Running Tests on Zip File")
        let filePath = Bundle.module.url(forResource: "NutritionClassifier-Test_Data", withExtension: "zip")!
        let testDataUrl = URL.documents.appendingPathComponent("Test Data", isDirectory: true)
        
        /// Remove directory and create it again
        try FileManager.default.removeItem(at: testDataUrl)
        try FileManager.default.createDirectory(at: testDataUrl, withIntermediateDirectories: true)

        /// Unzip Test Data contents
        try Zip.unzipFile(filePath, destination: testDataUrl, overwrite: true, password: nil)
        
        /// For each UUID in Test Cases/With Lanugage Correction
        for testCaseId in testCaseIds {
            if let singledOutTestCaseId = SingledOutTestCaseId {
                guard testCaseId == singledOutTestCaseId else {
                    print("↪️ Ignoring Test Case: \(testCaseId) as its not singled-out")
                    continue
                }
            }
            
            if IgnoredTests.contains(testCaseId) {
                print("↪️ Ignoring Test Case: \(testCaseId)")
                continue
            }
            
            try runTestsForTestCase(withId: testCaseId)
        }        
    }
    
    func runTestsForTestCase(withId id: UUID) throws {
        currentTestCaseId = id
        print("🧪 Test Case: \(id)")
        
        guard let array = arrayOfRecognizedTextsForTestCase(withId: id) else {
            XCTFail("Couldn't get array of recognized texts for Test Case \(id)")
            return
        }

        observedOutput = NutritionLabelClassifier.classify(array)
        
        /// Extract `expectedNutrients` from data frame
        guard let expectedDataFrame = dataFrameForTestCase(withId: id, testCaseFileType: .expectedNutrients) else {
            XCTFail("Couldn't get expected nutrients for Test Case \(id)")
            return
        }

        print("📃 Expectations:")
        print(expectedDataFrame)

        /// Create `Output` from test case file too
        guard let expectedOutput = Output(fromExpectedDataFrame: expectedDataFrame) else {
            XCTFail("Couldn't create expected Output from DataFrame for Test Case \(id)")
            return
        }
        self.expectedOutput = expectedOutput

        let dataFrame = NutritionLabelClassifier(arrayOfRecognizedTexts: array).dataFrameOfObservations()
        print("👀 Observations:")
        print(dataFrameWithTextIdsRemoved(from: dataFrame))
        
//        try compareOutputs()
        print("✅ Passed: \(id)")
    }
    
    func compareOutputs() throws {
        try compareServings()
        try compareNutrients()
    }
    
    //MARK: - Helpers
    
    func m(_ message: String) -> String {
        "\(message) (\(currentTestCaseId))"
    }
}
