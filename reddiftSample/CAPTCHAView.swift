//
//  CAPTCHAView.swift
//  reddift
//
//  Created by sonson on 2015/05/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class CAPTCHAView: UIView {
    var session: Session? = nil
    fileprivate var currentIden = ""
    
    var iden: String {
        return currentIden
    }
    
    var response: String {
        if let text = captchaTextField?.text {
            return text
        }
        return ""
    }
    
    @IBOutlet fileprivate var captchaImageView: UIImageView? = nil
    @IBOutlet fileprivate var captchaTextField: UITextField? = nil
    @IBOutlet fileprivate var activity: UIActivityIndicatorView? = nil
    
    class func loadFromIdiomNib() -> CAPTCHAView? {
        let nib = UINib(nibName: "CAPTCHAView", bundle: nil)
        if let view = nib.instantiate(withOwner: nil, options: nil)[0] as? CAPTCHAView {
            return view
        }
        return nil
    }
    
    @IBAction func reload(_ sender: AnyObject) {
        startLoading()
    }
    
    func startLoading() {
        captchaImageView?.image = nil
        activity?.startAnimating()
        activity?.isHidden = false
        
        do {
            try self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success(let identifier):
                    do {
                        try self.session?.getCAPTCHA(identifier, completion: { (result) -> Void in
                            switch result {
                            case .failure(let error):
                                print(error.description)
                            case .success(let image):
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.currentIden = identifier
                                    if let imageView = self.captchaImageView {
                                        imageView.image = image
                                    }
                                    if let activity = self.activity {
                                        activity.stopAnimating()
                                        activity.isHidden = true
                                    }
                                })
                            }
                        })
                    } catch { print(error) }
                }
            })
        } catch { print(error) }
    }
}
