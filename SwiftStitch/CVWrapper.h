//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface CVWrapper : NSObject
//将图片数据从swift文件传入opencv的文件中


+ (NSArray*) processImageToPartition: (UIImage*) inputImage;

@end
NS_ASSUME_NONNULL_END
