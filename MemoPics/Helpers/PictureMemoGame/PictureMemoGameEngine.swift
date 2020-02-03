//
//  PictureMemoGameEngine.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class PictureMemoGameEngine {
    private var whatToGuessContainer: Set<GameElement> = []
    private var whereToGuessContainer: Set<GameElement> = []
    private var finishedRounds: Int = 0
    private var numberOfFalseTaps: Int = 0
    private var gameDuration = GameDurations.sec60
    private var shouldBeExtraElement: Bool = false
    private let constantExtraNumbersForWhereToGuess: Int = 2
    private let probabilityOfExtraWhatElement: Int = 20
    private let probabilityOfExtraWhereElement: Int = 35
    
    private var numberOfIterations: Int {
        switch gameDuration {
        case .sec15:
            return 3
        case .sec30:
            return 4
        case .sec45:
            return 5
        case .sec60:
            return 6
        }
    }
    
    private var currentIteration: Int {
        return finishedRounds / numberOfIterations
    }

    private var numberOfGuessedItems: Int {
        return whatToGuessContainer.filter( { $0.isGuessed() == true } ).count
    }

    private var numberOfHiddenItems: Int {
        return whatToGuessContainer.filter( { $0.isHidden() == true } ).count
    }
    
    func initNewGame(for duration: GameDurations) throws {
        gameDuration = duration
        clearingForANewGame()
        
        try initRound()
    }
    
    func initRound() throws {
        clearingForANewRound()
        
        let numberOfWhatToGuess = getNumberOfWhatToGuess()
        try initWhatToGuessContainer(with: numberOfWhatToGuess)
        try initWhereToGuessContainer(with: getNumberOfWhereToGuess(basedOn: numberOfWhatToGuess))
    }
    
    func getWhat() -> [GameElement] {
        return whatToGuessContainer.map { $0 }
    }
    
    func getWhere() -> [GameElement] {
        return whereToGuessContainer.map { $0 }
    }
    
    func isElementToBeGuessed(_ element: PictureItem) -> Bool {
        guard let requestedItem = whatToGuessContainer.filter( { $0.getItem() == element } ).first else {
            return false
        }
        
        return ( requestedItem.isHidden() && !requestedItem.isGuessed() )
    }
    
    func increaseNumberOfGuessedItems(for elememt: PictureItem) {
        guard
            let requestedItem = whatToGuessContainer.filter( { $0.getItem() == elememt } ).first,
            var guessedItem = whatToGuessContainer.remove(requestedItem) else {
            return
        }
        
        guessedItem.setAsGuessed()
        whatToGuessContainer.insert(guessedItem)
    }
    
    func isAlreadyGuessed(_ element: PictureItem) -> Bool {
        guard let requestedItem = whatToGuessContainer.filter( { $0.getItem() == element } ).first else {
            return false
        }
        
        return requestedItem.isGuessed()
    }
    
    func isRoundFinished() -> Bool {
        return numberOfHiddenItems == numberOfGuessedItems
    }
    
    func getCurrentRound() -> Int {
        return finishedRounds + 1
    }
    
    func getFinishedRounds() -> Int {
        return finishedRounds
    }
    
    func finishCurrentRound() {
        finishedRounds += 1
    }
    
    func getNumberOfFalseTaps() -> Int {
        return numberOfFalseTaps
    }
    
    func getTotalNumberOfTaps() -> Int {
        return finishedRounds + numberOfFalseTaps
    }
    
    func thisTapWasFalse() {
        numberOfFalseTaps += 1
    }
    
    private func clearingForANewRound() {
        whatToGuessContainer = []
        whereToGuessContainer = []
    }
    
    private func clearingForANewGame() {
        finishedRounds = 0
        numberOfFalseTaps = 0
    }
    
    private func addNewItemTo(_ container: inout Set<GameElement>, of type: ContainerType, shouldBeHidden: Bool = true) {
        var result: (inserted: Bool, memberAfterInsert: GameElement)
        repeat {
            let newItem = GameElement(containerType: type, shouldBeHidden: shouldBeHidden)
            result = container.insert(newItem)
        } while !result.inserted
    }
    
    private func initWhatToGuessContainer(with countOfElements: Int) throws {
        let numberOfHiddenElements = countOfElements - (shouldBeExtraElement ? 1 : 0)
        
        guard numberOfHiddenElements > 0 else {
            throw AppError.incorrectCountValue
        }
        
        for _ in 0..<numberOfHiddenElements {
            addNewItemTo(&whatToGuessContainer, of: .whatToGuess, shouldBeHidden: true)
        }
        
        if shouldBeExtraElement {
            addNewItemTo(&whatToGuessContainer, of: .whatToGuess, shouldBeHidden: false)
        }
    }
    
    private func initWhereToGuessContainer(with countOfElements: Int) throws {
        guard countOfElements > 0 else {
            throw AppError.incorrectCountValue
        }
        
        guard countOfElements > whatToGuessContainer.count else {
            throw AppError.whereContainerCountIsLessWhanWhatContainerCount
        }
        
        whatToGuessContainer.forEach( {
            (element: GameElement) in
            
            let newItem = GameElement(pictureItem: element.getItem(),
                                      containerType: .whereToGuess,
                                      shouldBeHidden: false
                                        )
            whereToGuessContainer.insert(newItem)
        } )
        
        for _ in whatToGuessContainer.count..<countOfElements {
            addNewItemTo(&whereToGuessContainer, of: .whereToGuess)
        }
    }
    
    private func getNumberOfWhatToGuess() -> Int {
        let extraElement = Int.random(in: 0..<100) < probabilityOfExtraWhatElement ? 1 : 0
        shouldBeExtraElement = extraElement == 1
        
        return currentIteration + 1 + extraElement
    }
    
    private func getNumberOfWhereToGuess(basedOn numberOfWhatToGuess: Int) -> Int {
        let shouldBeExtraElement = Int.random(in: 0..<100) < probabilityOfExtraWhereElement ? 1 : 0

        return numberOfWhatToGuess + constantExtraNumbersForWhereToGuess + shouldBeExtraElement
    }
}
