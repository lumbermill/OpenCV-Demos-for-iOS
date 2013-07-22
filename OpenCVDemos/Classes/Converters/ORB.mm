//
//  ORB.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "ORB.h"

@implementation ORB

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 特徴点検出(ORB)
    
    // 中間画像の作成
    cv::Mat work_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
    
    // 入力配列，出力配列，範囲の下界，範囲の上界，正規化の種類
    cv::normalize(work_img, work_img, 0, 255, cv::NORM_MINMAX);
    
    std::vector<cv::KeyPoint> keypoints;
    std::vector<cv::KeyPoint>::iterator itk;
    
    // ORB 検出器に基づく特徴点検出
    //n_features=300, params=default
    cv::OrbFeatureDetector detector(self.gain*600);
    // Detectorをスライダ値で可変
    
    // 特徴点の描画
    cv::Scalar color(255,0,255);
    detector.detect(work_img, keypoints);
    for(itk = keypoints.begin(); itk!=keypoints.end(); ++itk) {
        cv::circle(src_img, itk->pt, 3, color, -1);
        cv::circle(src_img, itk->pt, itk->size, color, 1, CV_AA);
    }
    
    return src_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Detector\n %.2f",self.gain*600];
    
}



@end
