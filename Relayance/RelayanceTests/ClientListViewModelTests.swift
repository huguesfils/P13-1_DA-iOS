import Testing
import Foundation
@testable import Relayance

struct ClientListViewModelTests {

    // MARK: - init

    @Test func init_withDefaultParameter_loadsClientsFromJSON() {
        // Given / When
        let viewModel = ClientListViewModel()

        // Then
        #expect(!viewModel.clients.isEmpty, "Default init should load clients from Source.json")
    }

    @Test func init_withCustomList_usesProvidedClients() {
        // Given
        let clients = [
            Client(name: "Alice", email: "alice@example.com", creationDateString: "2024-01-15")
        ]

        // When
        let viewModel = ClientListViewModel(clients: clients)

        // Then
        #expect(viewModel.clients.count == 1, "Should use the provided clients list")
        #expect(viewModel.clients.first?.name == "Alice", "First client should be Alice")
    }

    @Test func init_withEmptyList_startsEmpty() {
        // Given / When
        let viewModel = ClientListViewModel(clients: [])

        // Then
        #expect(viewModel.clients.isEmpty, "Should start with an empty list")
    }

    // MARK: - addClient

    @Test func addClient_validClient_isAddedToList() {
        // Given
        let viewModel = ClientListViewModel(clients: [])

        // When
        viewModel.addClient(name: "Marie Curie", email: "marie@example.com")

        // Then
        #expect(viewModel.clients.count == 1, "List should contain 1 client after adding")
        #expect(viewModel.clients.first?.name == "Marie Curie", "The added client should have the correct name")
        #expect(viewModel.clients.first?.email == "marie@example.com", "The added client should have the correct email")
    }

    @Test func addClient_appendsAmongExistingClients() {
        // Given
        let existing = Client(name: "Frida Kahlo", email: "frida@example.com", creationDateString: "2024-01-15")
        let viewModel = ClientListViewModel(clients: [existing])

        // When
        viewModel.addClient(name: "Marie Curie", email: "marie@example.com")

        // Then
        #expect(viewModel.clients.count == 2, "List should contain 2 clients after adding")
        #expect(viewModel.clients.last?.name == "Marie Curie", "The new client should be the last element")
    }

    @Test func addClient_newClientHasTodayDate() {
        // Given
        let viewModel = ClientListViewModel(clients: [])

        // When
        viewModel.addClient(name: "Marie Curie", email: "marie@example.com")

        // Then
        let addedClient = viewModel.clients.first
        #expect(addedClient?.isNewClient() == true, "A newly added client should be marked as new (created today)")
    }

    // MARK: - deleteClient

    @Test func deleteClient_clientIsRemovedFromList() {
        // Given
        let clientToDelete = Client(name: "Frida Kahlo", email: "frida@example.com", creationDateString: "2024-01-15")
        let otherClient = Client(name: "Ada Lovelace", email: "ada@example.com", creationDateString: "2024-06-15")
        let viewModel = ClientListViewModel(clients: [clientToDelete, otherClient])

        // When
        viewModel.deleteClient(clientToDelete)

        // Then
        #expect(!viewModel.clients.contains(clientToDelete), "The deleted client should no longer be in the list")
    }

    @Test func deleteClient_onlyTargetClientIsRemoved() {
        // Given
        let clientToDelete = Client(name: "Frida Kahlo", email: "frida@example.com", creationDateString: "2024-01-15")
        let otherClient = Client(name: "Ada Lovelace", email: "ada@example.com", creationDateString: "2024-06-15")
        let viewModel = ClientListViewModel(clients: [clientToDelete, otherClient])

        // When
        viewModel.deleteClient(clientToDelete)

        // Then
        #expect(viewModel.clients.count == 1, "Only the targeted client should be removed")
        #expect(viewModel.clients.contains(otherClient), "Other clients should remain in the list")
    }

    @Test func deleteClient_listCountDecreasesByOne() {
        // Given
        let clientToDelete = Client(name: "Frida Kahlo", email: "frida@example.com", creationDateString: "2024-01-15")
        let viewModel = ClientListViewModel(clients: [
            clientToDelete,
            Client(name: "Ada Lovelace", email: "ada@example.com", creationDateString: "2024-06-15"),
            Client(name: "Nelson Mandela", email: "nelson@example.com", creationDateString: "2021-05-30")
        ])
        let initialCount = viewModel.clients.count

        // When
        viewModel.deleteClient(clientToDelete)

        // Then
        #expect(viewModel.clients.count == initialCount - 1, "List count should decrease by 1 after deletion")
    }

    @Test func deleteClient_lastClientLeavesEmptyList() {
        // Given
        let onlyClient = Client(name: "Frida Kahlo", email: "frida@example.com", creationDateString: "2024-01-15")
        let viewModel = ClientListViewModel(clients: [onlyClient])

        // When
        viewModel.deleteClient(onlyClient)

        // Then
        #expect(viewModel.clients.isEmpty, "Removing the last client should leave an empty list")
    }
}
