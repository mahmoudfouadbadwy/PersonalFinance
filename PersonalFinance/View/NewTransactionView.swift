//
//  NewTransactionView.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: PaymentActivity.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \PaymentActivity.date, ascending: false) ])
    private var paymentActivities: FetchedResults<PaymentActivity>
    @ObservedObject private var transactionViewModel: NewTransactionViewModel
    
    init() {
        transactionViewModel = NewTransactionViewModel()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TitleBar()
                
                // error messages
                Group {
                    if !transactionViewModel.isNameValid {
                        ValidationErrorMessage(text: "Please enter the payment name")
                    }
                    
                    if !transactionViewModel.isDateValid {
                        ValidationErrorMessage(text: "Please enter a vaild date")
                    }
                    
                    if !transactionViewModel.isAmountValid {
                        ValidationErrorMessage(text: "Please enter a valid amount")
                    }
                    
                    if !transactionViewModel.isMemoValid {
                        ValidationErrorMessage(text: "Your memo should not exceed 300 characters")
                    }
                }
                
                // name
                FormTextField(name: "NAME", placeholder: "Enter your paymennt",
                              value: $transactionViewModel.name)
                    .padding(.top)
                
                // type
                VStack(alignment: .leading) {
                    
                    Text("TYPE")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 0) {
                        
                        Button {
                            transactionViewModel.type = .income
                        } label: {
                            Text("Income")
                                .font(.system(.headline))
                                .foregroundColor(transactionViewModel.type == .income ? .white : .primary)
                            
                        }
                        .frame(minWidth: 0.0, maxWidth: .infinity)
                        .padding()
                        .background(transactionViewModel.type == .income ? Color.blue : Color.white)
                        
                        Button {
                            transactionViewModel.type = .expense
                        } label: {
                            Text("Expense")
                                .font(.system(.headline))
                                .foregroundColor(transactionViewModel.type == .expense ? .white : .primary)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(transactionViewModel.type == .expense ? Color.red : Color.white)
                        
                    }
                    .border(Color.gray.opacity(0.2), width: 1.0)
                }
                
                //date and amount
                HStack(spacing: 10) {
                    FormTextField(name: "DATE", placeholder: "dd/mm/yy", value: $transactionViewModel.date)
                    FormTextField(name: "AMOUNT $", placeholder: "0.0", value: $transactionViewModel.amount)
                    
                }
                .padding(.top)
                
                // location
                FormTextField(name: "LOCATION (OPTIONAL)", placeholder: "Where do you spend?", value: $transactionViewModel.location)
                    .padding(.top)
                
                // memo
                FormTextField(name: "MEMO (OPTIONAL)", placeholder: "Your personal note", value: $transactionViewModel.memo)
                    .padding(.top)
                
                // save button
                Button {
                    save()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .opacity(transactionViewModel.isFormInputValid ? 1.0 : 0.5)
                }
                .padding()
                .disabled(!transactionViewModel.isFormInputValid)
            }
            .padding()
        }
        .keyboardAdaptive()
    }
    
    
    private func save() {
        let newTransaction = PaymentActivity(context: context)
        newTransaction.paymentID = UUID()
        newTransaction.name = transactionViewModel.name
        newTransaction.paymentType = transactionViewModel.type
        newTransaction.date = Date.fromString(string: transactionViewModel.date, with: "dd/MM/yyyy") ?? Date()
        newTransaction.amount = Double(transactionViewModel.amount) ?? 0
        newTransaction.address = transactionViewModel.location
        newTransaction.memo = transactionViewModel.memo
        
        do {
            try context.save()
            print("Saved \(paymentActivities.count)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TitleBar: View {
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            
            Text("New Payment")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom)
            
            Spacer()
            
            Button {
                //action
            } label: {
                Image(systemName: "multiply")
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
    }
}


struct ValidationErrorMessage: View {
    
    var text: String
    private var iconName = "info.circle"
    private var iconColor = Color.red
    
    init(text: String) {
        self.text = text
    }
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}


struct FormTextField: View {
    var name: String
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            TextField(placeholder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .border(Color.gray.opacity(0.2), width: 1.0)
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
    }
}
