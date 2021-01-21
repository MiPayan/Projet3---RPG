//
//  Player.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Player {

    let name: String
    var characters = [Character]()
    let maximumNumberOfSelectableCharacters = 3
    
    init(name: String) {
        self.name = name
    }
    
    private func chooseCharacterName(_ characterType: CharacterType) {
        print("Choose \(characterType) name:")
        if let name = readLine() {
            if isCharacterNameAlreadyChosen(name: name) {
                print("This name has been already choosen!")
                chooseCharacterName(characterType)
            } else if name.isEmpty {
                print("😡 You need to choose a name for your character! 😡")
                chooseCharacterName(characterType)
            } else if name != name.trimmingCharacters(in: .whitespacesAndNewlines) {
                print(" Your character needs a name without spaces.")
                chooseCharacterName(characterType)
            } else {
                switch characterType {
                case .warrior:
                    characters.append(Warrior(name: name))
                case .colossus:
                    characters.append(Colossus(name: name))
                case .magus:
                    characters.append(Magus(name: name))
                case .priest:
                    characters.append(Priest(name: name))
                }
                print("Your \(characterType) \(name) has been added to your team.")
            }
        }
    }
    
    private func isCharacterNameAlreadyChosen(name: String) -> Bool {
        for character in characters {
            if character.name == name {
                return true
            }
        }
        return false
    }
    
    private func selectCharacter() -> Character? {
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return selectCharacter()
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return selectCharacter()
            }
            
            guard numberChoose <= maximumNumberOfSelectableCharacters, numberChoose > 0 else {
                print("You only have \(maximumNumberOfSelectableCharacters) characters")
                return selectCharacter()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("You need to choose a character")
                return selectCharacter()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return selectCharacter()
    }
    
    func buildYourTeamBySelectingCharacters() {
        print(" ⚠️ The same character cannot be selected more than once. Select your character by entering 1, 2, 3 or 4 and choose a name for him. Maximum of three characters per team. ⚠️")
        while characters.count < maximumNumberOfSelectableCharacters {
            print("""
                \(name), you must choose \(3 - characters.count) character:
                1 - ⚔️ Warrior ⚔️ - Simple, basic but efficient.
                Damage: 20  ||  Lifepoint: 90
                2 - 💪🏼 Colossus 💪🏼 - Thick smelly creature, can't even see his feet.
                Damage: 10  ||  Lifepoint: 110
                3 - 🧙🏼‍♂️ Magus 🧙🏼‍♂️ - Devastating power, but enough sensitive.
                Damage: 25  ||  Lifepoint: 70
                4 - 🙏🏼 Priest 🙏🏼 - Robust ally, incapable of causing harm.
                Healing: 10  ||  Lifepoint: 90
                """)
            
            if let picks = readLine(), !picks.isEmpty {
                switch picks {
                case "1":
                    if hasBeenAlreadyChosen(.warrior) {
                        print("The \(CharacterType.warrior) is already chosen! Please, make another choice.")
                        buildYourTeamBySelectingCharacters()
                    } else {
                        chooseCharacterName(.warrior)
                    }
                case "2":
                    if hasBeenAlreadyChosen(.colossus) {
                        print("The \(CharacterType.colossus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.colossus)
                    }
                case "3":
                    if hasBeenAlreadyChosen(.magus) {
                        print("The \(CharacterType.magus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.magus)
                    }
                case "4":
                    if hasBeenAlreadyChosen(.priest) {
                        print("The \(CharacterType.priest) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.priest)
                    }
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
    
    /// The player can only choose a character type once. For example, if the choice is warrior, he cannot choose that type a second time.
    private func hasBeenAlreadyChosen(_ characterType: CharacterType) -> Bool { 
        for character in characters {
            if character.characterType == characterType {
                return true
            }
        }
        return false
    }
    
    /// For choose the character to inflige damage at the ennemy or heal an ally
    func selectCharacterForHealingOrFighting() -> Character {
        print("\(name), choose a character to fight or heal:")
        
        diplayCharactersDescription()
        
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return selectCharacterForHealingOrFighting()
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return selectCharacterForHealingOrFighting()
            }
            
            guard numberChoose <= maximumNumberOfSelectableCharacters, numberChoose > 0 else {
                print("You only have \(maximumNumberOfSelectableCharacters) characters")
                return selectCharacterForHealingOrFighting()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("You need to choose a character")
                return selectCharacterForHealingOrFighting()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return selectCharacterForHealingOrFighting()
    }

    private func diplayCharactersDescription() {
        for (index, character) in characters.enumerated() {
            print("\(index + 1) \(character.showStatus())")
        }
    }
    
    /// Choice of the target to attack between the three characters enemy.
    func selectAllyToHealOrEnemyToAttack(character: Character) -> Character {
        if character is Priest {
            print("🎯 \(name), which ally needs heal? 🎯")
        } else {
            print("🎯 Who is the target? Chosen from the team of \(name). 🎯")
        }
        diplayCharactersDescription()
        
        if let targetTheAllyCharacter = selectCharacter() { /// Le nom de la constante n'est pas clair du tout.
            return targetTheAllyCharacter
        }
        return selectAllyToHealOrEnemyToAttack(character: character)
    }
    
    /// To check if character is dead.
    private func isAlive(_ character: Character) -> Bool {
        if character.isDead() {
            print("This character is dead. 💀")
            return false
        }
        return true
    }
    
    /// To check if all of the characters of team are dead. The player lost, else, the game continues.
    func isDefeat() -> Bool {
        let charactersAreDead = characters.filter { $0.isDead() }
        if charactersAreDead.count == maximumNumberOfSelectableCharacters {
            return true
        }
        return false
    }
}
