//
//  JMSkuSelectedViewConsts.h
//  ObjcSum
//
//  Created by yangyuan on 2016/12/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#ifndef JMSkuSelectedViewConsts_h
#define JMSkuSelectedViewConsts_h


//直接从RGB取颜色16进制(RGB 0xFF00FF)
#define ColorFromRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kSplitLineHeightFix(a)                     ((a) / ([UIScreen mainScreen].scale))

#define JMSkuSelectedViewSepratorColor ColorFromRGBHex(0xeeeeee)
#define JMSkuSelectedViewPaddingLeftRight (12.0)
#define JMSkuSelectedViewSkuItemSpacing (15.0)
#define JMSkuSelectedViewSkuLineSpacing (13.0)


typedef NS_ENUM(NSUInteger, JMSkuSectionType) {
    JMSkuSectionTypeAdditional,
    JMSkuSectionTypeSkuGroup,
    JMSkuSectionTypeNumSelected,
};



#endif /* JMSkuSelectedViewConsts_h */
