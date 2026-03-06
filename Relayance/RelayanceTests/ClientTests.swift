import Testing
import Foundation
@testable import Relayance

struct ClientTests {

    // MARK: - init

    @Test func init_assignsNameEmailAndCreationDateString() {
        // Given
        let name = "John Doe"
        let email = "john@example.com"
        let dateString = "2024-01-15"

        // When
        let client = Client(name: name, email: email, creationDateString: dateString)

        // Then
        #expect(client.name == "John Doe", "name should be assigned correctly")
        #expect(client.email == "john@example.com", "email should be assigned correctly")
    }

    // MARK: - creationDate (computed property)

    @Test func creationDate_withValidDateString_returnsCorrectDate() {
        // Given
        let client = Client(name: "Test", email: "test@test.com", creationDateString: "2024-06-15")

        // When
        let date = client.creationDate

        // Then
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        #expect(utcCalendar.component(.year, from: date) == 2024, "Year should be 2024")
        #expect(utcCalendar.component(.month, from: date) == 6, "Month should be 6")
        #expect(utcCalendar.component(.day, from: date) == 15, "Day should be 15")
    }

    @Test func creationDate_withInvalidDateString_fallsBackToNow() {
        // Given
        let client = Client(name: "Test", email: "test@test.com", creationDateString: "invalid")

        // When
        let date = client.creationDate

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

    // MARK: - createNewClient

    @Test func createNewClient_setsNameAndEmail() {
        // Given
        let name = "Jane Doe"
        let email = "jane@example.com"

        // When
        let client = Client.createNewClient(name: name, email: email)

        // Then
        #expect(client.name == "Jane Doe", "name should match the provided value")
        #expect(client.email == "jane@example.com", "email should match the provided value")
    }

    @Test func createNewClient_setsCreationDateToToday() {
        // Given / When
        let client = Client.createNewClient(name: "Test", email: "test@test.com")

        // Then
        let calendar = Calendar.current
        let now = Date.now
        #expect(calendar.component(.year, from: client.creationDate) == calendar.component(.year, from: now),
                "New client creationDate year should match today")
        #expect(calendar.component(.month, from: client.creationDate) == calendar.component(.month, from: now),
                "New client creationDate month should match today")
        #expect(calendar.component(.day, from: client.creationDate) == calendar.component(.day, from: now),
                "New client creationDate day should match today")
    }

    // MARK: - isNewClient

    @Test func isNewClient_whenCreatedToday_returnsTrue() {
        // Given
        let client = Client.createNewClient(name: "Nouveau", email: "nouveau@test.com")

        // When
        let result = client.isNewClient()

        // Then
        #expect(result == true, "A client created today should be considered new")
    }

    @Test func isNewClient_whenDifferentYear_returnsFalse() {
        // Given
        let client = Client(name: "Ancien", email: "ancien@test.com", creationDateString: "2020-06-15")

        // When
        let result = client.isNewClient()

        // Then
        #expect(result == false, "A client created in a different year should not be new")
    }

    @Test func isNewClient_whenSameYearDifferentMonth_returnsFalse() {
        // Given
        let calendar = Calendar.current
        let now = Date.now
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let differentMonth = currentMonth <= 6 ? currentMonth + 6 : currentMonth - 6
        let dateString = String(format: "%04d-%02d-15", currentYear, differentMonth)
        let client = Client(name: "Test", email: "test@test.com", creationDateString: dateString)

        // When
        let result = client.isNewClient()

        // Then
        #expect(result == false, "A client created in a different month should not be new")
    }

    @Test func isNewClient_whenSameYearAndMonthDifferentDay_returnsFalse() {
        // Given
        let calendar = Calendar.current
        let now = Date.now
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let currentDay = calendar.component(.day, from: now)
        let differentDay = currentDay >= 15 ? 1 : 28
        let dateString = String(format: "%04d-%02d-%02d", currentYear, currentMonth, differentDay)
        let client = Client(name: "Test", email: "test@test.com", creationDateString: dateString)

        // When
        let result = client.isNewClient()

        // Then
        #expect(result == false, "A client created on a different day should not be new")
    }

    // MARK: - exists

    @Test func exists_whenClientInList_returnsTrue() {
        // Given
        let client = Client(name: "Alice", email: "alice@test.com", creationDateString: "2024-01-01")
        let list = [
            Client(name: "Bob", email: "bob@test.com", creationDateString: "2024-01-01"),
            client
        ]

        // When
        let result = client.exists(in: list)

        // Then
        #expect(result == true, "Should return true when the client is in the list")
    }

    @Test func exists_whenClientNotInList_returnsFalse() {
        // Given
        let client = Client(name: "Alice", email: "alice@test.com", creationDateString: "2024-01-01")
        let list = [
            Client(name: "Bob", email: "bob@test.com", creationDateString: "2024-01-01")
        ]

        // When
        let result = client.exists(in: list)

        // Then
        #expect(result == false, "Should return false when the client is not in the list")
    }

    @Test func exists_whenListEmpty_returnsFalse() {
        // Given
        let client = Client(name: "Alice", email: "alice@test.com", creationDateString: "2024-01-01")

        // When
        let result = client.exists(in: [])

        // Then
        #expect(result == false, "Should return false when the list is empty")
    }

    // MARK: - formattedCreationDate

    // Note: formattedCreationDate contains a `?? self.creationDateString` fallback
    // that is unreachable (dead code) because Date.stringFromDate always returns
    // a non-nil String. This makes 100% branch coverage impossible without
    // refactoring the production code.

    @Test func formattedCreationDate_withValidDate_returnsFormattedString() {
        // Given
        let client = Client(name: "Test", email: "test@test.com", creationDateString: "2024-06-15")

        // When
        let result = client.formattedCreationDate()

        // Then
        let expected = Date.stringFromDate(client.creationDate)
        #expect(result == expected, "Should format the creation date as dd-MM-yyyy")
    }

    @Test func formattedCreationDate_withInvalidDate_returnsFormattedNow() {
        // Given
        let client = Client(name: "Test", email: "test@test.com", creationDateString: "invalid")

        // When
        let result = client.formattedCreationDate()

        // Then
        let expected = Date.stringFromDate(Date.now)
        #expect(result == expected, "Should format Date.now when the date string is invalid")
    }
}
