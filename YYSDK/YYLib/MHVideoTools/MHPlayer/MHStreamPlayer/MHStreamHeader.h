//
//  MHStreamHeader.h
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/8.
//  Copyright © 2019 mh. All rights reserved.
//

#ifndef MHStreamHeader_h
#define MHStreamHeader_h

typedef enum{
    mhTextureFragModeNil,
    mhTextureFragModeCgImage = 1,
    mhTextureFragModePixelBuf = 2,
    mhTextureFragModeYuv = 3,
    mhTextureFragModeRgb = 4,
    mhTextureFragModeRgba = 5,
}mhTextureFragMode;//渲染数据源类型

// SDTV标准 BT.601 ，YUV转RGB变换矩阵
static const GLfloat kColorConversion601[] = {
    1.164,  1.164, 1.164,
    0.0, -0.392, 2.017,
    1.596, -0.813,   0.0,
};

// HDTV标准 BT.709，YUV转RGB变换矩阵
static const GLfloat kColorConversion709[] = {
    1.164,  1.164, 1.164,
    0.0, -0.213, 2.112,
    1.793, -0.533,   0.0,
};

// BT.601 全彩颜色转换矩阵
static const GLfloat kColorConversion601FullRange[] = {
    1.0,    1.0,   1.0,
    0.0, -0.343, 1.765,
    1.4, -0.711,   0.0,
};




#endif /* MHStreamHeader_h */
