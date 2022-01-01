//
//  DashBoardView.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 01/01/2022.
//

import SwiftUI

enum TransactionDisplayType {
    case all
    case income
    case expense
}

struct DashBoardView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: PaymentActivity.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \PaymentActivity.date, ascending: false) ])
    private var paymentActivities: FetchedResults<PaymentActivity>
    @State private var listType: TransactionDisplayType = .all
    
    private var totalIncome: Double {
        paymentActivities
            .filter { $0.paymentType == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        paymentActivities
            .filter { $0.paymentType == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalBalance: Double {
        totalIncome - totalExpense
    }
    
    private var paymentTransactionsForView: [PaymentActivity] {
        switch listType {
        case .all:
            return paymentActivities
                .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        case .income:
            return paymentActivities
                .filter { $0.paymentType == .income }
                .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        case .expense:
            return paymentActivities
                .filter { $0.paymentType == .expense }
                .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        }
    }
    
    var body: some View {
        List {
            MenuBar {
                NewTransactionView()
            }
            .listRowInsets(EdgeInsets())
            
            VStack {
                PaymentCard(title: "Total Balance", price: totalBalance, color: .purple)
                HStack(spacing: 10) {
                    PaymentCard(title: "Income", price: totalIncome, color: .blue)
                    PaymentCard(title: "Expense", price: totalExpense, color: .red)
                }
                
                TransactionHeader(listType: $listType)
            }
            .padding( 10 )
            .listRowInsets(EdgeInsets())
            
            ForEach(paymentTransactionsForView) {
                TransactionCellView(transaction: $0)
            }
        }
        
    }
}


struct MenuBar<content>: View where content: View {
    @State private var showTransactionForm = false
    let viewContent: () -> content
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center) {
                    Text(Date().string(with: "EEEE, MMM d, yyyy"))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Personal Finance")
                        .font(.title)
                        .fontWeight(.black)
                }
                Spacer()
            }
            Button {
                showTransactionForm = true
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $showTransactionForm) {
                self.showTransactionForm = false
            } content: {
                self.viewContent()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
}

struct PaymentCard: View {
    var title = ""
    var price = 0.0
    var color: Color
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .cornerRadius(10)
            VStack {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text("\(NumberFormatter.currency(from: price))")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .frame( height: 150)
    }
}


struct TransactionHeader: View {
    @Binding var listType: TransactionDisplayType
    var body: some View {
        VStack {
            HStack {
                Text("Recent Transactions")
                    .font(.system(.headline, design: .rounded))
                Spacer()
            }
            .padding(.bottom, 5)
            
            HStack {
                Group {
                    Text("All")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(listType == .all ? .purple : .gray)
                        .onTapGesture {
                            self.listType = .all
                        }
                    Text("Income")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(listType == .income ? .blue : .gray)
                        .onTapGesture {
                            self.listType = .income
                        }
                    Text("Expense")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(listType == .expense ? .red : .gray)
                        .onTapGesture {
                            self.listType = .expense
                        }
                }
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
            
        }
    }
}

struct TransactionCellView: View {
    @ObservedObject var transaction: PaymentActivity
    var body: some View {
        
        HStack(spacing: 20) {
            
            if transaction.isFault {
                EmptyView()
                
            }  else {
                
                Image(systemName: transaction.paymentType == .income ? "arrowtriangle.up.circle.fill" : "arrowtriangle.down.circle.fill")
                    .font(.title)
                    .foregroundColor(transaction.paymentType == .income ? .blue : .red )
                
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.system(.body, design: .rounded))
                    Text(transaction.date.string())
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text((transaction.paymentType == .income ? "+" : "-") + NumberFormatter.currency(from: transaction.amount))
                    .font(.system(.headline, design: .rounded))
            }
        }
        .padding(.vertical, 5)
        
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
