//
//  CutImage.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/08/27.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "CutImage.h"

@implementation CutImage

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // トリミング
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    cv::Mat roi_img;
    
    int axisX = 0;
    int axisY = 0;
    int width = work_img.cols * self.gain;
    int height = work_img.rows * self.gain2nd;
    cv::Rect rect(axisX,axisY,width,height);
    CGRect cgrect = CGRectMake(axisX,axisY,width,height);
    
    //roi_img = work_img(rect);
    
    UIImage *srcUIImg = [Utils UIImageFromCVMat:src_img];
    CGImageRef srcCGImg = CGImageCreateWithImageInRect(srcUIImg.CGImage, cgrect);
    UIImage *sliceImg = [UIImage imageWithCGImage:srcCGImg];
    CGImageRelease(srcCGImg);
    roi_img = [Utils CVMatFromUIImage:sliceImg];
    
    return roi_img;
}

- (NSString *)getGainFormat
{
    return [NSString stringWithFormat:@"Width: %.2f",self.gain];
    
}

- (NSString *)getGain2ndFormat
{
    return [NSString stringWithFormat:@"Height: %.2f",self.gain2nd];
    
}

@end
