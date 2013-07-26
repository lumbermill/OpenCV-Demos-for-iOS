//
//  AVFUtils.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/26.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "AVFUtils.h"

@implementation AVFUtils

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    
    // イメージバッファの取得
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    // イメージバッファ情報の取得
    uint8_t*    base;
    size_t      width, height, bytesPerRow;
    base = (uint8_t*)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    // 画像の作成
    CGImageRef  cgImage;
    cgImage = CGBitmapContextCreateImage(cgContext);
    UIImage*  image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
 
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);

    return image;
}


// 本体の向きを取得し、AVFoundationに通知する値を選択する
+ (AVCaptureVideoOrientation)videoOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationFaceUp:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationFaceDown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}

@end
