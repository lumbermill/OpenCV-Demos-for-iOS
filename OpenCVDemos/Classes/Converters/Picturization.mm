//
//  Picturization.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/29.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Picturization.h"

@implementation Picturization

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 絵画風変換
    // （ほかと同じ構成にするため、遠回りな処理をしています）
    
    // 輪郭画像作成
    cv::Mat outline_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, outline_img, CV_RGB2GRAY);

    // 輪郭線はCannyで作成
    // 入力画像，出力画像，1番目の閾値，2番目の閾値
    cv::Canny(outline_img, outline_img, self.gain*255, self.gain2nd*255);
    // スライダ値によって引数を変更
    
    // 白黒反転
    outline_img = ~outline_img;
    
    // 白色の部分を透過する
    const float colorMasking[6] = {255, 255, 255, 255, 255, 255};
    CGImageRef lineCGImage = [Utils UIImageFromCVMat:outline_img].CGImage;
    lineCGImage = CGImageCreateWithMaskingColors(lineCGImage, colorMasking);
    UIImage *lineImage  = [UIImage imageWithCGImage:lineCGImage];
    CGImageRelease(lineCGImage);
    
    
    // 背景画像作成
    cv::Mat back_img;
    
    // ベース画像をMedianBlurで絵の具風にぼかす
    // 入力画像，出力画像，カーネルサイズ
    cv::medianBlur(src_img, back_img, 9);
    UIImage *backImage = [Utils UIImageFromCVMat:back_img];

    // 合成画像
    UIImage *mergeImage;
    CGRect imageRect = CGRectMake(0, 0, lineImage.size.width, lineImage.size.height);
    
    // オフスクリーン描画のためのグラフィックスコンテキストを用意
    UIGraphicsBeginImageContext(imageRect.size);
    // 背景画像をコンテキストに描画
    [backImage drawInRect:imageRect];
    // 輪郭画像をコンテキストに描画
    [lineImage drawInRect:imageRect];
    // 合成画像をコンテキストから取得
    mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    // オフスクリーン描画を終了
    UIGraphicsEndImageContext();
    
    cv::Mat mergeMat = [Utils CVMatFromUIImage:mergeImage];

    
    return mergeMat;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n T1:%.2f",self.gain*255];
    
}
- (NSString *)getGain2ndFormat{
    return [NSString stringWithFormat:@"Threshold\n T2:%.2f",self.gain2nd*255];
    
}


@end
