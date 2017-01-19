//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "UIImage+Rotate.h"
#import "partition.hpp"


@implementation CVWrapper

+ (NSMutableArray*) processImageToPartition: (UIImage*) inputImage{
    //传入一张图片给partition,并调用partition
    
    cv::Mat matImage;   //旋转处理后的图片
    cv::Mat partitionMat;   //partition处理后的图片
    NSMutableArray * resultImages = [[NSMutableArray alloc]init];      //结果数组
    
    if ([inputImage isKindOfClass: [UIImage class]]) {
        /*
         All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
         */
        UIImage* rotatedImage = [inputImage rotateToImageOrientation];
        matImage = [rotatedImage CVMat3];
    }

    UIImage* result;
    std::vector<cv::Mat> Array = partNum(matImage);
    std::vector<cv::Mat>::iterator iter;
    for (iter=Array.begin();iter!=Array.end();iter++){
        //循环遍历partNum的返回数组，将其保存UIImage
        result = [UIImage imageWithCVMat:*iter];
        [resultImages addObject:result];
    }
    //对旋转后的图片进行分割
    
    return resultImages;
}

@end
