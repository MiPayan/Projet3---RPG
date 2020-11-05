//
//  Team.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Player {
    
    // MARK: -   
    
    var name: String
    /// player name
    var characterTeam: [Character] = []
    /// player team
    let maxPicks = 3
    var characterName: [String] = []
    var chooseCharacter: Character?
    var targetChoice: Character?
    var defeat = false
    
    init(name: String) {
        self.name = name
    }
    
    // the function allows you  to choose characters
    // player --> player who chose the character
    // picks -->  the choice of the type of characters between warrior, colossus, magus and priest
    func chooseCharacterName(player: Player, picks: CharacterType) {
        while true {
            // a loop for asking the name
            print("Choose \(picks) name:")
            if let name = readLine() {
                if characterName.contains(name) {
                    print("This name is already choosen!")
                } else if name.isEmpty {
                    print("")
                } else {
                    switch picks {
                    case .warrior:
                        player.characterTeam.append(Warrior(name: name))
                    case .colossus:
                        player.characterTeam.append(Colossus(name: name))
                    case .magus:
                        player.characterTeam.append(Magus(name: name))
                    case .priest:
                        player.characterTeam.append(Priest(name: name))
                    }
                    print("Your \(picks) \(name) has been added to your team.")
                    characterName.append(name)
                    return
                    
                }
            }
        }
    }
    
    private func characterPick(_ player: Player) -> Character? {
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return nil
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return nil
            }
            
            guard numberChoose <= maxPicks, numberChoose > 0 else {
                print("You only have \(maxPicks) characters")
                return nil
            }
            
            guard isAlive(player.characterTeam[numberChoose - 1]) else {
                print("You need to choose a character")
                return nil
            }
            return player.characterTeam[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return nil
    }
    
    func chooseTeamCharacter() -> Character? {
        // For choose the character to inflige damage at the ennemy or heal an ally
        while true {
            if chooseCharacter == nil {
                print("\(name), choose a character to fight:")
            } else {
                print("\(name), choose an ally to heal:")
            }
            
            characterDescription(self)
            if let selectCharacter = characterPick(self) {
                return selectCharacter
                
            }
        }
    }
    
    func chooseTarget() {
        if self.chooseCharacter is Priest {
            guard let target = self.chooseTeamCharacter() else {
                return
            }
            
            self.targetChoice = target
        } else {
            guard let target = self.characterAttaking(InGame.targetPlayer) else {
                return
            }
            self.targetChoice = target
        }
    }
    
    private func characterDescription(_ player: Player) {
        let numberChoice = 1
        for character in player.characterTeam {
            print("\(numberChoice) \(character.die())")
        }
    }
    
    private func characterAttaking(_ player: Player) -> Character? {
        while true {
            print("Who is the target? Chosen from the team of \(player.name) ")
            
            characterDescription(player)
            if let targetCharacter = characterPick(player) {
                return targetCharacter
            }
        }
    }
    
    private func isAlive(_ character: Character) -> Bool { 
        if character.isDead {
            print("This character is dead.")
            return false
        }
        return true
    }
    
    private func ifThePlayerLost() {
        let charactersAreDead = characterTeam.filter
        { $0.isDead }
        if charactersAreDead.count == maxPicks {
            self.defeat = true
        }
    }
}
