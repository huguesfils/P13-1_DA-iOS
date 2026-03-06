//
//  Client.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

struct Client: Codable, Hashable {
    var name: String
    var email: String
    private var creationDateString: String
    var creationDate: Date {
        Date.dateFromString(creationDateString) ?? Date.now
    }

    enum CodingKeys: String, CodingKey {
        case name = "nom"
        case email
        case creationDateString = "date_creation"
    }

    init(name: String, email: String, creationDateString: String) {
        self.name = name
        self.email = email
        self.creationDateString = creationDateString
    }

    static func createNewClient(name: String, email: String) -> Client {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return Client(name: name, email: email, creationDateString: dateFormatter.string(from: Date.now))
    }

    func isNewClient() -> Bool {
        let today = Date.now
        let creationDate = self.creationDate

        if today.getYear() != creationDate.getYear() ||
            today.getMonth() != creationDate.getMonth() ||
            today.getDay() != creationDate.getDay() {
            return false
        }
        return true
    }

    func exists(in clientsList: [Client]) -> Bool {
        if clientsList.contains(where: { $0 == self }) {
            return true
        }
        return false
    }

    // Note: `?? self.creationDateString` is unreachable (dead code) because
    // Date.stringFromDate always returns a non-nil String.
    func formattedCreationDate() -> String {
        return Date.stringFromDate(self.creationDate) ?? self.creationDateString
    }
}
