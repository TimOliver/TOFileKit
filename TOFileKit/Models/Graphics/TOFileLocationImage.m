//
//  TOFileLocationImage.m
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOFileLocationImage.h"
#import <UIKit/UIKit.h>

@implementation TOFileLocationImage

+ (NSMapTable *)sharedCache
{
    static NSMapTable *sharedCache = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedCache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                            valueOptions:NSPointerFunctionsWeakMemory];
    });
    return sharedCache;
}

+ (NSDictionary *)allImagesDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (TOFileServiceType type = 0; type < TOFileServiceTypeCount; type++) {
        dictionary[@(type)] = [TOFileLocationImage imageOfType:type];
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (UIImage *)imageOfType:(TOFileServiceType)type
{
    // Ensure a valid value was provided
    if (type < 0 || type >= TOFileServiceTypeCount) { return nil; }

    // Return a cached version if available
    NSMapTable *sharedCache = [self.class sharedCache];
    if ([sharedCache objectForKey:@(type)]) { return [sharedCache objectForKey:@(type)]; }

    // Generate image
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions((CGSize){32.0f, 32.0f}, NO, 0.0f);
    {
        switch (type) {
            case TOFileServiceTypeDropbox: [TOFileLocationImage drawDropboxIcon]; break;
            case TOFileServiceTypeGoogleDrive: [TOFileLocationImage drawGoogleDriveIcon]; break;
            case TOFileServiceTypeBox: [TOFileLocationImage drawBoxIcon]; break;
            case TOFileServiceTypeOneDrive: [TOFileLocationImage drawOneDriveIcon]; break;
            case TOFileServiceTypeSMB: [TOFileLocationImage drawSMBIcon]; break;
            case TOFileServiceTypeFTP: [TOFileLocationImage drawFTPIcon]; break;
            case TOFileServiceTypeSFTP: [TOFileLocationImage drawSFTPIcon]; break;
            default: UIGraphicsEndImageContext(); return nil;
        }

        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    // Save to cache
    [sharedCache setObject:image forKey:@(type)];

    return image;
}

+ (void)drawDropboxIcon
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* dropboxColor = [UIColor colorWithRed: 0 green: 0.384 blue: 1 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [dropboxColor setFill];
    [rectanglePath fill];


    //// Group 2
    {
        //// Star Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 10.75, 9.58);
        CGContextRotateCTM(context, -90 * M_PI/180);

        UIBezierPath* starPath = [UIBezierPath bezierPath];
        [starPath moveToPoint: CGPointMake(0, -5.75)];
        [starPath addLineToPoint: CGPointMake(3.55, 0)];
        [starPath addLineToPoint: CGPointMake(0, 5.75)];
        [starPath addLineToPoint: CGPointMake(-3.55, 0)];
        [starPath closePath];
        [UIColor.whiteColor setFill];
        [starPath fill];

        CGContextRestoreGState(context);


        //// Star 2 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 22.25, 9.58);
        CGContextRotateCTM(context, -90 * M_PI/180);

        UIBezierPath* star2Path = [UIBezierPath bezierPath];
        [star2Path moveToPoint: CGPointMake(0, -5.75)];
        [star2Path addLineToPoint: CGPointMake(3.55, 0)];
        [star2Path addLineToPoint: CGPointMake(0, 5.75)];
        [star2Path addLineToPoint: CGPointMake(-3.55, 0)];
        [star2Path closePath];
        [UIColor.whiteColor setFill];
        [star2Path fill];

        CGContextRestoreGState(context);


        //// Star 3 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 10.75, 16.68);
        CGContextRotateCTM(context, -90 * M_PI/180);

        UIBezierPath* star3Path = [UIBezierPath bezierPath];
        [star3Path moveToPoint: CGPointMake(0, -5.75)];
        [star3Path addLineToPoint: CGPointMake(3.55, 0)];
        [star3Path addLineToPoint: CGPointMake(0, 5.75)];
        [star3Path addLineToPoint: CGPointMake(-3.55, 0)];
        [star3Path closePath];
        [UIColor.whiteColor setFill];
        [star3Path fill];

        CGContextRestoreGState(context);


        //// Star 4 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 22.25, 16.68);
        CGContextRotateCTM(context, -90 * M_PI/180);

        UIBezierPath* star4Path = [UIBezierPath bezierPath];
        [star4Path moveToPoint: CGPointMake(-0, -5.75)];
        [star4Path addLineToPoint: CGPointMake(3.55, -0)];
        [star4Path addLineToPoint: CGPointMake(-0, 5.75)];
        [star4Path addLineToPoint: CGPointMake(-3.55, -0)];
        [star4Path closePath];
        [UIColor.whiteColor setFill];
        [star4Path fill];

        CGContextRestoreGState(context);


        //// Star 5 Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 16.5, 21.42);
        CGContextRotateCTM(context, -90 * M_PI/180);

        UIBezierPath* star5Path = [UIBezierPath bezierPath];
        [star5Path moveToPoint: CGPointMake(0, -5.75)];
        [star5Path addLineToPoint: CGPointMake(3.55, -0)];
        [star5Path addLineToPoint: CGPointMake(0, 5.75)];
        [star5Path addLineToPoint: CGPointMake(-3.55, -0)];
        [star5Path closePath];
        [UIColor.whiteColor setFill];
        [star5Path fill];

        CGContextRestoreGState(context);
    }
}

+ (void)drawGoogleDriveIcon
{
    //// Color Declarations
    UIColor* googleDriveColor = [UIColor colorWithRed: 0 green: 0.585 blue: 0.301 alpha: 1];

    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [googleDriveColor setFill];
    [rectangle2Path fill];


    //// Group
    {
        //// Color Fill 1 Drawing
        UIBezierPath* colorFill1Path = [UIBezierPath bezierPath];
        [colorFill1Path moveToPoint: CGPointMake(12.32, 7)];
        [colorFill1Path addLineToPoint: CGPointMake(18.84, 7)];
        [colorFill1Path addLineToPoint: CGPointMake(25.27, 17.73)];
        [colorFill1Path addLineToPoint: CGPointMake(18.75, 17.73)];
        [colorFill1Path addLineToPoint: CGPointMake(12.32, 7)];
        [colorFill1Path closePath];
        [colorFill1Path moveToPoint: CGPointMake(8.55, 24.01)];
        [colorFill1Path addLineToPoint: CGPointMake(5.29, 18.68)];
        [colorFill1Path addLineToPoint: CGPointMake(11.47, 8.39)];
        [colorFill1Path addLineToPoint: CGPointMake(14.72, 13.72)];
        [colorFill1Path addLineToPoint: CGPointMake(8.55, 24.01)];
        [colorFill1Path closePath];
        [colorFill1Path moveToPoint: CGPointMake(10.21, 23.97)];
        [colorFill1Path addLineToPoint: CGPointMake(13.46, 18.64)];
        [colorFill1Path addLineToPoint: CGPointMake(25.85, 18.67)];
        [colorFill1Path addLineToPoint: CGPointMake(22.59, 24)];
        [colorFill1Path addLineToPoint: CGPointMake(10.21, 23.97)];
        [colorFill1Path closePath];
        [UIColor.whiteColor setFill];
        [colorFill1Path fill];
    }
}

+ (void)drawBoxIcon
{
    //// Color Declarations
    UIColor* boxColor = [UIColor colorWithRed: 0 green: 0.443 blue: 0.969 alpha: 1];

    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [boxColor setFill];
    [rectangle2Path fill];


    //// box_blue Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(15.9, 22.46)];
        [bezierPath addCurveToPoint: CGPointMake(11.66, 18.51) controlPoint1: CGPointMake(13.56, 22.46) controlPoint2: CGPointMake(11.66, 20.69)];
        [bezierPath addCurveToPoint: CGPointMake(15.9, 14.56) controlPoint1: CGPointMake(11.66, 16.33) controlPoint2: CGPointMake(13.56, 14.56)];
        [bezierPath addCurveToPoint: CGPointMake(20.13, 18.51) controlPoint1: CGPointMake(18.24, 14.56) controlPoint2: CGPointMake(20.13, 16.33)];
        [bezierPath addCurveToPoint: CGPointMake(15.9, 22.46) controlPoint1: CGPointMake(20.13, 20.69) controlPoint2: CGPointMake(18.24, 22.46)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(22.14, 15.42)];
        [bezierPath addCurveToPoint: CGPointMake(15.9, 11.92) controlPoint1: CGPointMake(20.95, 13.34) controlPoint2: CGPointMake(18.6, 11.92)];
        [bezierPath addCurveToPoint: CGPointMake(11.66, 13.24) controlPoint1: CGPointMake(14.31, 11.92) controlPoint2: CGPointMake(12.84, 12.41)];
        [bezierPath addLineToPoint: CGPointMake(11.66, 7.69)];
        [bezierPath addCurveToPoint: CGPointMake(10.25, 6.4) controlPoint1: CGPointMake(11.65, 6.98) controlPoint2: CGPointMake(11.02, 6.4)];
        [bezierPath addCurveToPoint: CGPointMake(8.84, 7.69) controlPoint1: CGPointMake(9.48, 6.4) controlPoint2: CGPointMake(8.85, 6.98)];
        [bezierPath addLineToPoint: CGPointMake(8.84, 18.62)];
        [bezierPath addLineToPoint: CGPointMake(8.84, 18.62)];
        [bezierPath addCurveToPoint: CGPointMake(15.9, 25.1) controlPoint1: CGPointMake(8.9, 22.21) controlPoint2: CGPointMake(12.04, 25.1)];
        [bezierPath addCurveToPoint: CGPointMake(22.14, 21.6) controlPoint1: CGPointMake(18.6, 25.1) controlPoint2: CGPointMake(20.95, 23.68)];
        [UIColor.whiteColor setFill];
        [bezierPath fill];


        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(15.88, 14.58)];
        [bezier2Path addCurveToPoint: CGPointMake(11.65, 18.53) controlPoint1: CGPointMake(13.54, 14.58) controlPoint2: CGPointMake(11.65, 16.35)];
        [bezier2Path addCurveToPoint: CGPointMake(15.88, 22.48) controlPoint1: CGPointMake(11.65, 20.71) controlPoint2: CGPointMake(13.54, 22.48)];
        [bezier2Path addCurveToPoint: CGPointMake(20.12, 18.53) controlPoint1: CGPointMake(18.22, 22.48) controlPoint2: CGPointMake(20.12, 20.71)];
        [bezier2Path addCurveToPoint: CGPointMake(16.44, 14.61) controlPoint1: CGPointMake(20.12, 16.53) controlPoint2: CGPointMake(18.52, 14.87)];
        [bezier2Path addCurveToPoint: CGPointMake(15.88, 14.58) controlPoint1: CGPointMake(16.26, 14.59) controlPoint2: CGPointMake(16.07, 14.58)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(23, 18.49)];
        [bezier2Path addCurveToPoint: CGPointMake(15.93, 25.09) controlPoint1: CGPointMake(23, 22.14) controlPoint2: CGPointMake(19.83, 25.09)];
        [bezier2Path addCurveToPoint: CGPointMake(8.85, 18.49) controlPoint1: CGPointMake(12.02, 25.09) controlPoint2: CGPointMake(8.85, 22.14)];
        [bezier2Path addCurveToPoint: CGPointMake(15.26, 11.92) controlPoint1: CGPointMake(8.85, 15.06) controlPoint2: CGPointMake(11.66, 12.24)];
        [bezier2Path addCurveToPoint: CGPointMake(15.93, 11.89) controlPoint1: CGPointMake(15.48, 11.9) controlPoint2: CGPointMake(15.7, 11.89)];
        [bezier2Path addCurveToPoint: CGPointMake(23, 18.49) controlPoint1: CGPointMake(19.83, 11.89) controlPoint2: CGPointMake(23, 14.85)];
        [bezier2Path closePath];
        [UIColor.whiteColor setFill];
        [bezier2Path fill];
    }
}

+ (void)drawOneDriveIcon
{
    //// Color Declarations
    UIColor* oneDriveColor = [UIColor colorWithRed: 0.02 green: 0.286 blue: 0.698 alpha: 1];
    UIColor* fillColor3 = [UIColor colorWithRed: 1 green: 0.999 blue: 0.996 alpha: 1];

    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [oneDriveColor setFill];
    [rectangle2Path fill];


    //// OneDrive_c_Wht Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(25.56, 17.13)];
        [bezierPath addCurveToPoint: CGPointMake(27.68, 19.43) controlPoint1: CGPointMake(25.56, 17.13) controlPoint2: CGPointMake(27.68, 17.35)];
        [bezierPath addCurveToPoint: CGPointMake(25.56, 21.62) controlPoint1: CGPointMake(27.68, 20.43) controlPoint2: CGPointMake(27.06, 21.62)];
        [bezierPath addLineToPoint: CGPointMake(13.44, 21.62)];
        [bezierPath addCurveToPoint: CGPointMake(10.28, 18.7) controlPoint1: CGPointMake(11.12, 21.62) controlPoint2: CGPointMake(10.28, 20.18)];
        [bezierPath addCurveToPoint: CGPointMake(13.33, 16.13) controlPoint1: CGPointMake(10.28, 16.22) controlPoint2: CGPointMake(13.33, 16.13)];
        [bezierPath addCurveToPoint: CGPointMake(16.25, 12.86) controlPoint1: CGPointMake(13.33, 16.13) controlPoint2: CGPointMake(13.58, 13.41)];
        [bezierPath addCurveToPoint: CGPointMake(20.62, 14.37) controlPoint1: CGPointMake(18.63, 12.37) controlPoint2: CGPointMake(19.97, 13.5)];
        [bezierPath addCurveToPoint: CGPointMake(23.71, 14.28) controlPoint1: CGPointMake(20.62, 14.37) controlPoint2: CGPointMake(22.07, 13.62)];
        [bezierPath addCurveToPoint: CGPointMake(25.56, 17.13) controlPoint1: CGPointMake(24.69, 14.67) controlPoint2: CGPointMake(25.65, 15.6)];
        [bezierPath closePath];
        [fillColor3 setFill];
        [bezierPath fill];


        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(9.51, 18.8)];
        [bezier2Path addCurveToPoint: CGPointMake(12.74, 15.62) controlPoint1: CGPointMake(9.51, 16.03) controlPoint2: CGPointMake(12.74, 15.62)];
        [bezier2Path addCurveToPoint: CGPointMake(16.08, 12.28) controlPoint1: CGPointMake(12.74, 15.62) controlPoint2: CGPointMake(13.15, 12.96)];
        [bezier2Path addCurveToPoint: CGPointMake(20.81, 13.71) controlPoint1: CGPointMake(18.35, 11.75) controlPoint2: CGPointMake(20.07, 12.68)];
        [bezier2Path addCurveToPoint: CGPointMake(22.39, 13.42) controlPoint1: CGPointMake(20.81, 13.71) controlPoint2: CGPointMake(21.3, 13.39)];
        [bezier2Path addCurveToPoint: CGPointMake(19.29, 9.79) controlPoint1: CGPointMake(22.28, 12.51) controlPoint2: CGPointMake(21.58, 10.6)];
        [bezier2Path addCurveToPoint: CGPointMake(13.35, 11.75) controlPoint1: CGPointMake(16.69, 8.88) controlPoint2: CGPointMake(14.41, 10.02)];
        [bezier2Path addCurveToPoint: CGPointMake(9.83, 11.7) controlPoint1: CGPointMake(13.35, 11.75) controlPoint2: CGPointMake(11.75, 10.81)];
        [bezier2Path addCurveToPoint: CGPointMake(7.82, 15.18) controlPoint1: CGPointMake(8.49, 12.32) controlPoint2: CGPointMake(7.65, 13.77)];
        [bezier2Path addCurveToPoint: CGPointMake(5.1, 18.01) controlPoint1: CGPointMake(7.82, 15.18) controlPoint2: CGPointMake(5.1, 15.36)];
        [bezier2Path addCurveToPoint: CGPointMake(8.1, 20.75) controlPoint1: CGPointMake(5.1, 19.47) controlPoint2: CGPointMake(6.54, 20.75)];
        [bezier2Path addLineToPoint: CGPointMake(10.12, 20.75)];
        [bezier2Path addCurveToPoint: CGPointMake(9.51, 18.8) controlPoint1: CGPointMake(9.63, 20.07) controlPoint2: CGPointMake(9.51, 19.36)];
        [bezier2Path closePath];
        [fillColor3 setFill];
        [bezier2Path fill];
    }
}

+ (void)drawSMBIcon
{
    //// Color Declarations
    UIColor* sMBColor = [UIColor colorWithRed: 0.797 green: 0.156 blue: 0.044 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [sMBColor setFill];
    [rectanglePath fill];


    //// Group
    {
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(11.58, 7)];
        [bezier3Path addCurveToPoint: CGPointMake(9.79, 7.15) controlPoint1: CGPointMake(10.7, 7) controlPoint2: CGPointMake(10.26, 7)];
        [bezier3Path addCurveToPoint: CGPointMake(8.65, 8.34) controlPoint1: CGPointMake(9.27, 7.34) controlPoint2: CGPointMake(8.86, 7.75)];
        [bezier3Path addCurveToPoint: CGPointMake(7.29, 17.84) controlPoint1: CGPointMake(8.57, 8.58) controlPoint2: CGPointMake(7.85, 13.78)];
        [bezier3Path addCurveToPoint: CGPointMake(9.47, 17.02) controlPoint1: CGPointMake(7.87, 17.33) controlPoint2: CGPointMake(8.64, 17.02)];
        [bezier3Path addLineToPoint: CGPointMake(22.46, 16.99)];
        [bezier3Path addCurveToPoint: CGPointMake(24.65, 17.81) controlPoint1: CGPointMake(23.3, 16.99) controlPoint2: CGPointMake(24.07, 17.3)];
        [bezier3Path addCurveToPoint: CGPointMake(23.28, 8.31) controlPoint1: CGPointMake(24.09, 13.75) controlPoint2: CGPointMake(23.36, 8.55)];
        [bezier3Path addCurveToPoint: CGPointMake(22.15, 7.12) controlPoint1: CGPointMake(23.08, 7.72) controlPoint2: CGPointMake(22.67, 7.31)];
        [bezier3Path addCurveToPoint: CGPointMake(20.36, 6.97) controlPoint1: CGPointMake(21.68, 6.97) controlPoint2: CGPointMake(21.24, 6.97)];
        [bezier3Path addLineToPoint: CGPointMake(11.58, 7)];
        [bezier3Path closePath];
        [UIColor.whiteColor setFill];
        [bezier3Path fill];


        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(21.87, 19.73)];
        [bezierPath addCurveToPoint: CGPointMake(20.74, 20.97) controlPoint1: CGPointMake(21.17, 19.78) controlPoint2: CGPointMake(20.74, 20.37)];
        [bezierPath addCurveToPoint: CGPointMake(21.99, 22.22) controlPoint1: CGPointMake(20.74, 21.66) controlPoint2: CGPointMake(21.3, 22.22)];
        [bezierPath addCurveToPoint: CGPointMake(23.24, 20.97) controlPoint1: CGPointMake(22.68, 22.22) controlPoint2: CGPointMake(23.24, 21.66)];
        [bezierPath addCurveToPoint: CGPointMake(21.87, 19.73) controlPoint1: CGPointMake(23.24, 20.28) controlPoint2: CGPointMake(22.63, 19.73)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(25, 21)];
        [bezierPath addCurveToPoint: CGPointMake(22, 24) controlPoint1: CGPointMake(25, 22.66) controlPoint2: CGPointMake(23.66, 24)];
        [bezierPath addLineToPoint: CGPointMake(10, 24)];
        [bezierPath addCurveToPoint: CGPointMake(7, 21) controlPoint1: CGPointMake(8.34, 24) controlPoint2: CGPointMake(7, 22.66)];
        [bezierPath addCurveToPoint: CGPointMake(10, 18) controlPoint1: CGPointMake(7, 19.34) controlPoint2: CGPointMake(8.34, 18)];
        [bezierPath addLineToPoint: CGPointMake(22, 18)];
        [bezierPath addCurveToPoint: CGPointMake(25, 21) controlPoint1: CGPointMake(23.66, 18) controlPoint2: CGPointMake(25, 19.34)];
        [bezierPath closePath];
        [UIColor.whiteColor setFill];
        [bezierPath fill];


        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(21.35, 20.35, 1.29, 1.29)];
        [UIColor.whiteColor setFill];
        [ovalPath fill];
    }
}

+ (void)drawFTPIcon
{
    //// Color Declarations
    UIColor* fTPColor = [UIColor colorWithRed: 0.922 green: 0.507 blue: 0 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.04, 0, 31.96, 32) cornerRadius: 7];
    [fTPColor setFill];
    [rectanglePath fill];


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(21.79, 12.31)];
    [bezier2Path addLineToPoint: CGPointMake(10.21, 12.31)];
    [bezier2Path addLineToPoint: CGPointMake(10.21, 19.16)];
    [bezier2Path addLineToPoint: CGPointMake(12.32, 19.16)];
    [bezier2Path addLineToPoint: CGPointMake(12.32, 20.19)];
    [bezier2Path addLineToPoint: CGPointMake(12.83, 20.19)];
    [bezier2Path addCurveToPoint: CGPointMake(12.83, 20.72) controlPoint1: CGPointMake(12.83, 20.45) controlPoint2: CGPointMake(12.83, 20.72)];
    [bezier2Path addLineToPoint: CGPointMake(19.13, 20.72)];
    [bezier2Path addCurveToPoint: CGPointMake(19.13, 20.19) controlPoint1: CGPointMake(19.13, 20.72) controlPoint2: CGPointMake(19.13, 20.45)];
    [bezier2Path addLineToPoint: CGPointMake(19.68, 20.19)];
    [bezier2Path addCurveToPoint: CGPointMake(19.68, 19.16) controlPoint1: CGPointMake(19.68, 20.19) controlPoint2: CGPointMake(19.68, 19.16)];
    [bezier2Path addLineToPoint: CGPointMake(21.79, 19.16)];
    [bezier2Path addLineToPoint: CGPointMake(21.79, 12.31)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(26, 16)];
    [bezier2Path addCurveToPoint: CGPointMake(16, 26) controlPoint1: CGPointMake(26, 21.52) controlPoint2: CGPointMake(21.52, 26)];
    [bezier2Path addCurveToPoint: CGPointMake(6, 16) controlPoint1: CGPointMake(10.48, 26) controlPoint2: CGPointMake(6, 21.52)];
    [bezier2Path addCurveToPoint: CGPointMake(11.16, 7.25) controlPoint1: CGPointMake(6, 12.23) controlPoint2: CGPointMake(8.08, 8.95)];
    [bezier2Path addCurveToPoint: CGPointMake(16, 6) controlPoint1: CGPointMake(12.59, 6.45) controlPoint2: CGPointMake(14.24, 6)];
    [bezier2Path addCurveToPoint: CGPointMake(26, 16) controlPoint1: CGPointMake(21.52, 6) controlPoint2: CGPointMake(26, 10.48)];
    [bezier2Path closePath];
    [UIColor.whiteColor setFill];
    [bezier2Path fill];

}

+ (void)drawSFTPIcon
{
    //// Color Declarations
    UIColor* sFTPColor = [UIColor colorWithRed: 0.582 green: 0.039 blue: 0.573 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 32, 32) cornerRadius: 7];
    [sFTPColor setFill];
    [rectanglePath fill];


    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(18.17, 12.79)];
    [bezier3Path addLineToPoint: CGPointMake(18.17, 14.35)];
    [bezier3Path addCurveToPoint: CGPointMake(18.17, 14.63) controlPoint1: CGPointMake(18.17, 14.45) controlPoint2: CGPointMake(18.17, 14.54)];
    [bezier3Path addLineToPoint: CGPointMake(13.89, 14.63)];
    [bezier3Path addCurveToPoint: CGPointMake(13.89, 14.35) controlPoint1: CGPointMake(13.89, 14.46) controlPoint2: CGPointMake(13.89, 14.35)];
    [bezier3Path addCurveToPoint: CGPointMake(13.89, 12.79) controlPoint1: CGPointMake(13.89, 12.79) controlPoint2: CGPointMake(13.89, 12.79)];
    [bezier3Path addCurveToPoint: CGPointMake(16.03, 10.68) controlPoint1: CGPointMake(13.89, 11.62) controlPoint2: CGPointMake(14.85, 10.68)];
    [bezier3Path addCurveToPoint: CGPointMake(18.17, 12.79) controlPoint1: CGPointMake(17.21, 10.68) controlPoint2: CGPointMake(18.17, 11.62)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(16.03, 9.47)];
    [bezier3Path addCurveToPoint: CGPointMake(14.51, 9.83) controlPoint1: CGPointMake(15.48, 9.47) controlPoint2: CGPointMake(14.96, 9.6)];
    [bezier3Path addCurveToPoint: CGPointMake(12.66, 12.79) controlPoint1: CGPointMake(13.41, 10.37) controlPoint2: CGPointMake(12.66, 11.5)];
    [bezier3Path addCurveToPoint: CGPointMake(12.66, 14.35) controlPoint1: CGPointMake(12.66, 12.79) controlPoint2: CGPointMake(12.66, 12.79)];
    [bezier3Path addCurveToPoint: CGPointMake(12.66, 14.69) controlPoint1: CGPointMake(12.66, 14.35) controlPoint2: CGPointMake(12.66, 14.49)];
    [bezier3Path addCurveToPoint: CGPointMake(12.51, 14.73) controlPoint1: CGPointMake(12.61, 14.7) controlPoint2: CGPointMake(12.56, 14.71)];
    [bezier3Path addCurveToPoint: CGPointMake(11.82, 15.44) controlPoint1: CGPointMake(12.19, 14.84) controlPoint2: CGPointMake(11.94, 15.09)];
    [bezier3Path addCurveToPoint: CGPointMake(11.74, 16.48) controlPoint1: CGPointMake(11.74, 15.68) controlPoint2: CGPointMake(11.74, 15.95)];
    [bezier3Path addLineToPoint: CGPointMake(11.74, 19.75)];
    [bezier3Path addCurveToPoint: CGPointMake(11.82, 20.93) controlPoint1: CGPointMake(11.74, 20.28) controlPoint2: CGPointMake(11.73, 20.64)];
    [bezier3Path addCurveToPoint: CGPointMake(12.47, 21.66) controlPoint1: CGPointMake(11.93, 21.24) controlPoint2: CGPointMake(12.1, 21.53)];
    [bezier3Path addCurveToPoint: CGPointMake(13.52, 21.74) controlPoint1: CGPointMake(12.71, 21.74) controlPoint2: CGPointMake(12.98, 21.74)];
    [bezier3Path addLineToPoint: CGPointMake(18.35, 21.74)];
    [bezier3Path addCurveToPoint: CGPointMake(19.49, 21.65) controlPoint1: CGPointMake(18.89, 21.74) controlPoint2: CGPointMake(19.2, 21.74)];
    [bezier3Path addCurveToPoint: CGPointMake(20.27, 20.93) controlPoint1: CGPointMake(19.81, 21.53) controlPoint2: CGPointMake(20.14, 21.29)];
    [bezier3Path addCurveToPoint: CGPointMake(20.36, 19.75) controlPoint1: CGPointMake(20.35, 20.69) controlPoint2: CGPointMake(20.36, 20.28)];
    [bezier3Path addLineToPoint: CGPointMake(20.36, 16.48)];
    [bezier3Path addCurveToPoint: CGPointMake(20.27, 15.4) controlPoint1: CGPointMake(20.36, 15.95) controlPoint2: CGPointMake(20.36, 15.68)];
    [bezier3Path addCurveToPoint: CGPointMake(19.54, 14.71) controlPoint1: CGPointMake(20.15, 15.09) controlPoint2: CGPointMake(19.9, 14.84)];
    [bezier3Path addCurveToPoint: CGPointMake(19.44, 14.35) controlPoint1: CGPointMake(19.44, 14.58) controlPoint2: CGPointMake(19.44, 14.47)];
    [bezier3Path addLineToPoint: CGPointMake(19.44, 12.79)];
    [bezier3Path addCurveToPoint: CGPointMake(16.03, 9.47) controlPoint1: CGPointMake(19.44, 10.96) controlPoint2: CGPointMake(17.89, 9.47)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(26, 16)];
    [bezier3Path addCurveToPoint: CGPointMake(16, 26) controlPoint1: CGPointMake(26, 21.52) controlPoint2: CGPointMake(21.52, 26)];
    [bezier3Path addCurveToPoint: CGPointMake(6, 16) controlPoint1: CGPointMake(10.48, 26) controlPoint2: CGPointMake(6, 21.52)];
    [bezier3Path addCurveToPoint: CGPointMake(11.16, 7.25) controlPoint1: CGPointMake(6, 12.23) controlPoint2: CGPointMake(8.08, 8.95)];
    [bezier3Path addCurveToPoint: CGPointMake(16, 6) controlPoint1: CGPointMake(12.59, 6.45) controlPoint2: CGPointMake(14.24, 6)];
    [bezier3Path addCurveToPoint: CGPointMake(26, 16) controlPoint1: CGPointMake(21.52, 6) controlPoint2: CGPointMake(26, 10.48)];
    [bezier3Path closePath];
    [UIColor.whiteColor setFill];
    [bezier3Path fill];

}

@end
