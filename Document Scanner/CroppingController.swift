//
//  CroppingController.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/27.
//

import UIKit
import DynamsoftDocumentNormalizer

class CroppingController: UIViewController {
    var imageView: UIImageView!
    var image:UIImage!
    var overlay: Overlay!
    var toolbar:UIToolbar!
    var ddn:DynamsoftDocumentNormalizer!
    var points:[CGPoint]!
    var vertices:[Vertice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.image = Utils.normalizedImage(self.image)
        self.imageView = UIImageView(frame: .zero)
        self.imageView.image = self.image
        self.overlay = Overlay()
        self.toolbar = UIToolbar.init()
        let retakeButton = UIBarButtonItem.init(title: "Retake", style: .plain, target: self, action: #selector(retakeAction))
        let okayButton =  UIBarButtonItem.init(title: "Okay", style: .plain, target: self, action: #selector(okayAction))
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        self.toolbar.items = [retakeButton,flexibleSpace,okayButton]
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.overlay)
        self.view.addSubview(self.toolbar)
        detect()
    }
    
    func detect(){
        if let ddn = self.ddn {
            let results = try? ddn.detectQuadFromImage(self.image)
            print("count:")
            print(results?.count ?? 0)
            if results?.count ?? 0 > 0 {
                self.points = results?[0].location.points as? [CGPoint]
                let CGPoints = Utils.scalePoints(self.points, xPercent: self.view.frame.width/self.image.size.width, yPercent: self.view.frame.height/self.image.size.height)
                showVertices(CGPoints)
                self.overlay.points = CGPoints
                self.overlay.setNeedsDisplay()
            }
        }
    }
    
    func showVertices(_ CGPoints:[CGPoint]){
        let verticeSize = 16.0
        for point in CGPoints {
            let vertice = Vertice()
            self.view.addSubview(vertice)
            vertice.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            vertice.frame = CGRect.init(x: point.x, y: point.y, width: verticeSize, height: verticeSize)
            vertices.append(vertice)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let imageView = self.imageView {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            imageView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
        if let overlay = self.overlay {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            overlay.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
        if let toolbar = self.toolbar {
            let width: CGFloat = view.frame.width
            let height: CGFloat = 32
            let x: CGFloat = 0.0
            let y: CGFloat = view.frame.height - 32
            toolbar.frame = CGRect.init(x: x, y: y, width: width, height: height)
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
    
    @objc
    func retakeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func okayAction() {
        let vc = ResultViewerController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
}

