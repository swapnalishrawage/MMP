//
//  MainVC.swift
//  MakeMePopular
//
//  Created by sachin shinde on 10/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var islogin:Bool = false
        if(UserDefaults.standard.value(forKey: "IsLogin") != nil){
        islogin = UserDefaults.standard.value(forKey: "IsLogin") as! Bool
        }
        if(islogin == false){
          DispatchQueue.main.async {
             self.performSegue(withIdentifier: "login", sender: self)
           }
        }
        else{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "dashboardvc", sender: self)
            }
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

