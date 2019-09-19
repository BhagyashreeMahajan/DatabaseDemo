//
//  ModelManager.swift
//  TractorInstallation
//
//  Created by Bhagyashree Mahajan on 20/08/18.
//  Copyright © 2018 mahindra. All rights reserved.
//

import UIKit

import FMDB

let sharedInstance = ModelManager()

struct DB {
    static let name = "TestDB.sqlite"
    static let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    static let Appname = "Demo"
}

func getPath(_ fileName: String) -> String {
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    print(documentsURL)
    let fileURL = documentsURL.appendingPathComponent(fileName)
    
    return fileURL.path
}

func copyFile(_ fileName: NSString) {
    
    let fileManager = FileManager.default
    guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    guard let sourceFilePath = Bundle.main.url(forResource: "TestDB", withExtension: "sqlite") else { return }
    let destinationPath = documentsPath.appendingPathComponent("TestDB.sqlite")
    
    print("[INFO] - destinationPath: \(destinationPath.absoluteString)")
    
    if !fileManager.fileExists(atPath: destinationPath.path) {
        print("[DEBUG] - File DOES NOT exist")
        do {
            try fileManager.copyItem(at: sourceFilePath, to: destinationPath)
        } catch {
            print(error)
        }
    } else {
        print("[DEBUG] - File DOES exist")
    }
}

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil
    
    let OBJ_APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: getPath(DB.name))
        }
        return sharedInstance
    }
    
    func saveData(name:String, age:String)->Bool
    {
        sharedInstance.database!.open()
        var isInserted:Bool = false
        do {
            
            let query = "INSERT INTO Customer (Name, Age) VALUES ('\(name)','\(age)')"
            
            isInserted = ((try sharedInstance.database?.executeUpdate(query, values:nil)) != nil)
            if(!isInserted)
            {
                print("Insert : failed: \(sharedInstance.database!.lastErrorMessage())")
            }
            else
            {
                print("Insert Succeed")
            }
            
        } catch {
            print("Insert failed: \(error.localizedDescription)")
        }
        
        sharedInstance.database!.close()
        
        return isInserted
    }
    

    func getData()->(name:String, age:String)
    {
        sharedInstance.database!.open()
        var name : String!
        var age : String!
        
        do {
            let query = "SELECT * FROM Customer"
            let resultSet = try sharedInstance.database?.executeQuery(query, values: nil)
            if resultSet != nil
            {
                while (resultSet?.next())!
                {
                    name = resultSet?.string(forColumn: "Name") ?? ""
                    age = resultSet?.string(forColumn: "Age") ?? ""
                   
                    
                }
            }
        }
        catch {
            print("failed: \(error.localizedDescription)")
        }
        sharedInstance.database!.close()
        
        return (name, age)
    }
    
}
