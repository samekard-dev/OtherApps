//
//  OtherAppsViewController.swift
//  OtherApps
//
//  Created by MH on 2024/03/07.
//

import UIKit
import StoreKit

fileprivate let appInfos = [
    OtherAppInfo(layout: .portrait, imageName: "KOYUMEISHI P", introduction: "KM", table: "OtherApps", storeID: 408709785),
    OtherAppInfo(layout: .landscape, imageName: "KOYUMEISHI L", introduction: "KM", table: "OtherApps", storeID: 409203825),
    OtherAppInfo(layout: .portrait, imageName: "KOYUMEISHI P", introduction: "KM", table: "OtherApps", storeID: 409201541),
    OtherAppInfo(layout: .landscape, imageName: "KOYUMEISHI L", introduction: "KM", table: "OtherApps", storeID: 409183694),
]

fileprivate enum OtherAppLayout {
    case portrait
    case landscape
}

fileprivate struct OtherAppInfo {
    let layout: OtherAppLayout
    let imageName: String
    let introduction: String
    let table: String
    let storeID: Int
}

class OtherAppsViewController: UIViewController {
    
    struct OtherAppViews {
        let baseView: UIView
        let imageView: UIImageView
        let introductionLabel: UILabel
        let button: UIButton
    }
    
    fileprivate struct OtherApp {
        let info: OtherAppInfo
        let views: OtherAppViews
    }
    
    fileprivate var otherApps: [OtherApp] = []
    
    let scrollView = UIScrollView()
    let closeButton = UIButton(type: .system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        
        for appInfo in appInfos {
            
            let appBaseView = UIView()
            appBaseView.backgroundColor = .systemGray6
            let imageView = UIImageView(image: UIImage(named: appInfo.imageName))
            imageView.contentMode = .scaleAspectFit
            let introductionLabel = UILabel()
            introductionLabel.numberOfLines = 0
            introductionLabel.text = NSLocalizedString(appInfo.introduction, tableName: appInfo.table, comment: "")
            let button = UIButton(type: .system)
            button.setTitle(NSLocalizedString("Store", tableName: "OtherApps", comment: ""), for: .normal)
            button.tag = appInfo.storeID
            button.addTarget(self, action: #selector(storeButtonPushed(_:)), for: .touchUpInside)
            appBaseView.addSubview(imageView)
            appBaseView.addSubview(introductionLabel)
            appBaseView.addSubview(button)
            
            scrollView.addSubview(appBaseView)
            
            let views = OtherAppViews(baseView: appBaseView, imageView: imageView, introductionLabel: introductionLabel, button: button)
            otherApps.append(OtherApp(info: appInfo, views: views))
        }
        
        view.addSubview(scrollView)
        
        closeButton.setTitle(NSLocalizedString("Close", tableName: "OtherApps", comment: ""), for: .normal)
        closeButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        view.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        
        let viewW: CGFloat = self.view.frame.size.width
        let viewH: CGFloat = self.view.frame.size.height
        let safeAreaL: CGFloat = view.safeAreaInsets.left
        let safeAreaT: CGFloat = view.safeAreaInsets.top
        let safeAreaW: CGFloat = viewW - (view.safeAreaInsets.left + view.safeAreaInsets.right)
        let safeAreaH: CGFloat = viewH - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        //let safeAreaR: CGFloat = viewW - view.safeAreaInsets.right
        //let safeAreaB: CGFloat = viewH - view.safeAreaInsets.bottom
        
        let closeButtonW: CGFloat = 80.0
        let closeButtonH: CGFloat = 50.0
        
        closeButton.frame = CGRect(x: safeAreaL, y: safeAreaT, width: closeButtonW, height: closeButtonH)
        scrollView.frame = CGRect(x: safeAreaL, y: safeAreaT + closeButtonH, width: safeAreaW, height: safeAreaH - closeButtonH)
        
        let buttonW: CGFloat = 70.0
        let buttonH: CGFloat = 50.0
        
        let contentW: CGFloat
        if safeAreaW < 360.0 {
            contentW = safeAreaW - 10.0
        } else if safeAreaW < 700.0 {
            contentW = (safeAreaW - 360.0) * 0.5 + 350.0
        } else {
            contentW = 520.0
        }
        
        let paddingH_S: CGFloat = (contentW - 310.0) * 0.1 + 5.0
        let paddingH_L: CGFloat = (contentW - 310.0) * 0.1 + 15.0
        let paddingV: CGFloat = (safeAreaH - 500.0) * 0.03 + 25.0
        let imageWHmin: CGFloat = {
            let returnVal: CGFloat = min(viewW, viewH) / 3.0
            return min(returnVal, 160.0)
        }()
        
        var posY: CGFloat = paddingV
        
        for otherApp in otherApps {
            let info = otherApp.info
            let views = otherApp.views
            
            let viewH: CGFloat
            
            switch info.layout {
                case .portrait:
                    
                    let textRect = views.introductionLabel.textRect(
                        forBounds: CGRect(x: 0.0, y: 0.0, 
                                          width: contentW - imageWHmin - paddingH_S * 3.0, 
                                          height: safeAreaH), 
                        limitedToNumberOfLines: 0)
                    
                    let reqH = textRect.size.height + buttonH + paddingV
                    
                    if reqH < imageWHmin * 2.0 {
                        viewH = imageWHmin * 2.0 + paddingV * 2.0
                    } else {
                        viewH = reqH + paddingV * 2.0
                    }
                    
                    views.imageView.frame.size = CGSize(width: imageWHmin, height: imageWHmin * 2.0)
                    views.imageView.center = CGPoint(x: paddingH_S + imageWHmin / 2.0, 
                                                     y: viewH / 2.0)
                    views.introductionLabel.frame.size = textRect.size
                    views.introductionLabel.frame.origin = CGPoint(
                        x: views.imageView.frame.maxX + paddingH_S, 
                        y: viewH / 2.0 - reqH / 2.0)
                    views.button.frame = CGRect(x: views.introductionLabel.center.x - buttonW / 2.0, 
                                                y: viewH / 2.0 + reqH / 2.0 - buttonH, 
                                                width: buttonW, 
                                                height: buttonH)
                    views.baseView.frame = CGRect(x: safeAreaW / 2.0 - contentW / 2.0, y: posY, width: contentW, height: viewH)
                case .landscape:
                    views.imageView.frame = CGRect(x: contentW / 2.0 - imageWHmin, y: paddingV, width: imageWHmin * 2.0, height: imageWHmin)
                    
                    let textRect = views.introductionLabel.textRect(
                        forBounds: CGRect(
                            x: 0.0, 
                            y: 0.0, 
                            width: contentW - buttonW - paddingH_L * 3.0, 
                            height: safeAreaH), 
                        limitedToNumberOfLines: 0)
                    
                    views.introductionLabel.frame.size = textRect.size
                    views.button.frame.size = CGSize(width: buttonW, height: buttonH)
                    
                    if buttonH < textRect.size.height {
                        views.introductionLabel.frame.origin = CGPoint(
                            x: paddingH_L, 
                            y: views.imageView.frame.maxY + paddingV)
                        views.button.center = CGPoint(x: contentW - paddingH_L - buttonW / 2.0, y: views.introductionLabel.center.y)
                        viewH = views.introductionLabel.frame.maxY + paddingV
                    } else {
                        views.button.center = CGPoint(x: contentW - paddingH_L - buttonW / 2.0, y: views.imageView.frame.maxY + paddingV + buttonH / 2.0)
                        views.introductionLabel.frame.origin = CGPoint(
                            x: paddingH_L, 
                            y: views.button.center.y - textRect.size.height / 2.0)
                        viewH = views.button.frame.maxY + paddingV
                    }
                    
                    views.baseView.frame = CGRect(x: safeAreaW / 2.0 - contentW / 2.0, y: posY, width: contentW, height: viewH)
            } 
            
            posY = views.baseView.frame.maxY
            posY += paddingV
        }
        
        if scrollView.frame.size.height < posY {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: posY)
        } else {
            scrollView.contentSize = scrollView.frame.size
        }
        
    }
    
    @objc 
    func storeButtonPushed(_ sender: UIControl) {
        let params = [SKStoreProductParameterITunesItemIdentifier : sender.tag]
        let store = SKStoreProductViewController()
        store.delegate = self
        store.loadProduct(withParameters: params, 
                          completionBlock: {
            (result: Bool, error: Error?) -> Void in
            if !result {
                //失敗したときは失敗したことを認識させるために2秒保持してから画面を消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //読み込み中にキャンセルボタンを押した時もここを通る
                    //キャンセルボタンでdismissしたときはもうdismissしない
                    if self.presentedViewController != nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
        self.present(store, animated: true, completion: nil)
    }
}

extension OtherAppsViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        //キャンセルボタン
        viewController.dismiss(animated: true, completion: nil)
    }
}
