//
//  BoxFilter.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "BoxFilter.h"

@implementation BoxFilter

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // ボックスフィルタを用いた平滑化（ぼかし）
    
    // 中間画像作成
    cv::Mat work_img = src_img;

    // 入力画像，出力画像，出力画像に求めるビット深度．カーネルサイズ，アンカー，正規化の有無
    cv::boxFilter(work_img, work_img, work_img.type(), cv::Size(2,2), cv::Point(-1,-1), false);

    return work_img;
}

@end
