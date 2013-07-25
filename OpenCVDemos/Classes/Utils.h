//
//  Utils.h
//
//  Created by Itou Yousei on 3/14/13.
//  Copyright (c) 2013 Itou Yousei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>

@interface Utils : NSObject

+ (cv::Mat)CVMatFromCGImage:(CGImageRef)image;
+ (CGImageRef)CGImageFromCVMat:(cv::Mat)cvMat;
+ (cv::Mat)CVMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (NSString*)convertByteToKB:(NSInteger)byte;

+ (unsigned int)getMemoryUsage;
+ (unsigned int)getFreeMemory;

@end