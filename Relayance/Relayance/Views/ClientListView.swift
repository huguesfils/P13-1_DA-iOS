//
//  ClientListView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientListViewModel()
    @State private var showModal: Bool = false

    var body: some View {
        NavigationStack {
            List(viewModel.clients, id: \.self) { client in
                NavigationLink {
                    ClientDetailView(
                        viewModel: ClientDetailViewModel(
                            client: client,
                            onDelete: { viewModel.deleteClient(client) }
                        )
                    )
                } label: {
                    Text(client.name)
                        .font(.title3)
                }
            }
            .navigationTitle("Liste des clients")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter un client") {
                        showModal.toggle()
                    }
                    .foregroundStyle(.orange)
                    .bold()
                }
            }
            .sheet(isPresented: $showModal) {
                AddClientView(
                    viewModel: AddClientViewModel(onAdd: { name, email in
                        viewModel.addClient(name: name, email: email)
                    })
                )
            }
        }
    }
}

#Preview {
    ClientListView()
}
