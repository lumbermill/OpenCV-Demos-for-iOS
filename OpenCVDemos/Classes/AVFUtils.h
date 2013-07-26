//
//  AVFUtils.h
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/26.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVFUtils : NSObject

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

+ (AVCaptureVideoOrientation)videoOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

@end
