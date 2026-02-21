import Testing
import Foundation
@testable import Relayance

struct ClientTests {

    // MARK: - init

    @Test func init_assignsNomEmailAndDateCreationString() {
        // Given
        let nom = "John Doe"
        let email = "john@example.com"
        let dateString = "2024-01-15"

        // When
        let client = Client(nom: nom, email: email, dateCreationString: dateString)

        // Then
        #expect(client.nom == "John Doe", "nom should be assigned correctly")
        #expect(client.email == "john@example.com", "email should be assigned correctly")
    }

    // MARK: - dateCreation (computed property)

    @Test func dateCreation_withValidDateString_returnsCorrectDate() {
        // Given
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: "2024-06-15")

        // When
        let date = client.dateCreation

        // Then
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        #expect(utcCalendar.component(.year, from: date) == 2024, "Year should be 2024")
        #expect(utcCalendar.component(.month, from: date) == 6, "Month should be 6")
        #expect(utcCalendar.component(.day, from: date) == 15, "Day should be 15")
    }

    @Test func dateCreation_withInvalidDateString_fallsBackToNow() {
        // Given
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: "invalid")

        // When
        let date = client.dateCreation

        // Then
        let calendar = Calendar.current
        let now = Date.now
        #expect(calendar.component(.year, from: date) == calendar.component(.year, from: now),
                "Should fall back to current year when date string is invalid")
        #expect(calendar.component(.month, from: date) == calendar.component(.month, from: now),
                "Should fall back to current month when date string is invalid")
        #expect(calendar.component(.day, from: date) == calendar.component(.day, from: now),
                "Should fall back to current day when date string is invalid")
    }

    // MARK: - creerNouveauClient

    @Test func creerNouveauClient_setsNomAndEmail() {
        // Given
        let nom = "Jane Doe"
        let email = "jane@example.com"

        // When
        let client = Client.creerNouveauClient(nom: nom, email: email)

        // Then
        #expect(client.nom == "Jane Doe", "nom should match the provided value")
        #expect(client.email == "jane@example.com", "email should match the provided value")
    }

    @Test func creerNouveauClient_setsDateCreationToToday() {
        // Given / When
        let client = Client.creerNouveauClient(nom: "Test", email: "test@test.com")

        // Then
        let calendar = Calendar.current
        let now = Date.now
        #expect(calendar.component(.year, from: client.dateCreation) == calendar.component(.year, from: now),
                "New client dateCreation year should match today")
        #expect(calendar.component(.month, from: client.dateCreation) == calendar.component(.month, from: now),
                "New client dateCreation month should match today")
        #expect(calendar.component(.day, from: client.dateCreation) == calendar.component(.day, from: now),
                "New client dateCreation day should match today")
    }

    // MARK: - estNouveauClient

    @Test func estNouveauClient_whenCreatedToday_returnsTrue() {
        // Given
        let client = Client.creerNouveauClient(nom: "Nouveau", email: "nouveau@test.com")

        // When
        let result = client.estNouveauClient()

        // Then
        #expect(result == true, "A client created today should be considered new")
    }

    @Test func estNouveauClient_whenDifferentYear_returnsFalse() {
        // Given
        let client = Client(nom: "Ancien", email: "ancien@test.com", dateCreationString: "2020-06-15")

        // When
        let result = client.estNouveauClient()

        // Then
        #expect(result == false, "A client created in a different year should not be new")
    }

    @Test func estNouveauClient_whenSameYearDifferentMonth_returnsFalse() {
        // Given
        let calendar = Calendar.current
        let now = Date.now
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let differentMonth = currentMonth <= 6 ? currentMonth + 6 : currentMonth - 6
        let dateString = String(format: "%04d-%02d-15", currentYear, differentMonth)
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: dateString)

        // When
        let result = client.estNouveauClient()

        // Then
        #expect(result == false, "A client created in a different month should not be new")
    }

    @Test func estNouveauClient_whenSameYearAndMonthDifferentDay_returnsFalse() {
        // Given
        let calendar = Calendar.current
        let now = Date.now
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let currentDay = calendar.component(.day, from: now)
        let differentDay = currentDay >= 15 ? 1 : 28
        let dateString = String(format: "%04d-%02d-%02d", currentYear, currentMonth, differentDay)
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: dateString)

        // When
        let result = client.estNouveauClient()

        // Then
        #expect(result == false, "A client created on a different day should not be new")
    }

    // MARK: - clientExiste

    @Test func clientExiste_whenClientInList_returnsTrue() {
        // Given
        let client = Client(nom: "Alice", email: "alice@test.com", dateCreationString: "2024-01-01")
        let list = [
            Client(nom: "Bob", email: "bob@test.com", dateCreationString: "2024-01-01"),
            client
        ]

        // When
        let result = client.clientExiste(clientsList: list)

        // Then
        #expect(result == true, "Should return true when the client is in the list")
    }

    @Test func clientExiste_whenClientNotInList_returnsFalse() {
        // Given
        let client = Client(nom: "Alice", email: "alice@test.com", dateCreationString: "2024-01-01")
        let list = [
            Client(nom: "Bob", email: "bob@test.com", dateCreationString: "2024-01-01")
        ]

        // When
        let result = client.clientExiste(clientsList: list)

        // Then
        #expect(result == false, "Should return false when the client is not in the list")
    }

    @Test func clientExiste_whenListEmpty_returnsFalse() {
        // Given
        let client = Client(nom: "Alice", email: "alice@test.com", dateCreationString: "2024-01-01")

        // When
        let result = client.clientExiste(clientsList: [])

        // Then
        #expect(result == false, "Should return false when the list is empty")
    }

    // MARK: - formatDateVersString

    // Note: formatDateVersString contains a `?? self.dateCreationString` fallback
    // that is unreachable (dead code) because Date.stringFromDate always returns
    // a non-nil String. This makes 100% branch coverage impossible without
    // refactoring the production code.

    @Test func formatDateVersString_withValidDate_returnsFormattedString() {
        // Given
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: "2024-06-15")

        // When
        let result = client.formatDateVersString()

        // Then
        let expected = Date.stringFromDate(client.dateCreation)
        #expect(result == expected, "Should format the creation date as dd-MM-yyyy")
    }

    @Test func formatDateVersString_withInvalidDate_returnsFormattedNow() {
        // Given
        let client = Client(nom: "Test", email: "test@test.com", dateCreationString: "invalid")

        // When
        let result = client.formatDateVersString()

        // Then
        let expected = Date.stringFromDate(Date.now)
        #expect(result == expected, "Should format Date.now when the date string is invalid")
    }
}
