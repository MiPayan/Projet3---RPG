//
//  InGame.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

///  var/let --> permet d'utiliser la variable directement sur la class ou struct sans passer par une instance de celle-ci. Clarifie le texte, évite les pavets
///guard, permet d'avoir un code plus lisible car il existe dans toute la portée de la fonction
/// .filter { $0.isDead } ou { $1.isDead }, permet de vérifier les conditions de chaque éléments, pour stocker dans un nouveau tableau(array) et créer une sortie

class InGame {
    
    var players = [Player]()
    let maxPlayers = 2
    let chestPercent = 5
    var bonusChest = 0
    var turns = 1
    var playingPlayer: Player {
        players[turns % 2]
    }
    var targetPlayer: Player {
        players[(turns + 1) % 2]
    }
    
    func start() {
        print("""
            1 - 🎮 New Game 🎮 -
            2 - ❌ Quit ❌ -
            """)
        
        if let line = readLine(){
            switch line {
            case "1":
                createPlayers()
            case "2":
                exitGame()
            default:
                print("🤞🏼 Try again! 🤞🏼")
                start()
            }
        }
    }
    
    /// Create the players. 
    private func createPlayers() {
        while players.count < maxPlayers {
            print("Choose name of the player \(players.count + 1):")
            if let name = readLine(), !name.isEmpty {
                players.append(Player(name: name))
            } else {
                print("😡 You need to choose a name! 😡")
            }
        }
        
        selectCharacterForEachPlayer()
    }
    
    func selectCharacterForEachPlayer() {
        for player in players {
            player.selectCharacter()
            
            print("✅ \(player.name) is ready! ✅")
        }
        print("Let's go to fight!")
        
        fight()
    }
    
    func fight() {
        var thePlayerLost = false
        while thePlayerLost == false {
            guard let character = playingPlayer.chooseCharacterTeam() else {
                return
            }
            
            playingPlayer.chooseCharacter = character
            randomChest(playingPlayer.chooseCharacter)
            chooseTarget(player: playingPlayer)
            
            if let theCharacter = playingPlayer.chooseCharacter as? Priest {
                guard let target = playingPlayer.targetChosen else {
                    return
                }
                theCharacter.healing(target)
                
            } else {
                guard let target = playingPlayer.targetChosen else {
                    return
                }
                character.actionOn(target)
            }
            playingPlayer.ifThePlayerLost()
            targetPlayer.ifThePlayerLost()
            
            for player in players {
                if player.defeat {
                    print("⚰️ All of your characters are dead.. Sorry but, \(player.name) you lost. ⚰️")
                    thePlayerLost = true
                }
            }
            turns += 1
            playingPlayer.chooseCharacter = nil
            playingPlayer.targetChosen = nil
        }
        statistics()
    }
    
    func chooseTarget(player: Player) {
        if player.chooseCharacter is Priest {
            guard let target = player.chooseCharacterTeam() else {
                return
            }
            
            player.targetChosen = target
        } else {
            guard let target = player.targetTheEnemyCharacter(targetPlayer) else {
                return
            }
            player.targetChosen = target
        }
    }
    
    private func randomChest(_ character: Character?) {
        guard arc4random_uniform(100) <= chestPercent else {
            return
        }
        print("🎁 A bonus chest appear! 🎁")
        
        bonusChest += 1
        if let character = playingPlayer.chooseCharacter {
            character.bonusWeapon()
        }
    }
    
    private func statistics() {
        let winner = players.filter { !$0.defeat }
        
        print("""
            ❌ THE GAME IS OVER ❌
            🥂 The winner is --|  \(winner[0].name)  |-- 🥂
            ♻️ The game was finished in \(turns)turns ♻️
            🎁 Bonus chest number: \(bonusChest) 🎁
            """)
    }
    
    private func exitGame() {
        print("See you later. 👋🏼")
    }
}

