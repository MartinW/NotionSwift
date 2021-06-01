//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

public struct User {
    public enum UserType {
        case person(Person)
        case bot(Bot)
        case unknown
    }

    public struct Person {
        public let email: String
    }

    public struct Bot {}

    public typealias Identifier = EntityIdentifier<User, UUIDv4>
    public let id: Identifier
    public let type: UserType?
    public let name: String?
    public let avatarURL: String?
}

extension User.Person: Decodable {}
extension User.Bot: Decodable {}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case avatarURL = "avatar_url"
        case person
        case bot
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Identifier.self, forKey: .id)
        self.name = try container.decode(String?.self, forKey: .name)
        self.avatarURL = try container.decode(String?.self, forKey: .avatarURL)

        if let type = try container.decode(String?.self, forKey: .type) {
            switch type {
            case "person":
                let person = try container.decode(Person.self, forKey: .person)
                self.type = .person(person)
            case "bot":
                let bot = try container.decode(Bot.self, forKey: .bot)
                self.type = .bot(bot)
            default:
                self.type = .unknown
            }
        } else {
            self.type = nil
        }
    }


}
