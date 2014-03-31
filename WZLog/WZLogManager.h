//
//  WZLogManager.h
//  WZLogTest
//
//  Created by wangzz on 14-3-30.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import <Foundation/Foundation.h>

//配置文件的名称（配置文件要放在程序沙盒的document目录下）
#define CONFIGURE_INFO_FILE_NAME     @"configure.plist"

//配置文件字段意义
/*
 logType:日志输出方式
 logLevel:日志输出级别
 maxFileSize:输出日志文件大小（以KB为单位)
 logFileName:输出日志文件名
 */

typedef enum
{
    WZLogLevelDebug = 0,
    WZLogLevelInfo,
    WZLogLevelWarning,
    WZLogLevelError
}WZLogLevel;

typedef enum
{
    WZLogTypeNull = 0,//不打印日志
    WZLogTypeConsole,//打印日志到控制台
    WZLogTypeFile,//打印日志到文件
    WZLogTypeConsoleAndFile//同时打印日志到文件和控制台
}WZLogType;

@interface WZLogManager : NSObject
{
    NSMutableArray*     _queue;
    NSCondition*        _signal;
    WZLogLevel         _logLevel;//日志打印级别
    WZLogType          _logType;//日志打印位置
    NSInteger           _maxFileSize;//日志文件最大值，以KB为单位
    NSString*           _currentLogFileName;//日志的保存文件
    NSString*           _currentLogFilePath;//日志的保存路径
}

@property(nonatomic,readonly)WZLogLevel         mLogLevel;
@property(nonatomic,readonly)WZLogType          mLogType;
@property(nonatomic,readonly)NSString*          mCurrentLogFileName;
@property(nonatomic,readonly)NSString*          mCurrentLogFilePath;

+ (WZLogManager *)getInstance;
- (void)appendLogEntry:(id)entry;
- (BOOL)removeLogFile;
@end
