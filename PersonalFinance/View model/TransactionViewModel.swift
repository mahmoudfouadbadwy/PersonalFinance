//
//  NewTransactionViewModel.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//

import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    
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
    
    
    init(transaction: PaymentActivity?) {
        self.name = transaction?.name ?? ""
        self.location = transaction?.address ?? ""
        self.amount = "\(transaction?.amount ?? 0.0)"
        self.memo = transaction?.memo ?? ""
        self.type = transaction?.paymentType ?? .expense
        self.date = (transaction?.date ?? Date()).string(with: "dd/MM/yyyy")
        
        $name
            .receive(on: DispatchQueue.main)
            .map{$0.count > 0}
            .assign(to: &$isNameValid)
        
        $date
            .receive(on: DispatchQueue.main)
            .map { Date.fromString(string: $0, with: "dd/MM/yyyy") != nil }
            .assign(to: &$isDateValid)
        
        $amount
            .receive(on: DispatchQueue.main)
            .map {
                guard let validAmount = Double($0) else {
                    return false
                }
               return validAmount > 0
            }
            .assign(to: &$isAmountValid)
        
        $memo
            .receive(on: DispatchQueue.main)
            .map {$0.count < 300 }
            .assign(to: &$isMemoValid)
        
        
        Publishers
            .CombineLatest4($isNameValid, $isDateValid, $isMemoValid, $isAmountValid)
            .receive(on: DispatchQueue.main)
            .map{
                $0 && $1 && $2 && $3
            }
            .assign(to: &$isFormInputValid)
    }
    
}
