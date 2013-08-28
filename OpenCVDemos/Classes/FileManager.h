//
//  FileManager.h
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/08/26.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

/* tmp */
+ (NSString*)temporaryDirectory;

/* /tmp/fileName */
+ (NSString*)temporaryDirectoryWithFileName:(NSString*)fileName;

+ (void)createDirectory:(NSString*)path;

/* /Documents */
+ (NSString*)documentDirectory;

/* /Documents/fileName */
+ (NSString*)documentDirectoryWithFileName:(NSString*)fileName;

/* pathのファイルが存在しているか */
+ (BOOL)fileExistsAtPath:(NSString*)path;

/* pathのファイルがelapsedTimeを超えているか */
+ (BOOL)isElapsedFileModificationDateWithPath:(NSString*)path elapsedTimeInterval:(NSTimeInterval)elapsedTime;

/* directoryPath内のextension(拡張子)と一致する全てのファイル名 */
+ (NSArray*)fileNamesAtDirectoryPath:(NSString*)directoryPath extension:(NSString*)extension;

/* pathのファイルを削除 */
+ (BOOL)removeFilePath:(NSString*)path;


@end
