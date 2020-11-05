//
//  InGame.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

/// static var/let --> permet d'utiliser la variable directement sur la class ou struct sans passer par une instance de celle-ci. Clarifie le texte, évite les pavets
///guard, permet d'avoir un code plus lisible car il existe dans toute la portée de la fonction
/// .filter { $0.isDead } ou { $1.isDead }, permet de vérifier les conditions de chaque éléments, pour stocker dans un nouveau tableau(array) et créer une sortie

class InGame {
    
    static var players: [Player] = []
    static let maxPlayers = 2
    static var turns = 1
    static var playingPlayer: Player {
        players[turns % 2]
    }
    static var targetPlayer: Player {
        players[(turns + 1) % 2]
    }
    
    static func start() {
        print("""
            1. New Game
            2. Quit
            """)
        
        if let line = readLine(){
            switch line {
            case "1":
                createPlayers()
            case "2":
                leaveTheGame()
            default:
                print("Try again")
                start()
            }
        }
    }
    
    static func createPlayers() {
        while players.count < maxPlayers {
            print("Choose name of the player")
            if let name = readLine() {
                if !name.isEmpty {
                    players.append(Player(name: name))
                    
                } else {
                    print("You need to choose a name")
                }
            }
        }
        
        picksCharacterMenu()
    }
    
    static func picksCharacterMenu() {
        for player in players {
            while player.characterTeam.count < player.maxPicks {
                print("""
                    \(player.name) choose \(player.characterTeam) characters:
                    1. Warrior -- 
                    Damage: 20  ||  Lifepoint: 90
                    2. Colossus --
                    Damage: 10  ||  Lifepoint: 110
                    3. Magus --
                    Damage: 25  ||  Lifepoint: 70
                    4. Priest --
                    Healing: 10  ||  Lifepoint: 90
                    """)
                
                if let picks = readLine() {
                    if !picks.isEmpty {
                        switch picks {
                        case "1":
                            player.chooseCharacterName(player: player, picks: CharacterType.warrior )
                        case "2":
                            player.chooseCharacterName(player: player, picks: CharacterType.colossus)
                        case "3":
                            player.chooseCharacterName(player: player, picks: CharacterType.magus)
                        case "4":
                            player.chooseCharacterName(player: player, picks: CharacterType.priest)
                        default:
                            print("Please, make your choice")
                        // if the choice is different of 1,2,3 or 4.
                        }
                        
                    } else {
                        print("You need to choose a character, between 1,2,3 and 4")
                        // if the choice is empty.
                    }
                }
            }
            
            print("\(player.name) is ready")
        }

        print("Let's go to fight!")
        
        fight()
    }
    
    static func fight() {
        var thePlayerLost = false
        while thePlayerLost == false {
            guard let character = playingPlayer.chooseTeamCharacter() else {
                return
            }
            
            playingPlayer.chooseCharacter = character
            playingPlayer.chooseTarget()
            
            if let theCharacter = playingPlayer.chooseCharacter as? Priest {
                guard let target = playingPlayer.targetChoice else {
                    return
                }
            }
        }
    }
    
    static func statistics() {
        let winner = players.filter { !$0.defeat }
        
        print("""
            THE GAME IS OVER
            The winner is --|  \(winner[0].name)  |--
            The game was finished in \(turns)turns
            """)
    }
    
    static func leaveTheGame() {
        print("See you later")
    }
}
