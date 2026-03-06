//
//  ClientDetailViewModel.swift
//  Relayance
//

import Foundation

class ClientDetailViewModel: ObservableObject {
    let client: Client
    private let onDelete: () -> Void

    init(client: Client, onDelete: @escaping () -> Void) {
        self.client = client
        self.onDelete = onDelete
    }

    var formattedCreationDate: String {
        client.formattedCreationDate()
    }

    func deleteClient() {
        onDelete()
    }
}
