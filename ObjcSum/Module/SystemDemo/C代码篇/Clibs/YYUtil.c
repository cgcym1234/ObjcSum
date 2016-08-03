//
//  YYUtil.c
//  MySimpleFrame
//
//  Created by sihuan on 15/3/26.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYUtil.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>
#include <math.h>
#include <unistd.h>
#include <sys/time.h>
#include <float.h>
#include <stdint.h>
#include <errno.h>


/* 内存大小转化为单位为字节大小的数值表示 */
/*"1Gi" will return 1073741824 that is(1024*1024*1024)*/
long long yyUtilMem2ll(const char *p, int *err) {
    const char *u;
    char buf[128];
    long mul; /* unit multiplier */
    long long val;
    unsigned int digits;
    
    if (err) *err = 0;
    /* Search the first non digit character. */
    u = p;
    if (*u == '-') u++;
    while(*u && isdigit(*u)) u++;
    //根据大小的单位做大小的转换
    if (*u == '\0' || !strcasecmp(u,"b")) {
        mul = 1;
    } else if (!strcasecmp(u,"k")) {
        mul = 1000;
    } else if (!strcasecmp(u,"kb")) {
        mul = 1024;
    } else if (!strcasecmp(u,"m")) {
        mul = 1000*1000;
    } else if (!strcasecmp(u,"mb")) {
        mul = 1024*1024;
    } else if (!strcasecmp(u,"g")) {
        mul = 1000L*1000*1000;
    } else if (!strcasecmp(u,"gb")) {
        mul = 1024L*1024*1024;
    } else {
        if (err) *err = 1;
        mul = 1;
    }
    digits = u-p;
    if (digits >= sizeof(buf)) {
        if (err) *err = 1;
        return LLONG_MAX;
    }
    memcpy(buf,p,digits);
    buf[digits] = '\0';
    val = strtoll(buf,NULL,10);
    return val*mul;
}

/* Return the number of digits of 'v' when converted to string in radix 10.
 * See ll2string() for more information. */
/* 返回一个数的位数有几位 */
uint32_t digits10(uint64_t v) {
    if (v < 10) return 1;
    if (v < 100) return 2;
    if (v < 1000) return 3;
    if (v < 1000000000000UL) {
        if (v < 100000000UL) {
            if (v < 1000000) {
                if (v < 10000) return 4;
                return 5 + (v >= 100000);
            }
            return 7 + (v >= 10000000UL);
        }
        if (v < 10000000000UL) {
            return 9 + (v >= 1000000000UL);
        }
        return 11 + (v >= 100000000000UL);
    }
    return 12 + digits10(v / 1000000000000UL);
}

/* Like digits10() but for signed values. */
uint32_t sdigits10(int64_t v) {
    if (v < 0) {
        /* Abs value of LLONG_MIN requires special handling. */
        uint64_t uv = (v != LLONG_MIN) ?
        (uint64_t)-v : ((uint64_t) LLONG_MAX)+1;
        return digits10(uv)+1; /* +1 for the minus. */
    } else {
        return digits10(v);
    }
}

/* long long类型转化为string类型 */
int yyUtilLL2string(char* dst, size_t dstlen, long long svalue) {
    static const char digits[201] =
    "0001020304050607080910111213141516171819"
    "2021222324252627282930313233343536373839"
    "4041424344454647484950515253545556575859"
    "6061626364656667686970717273747576777879"
    "8081828384858687888990919293949596979899";
    int negative;
    unsigned long long value;
    
    /* The main loop works with 64bit unsigned integers for simplicity, so
     * we convert the number here and remember if it is negative. */
    /* 在这里做正负号的判断处理 */
    if (svalue < 0) {
        if (svalue != LLONG_MIN) {
            value = -svalue;
        } else {
            value = ((unsigned long long) LLONG_MAX)+1;
        }
        negative = 1;
    } else {
        value = svalue;
        negative = 0;
    }
    
    /* Check length. */
    uint32_t const length = digits10(value)+negative;
    if (length >= dstlen) return 0;
    
    /* Null term. */
    uint32_t next = length;
    dst[next] = '\0';
    next--;
    while (value >= 100) {
        //做值的换算
        int const i = (value % 100) * 2;
        value /= 100;
        //i所代表的余数值用digits字符数组中的对应数字代替了
        dst[next] = digits[i + 1];
        dst[next - 1] = digits[i];
        next -= 2;
    }
    
    /* Handle last 1-2 digits. */
    if (value < 10) {
        dst[next] = '0' + (uint32_t) value;
    } else {
        int i = (uint32_t) value * 2;
        dst[next] = digits[i + 1];
        dst[next - 1] = digits[i];
    }
    
    /* Add sign. */
    if (negative) dst[0] = '-';
    return length;
}

/* String类型转换为long long类型 */
int yyUtilString2ll(const char *s, size_t slen, long long *value) {
    const char *p = s;
    size_t plen = 0;
    int negative = 0;
    unsigned long long v;
    
    if (plen == slen)
        return 0;
    
    /* Special case: first and only digit is 0. */
    if (slen == 1 && p[0] == '0') {
        if (value != NULL) *value = 0;
        return 1;
    }
    
    if (p[0] == '-') {
        negative = 1;
        p++; plen++;
        
        /* Abort on only a negative sign. */
        if (plen == slen)
            return 0;
    }
    
    /* First digit should be 1-9, otherwise the string should just be 0. */
    if (p[0] >= '1' && p[0] <= '9') {
        v = p[0]-'0';
        p++; plen++;
    } else if (p[0] == '0' && slen == 1) {
        *value = 0;
        return 1;
    } else {
        return 0;
    }
    
    while (plen < slen && p[0] >= '0' && p[0] <= '9') {
        //用的方法就是平常的方法，取余数复杂法
        if (v > (ULLONG_MAX / 10)) /* Overflow. */
            return 0;
        v *= 10;
        
        if (v > (ULLONG_MAX - (p[0]-'0'))) /* Overflow. */
            return 0;
        v += p[0]-'0';
        
        p++; plen++;
    }
    
    /* Return if not all bytes were used. */
    if (plen < slen)
        return 0;
    
    if (negative) {
        if (v > ((unsigned long long)(-(LLONG_MIN+1))+1)) /* Overflow. */
            return 0;
        if (value != NULL) *value = -v;
    } else {
        if (v > LLONG_MAX) /* Overflow. */
            return 0;
        if (value != NULL) *value = v;
    }
    return 1;
}

/* String类型转换为long类型，核心调用的方法还是string2ll()方法 */
int yyUtilString2l(const char *s, size_t slen, long *lval) {
    long long llval;
    
    if (!yyUtilString2ll(s,slen,&llval))
        return 0;
    
    //判断是否在Long类型的返回，不是直接返回0
    if (llval < LONG_MIN || llval > LONG_MAX)
        return 0;
    
    *lval = (long)llval;
    return 1;
}

/* double类型转化为String类型 */
int yyUtilD2string(char *buf, size_t len, double value) {
    if (isnan(value)) {
        len = snprintf(buf,len,"nan");
    } else if (isinf(value)) {
        if (value < 0)
            len = snprintf(buf,len,"-inf");
        else
            len = snprintf(buf,len,"inf");
    } else if (value == 0) {
        /* See: http://en.wikipedia.org/wiki/Signed_zero, "Comparisons". */
        if (1.0/value < 0)
            len = snprintf(buf,len,"-0");
        else
            len = snprintf(buf,len,"0");
    } else {
#if (DBL_MANT_DIG >= 52) && (LLONG_MAX == 0x7fffffffffffffffLL)
        /* Check if the float is in a safe range to be casted into a
         * long long. We are assuming that long long is 64 bit here.
         * Also we are assuming that there are no implementations around where
         * double has precision < 52 bit.
         *
         * Under this assumptions we test if a double is inside an interval
         * where casting to long long is safe. Then using two castings we
         * make sure the decimal part is zero. If all this is true we use
         * integer printing function that is much faster. */
        double min = -4503599627370495; /* (2^52)-1 */
        double max = 4503599627370496; /* -(2^52) */
        //调用的同样是ll2string的方法
        if (value > min && value < max && value == ((double)((long long)value)))
            len = yyUtilString2ll(buf,len,(long long)value);
        else
#endif
            len = snprintf(buf,len,"%.17g",value);
    }
    
    return len;
}

/* 获取输入文件名的绝对路径 */
char *yyUtilGetAbsolutePath(char *filename);

/* 判断一个路径是否就是纯粹的文件名，不是相对路径或是绝对路径 */
int yyUtilPathIsBaseName(char *path) {
    return strchr(path,'/') == NULL && strchr(path,'\\') == NULL;
}


















