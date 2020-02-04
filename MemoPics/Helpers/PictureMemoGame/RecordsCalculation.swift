//
//  RecordsCalculation.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 29.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

struct RecordsCalculation {
    let finishedRounds: Int
    let gameDuration: Int
    let lastRecord: RecordsScale
    
    init(finishedRounds: Int, gameDuration: GameDurations) {
        self.finishedRounds = finishedRounds
        self.gameDuration = gameDuration.rawValue
        
        let savedRecord = UserDefaults.standard.double(forKey: AuxiliaryStringKeys.lastRecordSettingsKey.rawValue)
        
        if let savedRecordsScale = RecordsScale(rawValue: savedRecord) {
            lastRecord = savedRecordsScale
        } else {
            lastRecord = RecordsScale.novice
        }
    }
    
    func getRecordsTitle() -> String {
        var lastIndex = 0
        for index in RecordsScale.allCases.indices {
            let scaledFinishedRounds = Int((Double(gameDuration) / RecordsScale.allCases[index].rawValue).rounded())
            if scaledFinishedRounds <= finishedRounds {
                break
            }
            
            lastIndex = index
        }
        
        let resultChange: String
                
        if lastRecord == RecordsScale.allCases[lastIndex] {
            resultChange = NSLocalizedString("SameResult.Label", comment: "Text.Label.Result")
        } else if lastRecord < RecordsScale.allCases[lastIndex] {
            resultChange = NSLocalizedString("WorseResult.Label", comment: "Text.Label.Result")
        } else {
            resultChange = NSLocalizedString("BetterResult.Label", comment: "Text.Label.Result")
        }
        
        saveRecordsScale(for: lastIndex)

        return "\(resultChange)\n\(RecordsScaleTitle.allCases[lastIndex].localizedString())"
    }
    
    private func saveRecordsScale(for index: Int) {
        UserDefaults.standard.set(RecordsScale.allCases[index].rawValue, forKey: AuxiliaryStringKeys.lastRecordSettingsKey.rawValue)
    }
}
