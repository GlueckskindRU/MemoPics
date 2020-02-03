//
//  AppError.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import Foundation

enum AppError: Error {
    case incorrectCountValue
    case whereContainerCountIsLessWhanWhatContainerCount
    case defaultErrorValue
    
    func getErrorText() -> String {
        switch self {
        case .incorrectCountValue:
            return NSLocalizedString("incorrectCountValue.ErrorText", comment: "ErrorHandle")
        case .whereContainerCountIsLessWhanWhatContainerCount:
            return NSLocalizedString("whereContainerCountIsLessWhanWhatContainerCount.ErrorText", comment: "ErrorHandle")
        case .defaultErrorValue:
            return NSLocalizedString("defaultErrorValue.ErrorText", comment: "ErrorHandle")
        }
    }
}
