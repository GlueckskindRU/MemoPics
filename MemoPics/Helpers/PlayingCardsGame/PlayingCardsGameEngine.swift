//
//  PlayingCardsGameEngine.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 11.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

class PlayingCardsGameEngine {
    private var cardsPackSet: Set<PlayingCard> = []
    private var cardsPack: [PlayingCard] = []
    private var playedPack: PackOfCards = .full
    private var gameDifficulty: CardsPlayingDifficulty = .easy
    private var lastOpenedCard: PlayingCard?
    private var currentlyOpenedCard: PlayingCard?
    private var numberOfCorrectAnswers: Int = 0
    private var numberOfPlayedRounds: Int = -1 // as the game starts with the increasing of this value and should indicate zero initially
    
    func initNewGame(for packOfCards: PackOfCards, having gameDifficulty: CardsPlayingDifficulty) {
        self.playedPack = packOfCards
        self.gameDifficulty = gameDifficulty
        clearingForANewGame()
        initCardsPack()
    }
    
    func startNewRound() -> PlayingCard? {
        return openACard()
    }
    
    func isCardGuessed(_ card: PlayingCard) -> Bool {
        guard
            let lastOpenedCard = lastOpenedCard,
            let currentlyOpenedCard = currentlyOpenedCard else {
                return false
        }
        
        if lastOpenedCard == card {
            numberOfCorrectAnswers += 1
        }
        
        self.lastOpenedCard = currentlyOpenedCard
        
        return lastOpenedCard == card
    }
    
    func getNumberOfCorrectAnswers() -> Int {
        return numberOfCorrectAnswers
    }
    
    func getTotalPlayedRounds() -> Int {
        return numberOfPlayedRounds
    }
    
    private func clearingForANewGame() {
        cardsPackSet = []
        cardsPack = []
        numberOfPlayedRounds = -1
        numberOfCorrectAnswers = 0
        lastOpenedCard = nil
        currentlyOpenedCard = nil
    }
    
    private func initCardsPack() {
        repeat {
            addNewCard()
        } while cardsPackSet.count < gameDifficulty.rawValue
        
        cardsPack = cardsPackSet.map { $0 }
    }
    
    private func addNewCard()  {
        var result: (inserted: Bool, memberAfterInsert: PlayingCard)
        
        var newCard: PlayingCard
        
        repeat {
            repeat {
                newCard = PlayingCard()
            } while !newCard.isIncluded(into: playedPack)
            
            result = cardsPackSet.insert(newCard)
        } while !result.inserted
    }
    
    private func openACard() -> PlayingCard? {
        numberOfPlayedRounds += 1
        
        if let openedCard = cardsPack.popLast() {
            currentlyOpenedCard = openedCard
            if lastOpenedCard == nil {
                lastOpenedCard = openedCard
            }
            return openedCard
        } else {
            return nil
        }
    }
}
