//
//  ClientDetailView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct ClientDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ClientDetailViewModel

    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(.orange)
                .padding(50)
            Spacer()
            Text(viewModel.client.name)
                .font(.title)
                .padding()
            Text(viewModel.client.email)
                .font(.title3)
            Text(viewModel.formattedCreationDate)
                .font(.title3)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Supprimer") {
                    viewModel.deleteClient()
                    dismiss()
                }
                .foregroundStyle(.red)
                .bold()
            }
        }
    }
}

#Preview {
    ClientDetailView(
        viewModel: ClientDetailViewModel(
            client: Client(name: "Tata", email: "tata@email", creationDateString: "20:32 Wed, 30 Oct 2019"),
            onDelete: {}
        )
    )
}
