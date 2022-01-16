//
//  CategoriesViewController.swift
//  ZOOLIFE
//
//  Created by Zeeshan Tariq on 20/02/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfSearch:UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var nextPage = ""
    var firsttime = false
    
    
    var arrCategoryData = [Category]()

    var arrAdsData = [Ad]()
    var filteredAdds = [Ad]()
    
    var isSearching = false

    var didSelectCategory: ((Int, String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        getCategory()
        getAds()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        tfSearch.text = ""
//        self.isSearching = false
//        self.filteredAdds.removeAll()
//        self.tableView.reloadData()
    }
    
    //MARK: - Custome functions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                tfSearch.textAlignment = .left
                tfSearch.localizeKey = "Search"
                lblTitle.localizeKey = "Categories"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                tfSearch.localizeKey = "بحث في زوولايف"
                tfSearch.textAlignment = .right
                lblTitle.localizeKey = "الفئات"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
    }

    // MARK: - Buttons Action
    @IBAction func backTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createDateTime(timestamp: String) -> String
    {
        var strDate = "undefined"
            
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if isSearching {
            let post = self.filteredAdds[indexPath.row]
            
            let viewController = AdDetailViewController()
            viewController.hidesBottomBarWhenPushed = true
            viewController.post = post
            viewController.indexSelected = indexPath.row
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let objC = self.arrCategoryData[indexPath.row]
            let categoryID = objC.id!
            let viewController = ExploreResultViewController()
            viewController.categoryID = categoryID
            viewController.subCategoryID = ""
            viewController.cityName = ""
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredAdds.count : arrCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching {
            let cell: FavouriteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as? FavouriteTableViewCell
            
            let objC = filteredAdds[indexPath.row]
            cell.lblUserName.text = objC.username ?? ""
            cell.lblCity.text = objC.city
            cell.lblTitle.text = objC.itemTitle!
            _ = createDateTime(timestamp: objC.createAt!)
            cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.created_at ?? "")
            if let created_at = objC.created_at{
                if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                    
                    let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                    print(localTimeAdString)
                    
                    cell.lblDate.text = localTimeAdString
                }
            }
            if let imgUrl = objC.imgUrl{
                AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = CategoryTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
        
        let objC = self.arrCategoryData[indexPath.row]
        cell.titleLabel.text = objC.title ?? ""
        print("categories title \(objC.title)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSearching ? 140 : 60
    }
    
}

extension CategoriesViewController {
    
    func getCategory() {
        
        AppUtility.showProgress()
        
        arrCategoryData.removeAll()
        let requestURL = URL(string: GET_ALL_CATEGORIES)!
        print(requestURL)
        
        print("categories \(requestURL) ---- \(appLanguage)")
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = [String : Any]()
        print(paramDict)
        
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
                        
                        if error == false
                        {
                            //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                            let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                            
                            for dic in dataArray
                            {
                                let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                let objD = Category.init(withDictionary:dicts)
                                print("categories \(objD.title)")
                                self.arrCategoryData.append(objD)
                            }
                            
                            self.tableView.reloadData()
                            
                            return
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
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
                        alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            case .failure(let encodingError):
                AppUtility.hideProgress()
                
                print(encodingError)
                let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func getAds()
    {
        
        var requestURL = URL(string: GET_ALL_ITEMS)!
        
        if firsttime
        {
            if nextPage == nil || nextPage.count == 0
            {
                print("nextpageurl return")
                return
            }
            requestURL = URL(string: nextPage)!
            nextPage = ""
        }
        else{
            
            arrAdsData.removeAll()
        }
        firsttime = true
//        AppUtility.showProgress()

        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        
        let paramDict = [String:String]()

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },            usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.get,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSON: '\(response)'")

                        if((response.result.value) != nil){
                            
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
//                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
//                                print("nextpageurl \(self.nextPage)")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        let objD = Ad.init(withDictionary:dicts)
                                        if objD.id?.isEmpty ?? false {
                                            
                                        } else {
                                            self.arrAdsData.append(objD)
                                        }
                                        
                                    }
                                }
                                self.tableView.reloadData()
                                self.getAds()
                                
    
                                return
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
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
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let encodingError):
                    AppUtility.hideProgress()
                    
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
}

extension CategoriesViewController {
    
    //MARK: TextField
      @IBAction func searchEditingChangeAction(_ sender: UITextField) {
        print(self.tfSearch.text!)
        print("search")
        if let text = self.tfSearch.text{
            
            if text.isEmpty{
                self.isSearching = false
                self.filteredAdds.removeAll()
                self.tableView.reloadData()
                
            }else{
                self.isSearching = true
                self.filteredAdds.removeAll()

                let searchPredicate = NSPredicate(format: "SELF contains[c] %@", text)
                //NSArray *aNames = [names filteredArrayUsingPredicate:predicate];
                self.filteredAdds = self.arrAdsData.filter { searchPredicate.evaluate(with: $0.itemTitle) }
                
                self.tableView.reloadData()
            }
            
        }
    }
    
}
