//
//  Utils.m
//
//  Created by Itou Yousei on 3/14/13.
//  Copyright (c) 2013 Itou Yousei. All rights reserved.
//

#import "Utils.h"
#import <mach/mach.h>

@implementation Utils

+ (cv::Mat)CVMatFromCGImage:(CGImageRef)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaPremultipliedLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (CGImageRef)CGImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info kCGImageAlphaNone
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return imageRef;
}


+ (cv::Mat)CVMatFromUIImage:(UIImage *)image
{
    return [Utils CVMatFromCGImage:image.CGImage];
}

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    CGImageRef imageRef = [Utils CGImageFromCVMat:cvMat];
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return finalImage;
}

// メモリの使用量
+ (unsigned int)getMemoryUsage {
    struct task_basic_info basicInfo;
    mach_msg_type_number_t basicInfoCount = TASK_BASIC_INFO_COUNT;
    
    if (task_info(current_task(), TASK_BASIC_INFO, (task_info_t)&basicInfo, &basicInfoCount) != KERN_SUCCESS) {
        NSLog(@"[SystemMonitor] %s", strerror(errno));
        return -1;
    }
    
    NSLog(@"MemoryUsed: %d",basicInfo.resident_size);
    return basicInfo.resident_size;
}

// メモリの空き容量
+ (unsigned int)getFreeMemory {
    mach_port_t hostPort;
    mach_msg_type_number_t hostSize;
    vm_size_t pagesize;
    
    hostPort = mach_host_self();
    hostSize = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(hostPort, &pagesize);
    vm_statistics_data_t vmStat;
    
    if (host_statistics(hostPort, HOST_VM_INFO, (host_info_t)&vmStat, &hostSize) != KERN_SUCCESS) {
        NSLog(@"[SystemMonitor] Failed to fetch vm statistics");
        return -1;
    }
    
    natural_t freeMemory = vmStat.free_count * pagesize;
    
    return (unsigned int)freeMemory;
}


// Byte -> KB
+ (NSString*)convertByteToKB:(NSInteger)byte {
    
    // NSNumberに変換 (単位:KB)
    NSNumber *number = [[NSNumber alloc] initWithInteger:byte / 1024];
    // 数値を3桁ごとカンマ区切りにするように設定
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    // 数値を3桁ごとカンマ区切り形式で文字列に変換する
    NSString *result = [[formatter stringFromNumber:number] stringByAppendingString:@" KB"];
    
    return result;
}

@end
