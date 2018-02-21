//
//  CommanClass.swift
//  MoneyLander
//
//  Created by PUNDSK003 on 15/09/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import Foundation
import UIKit

class buttonDesign : UIButton {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        //UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0) purple
        //UIColor(red: 162, green: 205, blue: 58, alpha: 1.0) green
        
        self.backgroundColor = UIColor(red: 162.0/255.0, green: 205.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.setTitleColor(UIColor.white , for: .normal)
    }
}

class buttonOnlyTitleDesign : UIButton {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0) , for: .normal)
    }
}

class lbleDesign : UILabel {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        
    }
}

class textFiledDesign : UITextField {
    required public init?(coder aDecoder: NSCoder) {
        //#bdbdbd; rgb(189,189,189)
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
        //self.font = UIFont(name: "Raleway-Medium", size: 20)
    }
}

class textViewDesign : UITextView {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
         //self.textColor.font = UIFont(name: "NameOfTheFont", size: 20)
        //self.font = UIFont(name: "Raleway-Medium", size: 20)
    }
}

class viewDesign : UIView {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        
    }
}


//@IBDesignable
class viewOfShadow: UIView {
    // @IBInspectable
    var cornerRadius: CGFloat = 2
    // @IBInspectable
    var shadowOffsetWidth: Int = 0
    //@IBInspectable
    var shadowOffsetHeight: Int = 1
    //  @IBInspectable
    var shadowColor: UIColor? = UIColor.lightGray
    //@IBInspectable
    var shadowOpacity: Float = 1.5
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}






