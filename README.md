# WZLog
---
**WZLog**是一个用于iOS平台的日志系统，主要具有以下功能特性：

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

根据大部分的用户需要，目前总共划分了'WZLogLevelDebug'、'WZLogLevelInfo'、'WZLogLevelWarning'、'WZLogLevelError'四种级别的日志，它们的日志重要性等级依次递升。你可以根据项目的实际需要，在不同的位置使用不同等级的日志。

2.

3.

4.



###ARC支持
'WZLog'同时支持ARC和非ARC


###使用方式



###兼容性
本项目可用在'iOS4.3'及以上版本的系统中

###需要完善的地方
1.崩溃检测
目前崩溃检测类型有限，只能检测'EXC_BAD_ACCESS'和其它少数的几种类型的崩溃
2.崩溃日志输出
目前崩溃日志是写在文件中的，后续可以考虑保存在网络上

###遵守协议
'WZLog'遵循MTK协议，详情见'LICENSE'文件。