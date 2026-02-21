import Testing
import Foundation
@testable import Relayance

struct DateExtensionTests {

    // MARK: - dateFromString

    @Test func dateFromString_withValidISODate_returnsCorrectDate() {
        // Given
        let dateString = "2024-01-15"

        // When
        let result = Date.dateFromString(dateString)

        // Then
        #expect(result != nil, "A valid ISO date string should return a non-nil Date")
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        #expect(utcCalendar.component(.year, from: result!) == 2024)
        #expect(utcCalendar.component(.month, from: result!) == 1)
        #expect(utcCalendar.component(.day, from: result!) == 15)
    }

    @Test func dateFromString_withInvalidString_returnsNil() {
        // Given
        let dateString = "not-a-date"

        // When
        let result = Date.dateFromString(dateString)

        // Then
        #expect(result == nil, "An invalid string should return nil")
    }

    // MARK: - stringFromDate

    @Test func stringFromDate_returnsFormattedDDMMYYYY() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 6
        components.day = 15
        let date = Calendar.current.date(from: components)!

        // When
        let result = Date.stringFromDate(date)

        // Then
        #expect(result == "15-06-2024", "Date should be formatted as dd-MM-yyyy")
    }

    // MARK: - getDay

    @Test func getDay_returnsCorrectDayComponent() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 25
        let date = Calendar.current.date(from: components)!

        // When
        let day = date.getDay()

        // Then
        #expect(day == 25, "getDay should return 25 for March 25")
    }

    // MARK: - getMonth

    @Test func getMonth_returnsCorrectMonthComponent() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 8
        components.day = 10
        let date = Calendar.current.date(from: components)!

        // When
        let month = date.getMonth()

        // Then
        #expect(month == 8, "getMonth should return 8 for August")
    }

    // MARK: - getYear

    @Test func getYear_returnsCorrectYearComponent() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        let date = Calendar.current.date(from: components)!

        // When
        let year = date.getYear()

        // Then
        #expect(year == 2024, "getYear should return 2024")
    }
}
