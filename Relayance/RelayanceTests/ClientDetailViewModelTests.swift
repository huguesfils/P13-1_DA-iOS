import Testing
import Foundation
@testable import Relayance

struct ClientDetailViewModelTests {

    // MARK: - init

    @Test func init_storesClient() {
        // Given
        let client = Client(name: "Alice", email: "alice@example.com", creationDateString: "2024-06-15")

        // When
        let viewModel = ClientDetailViewModel(client: client, onDelete: {})

        // Then
        #expect(viewModel.client.name == "Alice", "ViewModel should store the provided client")
        #expect(viewModel.client.email == "alice@example.com", "ViewModel should store the client's email")
    }

    // MARK: - formattedCreationDate

    @Test func formattedCreationDate_returnsFormattedString() {
        // Given
        let client = Client(name: "Alice", email: "alice@example.com", creationDateString: "2024-06-15")
        let viewModel = ClientDetailViewModel(client: client, onDelete: {})

        // When
        let result = viewModel.formattedCreationDate

        // Then
        let expected = Date.stringFromDate(client.creationDate)
        #expect(result == expected, "Should return the formatted creation date")
    }

    // MARK: - deleteClient

    @Test func deleteClient_callsOnDeleteClosure() {
        // Given
        var deleteCalled = false
        let client = Client(name: "Alice", email: "alice@example.com", creationDateString: "2024-06-15")
        let viewModel = ClientDetailViewModel(client: client, onDelete: {
            deleteCalled = true
        })

        // When
        viewModel.deleteClient()

        // Then
        #expect(deleteCalled == true, "deleteClient should trigger the onDelete closure")
    }

    @Test func deleteClient_removesClientFromList() {
        // Given
        let client = Client(name: "Alice", email: "alice@example.com", creationDateString: "2024-06-15")
        let listViewModel = ClientListViewModel(clients: [client])
        let detailViewModel = ClientDetailViewModel(client: client, onDelete: {
            listViewModel.deleteClient(client)
        })

        // When
        detailViewModel.deleteClient()

        // Then
        #expect(listViewModel.clients.isEmpty, "The client should be removed from the list after deletion")
    }
}
