//
//  InGame.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

///  static --> permet d'utiliser la variable directement sur la class ou struct sans passer par une instance de celle-ci. Clarifie le texte, évite les pavets
///guard, permet d'avoir un code plus lisible car il existe dans toute la portée de la fonction
/// .filter { $0.isDead } ou { $1.isDead }, permet de vérifier les conditions de chaque éléments, pour stocker dans un nouveau tableau(array) et créer une sortie

class InGame {
    
    var players = [Player]()
    let maxPlayers = 2
    let percentageBonusChest = 5
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
            if let name = readLine() {
                if playerNameHasAlreadyChosen(name: name) {
                    print("This name is already chosen.")
                } else if name.isEmpty {
                    print("😡 You must to choose a name! 😡")
                } else if name != name.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("❌ Sorry, the space are not allowed. ❌")
                } else {
                    players.append(Player(name: name))
                }
            }
        }
        selectCharacterForEachPlayer()
    }
    
    private func playerNameHasAlreadyChosen(name: String) -> Bool {
        for player in players {
            if player.name == name {
                return true
            }
        }
        return false
    }
    
    private func selectCharacterForEachPlayer() {
        for player in players {
            player.selectCharacter()
            
            print("✅ \(player.name) is ready! ✅")
        }
        print("Let's go to fight!")
        
        fight()
    }
    
    private func fight() {
        var thePlayerLost = false
        while thePlayerLost == false {
            let fightingCharacter = playingPlayer.selectCharacterForHealingOrFighting()
            
            randomChest(fightingCharacter: fightingCharacter)
            let targetCharacter = chooseTarget(fightingCharacter: fightingCharacter)
            
            fightingCharacter.actionOn(targetCharacter)
            
            playingPlayer.ifThePlayerLost()
            targetPlayer.ifThePlayerLost()
            
            for player in players {
                if player.defeat {
                    print("⚰️ All of your characters are dead.. Sorry but, \(player.name) you lost. ⚰️")
                    thePlayerLost = true
                }
            }
            turns += 1
        }
        statistics()
    }
    
    private func chooseTarget(fightingCharacter: Character) -> Character {
        if fightingCharacter is Priest {
            let characterToHeal = playingPlayer.selectAllyToHealOrEnemyToAttack(character: fightingCharacter)
            return characterToHeal
        } else {
            let characterToTarget = targetPlayer.selectAllyToHealOrEnemyToAttack(character: fightingCharacter)
            return characterToTarget
        }
    }
    
    private func randomChest(fightingCharacter: Character) {
        guard arc4random_uniform(100) <= percentageBonusChest else {
            return
        }
        if fightingCharacter is Warrior, hasAlreadyBonus(player: playingPlayer, weapon: DoubleSwords()) {
            return
        } else if fightingCharacter is Colossus, hasAlreadyBonus(player: playingPlayer, weapon: GiantFronde()) {
            return
        } else if fightingCharacter is Magus, hasAlreadyBonus(player: playingPlayer, weapon: VoidStaff()) {
            return
        } else if fightingCharacter is Priest, hasAlreadyBonus(player: playingPlayer, weapon: VoidStaff()) {
            return
        } else {
            bonusChest += 1
            fightingCharacter.bonusWeapon()
        }
    }
    
    private func hasAlreadyBonus(player: Player, weapon: Weapon) -> Bool {
        for bonus in player.characters {
            if bonus.weapon.name == weapon.name {
                return true
            }
        }
        return false
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
