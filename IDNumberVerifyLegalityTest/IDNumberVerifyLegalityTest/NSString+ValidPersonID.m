//
//  NSString+ValidPersonID.m
//  DDTest
//
//  Created by crystal on 16/2/17.
//  Copyright © 2016年 crystal. All rights reserved.
//

#import "NSString+ValidPersonID.h"

@implementation NSString (ValidPersonID)

- (BOOL)hyb_isValidPersonID
{
    return [NSString hyb_isValidPersonID:self];
}

/*
 *  功能：判断是否在地区码内
 *  参数：地区码
 */

+ (BOOL)_areaCode:(NSString *)sProvince
{
    // 省份代码 地区码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:sProvince]) {
            areaFlag =YES;
            break;
        }
    }
    return areaFlag;
}

/*
 *  功能：获取指定范围的字符串
 *  参数：字符串的开始小标
 *  参数：字符串的结束下标
 */

+ (NSString *)_subStringWithString:(NSString *)str begin:(NSInteger)begin end:(NSInteger)end
{
    return [str substringWithRange:NSMakeRange(begin, end)];
}

+ (BOOL)hyb_isValidPersonID:(NSString *)personId
{
    //判断位数
    if (personId.length != 15 && personId.length != 18)
    {
        return NO;
    }
    NSString *carid = personId;
    long lSumQT = 0;
    //加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    //校验码
    unsigned char checkers[11] = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *str = [NSMutableString stringWithString:personId];
    if (personId.length == 15)
    {
        [str insertString:@"19" atIndex:6];
        long p = 0;
        const char *personId = [str UTF8String];
        
        for (int i = 0; i <= 16; i ++)
        {
            p += (personId[i] - 48) * R[i];
        }
        
        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", checkers[o]];
        [str insertString:string_content atIndex:[str length]];
        carid = str;
    }
    
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    if (![self _areaCode:sProvince])
    {
        return NO;
    }
    
    //判断年月日是否有效
    //年份
    NSString *strYear = [self _subStringWithString:carid begin:6 end:4];
    //月份
    NSString *strMonth = [self _subStringWithString:carid begin:10 end:2];
    //日
    NSString *strDay = [self _subStringWithString:carid begin:12 end:2];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 12:00:00", strYear, strMonth, strDay]];
    
    if (date == nil)
    {
        return NO;
    }
    
    const char *pid = [carid UTF8String];
    //检验长度
    if (18 != strlen(pid))
    {
        return NO;
    }
    //校验数字
    for (int i = 0; i < 18; i ++)
    {
        if (!isdigit(pid[i]) && !(('X' == pid[i] || 'x' == pid[i]) && 17 == i))
        {
                return NO;
        }
    }
    
    //校验最末的校验码
    for (int i = 0; i <= 16; i ++)
    {
        lSumQT += (pid[i] - 48) * R[i];
    }
    
    if (checkers[lSumQT % 11] != pid[17])
    {
        return NO;
    }
    return YES;
}

@end
