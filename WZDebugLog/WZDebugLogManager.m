//
//  WZDebugLogManager.m
//  WZDebugLogTest
//
//  Created by wangzz on 14-3-30.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import "WZDebugLogManager.h"
#import "SafeArc.h"

//应用程序程序包路径
#define PACKAGE_FILE_PATH(FILE_NAME) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FILE_NAME]

//日志文件路径,目前是tmp目录
#define LOGFILE_PATH    NSTemporaryDirectory()


@implementation WZDebugLogManager
@synthesize mLogLevel = _logLevel;
@synthesize mLogType = _logType;
@synthesize mCurrentLogFileName = _currentLogFileName;
@synthesize mCurrentLogFilePath = _currentLogFilePath;

//必须用单例模式
static WZDebugLogManager*  uniqueInstance = NULL;
+ (WZDebugLogManager *)getInstance
{
    if (NULL == uniqueInstance) {
        @synchronized([WZDebugLogManager class])
        {
            if (NULL == uniqueInstance) {
                uniqueInstance = [[self alloc]init];
            }
        }
    }
    return  uniqueInstance;
}

- (id)init
{
    if (self == [super init]) {
        _queue = [[NSMutableArray alloc] init];
        _signal = [[NSCondition alloc] init];
        [self configureInfo];
        [NSThread detachNewThreadSelector:@selector(threadProc) toTarget:self withObject:nil];
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE(_queue);
    SAFE_ARC_RELEASE(_signal);
    
    _currentLogFileName = nil;
    _currentLogFilePath = nil;
    
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)configureInfo
{
    NSString*   configFilePath = PACKAGE_FILE_PATH(@"configure.plist");//配置文件目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:configFilePath]) {
        NSLog(@"configure file does not exist!");
        return;
    }
    
    NSDictionary    *confDic = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    if (confDic == nil) {
        NSLog(@"read configure info failed.");
        return;
    }
    
    _logType = [[confDic objectForKey:@"logType" ] intValue];
    _logLevel = [[confDic objectForKey:@"logLevel" ] intValue];
    _maxFileSize = [[confDic objectForKey:@"maxFileSize" ] intValue];
    _currentLogFileName = [[confDic objectForKey:@"logFileName" ] copy];
    _currentLogFilePath = [[NSString stringWithFormat:@"%@%@",LOGFILE_PATH,_currentLogFileName] copy];
}

- (void)threadProc
{
    do
    {
        @autoreleasepool {
            for ( int i = 0; i < 1; i++ )
            {
                [ _signal lock ];
                while ( [ _queue count ] == 0 )
                {// NSMutableArray* _queue，其它线程将日志加入_queue，日志线程负责输出到文件和控制台
                    [ _signal wait ]; // NSCondition* _signal
                }
                NSArray* items = [ NSArray arrayWithArray: _queue ];
                [ _queue removeAllObjects ];
                [ _signal unlock ];
                if ( [ items count ] > 0 )
                    [ self logExport: items ]; // 输出日志
            }
            
            // 每20次输出日志执行一次NSAutoreleasePool的release
            // 保证既不太频繁也不太滞后
        }
    } while ( YES );
}

- (void)appendLogEntry:(NSDictionary *)entryDic
{
    [ _signal lock ];
    [ _queue addObject:entryDic];
    [ _signal signal ];
    [ _signal unlock ];
}

- (void)logExport:(NSArray *)logArray
{
    NSMutableString*   logString = [[NSMutableString alloc] init];
    SAFE_ARC_AUTORELEASE(logString);
    for (int i = 0; i < logArray.count; i++) {
        [logString appendFormat:@"%@\n",[logArray objectAtIndex:i]];
    }
    
    switch (_logType) {
        case WZDebugLogTypeNull://不打印日志
            break;
        case WZDebugLogTypeConsole://打印日志到控制台
            [self logToConsole:logString];
            break;
        case WZDebugLogTypeFile://打印文件到文件
            [self logToFile:logString];
            break;
        case WZDebugLogTypeConsoleAndFile://打印日志到控制台和文件
            [self logToConsole:logString];
            [self logToFile:logString];
            break;
        default:
            break;
    }
}

- (void)logToConsole:(NSString *)logString
{
    NSLog(@"%@",logString);
}

- (void)logToFile:(NSString *)logString
{
    const char* type;
    if ([self isLogFileOutOfSize]) {
        type = "w";//覆盖方式写
    }
    else {
        type = "a";//追加方式写
    }
    
    FILE * file = NULL;
    file = fopen([_currentLogFilePath UTF8String],type);
    if (nil == file) {
        return;
    }
    
    const char*   ch = [logString UTF8String];
    int writeResult = fputs(ch, file);
    if (writeResult == EOF) {
        NSLog(@"log write file failed.");
    }
    fclose(file);
    file = NULL;
}

//文件是否超过预定大小
- (BOOL)isLogFileOutOfSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_currentLogFilePath]) {
        return NO;
    }
    
    NSDictionary * attributes = [fileManager attributesOfItemAtPath:_currentLogFilePath error:nil];
    NSInteger  fileSize = [[attributes objectForKey:NSFileSize] intValue];//单位是字节(B)
    fileSize = fileSize/1024;//单位转化成KB
    if (fileSize < _maxFileSize) {
        return NO;
    }
    
    return YES;
}

- (BOOL)removeLogFile
{
    NSError*    err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:_currentLogFilePath error:&err];
    if (!result) {
        NSLog(@"log file delete failed.reason is :%@",err);
    }
    return result;
}

@end
