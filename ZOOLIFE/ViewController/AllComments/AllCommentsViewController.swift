//
//  AllCommentsViewController.swift
//  ZOOLIFE
//
//  Created by Yousaf Shafiq on 25/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AllCommentsViewController: UIViewController {

    var commentsPost = [Comments]()
    var post: Ad?
    
    
    @IBOutlet weak var tbNew: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentBox: UITextField!
    @IBOutlet weak var allowComments:UIView!
    
    @IBOutlet weak var btnPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        
        tbNew.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        tbNew.tableFooterView = UIView()
        
        tbNew.dataSource = self
        tbNew.delegate = self
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 150
        commentTableView.tableFooterView = UIView()
        
        self.getComments()
        
        if let showComments = self.post?.showComments{
            if showComments == "0"{
                allowComments.isHidden = true
            }else{
                allowComments.isHidden = false
            }
        }


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Details"
                commentBox.localizeKey = "Write a comment here"
                btnPost.localizeKey = "send"
                commentBox.textAlignment = .left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "التفاصيل"
                commentBox.localizeKey = "أكتب تعليق "
                btnPost.localizeKey = "إرسال"
                commentBox.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func postCommentAction(){

        
        
        
       // var user: User
        
        if AppUtility.getSession() != nil {
            //user = u
            
            if let comment = commentBox.text {
                if comment == "" {
                    var word = "الرجاء إضافة تعليق"
                    if appLanguage == "en" {
                        word = "Please Add Comment"
                    }
                    let alert = UIAlertController(title: "Zoolife", message:word, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.postComment(comment: comment)
            }
            
            
        }else{
            
            var word = "يمكن للمستخدم المسجل فقط إضافة تعليقات"
            if appLanguage == "en" {
                word = "Only registered user can add comments"
            }
            
            let alert = UIAlertController(title: "Zoolife", message:word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
 
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension AllCommentsViewController {
    
    func postComment (comment : String){
    
        AppUtility.showProgress()
        let requestURL = URL(string: ADD_COMMENT)!

        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["id":self.post?.id ?? "",
                          "user_id":user.ID!,
                          "message": comment] as [String : Any]

        
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
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool

                            AppUtility.hideProgress()

                            if error == false{

                                self.commentBox.text = ""
                                self.getComments()
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)


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
    
    

    
    func getComments (){
      
        AppUtility.showProgress()
        let requestURL = URL(string: GET_COMMENTS)!
        print(requestURL)
    
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["id":post?.id ?? ""] as [String : Any]
        print(paramDict)
        
        self.commentsPost.removeAll()
        
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
                              //  self.noCommentsLabel.isHidden = false
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Comments.init(withDictionary:dicts)
                                
                                    self.commentsPost.append(objD)//.add(objD)
                                   // self.noCommentsLabel.isHidden = true
                                    
                                }
                                
//                                self.commentTableView.reloadData()
//                                self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
//                                self.setUpParentHeight()
//
                                self.commentTableView.reloadData()
                                self.tbNew.reloadData()
                               
                                return
                            }
                            else
                            {
                                
                                if let dataArray : [JSON] = (dict["data"]?.arrayValue){
                                    if dataArray.count == 0 {
//                                        self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
//                                        self.setUpParentHeight()
//
                                self.commentTableView.reloadData()
                                        self.tbNew.reloadData()
                                        
                                        
                                        
                                        
                                    }
                                    return
                                }
                                
//                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            AppUtility.hideProgress()
                            let result = response.result
                            print("response JSON: '\(result)'")
                            //let userInfo = response.error as? Error
                            let error = response.error

//                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
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



extension AllCommentsViewController:UITableViewDelegate,UITableViewDataSource{
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.commentsPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell: CommentsCell! = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as? CommentsCell
        if (cell == nil)
        {
            cell = CommentsCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CommentsCell")
        }
        
        let comment = self.commentsPost[indexPath.row]
        
        cell.lblName.text = comment.username
        cell.lblEventInfromation.text = comment.message
        cell.lblDate.text = comment.co       
        if let created_at = comment.co {
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                print(localTimeAdString)
                cell.lblDate.text = localTimeAdString
            }
        }
        
        cell.lblEventInfromation.numberOfLines = 0
        cell.lblEventInfromation.lineBreakMode = .byWordWrapping
        cell.lblEventInfromation.sizeToFit()
        
        return cell
    }
}
