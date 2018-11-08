//
//  InAppPurchaseManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 06.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseManager: NSObject {
    static let shared: InAppPurchaseManager = InAppPurchaseManager()
    private override init() {}
    
    private var transactionInProgress = false
    private var hasLoadedProducts: Bool = false
    private var hasBeenAddedToQueue: Bool = false
    
    public private(set) var products: [SKProduct] = []
    
    public var delegate: InAppPurchaseDelegate? = nil
    
    public static var canMakePayments: Bool {
        get {
            return SKPaymentQueue.canMakePayments()
        }
    }
    
    public func addToPaymentQueue() -> Void {
        if self.hasBeenAddedToQueue {
            return
        }
        self.hasBeenAddedToQueue = true
        SKPaymentQueue.default().add(self)
    }
    
    public func removeFromPaymentQueue() -> Void {
        if !self.hasBeenAddedToQueue {
            return
        }
        self.hasBeenAddedToQueue = false
        SKPaymentQueue.default().remove(self)
    }
    
    public func load(products: Set<String>) -> Void {
        if self.hasLoadedProducts {
            self.delegate?.manager(manager: self, didLoad: self.products)
        } else {
            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: products)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    public func checkout(withProduct product: SKProduct) -> Bool {
        if !InAppPurchaseManager.canMakePayments {
            return false
        }
        if self.transactionInProgress {
            return false
        }
        let payment: SKMutablePayment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
        return true
    }
    
    public func restoreCompletedTransactions() -> Void {
        self.transactionInProgress = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            self.products.removeAll()
            self.products.append(contentsOf: response.products)
            self.hasLoadedProducts = true
            
            DispatchQueue.main.async {
                self.delegate?.manager(manager: self, didLoad: self.products)
            }
        }
    }
}

// MARK: - Payment Observer

extension InAppPurchaseManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: SKPaymentTransaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                self.delegate?.managerDidRegisterPurchase(manager: self)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.transactionInProgress = false
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.transactionInProgress = false
                break
            case .deferred, .purchasing:
                break
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.transactionInProgress = false
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        self.transactionInProgress = false
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}


