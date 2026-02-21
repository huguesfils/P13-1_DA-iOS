//
//  ClientListViewModel.swift
//  Relayance
//

import Foundation

class ClientListViewModel: ObservableObject {
    @Published var clients: [Client]

    init(clients: [Client] = ModelData.load("Source.json")) {
        self.clients = clients
    }

    func addClient(name: String, email: String) {
        let newClient = Client.createNewClient(name: name, email: email)
        clients.append(newClient)
    }

    func deleteClient(_ client: Client) {
        clients.removeAll(where: { $0 == client })
    }
}
