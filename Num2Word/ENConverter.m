//
//  ENConverter.m
//  English Number
//
//  Created by Ning Ke on 9/18/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import "ENConverter.h"

@implementation ENConverter

static NSString *zero = @"zero";
static NSArray *singles;
static NSArray *teens;
static NSArray *tens;
static NSDictionary *order_shortscale;
static unsigned int order_shortscale_max;
static NSDictionary *order_longscale;
static unsigned int order_longscale_max;
static NSString *BritishSeparator = @" and ";
static NSString *AmericanSeparator = @" ";

+ (void)initialize {
    singles = [NSArray arrayWithObjects: @"zero", @"one", @"two", @"three",
               @"four", @"five", @"six", @"seven", @"eight", @"nine", nil];
    
    teens = [NSArray arrayWithObjects: @"ten", @"eleven", @"twelve", @"thirteen",
             @"fourteen", @"fifteen", @"sixteen", @"seventeen", @"eighteen", @"nineteen", nil];
    
    tens = [NSArray arrayWithObjects: @"twenty", @"thirty", @"forty", @"fifty",
            @"sixty", @"seventy", @"eighty", @"ninety", nil];
    
    order_shortscale = [NSDictionary dictionaryWithObjectsAndKeys:
             @"", [NSNumber numberWithInt:0],
             @"ten", [NSNumber numberWithInt:1],
             @"hundred", [NSNumber numberWithInt:2],
             @"thousand", [NSNumber numberWithInt:3],
             @"million", [NSNumber numberWithInt:6],
             @"billion", [NSNumber numberWithInt:9],
             @"trillion", [NSNumber numberWithInt:12],
             @"quadrillion", [NSNumber numberWithInt:15],
             @"quintillion", [NSNumber numberWithInt:18],
             @"sextillion", [NSNumber numberWithInt:21],
             @"septillion", [NSNumber numberWithInt:24],
             @"octillion", [NSNumber numberWithInt:27],
             @"nonillion", [NSNumber numberWithInt:30],
             @"decillion", [NSNumber numberWithInt:33],
             nil];
    order_shortscale_max = 33;

    order_longscale = [NSDictionary dictionaryWithObjectsAndKeys:
             @"", [NSNumber numberWithInt:0],
             @"ten", [NSNumber numberWithInt:1],
             @"hundred", [NSNumber numberWithInt:2],
             @"thousand", [NSNumber numberWithInt:3],
             @"million", [NSNumber numberWithInt:6],
             @"billion", [NSNumber numberWithInt:12],
             @"trillion", [NSNumber numberWithInt:18],
             @"quadrillion", [NSNumber numberWithInt:24],
             @"quintillion", [NSNumber numberWithInt:30],
             @"sextillion", [NSNumber numberWithInt:36],
             @"septillion", [NSNumber numberWithInt:42],
             @"octillion", [NSNumber numberWithInt:48],
             @"nonillion", [NSNumber numberWithInt:54],
             @"decillion", [NSNumber numberWithInt:60],
             nil];
    order_longscale_max = 60;
}

+ (BOOL)defaultUseLongScale {
    return FALSE;
}

+ (NSString *)unitNameFromOrder:(unsigned int)order LongScale:(BOOL)longScale {
    NSDictionary *dict;
    
    if (longScale) {
        dict = order_longscale;
    } else {
        dict = order_shortscale;
    }
    
    return [dict objectForKey:[NSNumber numberWithInt:order]];
}

+ (NSString *)getUnitStringFromValue:(float)value LongScale:(BOOL)longScale
{
    int idx;
    int cnt;
    NSDictionary *dict;
    NSArray *keys;
    NSNumber *k;

    if (longScale) {
        dict = order_longscale;
    } else {
        dict = order_shortscale;
    }
    cnt = [dict count];
    keys = [[dict allKeys] sortedArrayUsingComparator:^(NSNumber *a, NSNumber *b) {return [a compare:b];}];

    int start = 3; // start from thousand
    int length = cnt - start - 1;
    idx = length * value + start;
    k = [keys objectAtIndex:idx];
    //printf("slider value %f longScale %d => Idx %d Key %d\n", value, longScale, idx, [k integerValue]);
    return [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:k]];
}

+ (float)getOrderValue:(NSString *)ord LongScale:(BOOL)longScale
{
    int idx = -1;
    int cnt;
    NSDictionary *dict;
    NSArray *keys;
    float res;

    if (longScale) {
        dict = order_longscale;
    } else {
        dict = order_shortscale;
    }
    cnt = [dict count];
    keys = [[dict allKeys] sortedArrayUsingComparator:^(NSNumber *a, NSNumber *b) {return [a compare:b];}];

    int start = 3; // start from thousand
    int length = cnt - start - 1;
    // find out the idx of ord in keys array
    for (int i = 0; i < cnt; i++) {
        if ([ord caseInsensitiveCompare:[dict objectForKey:[keys objectAtIndex:i]]] == NSOrderedSame) {
            idx = i;
            break;
        }
    }
    if (idx == -1 || idx < start) {
        printf("%s: Bad ord %s\n", __func__, [ord cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        return 0; // Use minimum
    }
    // Use a middle value (a float between idx and idx + 1)
    float mid = idx + 0.5f;
    res = (mid - (float)start) / length;
    //printf("%s: ord %s idx %d value %f\n", __func__, [ord cStringUsingEncoding:[NSString defaultCStringEncoding]], idx, res);
    return res;
}

- (NSString *)threeDigitRepWithOnes:(unsigned int)ones tens:(unsigned int)tns hundreds:(unsigned int)hds {
    NSString *hdsRep = @"";
    NSString *tnsRep = @"";
    NSString *onesRep = @"";
    NSString *sep = AmericanSeparator;
    NSString *hyphen = @"-";

    if (hds == 0 && tns == 0 && ones == 0) {
        return zero;
    }

    if (hds) {
        hdsRep = [[NSString alloc] initWithFormat: @"%@ %@",
                  [singles objectAtIndex:hds],
                  [self.order objectForKey:[NSNumber numberWithInt:2]]];
    }
    
    if (tns == 1) {
        tnsRep = [[NSString alloc] initWithFormat:@"%@",
                   [teens objectAtIndex:ones]];
        if ([hdsRep length]) {
            return [[NSString alloc] initWithFormat:@"%@%@%@",
                hdsRep, sep, tnsRep];
        } else {
            return tnsRep;
        }
    } else if (tns > 1) {
        tnsRep = [tens objectAtIndex:(tns - 2)];
    }

    if (ones) {
        onesRep = [singles objectAtIndex:ones];
    }
    if (tns && ones) {
        tnsRep = [[NSString alloc] initWithFormat:@"%@%@%@",
                   tnsRep, hyphen, onesRep];
    } else if (tns) {
        tnsRep = tnsRep;
    } else {
        tnsRep = onesRep;
    }

    if ([hdsRep length] && [tnsRep length]) {
        return [[NSString alloc] initWithFormat:@"%@%@%@",
                hdsRep, sep, tnsRep];
    } else if ([hdsRep length]) {
        return hdsRep;
    } else if ([tnsRep length]) {
        return tnsRep;
    } else {
        return @"";
    }
}

// Pops 3 elements from the tail of a NSString str
// Returns a new array of two elements: [(NSArray *)array-of-last-3-digits-in-reverse, (NSString *)rest-of-str]
// For example: when str is "12345" then it returns [[5, 4, 3], "12"]
// when str is "12" then it returns [[2, 1, 0], ""]
+ (NSArray *)pop3:(NSString *)str {
    NSNumber *nszero = [NSNumber numberWithInt:0];
    unsigned len = [str length];
    
    if (len == 0) {
        return [NSArray arrayWithObjects:
                [NSArray arrayWithObjects: nszero, nszero, nszero, nil],
                @"",
                nil];
    } else if (len == 1) {
        return [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:
                 [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(0, 1)]],
                 nszero, nszero, nil],
                @"",
                nil];
    } else if (len == 2) {
        return [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:
                 [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(1, 1)]],
                 [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(0, 1)]],
                 nszero, nil],
                @"",
                nil];
    }

    // arr has at least 3 elements
    return [NSArray arrayWithObjects:
            [NSArray arrayWithObjects:
             [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(len - 1, 1)]],
             [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(len - 2, 1)]],
             [NSDecimalNumber decimalNumberWithString:[str substringWithRange:NSMakeRange(len - 3, 1)]],
             nil],
            [str substringToIndex:(len - 3)],
            nil];
}

- (NSString *)segment:(NSString *)digits {
    NSString *res = @"";
    int idx = 0;

    while ([digits length]) {
        NSNumber *o, *t, *h;
        NSArray *pop3res;
        NSArray *trio;
        NSString *seg;

        pop3res = [ENConverter pop3:digits];
        trio = [pop3res objectAtIndex:0];
        o = [trio objectAtIndex:0];
        t = [trio objectAtIndex:1];
        h = [trio objectAtIndex:2];
        seg = [self threeDigitRepWithOnes:[o unsignedIntValue] tens:[t unsignedIntValue] hundreds:[h unsignedIntValue]];
        if (idx > 0) {
            if ([res compare:zero] == NSOrderedSame) {
                res = @"";
            }
            if ([seg compare:zero] != NSOrderedSame) {
                NSString *curOrder = [self.order objectForKey:[NSNumber numberWithInt:idx]];
                bool newline = true;
                if (!curOrder) {
                    // This happens in long scale where the order jumps by 6 after million.
                    assert(idx % 3 == 0);
                    curOrder = @"thousand";
                    newline = false;
                }
                seg = [[NSString alloc] initWithFormat:@"%@ %@", seg, curOrder];
                if ([res compare:@""] == NSOrderedSame) {
                    res = seg;
                } else {
                    NSString *sep = newline ? @"\n" : @" ";
                    res = [[NSString alloc] initWithFormat:@"%@%@%@", seg, sep, res];
                }
            }
        } else {
            res = seg;
        }
        digits = [pop3res objectAtIndex:1];
        //printf("((%d %d %d), %s))\n", [o intValue], [t intValue], [h intValue], [digits cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        idx += 3;
    }
    
    if ([res length]) {
        res = [NSString stringWithFormat:@"%@%@", [[res substringToIndex:1] uppercaseString], [res substringFromIndex:1]];
    }
    return res;
}

- (NSString *)macroSegment:(NSString *)digits {
    NSString *orderName = [self.order objectForKey:[NSNumber numberWithUnsignedInt:orderMax]];
    NSString *curOrder = @"";
    unsigned len, newlen;
    NSString *res = @"";
    NSString *curname, *curdigits;

    do {
        len = [digits length];
        if (len <= orderMax) {
            newlen = 0;
        } else {
            newlen = len - orderMax;
        }
        curdigits = [digits substringFromIndex:newlen];
        curname = [self segment:curdigits];
        //printf("curname<%s> res<%s> curOrder<%s>\n", [curname cStringUsingEncoding:[NSString defaultCStringEncoding]], [res cStringUsingEncoding:[NSString defaultCStringEncoding]], [curOrder cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        if ([res compare:zero] == NSOrderedSame) {
            res = @"";
        }
        if ([curname compare:zero] != NSOrderedSame) {
            if ([res compare:@""] == NSOrderedSame) {
                res = [[NSString alloc] initWithFormat:@"%@ %@", curname, curOrder];
            } else {
                res = [[NSString alloc] initWithFormat:@"%@ %@\n%@", curname, curOrder, res];
            }
        }
        if ([curOrder compare:@""] == NSOrderedSame) {
            curOrder = orderName;
        } else {
            curOrder = [[NSString alloc] initWithFormat:@"%@ %@", orderName, curOrder];
        }
        digits = [digits substringToIndex:newlen];
    } while (newlen);
    
    return res;
}

@synthesize number;
@synthesize order;
@synthesize orderMax;

- (ENConverter *)initWithString:(NSString *)num Longscale:(BOOL)uselong LargestUnit:(NSString *)largestUnit {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    NSDictionary *dict = uselong ? order_longscale : order_shortscale;
    int maxord = -1;
    if (largestUnit) {
        NSArray *keys = [dict allKeysForObject:largestUnit];
        if ([keys count]) {
            maxord = [keys[0] integerValue];
        }
    } else {
        maxord = uselong ? order_longscale_max : order_shortscale_max;
    }
    [self setNumber:num];
    [self setOrder:dict];
    [self setOrderMax:maxord];
    
    return self;
}

- (NSString *)englishRep {
    return [self macroSegment:self.number];
}

@end
