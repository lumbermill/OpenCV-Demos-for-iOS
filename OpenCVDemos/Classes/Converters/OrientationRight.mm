//
//  OrientationRight.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/26.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "OrientationRight.h"

@implementation OrientationRight

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 中間画像作成
    // サイズを縦横変換します
    cv::Mat work_img(src_img.cols, src_img.rows, src_img.type());
    
    // 回転： -90 [deg], スケーリング： 1.0 [倍]
    float angle = -90;
    float rotateScale = 1.0;
    // 中心：画像中心
    cv::Point2f center(work_img.cols*0.5, work_img.cols*0.5);
    // 以上の条件から2次元の回転行列を計算
    const cv::Mat affine_matrix = cv::getRotationMatrix2D( center, angle, rotateScale );
    cv::warpAffine(src_img, work_img, affine_matrix, work_img.size());
    
    return work_img;
}


@end
