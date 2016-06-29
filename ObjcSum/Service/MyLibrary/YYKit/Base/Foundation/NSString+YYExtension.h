//
//  NSString+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
/**
 提供hash,加密,编码等扩展方法
 Provide hash, encrypt, encode and some common method for 'NSString'.
 */
@interface NSString (YYExtension)

#pragma mark - Hash

///=============================================================================
/// @name Hash
///=============================================================================

/**
Returns a lowercase NSString for md2 hash.
*/
- (NSString *)yy_md2String;

/**
Returns a lowercase NSString for md4 hash.
 */
- (NSString *)yy_md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)yy_md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)yy_sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)yy_sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)yy_sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)yy_sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)yy_sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (NSString *)yy_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)yy_crc32String;

#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (NSString *)yy_base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64Encoding The encoded string.
 */
+ (NSString *)yy_stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)yy_stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)yy_stringByURLDecode;

/**
 Escape commmon HTML to Entity.
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)yy_stringByEscapingHTML;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @param font          The font to use for computing the string size.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)yy_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)yy_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)yy_heightForFont:(UIFont *)font width:(CGFloat)width;


#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/**
 Whether it can match the regular expression
 
 @param regex  The regular expression
 @param options     The matching options to report.
 @return YES if can match the regex; otherwise, NO.
 */
- (BOOL)yy_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 Match the regular expression, and executes a given block using each object in the matches.
 
 @param regex    The regular expression
 @param options  The matching options to report.
 @param block    The block to apply to elements in the array of matches.
 The block takes four arguments:
 match: The match substring.
 matchRange: The matching options.
 stop: A reference to a Boolean value. The block can set the value
 to YES to stop further processing of the array. The stop
 argument is an out-only argument. You should only ever set
 this Boolean to YES within the Block.
 */
- (void)yy_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;

/**
 Returns a new string containing matching regular expressions replaced with the template string.
 
 @param regex       The regular expression
 @param options     The matching options to report.
 @param replacement The substitution template used when replacing matching instances.
 
 @return A string with matching regular expressions replaced by the template string.
 */
- (NSString *)yy_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement;


#pragma mark - Emoji
///=============================================================================
/// @name Emoji
///=============================================================================

/**
 Whether the receiver contains Apple Emoji (displayed in current version of iOS).
 */
- (BOOL)yy_containsEmoji;

- (BOOL)yy_containsEmojiForSystemVersion:(float)systemVersion;

/**
 *  过滤掉emoji表情
 *
 *  @return 过滤后的string
 */
- (NSString *)yy_stringWithNoEmoji;

#pragma mark - Date

/**日期进行下面4种情况的转换
 *  今天：  19：00
 *  昨天：  昨天 19：00
 *  本周：  周二 19：00
 *  其他：  2014年4月3日 19：00
 */
+ (NSString *)yy_stringFromDate:(NSDate *)date;

/** 数字1~7转换为周日~周六,否则返回未知
 *  1:周日
 *  2:周一
 ...
 */
+ (NSString *)yy_stringFromWeekday:(NSInteger)weekday;

#pragma mark - NSString转换成二维坐标，格式@"123,456"

/**
 *  转换成合法的二维坐标，格式@"123,456"
 *
 *  @param sep 分隔符,比如上面是,
 *
 *  @return 无法转换或转换结果不合法则返回kCLLocationCoordinate2DInvalid
 */
- (CLLocationCoordinate2D)yy_coordinate2DFromSelfWithSep:(NSString *)sep;


#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

// Now you can use NSString as a NSNumber.
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)yy_stringWithUUID;

/**
 Returns a string containing the characters in a given UTF32Char.
 
 @param char32 A UTF-32 character.
 @return A new string, or nil if the character is invalid.
 */
+ (NSString *)yy_stringWithUTF32Char:(UTF32Char)char32;

/**
 Returns a string containing the characters in a given UTF32Char array.
 
 @param char32 An array of UTF-32 character.
 @param length The character count in array.
 @return A new string, or nil if an error occurs.
 */
+ (NSString *)yy_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;

/**
 Enumerates the unicode characters (UTF-32) in the specified range of the string.
 
 @param range The range within the string to enumerate substrings.
 @param block The block executed for the enumeration. The block takes four arguments:
 char32: The unicode character.
 range: The range in receiver. If the range.length is 1, the character is in BMP;
 otherwise (range.length is 2) the character is in none-BMP Plane and stored
 by a surrogate pair in the receiver.
 stop: A reference to a Boolean value that the block can use to stop the enumeration
 by setting *stop = YES; it should not touch *stop otherwise.
 */
- (void)yy_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)yy_stringByTrim;

/**
 *  截取字符串，防止表情字符被中间截断
 */
- (NSString *)yy_substringWithMaxLength:(NSInteger)maxLength;


/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)yy_stringByAppendingNameScale:(CGFloat)scale;

/**
 Add scale modifier to the file path (with path extension),
 From @"name.png" to @"name@2x.png".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)yy_stringByAppendingPathScale:(CGFloat)scale;

/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)yy_pathScale;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)yy_isNotBlank;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 
 @discussion Apple has implemented this method in iOS8.
 */
- (BOOL)yy_containsString:(NSString *)string;

/**
 Returns YES if the target CharacterSet is contained within the receiver.
 @param set  A character set to test the the receiver.
 */
- (BOOL)yy_containsCharacterSet:(NSCharacterSet *)set;

/**
 Try to parse this string and returns an `NSNumber`.
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)yy_numberValue;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)yy_dataValue;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)yy_rangeOfAll;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)yy_jsonValueDecoded;

/**
 Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 
 @param name The file name (in main bundle).
 
 @return A new string create from the file in UTF-8 character encoding.
 */
+ (NSString *)yy_stringNamed:(NSString *)name;

/**
 *  将url的请求参数转换成字典,没有的话返回nil
 */
- (NSDictionary *)yy_dictionaryFromUrlParameters;

/**
 *  将阿拉伯数字转换为中文数字
 */
+ (NSString *)yy_translationArabicNum:(NSInteger)arabicNum;

@end
