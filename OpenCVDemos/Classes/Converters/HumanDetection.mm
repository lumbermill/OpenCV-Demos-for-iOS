//
//  HumanDetection.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/23.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "HumanDetection.h"

@implementation HumanDetection

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 人検出(HOG)

    // 中間画像の作成
    cv::Mat work_img;
    
    cv::cvtColor(src_img, work_img, CV_RGBA2RGB);
    cv::HOGDescriptor hog;
    hog.setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector());
    
    std::vector<cv::Rect> found;
    
    // 画像，検出結果，閾値（SVMのhyper-planeとの距離），
    // 探索窓の移動距離（Block移動距離の倍数），
    // 画像外にはみ出た対象を探すためのpadding，
    // 探索窓のスケール変化係数，グルーピング係数
    hog.detectMultiScale(work_img, found, self.gain*0.4, cv::Size(8,8), cv::Size(0,0), 1.05, 2);
    
    std::vector<cv::Rect>::const_iterator it = found.begin();
    std::cout << "found:" << found.size() << std::endl;

    // 検出結果（人）の描画
    for(; it!=found.end(); ++it) {
        cv::Rect r = *it;
        r.x += cvRound(r.width*0.1);
        r.width = cvRound(r.width*0.8);
        r.y += cvRound(r.height*0.07);
        r.height = cvRound(r.height*0.8);
        cv::rectangle(work_img, r.tl(), r.br(), cv::Scalar(0,255,0), 3);
    }
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n T1:%.2f",self.gain*0.4];
    
}

@end
