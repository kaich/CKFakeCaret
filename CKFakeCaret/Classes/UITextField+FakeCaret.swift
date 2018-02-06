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
    

    public func setupFakeCaret() {
        setFakeCaret()
        addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
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
            addSubview(fakeCaret!)
        }
        
        fakeCaret?.center = CGPoint(x: getCursorPosition(), y: self.bounds.height / 2)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            setFakeCaret()
        }
    }
    
}
