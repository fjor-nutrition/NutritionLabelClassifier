import Foundation
import VisionSugar

protocol Classifier {
    static func observations(from recognizedTexts: [RecognizedText]) -> [Observation]
    
    //MARK: Legacy
    static func observations(from recognizedTexts: [RecognizedText], priorObservations observations: [Observation]) -> [Observation]
    func getObservations() -> [Observation]
}
