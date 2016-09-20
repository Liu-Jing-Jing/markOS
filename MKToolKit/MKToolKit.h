//
//  MKToolKit.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#ifndef Pure_Weibo_MKToolKit_h
#define Pure_Weibo_MKToolKit_h
#define kDeviceOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//获取设备的物理高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#include "MKBaseModel.h"
#include "MKHTTPTool.h"
#include "MKDateTools.h"
#include "UIViewExt.h"
#include "UIImageView+WebDownload.h"
#include "NSString+MKEncodeingAddtions.h"
#endif

