//
//  ViewController.swift
//  Alamofire-Exercise Alamofire-Exercise Alamofire-Exercise
//
//  Created by seokhyun kim on 2018-03-22.
//  Copyright © 2018 seokhyun kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var currentTime: UILabel!
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            //GET
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            let response = try String(contentsOf: url!)
            self.currentTime.text = response
            self.currentTime.sizeToFit()
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    @IBOutlet var userId: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var responseView: UITextView!
    
    @IBAction func post(_ sender: Any) {
        //POST
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8)
        
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "ID : \(userId!)" + "\n"
                            + "Name : \(name!)" + "\n"
                            + "result of response : \(result!)" + "\n"
                            + "response time : \(timestamp!)" + "\n"
                            + "response method : x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject : \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    @IBAction func json(_ sender: Any) {
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        
        /* POST Type
         let param = "userId=\(userId)&name=\(name)"
         let paramData = param.data(using: .utf8)
         */
        //JSON Type
        let param = ["userId" : userId, "name" : name]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")
        //        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        /* POST Type
         request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
         */
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "ID : \(userId!)" + "\n"
                            + "Name : \(name!)" + "\n"
                            + "result of response : \(result!)" + "\n"
                            + "response time : \(timestamp!)" + "\n"
                            + "response method : x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject : \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }


}

