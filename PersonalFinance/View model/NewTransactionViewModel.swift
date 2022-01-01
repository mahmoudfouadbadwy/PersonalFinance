//
//  NewTransactionViewModel.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//

import Foundation
import Combine

class NewTransactionViewModel: ObservableObject {
    
    //inputs
    @Published var name = ""
    @Published var type = PaymentCategory.expense
    @Published var date = ""
    @Published var amount = "0.0"
    @Published var location = ""
    @Published var memo = ""
    
    //outputs
    @Published var isNameValid = false
    @Published var isAmountValid = true
    @Published var isDateValid = false
    @Published var isMemoValid = true
    @Published var isFormInputValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        
        $name
            .receive(on: DispatchQueue.main)
            .map{$0.count > 0}
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellableSet)
        
        $date
            .receive(on: DispatchQueue.main)
            .map { Date.fromString(string: $0, with: "dd/MM/yyyy") != nil }
            .assign(to: \.isDateValid, on: self)
            .store(in: &cancellableSet)
        
        $amount
            .receive(on: DispatchQueue.main)
            .map {
                guard let validAmount = Double($0) else {
                    return false
                }
               return validAmount > 0
            }
            .assign(to: \.isAmountValid, on: self)
            .store(in: &cancellableSet)
        
        $memo
            .receive(on: DispatchQueue.main)
            .map {$0.count < 300 }
            .assign(to: \.isMemoValid, on: self)
            .store(in: &cancellableSet)
        
        
        Publishers
            .CombineLatest4($isNameValid, $isDateValid, $isMemoValid, $isAmountValid)
            .receive(on: DispatchQueue.main)
            .map{
                $0 && $1 && $2 && $3
            }
            .assign(to: \.isFormInputValid, on: self)
            .store(in: &cancellableSet)
    }
    
}
