//
//  AddClientView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct AddClientView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddClientViewModel
    @State private var presentAlert: Bool = false

    var body: some View {
        VStack {
            Text("Ajouter un nouveau client")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            TextField("Nom", text: $viewModel.name)
                .font(.title2)
            TextField("Email", text: $viewModel.email)
                .font(.title2)
            Button("Ajouter") {
                if viewModel.addClient() {
                    dismiss()
                } else {
                    presentAlert = true
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical)
            .font(.title2)
            .bold()
            .background(RoundedRectangle(cornerRadius: 10).fill(.orange))
            .foregroundStyle(.white)
            .padding(.top, 50)
            Spacer()
        }
        .padding()
        .alert("Erreur", isPresented: $presentAlert, actions: {
        }, message: {
            Text("Veuillez verifier les champs")
        })
    }
}

#Preview {
    AddClientView(viewModel: AddClientViewModel(onAdd: { _, _ in }))
}
