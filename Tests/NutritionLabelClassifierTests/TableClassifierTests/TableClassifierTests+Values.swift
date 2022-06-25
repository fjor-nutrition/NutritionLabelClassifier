import XCTest

@testable import NutritionLabelClassifier

let valueExpectations: [String: [[[Value?]]]?] = [
    
    "C19F126E-6D6E-464A-B7C4-718AA4384CC2": [
        [
            [v(460, .kj),   v(2218, .kj)],
            [v(6, .g),      v(28, .g)],
            [v(2.5, .g),    v(13, .g)],
            [v(0, .g),      v(0, .g)],
            [v(0, .g),      v(2, .g)],
            [v(13, .g),     v(66, .g)],
            [v(3, .g),      v(15, .g)],
            [v(1, .g),      v(5, .g)],
            [v(130, .mg),   v(650, .mg)]
        ]
    ],
    
    "DE476A74-8174-4E9C-81DA-450F578F039D": [
        [
            [v(735, .kj), v(13, .g), v(3.2, .g), v(0.9, .g), v(0, .g), v(14, .g)],
            [v(412, .kj), v(7.3, .g), v(1.8, .g), v(0, .g), v(0, .g), v(7.8, .g)],
        ]
    ],

//    "B1E5C59E-7B94-4570-B226-DD9D17BC743E" : [
//        [
//            [v(1239, .kj), v(11, .g), v(7.7, .g), v(43, .g), v(25, .g), v(2.2, .g), v(4.9, .g), v(0.81, .g)],
//            [v(992, .kj), v(9, .g), v(6.2, .g), v(34, .g), v(20, .g), v(1.8, .g), v(3.9, .g), v(0.65, .g)]
//        ]
//    ],
//
//    "75C66881-51E5-4A42-92E6-F3B3953BC8E6": [
//        [
//            [v(1387, .kj), v(35.1, .g), v(22, .g), v(8.6, .g), v(0.7, .g), v(1.2, .g), v(121, .mg), v(3.3, .g), v(3.3, .g), v(0, .g), v(2.1, .g), v(0.07, .g), v(30, .mg)],
//            [v(277, .kj), v(7, .g), v(4.4, .g), v(1.7, .g), v(0.1, .g), v(0.2, .g), v(24, .mg), v(0.7, .g), v(0.7, .g), v(0, .g), v(0.4, .g), v(0.01, .g), v(6, .mg)]
//        ]
//    ],
//    "9C26D1D5-50B2-4933-B906-29824617FD96": [
//        [
//            [v(1387, .kj), v(35.1, .g), v(22, .g), v(8.6, .g), v(0.7, .g), v(1.2, .g), v(121, .mg), v(3.3, .g), v(3.3, .g), v(0, .g), v(2.1, .g), v(0.07, .g), v(30, .mg)],
//            [v(277, .kj), v(7, .g), v(4.4, .g), v(1.7, .g), v(0.1, .g), v(0.2, .g), v(24, .mg), v(0.7, .g), v(0.7, .g), v(0, .g), v(0.4, .g), v(0.01, .g), v(6, .mg)]
//        ]
//    ],
//    "1B51A831-FE9C-4752-B526-0ED7823EA591": [
//        [
//            [v(1387, .kj), v(35.1, .g), v(22, .g), v(8.6, .g), v(0.7, .g), v(1.2, .g), v(121, .mg), v(3.3, .g), v(3.3, .g), v(0, .g), v(2.1, .g), v(0.07, .g), v(30, .mg)],
//            [v(277, .kj), v(7, .g), v(4.4, .g), v(1.7, .g), v(0.1, .g), v(0.2, .g), v(24, .mg), v(0.7, .g), v(0.7, .g), v(0, .g), v(0.4, .g), v(0.01, .g), v(6, .mg)]
//        ]
//    ],

    //TODO: Do Haribo Next, Goldbears first then Fizzy Cola
    
//    "99D1A080-19CF-4A08-B8B7-1BD5E4D9CB40": nil,
//    "3C53CC91-34D1-46EE-92BE-328ABDC20342": nil,
//    "15C9C2C9-5012-43A3-835A-3FB0A2DD1E2D": nil,
//    "0D04AEB7-95B1-4781-AFCA-38BF1036DAAC": nil,
//    "26F3916F-B688-49CC-A0DD-4F757B6735FD": nil,
//    "B3DC8D45-2F10-41C8-ACDF-2A00AFE6E0D3": nil,
//    "0A321001-BD7F-4A8A-8F62-FDE636B64CE3": nil,
//    "749A730F-17B1-47DE-9A5B-129C152D657E": nil,
//    "AE8C75F6-D65E-4F5F-A2D9-47FC81C158B9": nil,
//    "0494F267-A8C9-4796-8D23-DA6098C1AA5B": nil,
//    "BF1EE7E6-96C0-4929-8F9B-C3E4EC7782F2": nil,
//    "DF58E0D9-56BF-404C-8B36-675F797411A6": nil,
//    "0CBD5EF1-01E2-482E-891D-21A32479CFB0": nil,
//    "91F8FEFC-DF56-492D-BAB0-3EC24ADB84F3": nil,
//    "FCA442D0-9F3A-4AF9-9460-D3075C7FB2A0": nil,
//    "D65B73DA-E3E0-4968-83EF-06EA3E629A20": nil,
//    "6C3008A5-A6B0-438D-9332-827B52421643": nil,
//    "CC5957B2-1208-4A85-A728-5EABA1348DB9": nil,
//    "BB071452-B8C0-492D-890E-122BDBBF5909": nil,
//    "D3E7433B-AF49-4ACB-84EC-8366795CE048": nil,
//    "18E7934B-8B75-4E60-A041-7837D1E3DC27": nil,
//    "3A7D1894-FD50-4226-8A97-8471F4E34E89": nil,
//    "4CF0CBA5-C746-4844-BF54-27A92C808280": nil,
//    "5410D64B-4A8D-4183-8C81-EC82ABBFA648": nil,
//    "B789ED71-802F-42EF-85A5-FD9FEED77E6F": nil,
//    "083C5BAA-2DDA-42E5-8A6C-DCD1A3E5B7E1": nil,
//    "CE17DE0B-1480-4195-ACD0-C706FF9EE86F": nil,
//    "9CFDEE5E-005E-408F-B1E5-2EF751747988": nil,
//    "85025F31-4CD8-48D5-8AB0-246D8EAF0465": nil,
//    "9BA54F68-9FC5-430B-90C2-158A2BD1B29D": nil,
//    "90520604-4AF2-4C16-8C5E-F522F2309ECE": nil,
//    "92C3B115-CBED-4E4D-B831-4BF7BF973BCD": nil,
//    "674347E4-7B53-4409-95AF-07FD0560ADBA": nil,
//    "0E6CBF93-F98E-4922-8058-CE987BBD9617": nil,
//    "B362A01E-8762-4BD4-B7E9-ACED4D919B5B": nil,
//    "4527F77A-3514-4EAB-9DC1-214D10BBE9BA": nil,
//    "2E51C3CE-7363-412E-AF68-EB3F3ED9B343": nil,
//    "662AD301-6914-49EE-B8D2-DAFE00AF7F7F": nil,
//    "DE38ABA0-A8D7-46A5-8DBB-7E2DE983F9F4": nil,
//    "180F6D30-B077-4787-BE2C-22D3C4FC00E3": nil,
//    "1B9397C9-27E5-4E9F-BE75-17C878A2F323": nil,
//    "40E7C0B9-E9CC-4FA7-93A3-B3623FAB23FF": nil,
//    "7A7E14B8-EFA8-4140-987F-65439B83D99A": nil,
//    "713A721E-A470-4DA8-B44E-E939FEF9777A": nil,
//    "BD53EFF6-2AF9-4FCA-8865-67CCB4BA9B69": nil,
//    "D8809685-A90E-4756-BCA1-79B2D8C0D090": nil,
]

//let SingledOutTestCase: UUID? = nil

// 🥳 Looks like it's passing for these
//let SingledOutTestCase: UUID? = UUID(uuidString: "B2C50752-AE52-493A-AD79-69DA4EA74504")!
//let SingledOutTestCase: UUID? = UUID(uuidString: "9C26D1D5-50B2-4933-B906-29824617FD96")!
//let SingledOutTestCase: UUID? = UUID(uuidString: "DE476A74-8174-4E9C-81DA-450F578F039D")!
//let SingledOutTestCase: UUID? = UUID(uuidString: "CDD8E0DD-7D2B-4802-9C1D-54EFFBB71E58")!

let SingledOutTestCase: UUID? = UUID(uuidString: "DE476A74-8174-4E9C-81DA-450F578F039D")!
//let SingledOutTestCase: UUID? = UUID(uuidString: "C19F126E-6D6E-464A-B7C4-718AA4384CC2")!

let TestPassingTestCases = false
