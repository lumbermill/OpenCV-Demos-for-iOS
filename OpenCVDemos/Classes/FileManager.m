//
//  FileManager.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/08/26.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (NSString*)temporaryDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString*)temporaryDirectoryWithFileName:(NSString*)fileName
{
    return [[self temporaryDirectory] stringByAppendingPathComponent:fileName];
}

+ (void)createDirectory:(NSString *)path
{
    // NSFileManagerを取得 (非スレッドセーフ)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // ディレクトリを作成
    [fileManager createDirectoryAtPath: path    // (NSString*) 作成したいディレクトリパス
           withIntermediateDirectories: YES     // (BOOL) 中間ディレクトリが存在しないときに作成するか否か
                            attributes: nil     // (NSDictionary*) ディレクトリの属性
                                 error: NULL];  // (NSError**) エラー
}

+ (NSString*)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    return [paths objectAtIndex:0];
}

+ (NSString*)documentDirectoryWithFileName:(NSString*)fileName
{
    return [[self documentDirectory] stringByAppendingPathComponent:fileName];
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    /* ファイルが存在するか */
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isElapsedFileModificationDateWithPath:(NSString*)path elapsedTimeInterval:(NSTimeInterval)elapsedTime
{
    if ([self fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary* dicFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
        /* 現在時間とファイルの最終更新日時との差を取得 */
        NSTimeInterval diff  = [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSinceDate:dicFileAttributes.fileModificationDate];
        if(elapsedTime < diff){
            /* ファイルの最終更新日時からelapseTime以上経っている */
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

+ (NSArray*)fileNamesAtDirectoryPath:(NSString*)directoryPath extension:(NSString*)extension
{
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSError *error = nil;
    /* 全てのファイル名 */
    NSArray *allFileName = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) return nil;
    NSMutableArray *hitFileNames = [[NSMutableArray alloc] init];
    for (NSString *fileName in allFileName) {
        /* 拡張子が一致するか */
        if ([[fileName pathExtension] isEqualToString:extension]) {
            [hitFileNames addObject:fileName];
        }
    }
    return hitFileNames;
}

+ (BOOL)removeFilePath:(NSString*)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    return [fileManager removeItemAtPath:path error:NULL];
}
@end
