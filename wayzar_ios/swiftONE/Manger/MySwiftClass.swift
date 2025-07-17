//
//  MySwiftClass.swift
//  swiftONE
//
//  Created by admin on 2021/9/6.
//
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import UIKit
//在桥接文件中引入头文件

@objc class MySwiftClass: NSObject {
    
    @objc
    public var maptile_name : String = ""
    static var i : Int = 0
    override init() {
        super.init()
    }

    @objc
    public func sayHello() -> Void {
        print("hello111");
    }

    @objc(addX:andY:)
    public func add(x: Int, y: Int) -> Int {
        return x+y
    }
    @objc
    public func requesetUpload(filePath: String) -> Void {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "image",
            "src": filePath,
            "type": "file"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
                do{
              let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData , encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue) )
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }catch{
                    
                }
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://aimap.newayz.com/aimap/waic/v1/coffee/image")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
            DispatchQueue.global(qos: .background).async {

                // Background Thread

                DispatchQueue.main.async {
                        let window = UIApplication.shared.keyWindow;
                        window?.makeToast("返回结果！"+String(data: data, encoding: .utf8)!, duration: 2, position: CSToastPositionCenter)
                   
                }
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    @objc public func requestUploadImageTwo(filePath: String,homeViewC homeViewC1:HomeViewController) -> Void {

        var semaphore = DispatchSemaphore (value: 0)
        do{
      let fileData = try NSData(contentsOfFile:filePath, options:[]) as Data
            let parameters = "{\n    \"image\":\""+fileData.base64EncodedString()+"\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://aimap.newayz.com/aimap/waic/v1/coffee/image")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              DispatchQueue.global(qos: .background).async {
                  // Background Thread
                  DispatchQueue.main.async {
                      homeViewC1.showLeftUIView("error")
                      let window = UIApplication.shared.keyWindow;
                      window?.makeToast("网络异常！")
                  }
              }
            semaphore.signal()
            return
          }
            var responseJson = String(data: data, encoding: .utf8)!;
            print(responseJson)
            if(responseJson.contains("link")){
            DispatchQueue.global(qos: .background).async {

                // Background Thread

                DispatchQueue.main.async {
                    let dictionary = self.getDictionaryFromJSONString(jsonString: responseJson)
                                if let imageString = dictionary["link"] as? String {
                                    let window = UIApplication.shared.keyWindow;
                                    //window?.makeToast("请扫描二维码，获取照片！"+imageString, duration: 2, position: CSToastPositionCenter)
                                    let prefs = UserDefaults.standard
                                    prefs.setValue(imageString, forKey: "imageString")
                                    self.maptile_name = imageString;
                                    homeViewC1.showLeftUIView(imageString)
                                }
                        let window = UIApplication.shared.keyWindow;
                        window?.makeToast("请扫描二维码，获取照片！", duration: 2, position: CSToastPositionCenter)
                   
                }
            }
            }else{
                DispatchQueue.global(qos: .background).async {
                    // Background Thread
                    DispatchQueue.main.async {
                        homeViewC1.showLeftUIView("error")
                        let window = UIApplication.shared.keyWindow;
                        window?.makeToast("网络异常！")
                    }
                }
            }
          semaphore.signal()
        }

        task.resume()
            
              }catch{
                      
                  }
        semaphore.wait()

    }
    
    @objc public func showSwiftLog(str:String,abc str2:String,bcd str3:String,orentation str4:String,lat lat1:String,lon lon1:String,homeView homeView1:UIImageView,homeViewC homeViewC1:HomeViewController,x x1:String,y y1:String,z z1:String,w w1:String) -> Void {
        print(lat1+"swiftss")
        print(lon1+"swiftss")
        print("定位开始")
          UnityToiOSManger.setRequest(true);
        //121.608602,31.185154  智能岛gps
        //116.018859,29.702849  九江非遗小苑gps
        //120.02457, 30.273013 测科院
        //121.614359,31.18723 张江科学会堂
       var lat2 = "31.18723";
       var lon2 = "121.614359";
        var semaphore = DispatchSemaphore (value: 0)
        var data = ""
        
        let dateTime = NSDate.init()
        //这里是秒，如果想要毫秒timeIntervalSince1970 * 1000
        let timeSp = String(format: "%d", dateTime.timeIntervalSince1970*1000)
        NSLog(timeSp+"yuan")
        if(maptile_name==nil||maptile_name.isEmpty){
            data = "{\"orientation\":\""+str4+"\",\"timestamp\":\""+timeSp+"\",\"intrinsic\":\"["+str2+", "+str3+"]\",\"distortion\":\"[0.0, 0.0, 0.0, 0.0]\",\"prior_translation\":\"{\\\"alt\\\":10.0,\\\"lat\\\":"+lat1+",\\\"lon\\\":"+lon1+"}\",\"prior_rotation\":\"{\\\"x\\\":"+x1+", \\\"y\\\":"+y1+", \\\"z\\\":"+z1+", \\\"w\\\":"+w1+"}\"}";
        }else{
            data = "{"+"\"orientation\":\""+str4+"\","+"\"prior_maptile_name\":\""+maptile_name+"\","+"\"timestamp\":\""+timeSp+"\",\"intrinsic\":\"["+str2+", "+str3+"]\",\"distortion\":\"[0.0, 0.0, 0.0, 0.0]\",\"prior_translation\":\"{\\\"alt\\\":10.0,\\\"lat\\\":"+lat1+",\\\"lon\\\":"+lon1+"}\",\"prior_rotation\":\"{\\\"x\\\":"+x1+", \\\"y\\\":"+y1+", \\\"z\\\":"+z1+", \\\"w\\\":"+w1+"}\"}";
        }
        YPLogTool.ypwLogInfo("data:"+String(describing: data));
        let parameters = [
          [
            "key": "data",
            "value": data,
            "type": "text"
          ],
          [
            "key": "image",
            "value": str,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
                do {
                    let paramSrc = param["src"] as! String
                    let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                      + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                } catch  {
                }
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        //测试ip  114.67.232.99  九江，智能岛，9L场景等
        //正式版ip  http://116.196.107.117:50052/wayzoom/v1/vps/single
        //张远测试版ip http://192.168.1.76:50052/wayzoom/v1/vps/single
        //老服务器 IP  116.196.107.117
        //新服务器 IP 114.67.225.7  新地图，绿巨人，人才港
        //192.168.1.54 飞哥本地服务
        let prefs = UserDefaults.standard
        let aaa = prefs.string(forKey: "serverIP");
        //let url = "http://" + aaa! + ":50052/wayzoom/v1/vps/single"
        //        let url = "https://hdmap.newayz.com" + "/wayzoom/v1/vps/single"
        //let url = "http://192.168.1.93:50052/wayzoom/v1/vps/single"
//                let url = "https://prod-hdmap.newayz.com/wayzoom/v1/vps/single"
                let url = "https://prod-hdmap.newayz.com/wayzoom/v1/vps/single"
        
        print("==="+url)
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("ade820503cc6069ff507346a6ef7fec3", forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              UnityToiOSManger.setRequest(false);
              print("定位结束")
    
              YPLogTool.ypwLogInfo("hahah123"+String(describing: error));
            DispatchQueue.global(qos: .background).async {

                // Background Thread

                DispatchQueue.main.async {
                    
                    let prefs = UserDefaults.standard
                    let debug = prefs.bool(forKey: "debug");
                    if(debug){
                        let window = UIApplication.shared.keyWindow;
                        window?.makeToast("定位网络异常！"+String(describing: error), duration: 2, position: CSToastPositionCenter)
                        return
                    }
                    let recording = prefs.bool(forKey: "recording");
                    if(!recording){
                    let window = UIApplication.shared.keyWindow;
                    window?.makeToast("定位网络异常！")
                    MySwiftClass.i = 0
                    }
                    // Run UI Updates
                    // UI更新代码
                     //WHToast.showMessage(String(describing: error), duration: 1)
                }
            }
            semaphore.signal()
            return
          }
            //"{\"causeValue\":0,\"description\":\"succeed\",\"timestamp\":\"1630393036\",\"translation\":\"1.041751430854904 2.680643000547613 -0.8392351244462269\",\"rotation\":\"0.25414075039852985 0.5815148397157555 -0.7107504888478893 -0.3034579258805374\",\"deviation\":null,\"ori_tvec\":[0.0,0.0,0.0],\"ori_qvec\":[0,0,0,1],\"maptile_name\":\"F9_0214\"}"
            let json = String(data: data, encoding: .utf8)!;
          print(String(data: data, encoding: .utf8)!)
            let manager = UnityToiOSManger()
            UnityToiOSManger.setRequest(false);
            print("定位结束")
            if json.contains("succ"){
                YPLogTool.ypwLogInfo("hahah123"+json);
                DispatchQueue.global(qos: .background).async {

                    // Background Thread

                    DispatchQueue.main.async {
                        homeView1.isHidden = true ;
                        let prefs = UserDefaults.standard
                        let recording = prefs.bool(forKey: "recording");
                        if(!recording){
                        var window = UIApplication.shared.keyWindow;
                        window?.makeToast("定位成功！")
                        }
                        let debug = prefs.bool(forKey: "debug");
                        homeViewC1.setDingweiTime("35")
//                        homeViewC1.showLeftUIView()
                        MySwiftClass.i = 0
                        if(debug){
                            let window = UIApplication.shared.keyWindow;
                            window?.makeToast("定位成功！"+json, duration: 2, position: CSToastPositionCenter)
                            return
                        }
                    }
                }
                print("succ")
            manager.sendMsgToUnity(withMsg: String(data: data, encoding: .utf8)!)
                if(self.maptile_name==""){
                let dictionary = self.getDictionaryFromJSONString(jsonString: json)
                            if let maptile_name1 = dictionary["maptile_name"] as? String {
                                self.maptile_name = maptile_name1;
                                print("====maptile_name:"+self.maptile_name)
                                //homeViewC1.requestPOIData();
                                //self.requestPOIConverT(x: maptile_name1)
                            }
                }
            }else{
                YPLogTool.ypwLogInfo("hahah123"+json);
                    DispatchQueue.global(qos: .background).async {

                        // Background Thread

                        DispatchQueue.main.async {
                            
                            let prefs = UserDefaults.standard
                            let debug = prefs.bool(forKey: "debug");
                            if(debug){
                                let window = UIApplication.shared.keyWindow;
                                window?.makeToast("定位失败！"+json, duration: 2, position: CSToastPositionCenter)
                                return
                            }
                            // Run UI Updates
                            // UI更新代码
                            MySwiftClass.i = MySwiftClass.i+1;
                            if(MySwiftClass.i>5){
                                MySwiftClass.i = 0
                                let recording = prefs.bool(forKey: "recording");
                                if(!recording){
                                let window = UIApplication.shared.keyWindow;
                                window?.makeToast("定位失败！")
                                }
                            }
                        }
                    }            }
            //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        }
    // JSONString转换为字典
     
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
     
        let jsonData:Data = jsonString.data(using: .utf8)!
     
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
         
     
    }
    
    @objc
    public func requestPOIConverT(x: String,homeViewC homeViewC1:HomeViewController) -> Void {

        var semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "data",
            "value":x,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        
        print("Boundary:"+boundary)
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
                do {
                    let paramSrc = param["src"] as! String
                    let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                      + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                } catch  {
                    
                }
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://114.67.225.7:50052/wayzoom/v1/poi_convert")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        print("====maptile_name start:")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            print("====maptile_name start:"+String(describing: error))
            semaphore.signal()
            return
          }
            let json = String(data: data, encoding: .utf8)!
            print("====maptile_name start123:"+json)
            if(json.contains("succ")){
                //homeViewC1.
                homeViewC1.sendUnityPOIJson(json)
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
}
