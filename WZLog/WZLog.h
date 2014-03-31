//
//  WZLog.h
//  WZLogTest
//
//  Created by wangzz on 14-3-30.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZLogManager.h"


#ifdef __OBJC__

/**
 *  不定义该宏，每条日志会以每条一行的形式打印或写入文件
 *  定义该宏，每条日志会以字典的形式打印或写入文件
 */
//#define WZLogStyleDic


/**
 *  定义该宏，打开日志系统
 *  不定义该宏，将使用正常的NSLog打印日志
 */
#define OPEN_WZDEBUG_LOG



#ifdef  OPEN_WZDEBUG_LOG

/**
 *  打印debug级别的日志
 */
#define WZLogDebug(format,...)       writeWZLog(__FUNCTION__,WZLogLevelDebug,format,##__VA_ARGS__)

/**
 *  打印info级别的日志
 */
#define WZLogInfo(format,...)        writeWZLog(__FUNCTION__,WZLogLevelInfo,format,##__VA_ARGS__)

/**
 *  打印warn级别的日志
 */
#define WZLogWarn(format,...)        writeWZLog(__FUNCTION__,WZLogLevelWarning,format,##__VA_ARGS__)

/**
 *  打印error级别的日志
 */
#define WZLogError(format,...)       writeWZLog(__FUNCTION__,WZLogLevelError,format,##__VA_ARGS__)
#else
#define WZLogDebug(format,...)      NSLog(format, ##__VA_ARGS__)
#define WZLogInfo(format,...)       NSLog(format, ##__VA_ARGS__)
#define WZLogWarn(format,...)       NSLog(format, ##__VA_ARGS__)
#define WZLogError(format,...)      NSLog(format, ##__VA_ARGS__)
#endif


/**
 *  日志文件删除
 */
#define WZLogFileRemove()              removeLogFile()


/**
 *  初始化日志打印系统，必须在初始化log系统的时候调用
 */
void initWZLog();

/**
 *  删除日志文件
 */
void removeLogFile();


/**
 *  将日志信息写到文件中
 *
 *  @param function 记录日志所在的函数名称
 *  @param level    日志级别，Debug、Info、Warn、Error
 *  @param format   日志内容，格式化字符串
 *  @param ...      格式化字符串的参数
 */
void writeWZLog( const char* function, WZLogLevel level, NSString* format, ... );


#endif