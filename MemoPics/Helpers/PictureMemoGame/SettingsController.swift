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
    private var playingCardsDifficulty: CardsPlayingDifficulty
    private var playingCardsPack: PackOfCards
    
    init() {
        let savedDuration = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.gameDurutionSettingsKey.rawValue)
        let savedPlayingCardsDifficulty = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.playingCardsDifficultySettingsKey.rawValue)
        let savedPlayedCardsPackIsFull = UserDefaults.standard.bool(forKey: AuxiliaryStringKeys.playingCardsPackSettingsKey.rawValue)
        
        if let duration = GameDurations(rawValue: savedDuration) {
            self.gameDuration = duration
        } else {
            self.gameDuration = GameDurations.sec15
        }
        
        if let cardsDifficulty = CardsPlayingDifficulty(rawValue: savedPlayingCardsDifficulty) {
            self.playingCardsDifficulty = cardsDifficulty
        } else {
            self.playingCardsDifficulty = CardsPlayingDifficulty.easy
        }
        
        if savedPlayedCardsPackIsFull {
            self.playingCardsPack = PackOfCards.full
        } else {
            self.playingCardsPack = PackOfCards.short
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(gameDuration.rawValue, forKey: AuxiliaryStringKeys.gameDurutionSettingsKey.rawValue)
        UserDefaults.standard.set(playingCardsDifficulty.rawValue, forKey: AuxiliaryStringKeys.playingCardsDifficultySettingsKey.rawValue)
        UserDefaults.standard.set(playingCardsPack == .full, forKey: AuxiliaryStringKeys.playingCardsPackSettingsKey.rawValue)
    }
    
// MARK: - Game Duration
    func setNewGameDuration(_ newDuration: GameDurations) {
        gameDuration = newDuration
    }
    
    func getGameDuration() -> GameDurations {
        return gameDuration
    }
    
// MARK: - Playing Cards Difficulty
    func setNewPlayingCardsDifficulty(_ newDifficulty: CardsPlayingDifficulty) {
        playingCardsDifficulty = newDifficulty
    }
    
    func getPlayingCardsDifficulty() -> CardsPlayingDifficulty {
        return playingCardsDifficulty
    }
    
// MARK: - Playing Cards Pack
    func setNewPlayingCardsPack(_ newPack: PackOfCards) {
        playingCardsPack = newPack
    }
    
    func getPlayingCardsPack() -> PackOfCards {
        return playingCardsPack
    }
}
