//  Converted to Swift 4 by Swiftify v4.1.6613 - https://objectivec2swift.com/
/*
     File: Transaction.swift
 Abstract: This class manages the individual transactions in the document. It uses bindings to show transactions in a master-detail view.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

import Cocoa

class Transaction: NSObject, NSCoding {
    
    @objc
    var amount: Double {
        get {
            if self.amount == 0 && stockTransaction {
                return saleAmount - costBasis
            }
            return self.amount
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: amount), object: amount)
            self.amount = value
        }
    }
    
    @objc
    var date: Date? {
        get {
            return self.date
        }
        set(value) {
            if date != value {
                undoManager?.registerUndo(withTarget: self, selector: #selector(setter: date), object: date)
                self.date = value
            }
        }
    }
    
    @objc
    var descriptionString: String {
        get {
            return self.descriptionString
        }
        set(value) {
            if descriptionString != value {
                undoManager?.registerUndo(withTarget: self, selector: #selector(setter: descriptionString), object: descriptionString)
                self.descriptionString = value
            }
        }
    }
    
    @objc
    var type: String {
        get {
            return self.type
        }
        set(value) {
            if type != value {
                undoManager?.registerUndo(withTarget: self, selector: #selector(setter: type), object: type)
                self.type = value
            }
        }
    }
    
    @objc
    var accountType: String {
        get {
            return self.accountType
        }
        set(value) {
            if accountType != value {
                undoManager?.registerUndo(withTarget: self, selector: #selector(setter: accountType), object: accountType)
                self.accountType = value
            }
        }
    }
    
    @objc
    var isTaxable: Bool {
        get {
            return self.isTaxable
        }
        set(flag) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: isTaxable), object: isTaxable)
            self.isTaxable = flag
        }
    }
    
    @objc
    var stockTransaction: Bool {
        get {
            return self.stockTransaction
        }
        set(flag) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: stockTransaction), object: stockTransaction)
            self.stockTransaction = flag
        }
    }
    
    @objc
    var purchasePrice: Double {
        get {
            return self.purchasePrice
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: purchasePrice), object: purchasePrice)
            self.purchasePrice = value
        }
    }
    
    @objc
    var salePrice: Double {
        get {
            return self.salePrice
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: salePrice), object: salePrice)
            self.salePrice = value
        }
    }
    
    @objc
    var numberShares: Double {
        get {
            return self.numberShares
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: numberShares), object: numberShares)
            self.numberShares = value
        }
    }
    
    @objc
    var costBasis: Double {
        get {
            if self.costBasis != 0 {
                return self.costBasis
            }
            else {
                return purchasePrice * numberShares
            }
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: costBasis), object: costBasis)
            self.costBasis = value
        }
    }
    
    @objc
    var saleAmount: Double {
        get {
            if self.saleAmount != 0 {
                return self.saleAmount
            }
            else {
                return salePrice * numberShares
            }
        }
        set(value) {
            undoManager?.registerUndo(withTarget: self, selector: #selector(setter: saleAmount), object: saleAmount)
            self.saleAmount = value
        }
    }
    
    @objc
    var purchaseDate: Date? {
        get {
            return self.purchaseDate
        }
        set(value) {
            if purchaseDate != value {
                undoManager?.registerUndo(withTarget: self, selector: #selector(setter: purchaseDate), object: purchaseDate)
                self.purchaseDate = value
            }
        }
    }
    
    @objc
    var document: NSDocument?
    
    @objc
    var undoManager: UndoManager? {
        return document?.undoManager
    }

    required init(string: String) {
        super.init()

        var stringComponents: [String]
        var substring: String
        var scanner: Scanner?
        var substringVal: Float = 0.0
        var foundDate = false
        var foundAmount = false
        var foundDescription = false
        var foundType = false
        var foundAccountType = false
        let skipSet = CharacterSet(charactersIn: "\n\t,\"")
        stringComponents = string.components(separatedBy: "\n")
        
        if stringComponents.count < 3 {
            stringComponents = string.components(separatedBy: "\t")
        }
        
        if stringComponents.count < 3 {
            stringComponents = string.components(separatedBy: ",")
        }
        
        for substring2 in stringComponents {
            substring = substring2.trimmingCharacters(in: skipSet)
            scanner = Scanner(string: substring)
            scanner?.scanFloat(&substringVal)
            if !(foundDate && ((substring as NSString).range(of: "/")).length != 0) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                var range = NSRange(location: 0, length: substring.count)
                var readDate: AnyObject?
                //var error: Error?
                try? dateFormatter.getObjectValue(&readDate, for: substring, range: &range)
                date = readDate as? Date
                foundDate = true
            }
            else if !(foundAmount && scanner!.isAtEnd) {
                amount = Double(substringVal)
                foundAmount = true
            }
            else if substring.count > 1 {
                if !foundDescription {
                    descriptionString = substring
                    foundDescription = true
                }
                else if !foundType {
                    type = substring
                    foundType = true
                }
                else if !foundAccountType {
                    accountType = substring
                    foundAccountType = true
                }
            }
        }
        //if !(foundDate || !foundAmount) {
        //    self = nil
        //}
    }

    class func keyPathsForValuesAffectingAmount() -> Set<AnyHashable> {
        return Set<AnyHashable>(["purchasePrice", "salePrice", "numberShares", "costBasis", "saleAmount"])
    }

    // costBasis is computed from purchasePrice and numberShares.  This method is invoked automatically from keyPathsForValuesAffectingValueForKey:@"costBasis".
    class func keyPathsForValuesAffectingCostBasis() -> Set<AnyHashable> {
        return Set<AnyHashable>(["purchasePrice", "numberShares"])
    }

    // saleAmount is computed from salePrice and numberShares.  This method is invoked automatically from keyPathsForValuesAffectingValueForKey:@"saleAmount".
    class func keyPathsForValuesAffectingSaleAmount() -> Set<AnyHashable> {
        return Set<AnyHashable>(["salePrice", "numberShares"])
    }

    override init() {
        super.init()

        date = Date()
    
    }

    deinit {
        // First, set the "document" property to nil.  Since this is how the undo manager is referenced, setting it to nil will prevent the following from causing spurious undo registrations.  Note that in -dealloc we are manipulating the underying instance variables directly, because invoking setters can cause side-effects, and getters can return copies.
        document = nil
    }

    func description() -> String {
        return "\(String(describing: date)) \(amount) \(descriptionString)"
    }

    let kDate = "Date"
    let kPurchaseDate = "PurchaseDate"
    let kAmount = "Amount"
    let kDescription = "Description"
    let kCategory = "Category"
    let kAccountType = "AccountType"
    let kTaxable = "Taxable"
    let kStockTransaction = "StockTransaction"
    let kPurchasePrice = "PurchasePrice"
    let kSalePrice = "SalePrice"
    let kNumberShares = "NumberShares"
    let kCostBasis = "CostBasis"
    let kSaleAmount = "SaleAmount"

    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: kDate)
        aCoder.encode(amount, forKey: kAmount)
        if descriptionString != "" {
            aCoder.encode(descriptionString, forKey: kDescription)
        }
        if type != "" {
            aCoder.encode(type, forKey: kCategory)
        }
        if accountType != "" {
            aCoder.encode(accountType, forKey: kAccountType)
        }
        if isTaxable {
            aCoder.encode(isTaxable, forKey: kTaxable)
        }
        if stockTransaction {
            aCoder.encode(true, forKey: kStockTransaction)
            aCoder.encode(purchasePrice, forKey: kPurchasePrice)
            aCoder.encode(salePrice, forKey: kSalePrice)
            aCoder.encode(numberShares, forKey: kNumberShares)
            aCoder.encode(purchaseDate, forKey: kPurchaseDate)
            if costBasis != 0.0 {
                aCoder.encode(costBasis, forKey: kCostBasis)
            }
            if saleAmount != 0.0 {
                aCoder.encode(saleAmount, forKey: kSaleAmount)
            }
        }
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        date = aDecoder.decodeObject(forKey: kDate) as? Date
        amount = aDecoder.decodeDouble(forKey: kAmount)
        descriptionString = aDecoder.decodeObject(forKey: kDescription) as? String ?? ""
        type = aDecoder.decodeObject(forKey: kCategory) as? String ?? ""
        accountType = aDecoder.decodeObject(forKey: kAccountType) as? String ?? ""
        isTaxable = aDecoder.decodeBool(forKey: kTaxable)
        if aDecoder.decodeBool(forKey: kStockTransaction) {
            stockTransaction = true
            purchasePrice = aDecoder.decodeDouble(forKey: kPurchasePrice)
            salePrice = aDecoder.decodeDouble(forKey: kSalePrice)
            numberShares = aDecoder.decodeDouble(forKey: kNumberShares)
            costBasis = aDecoder.decodeDouble(forKey: kCostBasis)
            saleAmount = aDecoder.decodeDouble(forKey: kSaleAmount)
            purchaseDate = aDecoder.decodeObject(forKey: kPurchaseDate) as? Date
        }
    }
    
}
