//
//  CallUsViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 11/01/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class CallUsViewController: UIViewController {
    
    
    @IBOutlet weak var lblAdvertisePhone: UILabel!
    
    @IBOutlet weak var lblnquiryPhone: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblText3: UILabel!
    @IBOutlet weak var lblText4: UILabel!
    @IBOutlet weak var lblPhone1: UILabel!
    @IBOutlet weak var lblPhone2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    
    //MARK: - Custome Functions
  
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Contact Us"
                lblText1.localizeKey = "If you have any question, we would be happy to answer it!"
                lblText2.localizeKey = "Objectives"
                lblText3.localizeKey = " We found  ZooLife platform to collect everything related to animals and make it easy for users to search for buying and selling, food, medicine and vet  clinics, and it brings together a group of experts and advisors to provide  and share the best advices  and experiences, ZooLife includes shows and entertainment events in the animal world.Our Goal \n\n1. Our primary goal is to provide and facilitate services to clients in researching the animal world. \n\n2. Establishing forums for the owners of birds, livestock, fish, horses and others.\n\n3. A platform that gathers all veterinary clinics, all pharmaceutical and feed companies, and everything related to animals. We are happy to contact us and receive any inquiries via the following numbers."
                lblText4.localizeKey = "Follow us on our social media pages."
                lblPhone1.localizeKey = "Advertise"
                lblPhone2.localizeKey = "Inquiries"
                
                lblText1.textAlignment = .left
                lblText2.textAlignment = .left
                lblText3.textAlignment = .left
                
                lblnquiryPhone.textAlignment = .right
                lblAdvertisePhone.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "اتصل بنا"
                lblText1.localizeKey = "وضعنا بين أيديكم منصة زوولايف ليجمع كل ما يخص الحيوانات ويسهل على المستخدمين البحث عن بيع وشراء وغذاء ودواء والعيادات الخاصة ويجمع نخبة من الخبراء والمستشارين ليقدموا افضل النصائح والاستشارات ويضم زوولايف عروض وفعاليات ترفيهيه في عالم الحيوان."
                lblText2.localizeKey = "الأهداف"
                lblText3.localizeKey = "1 - هدفنا الأول هو تقديم وتسهيل الخدمات للعملاء في البحث في عالم الحيوان.\n\n2 - إنشاء ملتقيات لملاك الطيور والمواشي والأسماك والخيول وغيرها.\n\n3 - منصة تجمع كل العيادات البيطرية وكل شركات الأدوية والأعلاف وكل ما يخص الحيوانات. يسعدنا التواصل معنا  وتلقي أي استفسار عبر الارقام التالية."
                
                lblText4.localizeKey = "تابعنا على صفحاتنا  على مواقع التواصل الاجتماعي."
                lblPhone1.localizeKey = "الاعلانات"
                lblPhone2.localizeKey = "الشكاوي والاقتراحات"
                lblnquiryPhone.textAlignment = .left
                lblAdvertisePhone.textAlignment = .left
                lblText1.textAlignment = .right
                lblText2.textAlignment = .right
                lblText3.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }

//    @IBOutlet weak var contactUsText: UILabel!
    
    //MARK: - Button Actions
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func callSupport(_ sender: UIButton) {
  
        if sender.tag == 0 {
            whatsAppCallAction(number: "+966591114156")
        }else{
            whatsAppCallAction(number: "+966551180030")
        }
        
   
       
    }
    
    @IBAction func tikTok(_ sender: Any) {
  
        if let url = URL(string: "https://www.tiktok.com/@zoolife2030?lang=en") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func socialTwitter(_ sender: Any) {
  
        if let url = URL(string: "https://twitter.com/zoolife2030") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func socialFacebook(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/zoolife.mooh") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func socialInstagram(_ sender: Any) {
        if let url = URL(string:"https://www.instagram.com/zoolife.sa/"){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func socialTelegram(_ sender: Any) {
        if let url = URL(string:"https://t.me/ZooLife2030")
        {UIApplication.shared.open(url)}
    }
    
    @IBAction func socialSnapChat(_ sender: Any) {
        if let url = URL(string:"https://www.snapchat.com/add/zoolife.sa")
        {UIApplication.shared.open(url)}
    }

}
