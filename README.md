# WZLog

`WZLog`是一个用于iOS平台的日志系统，主要具有以下功能特性：

1.可以支持多种级别的日志打印：

```objective-c
typedef enum
{
    WZLogLevelDebug = 0,        //打印debug级别日志
    WZLogLevelInfo,             //打印info级别日志
    WZLogLevelWarning,          //打印warning级别日志
    WZLogLevelError             //打印error级别日志
}WZLogLevel;
```

目前共划分了`WZLogLevelDebug`、`WZLogLevelInfo`、
`WZLogLevelWarning`、`WZLogLevelError`四种级别的日志，它们的日志重要性等级依次递升。你可以根据项目的实际需要，在不同的位置使用不同等级的日志。

你可以通过下文要讲的配置文件灵活设定当前需要处理的日志级别。比如上述四种级别的日志你都打印了，但是你把需要处理的日志级别设定为`WZLogLevelWarning`,这样以后`WZLogLevelDebug`、`WZLogLevelInfo`两种级别的日志就不会再被处理。
这在实际调试过程中可以减少日志打印量，方便快速定位问题。

2.设定日志输出方式
日志输出方式有以下几种：
```objective-c
typedef enum
{
    WZLogTypeNull = 0,          //不打印日志
    WZLogTypeConsole,           //打印日志到控制台
    WZLogTypeFile,              //打印日志到文件
    WZLogTypeConsoleAndFile     //同时打印日志到文件和控制台
}WZLogType;
```
根据不同的调试需求，设定了四种日志输出方式：`WZLogTypeNull`、`WZLogTypeConsole`、`WZLogTypeFile`、`WZLogTypeConsoleAndFile`
分别表示:
* 不输出任何日志
这可以用于软件的release版本，减少因为log输出造成的系统性能损失；
* 输出日志到控制台
在日常调试过程中可以使用该模式，这和使用`NSLog`打印日志没有任何区别；
* 输出日志到文件
可以将日志输出到指定名称的文件中，文件名称可以在配置文件中设置，可用于打包软件给测试时，测试出现的bug可以通过该日志文件分析定位原因；
* 同时输出日志到日志文件和控制台
可以将日志文件同时输出到日志文件和控制台，可用于日常开发调试；

日志输出方式可以通过配置文件设置。

3.配置文件
配置文件在项目中的目录为`WZLog->configure.plist`。
这是一个plist文件，共有以下几个设置项：
* logType
-取值类型：int值
-取值范围：[0-3]
-作用：对应`WZLogType`定义，用于设置日志输出方式
-默认值：3，即同时输出日志到文件和控制台

* logLevel
取值类型：int值
取值范围：[0-3]
作用：对应`WZLogLevel`定义，用于设置日志输出级别
默认值：0，即可以输出全部四种级别的日志
* maxFileSize
取值类型：int值
取值范围：理论上无限制
作用：输出日志文件大小（以KB为单位)，用于设置log文件的最大值
默认值：10000，即日志文件最大约10MB
* logFileName
取值类型：string值
取值范围：理论上无限制
作用：用于设置输出日志文件名
默认值：`WZLog.txt`

4.崩溃监测
本日志系统能监测到`EXC_BAD_ACCESS`和其它少数的几种类型的崩溃，并同时输出崩溃堆栈到崩溃文件。这对崩溃原因定位的帮助极大。

5.日志输出格式
* 默认输出格式
默认的日志输出格式为：
```objective-c
[2014-03-31 17:48:04][Error][-[WZViewController onButtonAction:]]It is a debug log!
```
其含义依次为：[`当前时间`][`日志级别`][`日志所在方法`][`日志实际打印内容`]

* 其它输出格式
```objective-c
{
    FunctionName = "-[WZViewController onButtonAction:]";
    Level = Debug;
    Message = "It is a debug log.";
}
{
    FunctionName = "-[WZViewController onButtonAction:]";
    Level = Info;
    Message = "It is a info log.";
}
{
    FunctionName = "-[WZViewController onButtonAction:]";
    Level = Warning;
    Message = "It is a warn log!";
}
{
    FunctionName = "-[WZViewController onButtonAction:]";
    Level = Error;
    Message = "It is a debug log!";
}
```
如果想以第二种格式输出日志，可以定义宏：`#define WZLogStyleDic`

###ARC支持
`WZLog`同时支持`ARC`和`非ARC`


###系统要求
本项目可用在`iOS4.3`及以上版本的系统中

###CocoaPods
通过CocoaPods安装该项目，可以在你的`Podfile`文件中加入以下内容：
 ```
pod 'WZLog'
```

###日志系统使用前需要做的
1.将项目添加到你的工程中
可以通过`CocoaPods`或者直接将本仓库中的`WZLog`文件夹下的6个文件全部添加到你的工程中

2.头文件引入
在你工程的`.pch`文件中引入`WZLog.h`头文件

3.初始化日志系统
在软件启动的时候初始化日志系统，推荐初始化方式如下：
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化日志系统.
    initWZLog();

    return YES;
}
```
做完以上几步，你就可以在工程中使用本日志系统了。

###日志系统使用方式
1.日志打印
在工程中任何一个需要打印日志的地方，通过以下方式使用本日志系统打印日志：
```objective-c
- (void)onButtonAction:(id)sender
{
    WZLogDebug(@"It is a debug log.");
    WZLogInfo(@"It is a info log.");
    WZLogWarn(@"It is a warn log!");
    WZLogError(@"It is a debug log!");
}
```
2.切换日志输出格式
默认格式输出，则所有的日志信息会输出在一行，当定义了宏'#define WZLogStyleDic'时，将会以字典的形式输出。

###说明
1.log文件
* 默认名称:
`WZLog.txt`
* 默认输出路径：
软件沙盒的`tmp`目录下，比如`59E55879-58C3-4CD4-96AA-B1EBBC78A621/tmp/WZLog.txt`
* 最大大小：
为配置文件中的设定值，当超过该值时，会清除之前的日志文件，重新开始写

2.崩溃日志记录文件
* 文件名称:
`LastExceptionLog.txt`
* 输出路径：
软件沙盒的Documents目录下，比如：`59E55879-58C3-4CD4-96AA-B1EBBC78A621/Documents/LastExceptionLog.txt`
* 记录方式：
需要注意，崩溃日志文件只会记录最近的一条崩溃信息

###需要完善的地方
1.崩溃检测
目前崩溃检测类型有限，只能检测`EXC_BAD_ACCESS`和其它少数的几种类型的崩溃

2.崩溃日志输出
目前崩溃日志是写在文件中的，而且只能记录最近的一条日志，后续可以考虑记录多条崩溃日志，并且保存在网络上

###联系我
大家有好的想法可以通过[邮件]<wzzvictory_tjsd@163.com>或者[@新浪微博]<http://weibo.com/foogry>联系我。

###遵守协议
`WZLog`遵循`MTK`协议，详情见`LICENSE`文件。
