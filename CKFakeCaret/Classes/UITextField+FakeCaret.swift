//
//  UITextField+FakeCaret.swift
//  CKFakeCaret
//
//  Created by mk on 2018/2/6.
//

import Foundation

extension UITextField {
    
    private struct AssociatedKeys {
        static var fakeCaret = "fakeCaret"
        static var safeObservers = "safeObservers"
    }
    
    internal var fakeCaret: CKFakeCaret? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fakeCaret) as? CKFakeCaret
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.fakeCaret, newValue as CKFakeCaret?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private var safeObservers: [ObserverInfo] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.safeObservers) as? [ObserverInfo] ?? []
        }
        set (new) {
            objc_setAssociatedObject(self, &AssociatedKeys.safeObservers, new, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addSafeObserver(observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions) {
        let observerInfo = ObserverInfo(observer: observer, keypath: keyPath)
        if !self.safeObservers.contains(observerInfo) {
            self.safeObservers.append(ObserverInfo(observer: observer, keypath: keyPath))
            self.addObserver(observer, forKeyPath: keyPath, options: options, context: nil)
        }
    }
    
    func removeSafeObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = ObserverInfo(observer: observer, keypath: keyPath)
        if self.safeObservers.contains(observerInfo) {
            self.safeObservers.remove(at: self.safeObservers.index(of: observerInfo)!)
            self.removeObserver(observer, forKeyPath: keyPath)
        }
    }
    

    public func setupFakeCaret() {
        setFakeCaret()
        addSafeObserver(observer: self, forKeyPath: "text", options: [.old,.new])
    }
    
    public func removeFakeCaret() {
        fakeCaret?.removeFromSuperview()
        fakeCaret = nil
        removeSafeObserver(observer: self, forKeyPath: "text")
    }

    func getCursorPosition() -> CGFloat {
        let textRect = self.textRect(forBounds: self.bounds)
        
        let fontAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: font as Any]
        if let text = text {
            let size = text.size(withAttributes: fontAttributes)
            return size.width + textRect.minX
        }
        return textRect.minX
    }
    
    func setFakeCaret() {
        if fakeCaret == nil {
            fakeCaret = CKFakeCaret.create()
        }
        
        addSubview(fakeCaret!)

        fakeCaret?.center = CGPoint(x: getCursorPosition(), y: self.bounds.height / 2)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            setFakeCaret()
        }
    }
    
}


private class ObserverInfo: Equatable {
    let observer: UnsafeMutableRawPointer
    let keypath: String
    
    init(observer: NSObject, keypath: String) {
        self.observer = Unmanaged.passUnretained(observer).toOpaque()
        self.keypath = keypath
    }
}

private func ==(lhs: ObserverInfo, rhs: ObserverInfo) -> Bool {
    return lhs.observer == rhs.observer && lhs.keypath == rhs.keypath
}
