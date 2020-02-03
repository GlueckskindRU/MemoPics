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
    
    init(finishedRounds: Int, gameDuration: GameDurations) {
        self.finishedRounds = finishedRounds
        self.gameDuration = gameDuration.rawValue
    }
    
    func getRecordsTitle() -> String {
        var lastIndex = 0
        for index in RecordsScale.allCases.indices {
            let scaledFinishedRounds = Int((Double(gameDuration) / RecordsScale.allCases[index].rawValue).rounded())
            if scaledFinishedRounds <= finishedRounds {
                return RecordsScaleTitle.allCases[index].localizedString()
            }
            
            lastIndex = index
        }
        
        return RecordsScaleTitle.allCases[lastIndex].localizedString()
    }
}
