//
//  SearchViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoArticle: UILabel!
    @IBOutlet weak var tfSearch:UITextField!
    @IBOutlet weak var articlesCollectionView:UICollectionView!
    @IBOutlet weak var noArticlesLabel:UILabel!
    
    
    var articles : [Articles]?
    
    var filteredArticles : [Articles]?
    var isSearching = false

    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       
        self.articles = []
        self.filteredArticles = []
        articlesCollectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        articlesCollectionView.register(UINib(nibName: "FirstSearchCell", bundle: nil), forCellWithReuseIdentifier: "FirstSearchCell")
        getArticles()
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        tfSearch.rightView = paddingView
        tfSearch.leftView = paddingView
        tfSearch.leftViewMode = .always
        tfSearch.rightViewMode = .always
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    
    //MARK: - Bution Actions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                tfSearch.textAlignment = .left
                lblTitle.localizeKey = "Explore"
                tfSearch.localizeKey = "Search"
                lblNoArticle.localizeKey = "No Articles Found"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "اكتشف"
                lblNoArticle.localizeKey = "لم يتم العثور على مقالات"
                tfSearch.localizeKey = "بحث"
                tfSearch.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        tfSearch.placeholder = loc.TabSearch.localized()
    }

    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
}


extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if isSearching{
            if let filteredArticles = self.filteredArticles{
                return filteredArticles.count
            }
        }else{
            if let articles = self.articles{
                return articles.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
 
        
        var article : Articles?
        var cell : SearchCell?
        
//        if indexPath.item == 0 {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstSearchCell", for: indexPath as IndexPath) as? SearchCell
//        }else{
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath as IndexPath) as? SearchCell
//        }
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath as IndexPath) as? SearchCell
        
        if isSearching{
            article = self.filteredArticles?[indexPath.item]
        }else{
            article = self.articles?[indexPath.item]
        }
        
        if let article = article{
            
            if let cell = cell{
                cell.articleTitle.text = article.title
                cell.articlePostedDate.text = article.date
                AppUtility.setImage(url:article.image1 ?? "", image: cell.image1)
//                if indexPath.item == 0{
//                    AppUtility.setImage(url:article.image2 ?? "", image: cell.image2)
//                    AppUtility.setImage(url:article.image3 ?? "", image: cell.image3)
//                }
                
                return cell
            }
        }
        
         return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        var article : Articles?
        if isSearching{
            article = self.filteredArticles?[indexPath.item]
        }else{
            article = self.articles?[indexPath.item]
        }
        
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.article = article
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.item == 0{
            let width = CGFloat (collectionView.frame.size.width)
            return CGSize (width: width, height: 230)
        }
        else {
        let width = CGFloat (collectionView.frame.size.width) / 2
        return CGSize (width: width, height: 200)
        }
    }
}



extension SearchViewController {
    
    func getArticles() {
        AppUtility.showProgress()
        articles?.removeAll()
        let requestURL = URL(string: GET_ALL_ARTICLES)!
        print(requestURL)
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let paramDict = ["pass":"all_articles"]

        print("params",paramDict)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },            usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSON: '\(response)'")

                        if((response.result.value) != nil)
                        {
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                           
                            
                            if error == false{
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.noArticlesLabel.isHidden = false
                                for dic in dataArray{
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Articles.init(withDictionary:dicts)
                                    self.articles?.append(objD)
                                    self.noArticlesLabel.isHidden = true
                                }
                                self.articlesCollectionView.reloadData()
                                
    
                                return
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            AppUtility.hideProgress()
                            let result = response.result
                            print("response JSON: '\(result)'")
                            //let userInfo = response.error as? Error
                            let error = response.error

                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let encodingError):
                    AppUtility.hideProgress()
                    
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
}




extension SearchViewController{
    
    //MARK: TextField
      @IBAction func searchEditingChangeAction(_ sender: UITextField) {
        print(self.tfSearch.text!)
        print("search")
        if let text = self.tfSearch.text{
            
            if text.isEmpty{
                self.isSearching = false
                self.filteredArticles?.removeAll()
                self.articlesCollectionView.reloadData()
            }else{
                self.isSearching = true
                self.filteredArticles?.removeAll()
                
                if let articles = self.articles{
                    for article in articles{
                        if article.title?.range(of: self.tfSearch.text!, options: .caseInsensitive) != nil{
                            self.filteredArticles?.append(article)
                        }
                    }
                }
                self.articlesCollectionView.reloadData()
            }
            
        }
    }
    
}
