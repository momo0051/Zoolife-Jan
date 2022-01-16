//
//  CityListViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var arrCityNames = ["الرياض","الشرقية","جدة","مكة","ينبع","حفر الباطن","المدينة","الطائف","تبوك","القصيم","حائل","ابها","الباحة","جيزان","نجران","الجوف","عرعر","الكويت","الأمارات","البحرين"]
    
    var selectedCountryName = ""
    var selectedCountrIndex = 999999
    
    let BASE_COLOR = UIColor(red: 228/255, green: 57/255, blue: 65/255, alpha: 1.0)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
    }
    
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCityNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "CountryListCell", bundle: nil), forCellReuseIdentifier: "CountryListCell")
        var cell: CountryListCell! = tableView.dequeueReusableCell(withIdentifier: "CountryListCell") as? CountryListCell
        if (cell == nil)
        {
            cell = CountryListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CountryListCell")
        }
        
        cell.lblCountryName.text = arrCityNames[indexPath.row]
        
        //let obj:Vote = arrData.object(at: indexPath.row) as! Vote
        //cell.lblDate.text = obj.latestMajorActionDate
        //cell.lblBillNumer.text = obj.billNumber
        //cell.lblChamber.text = obj.chamber
        //cell.lblTitle.text = obj.title
        
        if selectedCountrIndex == indexPath.row
        {
            cell.viewBackGround.backgroundColor = BASE_COLOR
            cell.lblCountryName.textColor = UIColor.white
            cell.imgNext.image = UIImage(named: "ic_next-2")
        }
        else
        {
            cell.viewBackGround.backgroundColor = UIColor.white
            cell.lblCountryName.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
            cell.imgNext.image = UIImage(named: "ic_next-1")
        }
        
        
         cell.selectionStyle = .none

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 71
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let indexpath = indexPath.row
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! CountryListCell
        let obj = arrCityNames[indexPath.row]
        selectedCountryName = obj
        selectedCountrIndex = indexPath.row
        //btnSelectCountry.setTitle(obj, for: .normal)
        
        if selectedCountrIndex == indexPath.row
        {
            cell.viewBackGround.backgroundColor = BASE_COLOR
            cell.lblCountryName.textColor = UIColor.white
            cell.imgNext.image = UIImage(named: "ic_next-2")
        }
        else
        {
            cell.viewBackGround.backgroundColor = UIColor.white
            cell.lblCountryName.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
            cell.imgNext.image = UIImage(named: "ic_next-1")
        }
        
//        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            //self.viewCountryList.alpha = 0
//            //self.viewCountryList.isHidden = true
//        })
        let viewController = SettingsViewController()
        viewController.cityName = obj
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    

    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
