//
//  Converter.m
//  OpenCVDemos
//
//  Created by 中村 将 on 2013/07/19.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Converter.h"

@implementation Converter

- (cv::Mat)convert:(cv::Mat) src_img{
    
//    NSLog(@"Convert");
    return src_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n %.2f",self.gain*255];
    
}

- (id)init
{
    self = [super init];
    return self;
}

@end
