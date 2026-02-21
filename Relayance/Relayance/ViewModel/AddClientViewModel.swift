//
//  AddClientViewModel.swift
//  Relayance
//

import Foundation

class AddClientViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""

    private let onAdd: (String, String) -> Void

    init(onAdd: @escaping (String, String) -> Void) {
        self.onAdd = onAdd
    }

    func validateInformation() -> Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@") && email.contains(".")
    }

    /// Returns true if the client was added successfully, false if validation failed.
    func addClient() -> Bool {
        guard validateInformation() else { return false }
        onAdd(name, email)
        return true
    }
}
