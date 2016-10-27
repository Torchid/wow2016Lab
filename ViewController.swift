//
//  ViewController.swift
//  MyApp
//
//  Created by ibmevents on 10/27/16.
//  Copyright © 2016 ibmevents. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController {

    @IBOutlet weak var urlText: UITextField!
   
    @IBOutlet weak var analysisTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        NSLog("Button Pressed " + urlText.text!);
        
        var status = "waiting for Watson processing the URL : " + urlText.text!
        
        //Adding Watson Visual Recognition - based on the example from WDC sdk iOS
        let apiKey = "dee2893e33ff636c6c1c3845bc0579a30aaad2d7"
        let version = "2016-05-22" // use today's date for the most recent version
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let url = urlText.text!
        let failure = { (error: NSError) in print(error) }
        visualRecognition.classify(url, failure: failure) { classifiedImages in
            status = "visual status ::::::::::::: " + (classifiedImages.images.description)
            
            //detecting classification
            if (!classifiedImages.images.isEmpty && !classifiedImages.images[0].classifiers.isEmpty &&
                !classifiedImages.images[0].classifiers[0].classes.isEmpty) {
                status = status + "######## classification : " + classifiedImages.images[0].classifiers[0].classes[0].classification
                
                //detecting faces on the pictures with people
                if (!classifiedImages.images[0].classifiers[0].classes[0].classification.isEmpty &&
                    "person" == classifiedImages.images[0].classifiers[0].classes[0].classification) {
                    self.analysisTextLabel.text = status + " ##########  person found ###########"
                    visualRecognition.detectFaces(url, failure: failure) { imagesWithFaces in
                        if (!imagesWithFaces.images[0].faces.isEmpty) {
                            status = status + " ###### the person's age max : " + imagesWithFaces.images[0].faces[0].age.max.description
                            status = status + " age min : " + imagesWithFaces.images[0].faces[0].age.min.description
                            status = status + " person's gender : " + imagesWithFaces.images[0].faces[0].gender.gender
                            NSLog("faces :::::::::::::: ")
                            self.analysisTextLabel.text = "3 : " + status
                        }
                    }
                }
            }
            //setting feedback on sentiment
            self.analysisTextLabel.text = "2 : " + status
        }
        //setting feedback on sentiment
        self.analysisTextLabel.text = "1 : " + status
        
    }

}

