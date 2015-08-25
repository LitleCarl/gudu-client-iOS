//
//  MegaTheme.m
//  Mega
//
//  Created by Sergey on 1/30/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "MegaTheme.h"

@implementation MegaTheme


+(NSString*) fontName{
    
    return @"Avenir-Book";
    
}

+(NSString*) boldFontName{
    
    return @"Avenir-Black";
    
}

+(NSString*) semiBoldFontName{
    
    return @"Avenir-Heavy";
    
}

+(NSString*) lighterFontName{
    
    return @"Avenir-Light";
    
}

+(UIColor*) darkColor{
    
    return [UIColor blackColor];
    
}

+(UIColor*) lightColor{
    
    return [UIColor colorWithWhite:0.6 alpha:1.0];
    
}


@end
