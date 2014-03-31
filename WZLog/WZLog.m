//
//  WZLog.m
//  WZLogTest
//
//  Created by wangzz on 14-3-30.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import "WZLog.h"
#import "SafeArc.h"


static WZLogManager*   mLogManager = NULL;//单例的日志文件管理器
static void handleRootException( NSException* exception );//系统崩溃回调函数

/**
 *  初始化日志打印系统，必须调用的方法
 */
void initWZLog()
{
    mLogManager = [WZLogManager getInstance];
    NSSetUncaughtExceptionHandler(handleRootException);//指定系统崩溃时回调
}

/**
 *  删除日志文件
 */
void removeLogFile()
{
    [mLogManager removeLogFile];
}

/**
 *  将日志信息写到文件中
 *
 *  @param function 记录日志所在的函数名称
 *  @param level    日志级别，Debug、Info、Warn、Error
 *  @param format   日志内容，格式化字符串
 *  @param ...      格式化字符串的参数
 */
void writeWZLog( const char* function,        // 记录日志所在的函数名称
                 WZLogLevel level,            // 日志级别，Debug、Info、Warn、Error
                 NSString* format,            // 日志内容，格式化字符串
                 ... )                        // 格式化字符串的参数
{
    if ( mLogManager.mLogLevel > level || !format ) // 先检查当前程序设置的日志输出级别。如果这条日志不需要输出，就不用做字符串格式化
    {
        return;
    }
    va_list args;
    va_start( args, format );
    NSString* str = [ [ NSString alloc ] initWithFormat: format arguments: args ];
    va_end( args );
    //    NSThread* currentThread = [ NSThread currentThread ];
    NSString* functionName = [ NSString stringWithUTF8String: function ];
    if ( ! functionName )
        functionName = @"";
    if ( ! str )
        str = @"";
    
    NSString    *levelString = @"";
    if (level == WZLogLevelDebug) {
        levelString = @"Debug";
    }else if (level == WZLogLevelInfo){
        levelString = @"Info";
    }else if (level == WZLogLevelWarning){
        levelString = @"Warning";
    }else if (level == WZLogLevelError){
        levelString = @"Error";
    }
    
#ifndef WZLogStyleDic
    NSDate* date = [NSDate date];
    NSDateFormatter*    dateFormatter = [[NSDateFormatter alloc] init];
    SAFE_ARC_AUTORELEASE(dateFormatter);
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*   dateString = [dateFormatter stringFromDate:date];
    NSString    *entry = [[NSString alloc] initWithFormat:@"[%@][%@][%@]%@",dateString,levelString,functionName,str];
#else
    // NSDictionary中加入所有需要记录到日志中的信息
    NSDictionary* entry = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                           str, @"Message",  // 日志内容
                           //                           dateString, @"Date", // 日志生成时间
                           levelString, @"Level", // 本条日志级别
                           //                           currentThread, @"currentThread", // 本条日志所在的线程名称
                           functionName, @"FunctionName", // 本条日志所在的函数名称
                           nil ];
#endif
    
    [ mLogManager appendLogEntry:entry];
    SAFE_ARC_RELEASE(entry);
    SAFE_ARC_RELEASE(str);
}

static void handleRootException( NSException* exception )
{
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; // 将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    NSString*   errorInfo = [NSString stringWithFormat:@"[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]", name, reason, strSymbols];
    
    // 写日志，级别为ERROR
    writeWZLog( __FUNCTION__, WZLogLevelError, errorInfo);
    SAFE_ARC_RELEASE(strSymbols);
    
    // 写一个文件，记录此时此刻发生了异常
    NSDictionary* dict = [ NSDictionary dictionaryWithObjectsAndKeys:
                          mLogManager.mCurrentLogFileName, @"LogFile",                // 当前日志文件名称
                          mLogManager.mCurrentLogFilePath, @"LogFileFullPath",    // 当前日志文件全路径
                          [ NSDate date ], @"TimeStamp",                        // 异常发生的时刻
                          nil ];
    NSString* path = [ NSString stringWithFormat: @"%@/Documents/", NSHomeDirectory() ];
    NSString* lastExceptionLog = [ NSString stringWithFormat: @"%@LastExceptionLog.txt", path ];
    [ dict writeToFile: lastExceptionLog atomically: YES ];
}

