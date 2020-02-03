//
//  SettingsController.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 09.01.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

class SettingsController {
    private var gameDuration: GameDurations
    
    init() {
        let savedDuration = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.gameDurutionSettingsKey.rawValue)
        
        if let duration = GameDurations(rawValue: savedDuration) {
            self.gameDuration = duration
        } else {
            self.gameDuration = GameDurations.sec15
        }
    }
    
    func setNewGameDuration(_ newDuration: GameDurations) {
        gameDuration = newDuration
    }
    
    func saveGameDuration() {
        UserDefaults.standard.set(gameDuration.rawValue, forKey: AuxiliaryStringKeys.gameDurutionSettingsKey.rawValue)
    }
    
    func getGameDuration() -> GameDurations {
        return gameDuration
    }
}
