import Foundation
import VisionSugar

extension Attribute {
    
    
    static func detect(in string: String) -> [Attribute] {
        var attributes: [Attribute] = []
        for attribute in Self.allCases {
            guard let regex = attribute.regex else { continue }
            if string.cleanedAttributeString.matchesRegex(regex) {
                attributes.append(attribute)
            }
        }
        
        /// If we have more than one attribute, order them based on the appearance
        guard attributes.count <= 1 else {
            var orderedAttributes: [Attribute] = []
            var stringToCheck = ""
            for character in string {
                /// Keep checking string one character at a time
                stringToCheck.append(character)
                
                /// Once an attribute is detected, append it to the array and clear the string
                if let attribute = Attribute(fromString: stringToCheck) {
                    orderedAttributes.append(attribute)
                    stringToCheck = ""
                }
            }
            return orderedAttributes
        }
        return attributes
    }

    static func haveAttributes(in string: String) -> Bool {
        detect(in: string).count > 0
    }
    
    static func haveNutrientAttribute(in string: String) -> Bool {
        detect(in: string).contains(where: { $0.isNutrientAttribute })
    }
}

extension TableClassifier {
    
    public func getAttributes() -> [Attribute] {
        guard let attributeRecognizedTexts = getAttributeRecognizedTexts() else {
            return []
        }
        return getUniqueAttributeTextsFrom(attributeRecognizedTexts)?
            .map { $0.attribute }
        ?? []
    }
    
    func getUniqueAttributeTextsFrom(_ texts: [RecognizedText]) -> [AttributeText]? {
        var attributeTexts: [AttributeText] = []
        for text in texts {
            let attributes = Attribute.detect(in: text.string)
            for attribute in attributes {
                guard !attributeTexts.contains(where: { $0.attribute == attribute }) else { continue }
                attributeTexts.append(AttributeText(attribute: attribute, text: text))
            }
        }
        return attributeTexts
    }
    
    func getAttributeRecognizedTexts() -> [RecognizedText]? {
        
        var candidates: [[RecognizedText]] = [[]]
        
        for recognizedTexts in arrayOfRecognizedTexts {
            for text in recognizedTexts {
                guard Attribute.haveNutrientAttribute(in: text.string) else {
                    continue
                }
                
                /// Go through texts until a nutrient attribute is found
                let columnOfTexts = getColumnOfNutrientLabelTexts(startingFrom: text)
                    .sorted(by: { $0.rect.minY < $1.rect.minY })
                
                /// Add this to the array of candidates
                candidates.append(columnOfTexts)
            }
        }
        
        /// Now that we've parsed all the nutrient-label columns, pick the one with the most elements
        return candidates.sorted(by: { $0.count > $1.count }).first
    }
    
    func getColumnOfNutrientLabelTexts(startingFrom startingText: RecognizedText) -> [RecognizedText] {
        
        print("Getting column starting from: \(startingText.string)")

        let BoundingBoxMinXDeltaThreshold = 0.20
        var array: [RecognizedText] = [startingText]
        
        for recognizedTexts in arrayOfRecognizedTexts {
            /// Now go upwards to get nutrient-attribute texts in same column as it
            let textsAbove = recognizedTexts.filterSameColumn(as: startingText, preceding: true, removingOverlappingTexts: false).filter { !$0.string.isEmpty }.reversed()
            
            print("  ⬆️ textsAbove: \(textsAbove.map { $0.string } )")

            for text in textsAbove {
                print("    Checking: \(text.string)")
                let boundingBoxMinXDelta = abs(text.boundingBox.minX - startingText.boundingBox.minX)
                
                /// Ignore `text`s that are clearly not in-line with the `startingText`, in terms of its `boundingBox.minX` being more than `0.05` from the `startingText`s
                guard boundingBoxMinXDelta < BoundingBoxMinXDeltaThreshold else {
                    print("    ignoring because boundingBoxMinXDelta = \(boundingBoxMinXDelta)")
                    continue
                }

                /// Until we reach a non-nutrient-attribute text
                guard Attribute.haveNutrientAttribute(in: text.string) else {
                    print("    ✋🏽 ending search because no nutrient attributes can be detected in string")
                    break
                }
                
                /// Insert these into the start of our column of labels as we read them in
                array.insert(text, at: 0)
            }

            /// Now do the same thing downwards
            let textsBelow = recognizedTexts.filterSameColumn(as: startingText, preceding: false, removingOverlappingTexts: false).filter { !$0.string.isEmpty }
            
            print("  ⬇️ textsBelow: \(textsBelow.map { $0.string } )")

            for text in textsBelow {
                print("    Checking: \(text.string)")
                let boundingBoxMinXDelta = abs(text.boundingBox.minX - startingText.boundingBox.minX)
                
                /// Ignore `text`s that are clearly not in-line with the `startingText`, in terms of its `boundingBox.minX` being more than `0.05` from the `startingText`s
                guard boundingBoxMinXDelta < BoundingBoxMinXDeltaThreshold else {
                    print("    ignoring because boundingBoxMinXDelta = \(boundingBoxMinXDelta)")
                    continue
                }

                guard Attribute.haveNutrientAttribute(in: text.string) else {
                    print("    ✋🏽 ending search because no nutrient attributes can be detected in string")
                    break
                }
                
                array.append(text)
            }
        }

        print("    ✨Got: \(array.description)")
        print(" ")
        print(" ")
        return array
    }
}
