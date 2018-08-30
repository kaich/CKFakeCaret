//
//  CKFakeCaret.swift
//  CKFakeCaret
//
//  Created by mk on 2018/2/6.
//

import UIKit

public class CKFakeCaret: UIView {
    
    public class func create() -> CKFakeCaret {
        return CKFakeCaret(frame: CGRect(x: 0, y: 0, width: 2, height: 18))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        setupBottomCorner()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBottomCorner() {
        //bottom corner
        let radiusBounds = CGRect.init(x: 0, y: 0, width: 2, height: frame.height)
        let corners: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
        let path = UIBezierPath(roundedRect: radiusBounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 1, height: 1))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = radiusBounds
        layer.mask = maskLayer
    }
    
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.8, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
    
    public override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        blink()
    }
}
