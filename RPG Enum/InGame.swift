//
//  InGame.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class InGame {
    
    var players = [Player]()
    let maxPlayers = 2
    var bonus = 0
    let percentageBonusChest = 5
    var turns = 1
    var playingPlayer: Player {
        players[turns % 2]
    }
    var targetPlayer: Player {
        players[(turns + 1) % 2]
    }
    
    func start() {
        print("""
            Hi! What do you want to do? (For make your choice, enter 1 or 2)
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
        print("⚠️ How to play? Same as character selection. Select your character to attack or heal, and after, select your target. ⚠️")
        print("Let's go to fight!")
        
        fight()
    }
    
    private func fight() {
        let fightingCharacter = playingPlayer.selectCharacterForHealingOrFighting()
        randomChest(fightingCharacter: fightingCharacter)
        
        let targetCharacter = chooseTarget(fightingCharacter: fightingCharacter)
        fightingCharacter.actionOn(targetCharacter)
        
        if targetPlayer.isDefeat() {
            print("⚰️ All of your characters are dead.. Sorry, \(targetPlayer.name) you lost. ⚰️")
            statistics()
        } else {
            turns += 1
            return fight()
        }
    }
    
    private func chooseTarget(fightingCharacter: Character) -> Character {
        let player = fightingCharacter is Priest ? playingPlayer : targetPlayer
        return player.selectAllyToHealOrEnemyToAttack(character: fightingCharacter)
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
            bonus += 1
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
        let winner = players.filter { !$0.isDefeat() }
        
        print("""
            ❌ THE GAME IS OVER ❌
            🥂 The winner is --|  \(winner[0].name)  |-- 🥂
            ♻️ The game was finished in \(turns)turns ♻️
            🎁 Bonus number: \(bonus) 🎁
            """)
    }
    
    private func exitGame() {
        print("See you later. 👋🏼")
    }
}
