//
//  UIImage-Extensions.h
//  The9AdPlatform
//
//  Created by zhang xiaodong on 11-5-31.
//  Copyright 2011 the9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (CS_Extensions)
- (UIImage *)jkImageByDrawInRect:(CGRect)rect;
- (UIImage *)jkImageByFitToWidth:(CGFloat)width;
@end;
