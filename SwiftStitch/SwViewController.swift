//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit

class SwViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet weak var OutImage: UIImageView!
    @IBOutlet weak var OutImage1: UIImageView!
    @IBOutlet weak var OutImage2: UIImageView!
    @IBOutlet weak var OutImage3: UIImageView!
    @IBOutlet weak var ResCode: UIImageView!
    
    let fileManager = FileManager.default
    //文件管理
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stitch()
    }
    
    func getDirectoryPath() -> String {
        //获取模拟器沙盒Documents文件夹路径
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    func getImage(name:String) -> UIImage{
        //获取images文件夹下所有文件
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("/images/\(name)")
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
            return UIImage(named:"test")!
        }
    }
    func saveImage(imageArray:[UIImage],pathName:NSString){
        //保存图片
        var paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        paths = paths.appending("/dstImages/\(pathName)") as (NSString)
        //输出文件夹为dstImages，在其中创建pathName的文件夹
        var imageData:Data?
        if !fileManager.fileExists(atPath: paths as String){
            //创建文件夹
            try! fileManager.createDirectory(atPath: paths as String, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Dictionary already exists.")
        }
        for (index,value) in imageArray.enumerated() {
            //遍历结果图片，保存至本地
            print(index,value)
            let newPaths = paths.appendingPathComponent("\(index)") as (NSString)
            //设置文件名字
            imageData = UIImageJPEGRepresentation(value, 0.5)
            //保存，第二个参数为质量
            fileManager.createFile(atPath: newPaths as String, contents: imageData, attributes: nil)
        }
    }
    
    func stitch() {
        self.spinner.startAnimating()
        DispatchQueue.global().async {
            
            var srcImage:UIImage?//储存输入图片
            let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent("/images")
            let contentsOfPath = try? self.fileManager.contentsOfDirectory(atPath: imagePath as String) as [NSString]
            for (index,value) in (contentsOfPath?.enumerated())!{
                //取遍目标文件夹内所有文件
                print(index,value)
                
                if value.contains(".jpg") == true {
                    //字符串包涵.jpg，为图片格式
                    srcImage = self.getImage(name:value as String)
                    
                    let resultArray:[Any] = CVWrapper.processImage(toPartition: srcImage!)
                    //通过CVWrapper的process方法，传入partition中调用OpenCV进行处理
                    self.saveImage(imageArray: resultArray as! [UIImage],pathName: value)
                    //保存分割后的图片
                    
                    //for (index,value) in resultArray.enumerated(){
                    //    遍历分割后的图片
                    //    let image:UIImage = value as! UIImage
                    //}
                    self.ResCode.image = srcImage
                    //self.OutImage.image = image
                    //self.OutImage.contentMode = .scaleAspectFit
                    //self.OutImage1.image = image1
                    //self.OutImage1.contentMode = .scaleAspectFit
                    //self.OutImage2.image = image2
                    //self.OutImage2.contentMode = .scaleAspectFit
                    //self.OutImage3.image = image3
                    //self.OutImage3.contentMode = .scaleAspectFit
                    //显示处理过的Image
                }
            }
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }
    
    
//    func viewForZooming(in scrollView:UIScrollView) -> UIView? {
//        //开启缩放功能
//        return self.imageView!
//    }
    
}
