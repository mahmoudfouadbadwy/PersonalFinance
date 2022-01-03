//
//  TransactionDetailViewModel.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 03/01/2022.
//

import Foundation


struct TransactionDetailViewModel {
    private var transaction: PaymentActivity
    
    var name: String {
        return transaction.name
    }
    
    var date: String {
        return transaction.date.string()
    }
    
    var address: String {
        return transaction.address ?? ""
    }
    
    var typeIcon: String {
        let icon: String
        switch transaction.paymentType {
        case .income: icon = "arrowtriangle.up.circle.fill"
        case .expense: icon = "arrowtriangle.down.circle.fill"
        }
        return icon
    }
    
    var image: String = "payment-detail"
    
    var amount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        
        let formattedValue = formatter.string(from: NSNumber(value: transaction.amount)) ?? ""
        
        let formattedAmount = ((transaction.paymentType == .income) ? "+" : "-") + "$" + formattedValue
        
        return formattedAmount
    }
    
    var memo: String {
        return transaction.memo ?? ""
    }
    
    init(transaction: PaymentActivity) {
        self.transaction = transaction
    }
    
}



