//
//  PaymentActivity+CoreDataProperties.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//
//

import Foundation
import CoreData

enum PaymentCategory: Int {
    case income = 0
    case expense = 1
}

extension PaymentActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentActivity> {
        return NSFetchRequest<PaymentActivity>(entityName: "PaymentActivity")
    }

    @NSManaged public var address: String?
    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var memo: String?
    @NSManaged public var name: String
    @NSManaged public var paymentID: UUID
    @NSManaged public var type: Int32

}

extension PaymentActivity : Identifiable {
    var paymentType: PaymentCategory {
        get {
            PaymentCategory(rawValue: Int(type)) ?? .expense
        }
        set {
            type = Int32(newValue.rawValue)
        }
    }

}
