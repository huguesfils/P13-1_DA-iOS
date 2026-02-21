import Testing
import Foundation
@testable import Relayance

struct AddClientViewModelTests {

    // MARK: - validateInformation - success

    @Test func validateInformation_validNameAndEmail_returnsTrue() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = "Marie Curie"
        viewModel.email = "marie@example.com"

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == true, "Valid name and email should pass validation")
    }

    // MARK: - validateInformation - empty fields

    @Test func validateInformation_emptyName_returnsFalse() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = ""
        viewModel.email = "marie@example.com"

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == false, "An empty name should fail validation")
    }

    @Test func validateInformation_emptyEmail_returnsFalse() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = "Marie Curie"
        viewModel.email = ""

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == false, "An empty email should fail validation")
    }

    @Test func validateInformation_bothFieldsEmpty_returnsFalse() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == false, "Both fields empty should fail validation")
    }

    // MARK: - validateInformation - invalid email format

    @Test func validateInformation_emailWithoutAtSign_returnsFalse() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = "Marie Curie"
        viewModel.email = "marie.example.com"

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == false, "An email without @ should fail validation")
    }

    @Test func validateInformation_emailWithoutDot_returnsFalse() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = "Marie Curie"
        viewModel.email = "marie@example"

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == false, "An email without a dot should fail validation")
    }

    @Test func validateInformation_emailWithOnlyAtAndDot_returnsTrue() {
        // Given
        let viewModel = AddClientViewModel(onAdd: { _, _ in })
        viewModel.name = "Marie Curie"
        viewModel.email = "@."

        // When
        let result = viewModel.validateInformation()

        // Then
        #expect(result == true, "An email with @ and . passes the basic validation")
    }

    // MARK: - addClient

    @Test func addClient_withValidData_callsOnAddAndReturnsTrue() {
        // Given
        var receivedName: String?
        var receivedEmail: String?
        let viewModel = AddClientViewModel(onAdd: { name, email in
            receivedName = name
            receivedEmail = email
        })
        viewModel.name = "Marie Curie"
        viewModel.email = "marie@example.com"

        // When
        let result = viewModel.addClient()

        // Then
        #expect(result == true, "addClient should return true when validation passes")
        #expect(receivedName == "Marie Curie", "onAdd should receive the correct name")
        #expect(receivedEmail == "marie@example.com", "onAdd should receive the correct email")
    }

    @Test func addClient_withInvalidData_returnsFalseAndDoesNotCallOnAdd() {
        // Given
        var onAddCalled = false
        let viewModel = AddClientViewModel(onAdd: { _, _ in
            onAddCalled = true
        })
        viewModel.name = ""
        viewModel.email = "marie@example.com"

        // When
        let result = viewModel.addClient()

        // Then
        #expect(result == false, "addClient should return false when validation fails")
        #expect(onAddCalled == false, "onAdd should not be called when validation fails")
    }

    @Test func addClient_addsClientToList() {
        // Given
        let listViewModel = ClientListViewModel(clients: [])
        let addViewModel = AddClientViewModel(onAdd: { name, email in
            listViewModel.addClient(name: name, email: email)
        })
        addViewModel.name = "Marie Curie"
        addViewModel.email = "marie@example.com"

        // When
        _ = addViewModel.addClient()

        // Then
        #expect(listViewModel.clients.count == 1, "Client should be added to the list")
        #expect(listViewModel.clients.first?.name == "Marie Curie", "Added client should have the correct name")
    }
}
