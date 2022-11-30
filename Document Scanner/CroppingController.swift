//
//  CroppingController.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/27.
//

import UIKit

class CroppingController: UIViewController {
    var imageView: UIImageView!
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageView = UIImageView(frame: .zero)
        self.imageView.image = image
        self.view.addSubview(self.imageView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let imageView = self.imageView {
            //let top = self.navigationController?.navigationBar.frame.maxY ?? 0
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            imageView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

