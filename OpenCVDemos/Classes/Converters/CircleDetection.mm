//
//  CircleDetection.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/25.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "CircleDetection.h"

@implementation CircleDetection

- (cv::Mat)convert:(cv::Mat) src_img{
    
    //楕円フィッティング
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_BGR2GRAY);
    
    // Hough変換のための前処理（画像の平滑化を行なわないと誤検出が発生しやすい）
    cv::GaussianBlur(work_img, work_img, cv::Size(11,11), 2, 2);
    //cv::GaussianBlur(work_img, work_img, cv::Size(5,5), 2, 2);
    
    // Hough変換による円の検出と検出した円の描画
    std::vector<cv::Vec3f> circles;
    
    // 入力画像
    // 検出された円を出力するベクトル
    // メソッド
    // 画像分解能に対する投票分解能の比率の逆数．dp=1の場合,投票空間=入力画像  また dp=2の場合,投票空間の幅と高さ=半分
    // 検出される円の中心同士の最小距離
    // エッジ検出器に渡される閾値
    // 円の中心を検出する際の投票数の閾値
    // 円の半径の最小値
    // 円の半径の最大値
    cv::HoughCircles(work_img, circles, CV_HOUGH_GRADIENT, 1, self.gain*400, 20, 50, 10, 100);
    
    std::vector<cv::Vec3f>::iterator it = circles.begin();
    for(; it!=circles.end(); ++it) {
        cv::Point center(cv::saturate_cast<int>((*it)[0]), cv::saturate_cast<int>((*it)[1]));
        int radius = cv::saturate_cast<int>((*it)[2]);
        cv::circle(src_img, center, radius, cv::Scalar(255,0,0), 3);
    }

    return src_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Circle distance\n %.2f",self.gain*400];
    
}


@end
