//
//  ServiceHelper.swift
//  Pappaya
//
//  Created by Thirumal on 15/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class WebServiceDataModel: NSObject
{
    var error : Error?
    var returnValue : Any?
    var response : URLResponse?
}

class ServiceHelper: NSObject
{
    static let sharedInstance = ServiceHelper()
    
    //MARK:- CalendarDetail
    
    func getListOfCalendarEvent(completionHandler :@escaping (NSDictionary? , NSError?) -> Void?)
    {
        if let url = URL(string: "https://cander-2524f.firebaseio.com/calendars.json")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            webServiceCall(urlRequest: request, completionHandler: { (webServiceResponse) -> Void? in
                completionHandler(webServiceResponse.returnValue as? NSDictionary , webServiceResponse.error as? NSError)
            })
        }
        else
        {
            completionHandler(nil, self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid URL, Please try again later."))
        }
    }
    
    func getListOfEvents(completionHandler :@escaping (NSDictionary? , NSError?) -> Void?)
    {
        if let url = URL(string: "https://cander-2524f.firebaseio.com/events.json")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            webServiceCall(urlRequest: request, completionHandler: { (webServiceResponse) -> Void? in
                completionHandler(webServiceResponse.returnValue as? NSDictionary , webServiceResponse.error as? NSError)
            })
        }
        else
        {
            completionHandler(nil, self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid URL, Please try again later."))
        }
    }
    
    func addEventToCalendar(eventId : String, calendarName : String , completionHandler :@escaping (Bool? , NSError?) -> Void?)
    {
        let urlString = "https://cander-2524f.firebaseio.com/events/" + eventId + "/accepted.json"
        let request = getUrlRequestWithUrl(urlString: urlString, method: "PATCH", postData: ["karts" : true])
        webServiceCall(urlRequest: request, completionHandler: { (webServiceResponse) -> Void in
            if let response = webServiceResponse.response as? HTTPURLResponse
            {
                if response.statusCode == 200
                {
                    let urlAddString = "https://cander-2524f.firebaseio.com/calendars/" + calendarName + "/events.json"
                    let addRequest = self.getUrlRequestWithUrl(urlString: urlAddString, method: "PATCH", postData: [eventId : true])
                    self.webServiceCall(urlRequest: addRequest, completionHandler: { (webServiceResponse) -> Void in
                        if let response = webServiceResponse.response as? HTTPURLResponse
                        {
                            if response.statusCode == 200
                            {
                                completionHandler(true , webServiceResponse.error as? NSError)
                            }
                            else
                            {
                                completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                                
                            }
                        }
                        else
                        {
                            completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                            
                        }
                    })
                }
                else
                {
                    completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                }
            }
            else
            {
                completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
            }
        })
        
        
    }
    
    func removeEventFromCalendar(eventId : String, calendarName : String , completionHandler :@escaping (Bool? , NSError?) -> Void?)
    {
        let urlString = "https://cander-2524f.firebaseio.com/calendars/" + calendarName + "/events/" + eventId + ".json"
        var request = URLRequest(url: URL(string:urlString)!)
        request.httpMethod = "DELETE"
        webServiceCall(urlRequest: request, completionHandler: { (webServiceResponse) -> Void in
            if let response = webServiceResponse.response as? HTTPURLResponse
            {
                if response.statusCode == 200
                {
                    let urlAddString = "https://cander-2524f.firebaseio.com/events/" + eventId + "/accepted/karts.json"
                    var eventRequest = URLRequest(url: URL(string:urlAddString)!)
                    eventRequest.httpMethod = "DELETE"
                    self.webServiceCall(urlRequest: eventRequest, completionHandler: { (webServiceResponse) -> Void in
                        if let response = webServiceResponse.response as? HTTPURLResponse
                        {
                            if response.statusCode == 200
                            {
                                let urlPatchString = "https://cander-2524f.firebaseio.com/events/" + eventId + "/declined.json"
                                let addRequest = self.getUrlRequestWithUrl(urlString: urlPatchString, method: "PATCH", postData: ["karts" : true])
                                self.webServiceCall(urlRequest: addRequest, completionHandler: { (webServiceResponse) -> Void in
                                    if let response = webServiceResponse.response as? HTTPURLResponse
                                    {
                                        if response.statusCode == 200
                                        {
                                            completionHandler(true , webServiceResponse.error as? NSError)
                                        }
                                        else
                                        {
                                            completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                                            
                                        }
                                    }
                                    else
                                    {
                                        completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                                        
                                    }
                                })
                            }
                            else
                            {
                                completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                                
                            }
                        }
                        else
                        {
                            completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                            
                        }
                    })
                }
                else
                {
                    completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
                }
            }
            else
            {
                completionHandler(false , self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later."))
            }
        })
        
        
    }
    
    func getUrlRequestWithUrl(urlString : String,method : String , postData : [String : Any]) -> URLRequest
    {
        //create the url with URL
        let url = URL(string: urlString)!
        
        //                let url = URL(string: "http://" + Constants.ServiceApi.DomainUrl + "/mobile/" + urlString)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = method //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    
    func webServiceCall(urlRequest : URLRequest , completionHandler : @escaping (WebServiceDataModel) -> Void?)
    {
        if checkInternetConnection()
        {
            //create the session object
            let session = URLSession.shared
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: urlRequest , completionHandler: { data, response, error in
                
                let webServiceData = WebServiceDataModel()
                webServiceData.response = response
                if error != nil
                {
                    webServiceData.error = error
                }
                else
                {
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        {
                            webServiceData.returnValue = json
                        }
                        else
                        {
                            webServiceData.error = self.getLocalErrorWithCode(errorCode: 102, errorMessage: "Json error, Please try again later.")
                        }
                    }
                    catch
                    {
                        webServiceData.error = self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later.")
                    }
                }
                DispatchQueue.main.async(){
                    completionHandler(webServiceData)
                }
            })
            task.resume()
        }
        else
        {
            let serviceError = WebServiceDataModel()
            serviceError.error = self.getLocalErrorWithCode(errorCode: 100, errorMessage: "No Internet connection, Please try again later.")
            completionHandler(serviceError)
        }
    }
    
    func getLocalErrorWithCode(errorCode : Int, errorMessage : String) -> NSError
    {
       return NSError(domain: "Calendar", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
}
