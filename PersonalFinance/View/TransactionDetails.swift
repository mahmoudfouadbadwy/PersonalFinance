//
//  TransactionDetails.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 03/01/2022.
//

import SwiftUI

struct TransactionDetails: View {
    @Binding private var isShow: Bool
    private let transaction: PaymentActivity
    private let viewModel: TransactionDetailViewModel
    
    init(isShow: Binding<Bool>, payment: PaymentActivity) {
        self._isShow = isShow
        self.transaction = payment
        self.viewModel = TransactionDetailViewModel(transaction: payment)
    }
    
    var body: some View {
        BottomSheet(isShow: $isShow) {
            VStack {
                TitleBarForDetails(viewModel: viewModel)
                
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                // Payment details
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(self.viewModel.name)
                            .font(.system(.headline))
                            .fontWeight(.semibold)
                        Text(self.viewModel.date)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.brown)
                        Text(self.viewModel.address)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                                        
                    VStack(alignment: .trailing) {
                        Text(self.viewModel.amount)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing)
                }

                Divider()
                    .padding(.horizontal)

                if self.viewModel.memo != "" {
                    Group {
                        Text("Memo")
                            .font(.subheadline)
                            .bold()
                            .padding(.bottom, 5)
                        
                        Text(self.viewModel.memo)
                            .font(.subheadline)
                        
                        Divider()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                }
                
            }

        }
    }
}

struct TitleBarForDetails: View {
    var viewModel: TransactionDetailViewModel
    var body: some View {
        HStack {
            Text("Payment Details")
                .font(.headline)
                .foregroundColor(.brown)

            Image(systemName: viewModel.typeIcon)
                .foregroundColor(.cyan)
            
            Spacer()
        }
        .padding()
    }
}
