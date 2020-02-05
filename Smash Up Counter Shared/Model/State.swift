//
//  State.swift
//  Smash Up Counter iOS
//
//  Created by Cyril on 23/02/2018.
//  Copyright © 2018 Cyril GY. All rights reserved.
//

/*
 The enum state describes the different state of the application:
    .none:                  undefined state of the application (must not be used, there is a problem if it used).
    .initializing:          the initial application data is being initialized, the application can not be used yet.
    .ready:                 the initial application data is initialized, the application can be used.
    .settingUpPlayers:      the players must be defined.
    .settingUpFactions:     the factions that must be played with must be selected.
    .factionsDistributed:   the selected factions are distributed to the players and are being revealed.
    .playing:               the players are playing, the scores can evolved.
    .endGame:               the game is done, a winner is named.
 */

// MARK: - Definition

enum State {
    case none
    case initializing
    case ready
    case settingUpPlayers
    case settingUpFactions
    case factionsDistributed
    case playing
    case endGame(winner: Player?)
}


// MARK: - Extension (Equatable)

extension State: Equatable {
    static func ==(lhs: State, rhs: State) -> Bool {
        switch lhs {
        case .none:
            switch rhs {
            case .none:
                return true
            default:
                return false
            }
        case .initializing:
            switch rhs {
            case .initializing:
                return true
            default:
                return false
            }
        case .ready:
            switch rhs {
            case .ready:
                return true
            default:
                return false
            }
        case .settingUpPlayers:
            switch rhs {
            case .settingUpPlayers:
                return true
            default:
                return false
            }
        case .settingUpFactions:
            switch rhs {
            case .settingUpFactions:
                return true
            default:
                return false
            }
        case .factionsDistributed:
            switch rhs {
            case .factionsDistributed:
                return true
            default:
                return false
            }
        case .playing:
            switch rhs {
            case .playing:
                return true
            default:
                return false
            }
        case .endGame(_):
            switch rhs {
            case .endGame(_):
                return true
            default:
                return false
            }
        }
    }
}
