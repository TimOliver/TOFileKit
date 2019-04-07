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

+ (UIImage *)imageOfType:(TOFileLocationImageType)type
{
    CGSize size = (CGSize){29.0f, 29.0f};
    UIImage *image = nil;

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    {
        switch (type) {
            case TOFileLocationImageTypeDropbox: [TOFileLocationImage drawDropboxIcon]; break;
            case TOFileLocationImageTypeGoogleDrive: [TOFileLocationImage drawGoogleDriveIcon]; break;
            case TOFileLocationImageTypeBox: [TOFileLocationImage drawBoxIcon]; break;
            case TOFileLocationImageTypeOneDrive: [TOFileLocationImage drawOneDriveIcon]; break;
            case TOFileLocationImageTypeSMB: [TOFileLocationImage drawSMBIcon]; break;
            case TOFileLocationImageTypeFTP: [TOFileLocationImage drawFTPIcon]; break;
            case TOFileLocationImageTypeSFTP: [TOFileLocationImage drawSFTPIcon]; break;
            default: break;
        }

        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return image;
}

+ (void)drawDropboxIcon
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* dropboxColor = [UIColor colorWithRed: 0 green: 0.384 blue: 1 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [dropboxColor setFill];
    [rectanglePath fill];


    //// Group 2
    {
        //// Star Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 8.75, 8.58);
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
        CGContextTranslateCTM(context, 20.25, 8.58);
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
        CGContextTranslateCTM(context, 8.75, 15.68);
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
        CGContextTranslateCTM(context, 20.25, 15.68);
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
        CGContextTranslateCTM(context, 14.5, 20.42);
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
    UIColor* googleDriveColor = [UIColor colorWithRed: 0 green: 0.697 blue: 0.097 alpha: 1];

    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [googleDriveColor setFill];
    [rectangle2Path fill];


    //// Group
    {
        //// Color Fill 1 Drawing
        UIBezierPath* colorFill1Path = [UIBezierPath bezierPath];
        [colorFill1Path moveToPoint: CGPointMake(11.32, 5)];
        [colorFill1Path addLineToPoint: CGPointMake(17.84, 5)];
        [colorFill1Path addLineToPoint: CGPointMake(24.27, 15.73)];
        [colorFill1Path addLineToPoint: CGPointMake(17.75, 15.73)];
        [colorFill1Path addLineToPoint: CGPointMake(11.32, 5)];
        [colorFill1Path closePath];
        [colorFill1Path moveToPoint: CGPointMake(7.55, 22.01)];
        [colorFill1Path addLineToPoint: CGPointMake(4.29, 16.68)];
        [colorFill1Path addLineToPoint: CGPointMake(10.47, 6.39)];
        [colorFill1Path addLineToPoint: CGPointMake(13.72, 11.72)];
        [colorFill1Path addLineToPoint: CGPointMake(7.55, 22.01)];
        [colorFill1Path closePath];
        [colorFill1Path moveToPoint: CGPointMake(9.21, 21.97)];
        [colorFill1Path addLineToPoint: CGPointMake(12.46, 16.64)];
        [colorFill1Path addLineToPoint: CGPointMake(24.85, 16.67)];
        [colorFill1Path addLineToPoint: CGPointMake(21.59, 22)];
        [colorFill1Path addLineToPoint: CGPointMake(9.21, 21.97)];
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
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [boxColor setFill];
    [rectangle2Path fill];


    //// box_blue Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(14.9, 21.46)];
        [bezierPath addCurveToPoint: CGPointMake(10.66, 17.51) controlPoint1: CGPointMake(12.56, 21.46) controlPoint2: CGPointMake(10.66, 19.69)];
        [bezierPath addCurveToPoint: CGPointMake(14.9, 13.56) controlPoint1: CGPointMake(10.66, 15.33) controlPoint2: CGPointMake(12.56, 13.56)];
        [bezierPath addCurveToPoint: CGPointMake(19.13, 17.51) controlPoint1: CGPointMake(17.24, 13.56) controlPoint2: CGPointMake(19.13, 15.33)];
        [bezierPath addCurveToPoint: CGPointMake(14.9, 21.46) controlPoint1: CGPointMake(19.13, 19.69) controlPoint2: CGPointMake(17.24, 21.46)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(21.14, 14.42)];
        [bezierPath addCurveToPoint: CGPointMake(14.9, 10.92) controlPoint1: CGPointMake(19.95, 12.34) controlPoint2: CGPointMake(17.6, 10.92)];
        [bezierPath addCurveToPoint: CGPointMake(10.66, 12.24) controlPoint1: CGPointMake(13.31, 10.92) controlPoint2: CGPointMake(11.84, 11.41)];
        [bezierPath addLineToPoint: CGPointMake(10.66, 6.69)];
        [bezierPath addCurveToPoint: CGPointMake(9.25, 5.4) controlPoint1: CGPointMake(10.65, 5.98) controlPoint2: CGPointMake(10.02, 5.4)];
        [bezierPath addCurveToPoint: CGPointMake(7.84, 6.69) controlPoint1: CGPointMake(8.48, 5.4) controlPoint2: CGPointMake(7.85, 5.98)];
        [bezierPath addLineToPoint: CGPointMake(7.84, 17.62)];
        [bezierPath addLineToPoint: CGPointMake(7.84, 17.62)];
        [bezierPath addCurveToPoint: CGPointMake(14.9, 24.1) controlPoint1: CGPointMake(7.9, 21.21) controlPoint2: CGPointMake(11.04, 24.1)];
        [bezierPath addCurveToPoint: CGPointMake(21.14, 20.6) controlPoint1: CGPointMake(17.6, 24.1) controlPoint2: CGPointMake(19.95, 22.68)];
        [UIColor.whiteColor setFill];
        [bezierPath fill];


        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(14.88, 13.58)];
        [bezier2Path addCurveToPoint: CGPointMake(10.65, 17.53) controlPoint1: CGPointMake(12.54, 13.58) controlPoint2: CGPointMake(10.65, 15.35)];
        [bezier2Path addCurveToPoint: CGPointMake(14.88, 21.48) controlPoint1: CGPointMake(10.65, 19.71) controlPoint2: CGPointMake(12.54, 21.48)];
        [bezier2Path addCurveToPoint: CGPointMake(19.12, 17.53) controlPoint1: CGPointMake(17.22, 21.48) controlPoint2: CGPointMake(19.12, 19.71)];
        [bezier2Path addCurveToPoint: CGPointMake(15.44, 13.61) controlPoint1: CGPointMake(19.12, 15.53) controlPoint2: CGPointMake(17.52, 13.87)];
        [bezier2Path addCurveToPoint: CGPointMake(14.88, 13.58) controlPoint1: CGPointMake(15.26, 13.59) controlPoint2: CGPointMake(15.07, 13.58)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(22, 17.49)];
        [bezier2Path addCurveToPoint: CGPointMake(14.93, 24.09) controlPoint1: CGPointMake(22, 21.14) controlPoint2: CGPointMake(18.83, 24.09)];
        [bezier2Path addCurveToPoint: CGPointMake(7.85, 17.49) controlPoint1: CGPointMake(11.02, 24.09) controlPoint2: CGPointMake(7.85, 21.14)];
        [bezier2Path addCurveToPoint: CGPointMake(14.26, 10.92) controlPoint1: CGPointMake(7.85, 14.06) controlPoint2: CGPointMake(10.66, 11.24)];
        [bezier2Path addCurveToPoint: CGPointMake(14.93, 10.89) controlPoint1: CGPointMake(14.48, 10.9) controlPoint2: CGPointMake(14.7, 10.89)];
        [bezier2Path addCurveToPoint: CGPointMake(22, 17.49) controlPoint1: CGPointMake(18.83, 10.89) controlPoint2: CGPointMake(22, 13.85)];
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
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [oneDriveColor setFill];
    [rectangle2Path fill];


    //// OneDrive_c_Wht Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(23.56, 15.13)];
        [bezierPath addCurveToPoint: CGPointMake(25.68, 17.43) controlPoint1: CGPointMake(23.56, 15.13) controlPoint2: CGPointMake(25.68, 15.35)];
        [bezierPath addCurveToPoint: CGPointMake(23.56, 19.62) controlPoint1: CGPointMake(25.68, 18.43) controlPoint2: CGPointMake(25.06, 19.62)];
        [bezierPath addLineToPoint: CGPointMake(11.44, 19.62)];
        [bezierPath addCurveToPoint: CGPointMake(8.28, 16.7) controlPoint1: CGPointMake(9.12, 19.62) controlPoint2: CGPointMake(8.28, 18.18)];
        [bezierPath addCurveToPoint: CGPointMake(11.33, 14.13) controlPoint1: CGPointMake(8.28, 14.22) controlPoint2: CGPointMake(11.33, 14.13)];
        [bezierPath addCurveToPoint: CGPointMake(14.25, 10.86) controlPoint1: CGPointMake(11.33, 14.13) controlPoint2: CGPointMake(11.58, 11.41)];
        [bezierPath addCurveToPoint: CGPointMake(18.62, 12.37) controlPoint1: CGPointMake(16.63, 10.37) controlPoint2: CGPointMake(17.97, 11.5)];
        [bezierPath addCurveToPoint: CGPointMake(21.71, 12.28) controlPoint1: CGPointMake(18.62, 12.37) controlPoint2: CGPointMake(20.07, 11.62)];
        [bezierPath addCurveToPoint: CGPointMake(23.56, 15.13) controlPoint1: CGPointMake(22.69, 12.67) controlPoint2: CGPointMake(23.65, 13.6)];
        [bezierPath closePath];
        [fillColor3 setFill];
        [bezierPath fill];


        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(7.51, 16.8)];
        [bezier2Path addCurveToPoint: CGPointMake(10.74, 13.62) controlPoint1: CGPointMake(7.51, 14.03) controlPoint2: CGPointMake(10.74, 13.62)];
        [bezier2Path addCurveToPoint: CGPointMake(14.08, 10.28) controlPoint1: CGPointMake(10.74, 13.62) controlPoint2: CGPointMake(11.15, 10.96)];
        [bezier2Path addCurveToPoint: CGPointMake(18.81, 11.71) controlPoint1: CGPointMake(16.35, 9.75) controlPoint2: CGPointMake(18.07, 10.68)];
        [bezier2Path addCurveToPoint: CGPointMake(20.39, 11.42) controlPoint1: CGPointMake(18.81, 11.71) controlPoint2: CGPointMake(19.3, 11.39)];
        [bezier2Path addCurveToPoint: CGPointMake(17.29, 7.79) controlPoint1: CGPointMake(20.28, 10.51) controlPoint2: CGPointMake(19.58, 8.6)];
        [bezier2Path addCurveToPoint: CGPointMake(11.35, 9.75) controlPoint1: CGPointMake(14.69, 6.88) controlPoint2: CGPointMake(12.41, 8.02)];
        [bezier2Path addCurveToPoint: CGPointMake(7.83, 9.7) controlPoint1: CGPointMake(11.35, 9.75) controlPoint2: CGPointMake(9.75, 8.81)];
        [bezier2Path addCurveToPoint: CGPointMake(5.82, 13.18) controlPoint1: CGPointMake(6.49, 10.32) controlPoint2: CGPointMake(5.65, 11.77)];
        [bezier2Path addCurveToPoint: CGPointMake(3.1, 16.01) controlPoint1: CGPointMake(5.82, 13.18) controlPoint2: CGPointMake(3.1, 13.36)];
        [bezier2Path addCurveToPoint: CGPointMake(6.1, 18.75) controlPoint1: CGPointMake(3.1, 17.47) controlPoint2: CGPointMake(4.54, 18.75)];
        [bezier2Path addLineToPoint: CGPointMake(8.12, 18.75)];
        [bezier2Path addCurveToPoint: CGPointMake(7.51, 16.8) controlPoint1: CGPointMake(7.63, 18.07) controlPoint2: CGPointMake(7.51, 17.36)];
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
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [sMBColor setFill];
    [rectanglePath fill];


    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(10.58, 6)];
    [bezier3Path addCurveToPoint: CGPointMake(8.79, 6.15) controlPoint1: CGPointMake(9.7, 6) controlPoint2: CGPointMake(9.26, 6)];
    [bezier3Path addCurveToPoint: CGPointMake(7.65, 7.34) controlPoint1: CGPointMake(8.27, 6.34) controlPoint2: CGPointMake(7.86, 6.75)];
    [bezier3Path addCurveToPoint: CGPointMake(6.29, 16.84) controlPoint1: CGPointMake(7.57, 7.58) controlPoint2: CGPointMake(6.85, 12.78)];
    [bezier3Path addCurveToPoint: CGPointMake(8.47, 16.02) controlPoint1: CGPointMake(6.87, 16.33) controlPoint2: CGPointMake(7.64, 16.02)];
    [bezier3Path addLineToPoint: CGPointMake(21.46, 15.99)];
    [bezier3Path addCurveToPoint: CGPointMake(23.65, 16.81) controlPoint1: CGPointMake(22.3, 15.99) controlPoint2: CGPointMake(23.07, 16.3)];
    [bezier3Path addCurveToPoint: CGPointMake(22.28, 7.31) controlPoint1: CGPointMake(23.09, 12.75) controlPoint2: CGPointMake(22.36, 7.55)];
    [bezier3Path addCurveToPoint: CGPointMake(21.15, 6.12) controlPoint1: CGPointMake(22.08, 6.72) controlPoint2: CGPointMake(21.67, 6.31)];
    [bezier3Path addCurveToPoint: CGPointMake(19.36, 5.97) controlPoint1: CGPointMake(20.68, 5.97) controlPoint2: CGPointMake(20.24, 5.97)];
    [bezier3Path addLineToPoint: CGPointMake(10.58, 6)];
    [bezier3Path closePath];
    [UIColor.whiteColor setFill];
    [bezier3Path fill];


    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(20.87, 18.73)];
    [bezierPath addCurveToPoint: CGPointMake(19.74, 19.97) controlPoint1: CGPointMake(20.17, 18.78) controlPoint2: CGPointMake(19.74, 19.37)];
    [bezierPath addCurveToPoint: CGPointMake(20.99, 21.22) controlPoint1: CGPointMake(19.74, 20.66) controlPoint2: CGPointMake(20.3, 21.22)];
    [bezierPath addCurveToPoint: CGPointMake(22.24, 19.97) controlPoint1: CGPointMake(21.68, 21.22) controlPoint2: CGPointMake(22.24, 20.66)];
    [bezierPath addCurveToPoint: CGPointMake(20.87, 18.73) controlPoint1: CGPointMake(22.24, 19.28) controlPoint2: CGPointMake(21.63, 18.73)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(24, 20)];
    [bezierPath addCurveToPoint: CGPointMake(21, 23) controlPoint1: CGPointMake(24, 21.66) controlPoint2: CGPointMake(22.66, 23)];
    [bezierPath addLineToPoint: CGPointMake(9, 23)];
    [bezierPath addCurveToPoint: CGPointMake(6, 20) controlPoint1: CGPointMake(7.34, 23) controlPoint2: CGPointMake(6, 21.66)];
    [bezierPath addCurveToPoint: CGPointMake(9, 17) controlPoint1: CGPointMake(6, 18.34) controlPoint2: CGPointMake(7.34, 17)];
    [bezierPath addLineToPoint: CGPointMake(21, 17)];
    [bezierPath addCurveToPoint: CGPointMake(24, 20) controlPoint1: CGPointMake(22.66, 17) controlPoint2: CGPointMake(24, 18.34)];
    [bezierPath closePath];
    [UIColor.whiteColor setFill];
    [bezierPath fill];


    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(20.35, 19.35, 1.29, 1.29)];
    [UIColor.whiteColor setFill];
    [ovalPath fill];

}

+ (void)drawFTPIcon
{
    //// Color Declarations
    UIColor* fTPColor = [UIColor colorWithRed: 0.922 green: 0.507 blue: 0 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.04, 0, 29, 29) cornerRadius: 7];
    [fTPColor setFill];
    [rectanglePath fill];


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(20, 11)];
    [bezier2Path addLineToPoint: CGPointMake(9, 11)];
    [bezier2Path addLineToPoint: CGPointMake(9, 17.5)];
    [bezier2Path addLineToPoint: CGPointMake(11, 17.5)];
    [bezier2Path addLineToPoint: CGPointMake(11, 18.48)];
    [bezier2Path addLineToPoint: CGPointMake(11.49, 18.48)];
    [bezier2Path addCurveToPoint: CGPointMake(11.49, 18.98) controlPoint1: CGPointMake(11.49, 18.73) controlPoint2: CGPointMake(11.49, 18.98)];
    [bezier2Path addLineToPoint: CGPointMake(17.47, 18.98)];
    [bezier2Path addCurveToPoint: CGPointMake(17.47, 18.48) controlPoint1: CGPointMake(17.47, 18.98) controlPoint2: CGPointMake(17.47, 18.73)];
    [bezier2Path addLineToPoint: CGPointMake(18, 18.48)];
    [bezier2Path addCurveToPoint: CGPointMake(18, 17.5) controlPoint1: CGPointMake(18, 18.48) controlPoint2: CGPointMake(18, 17.5)];
    [bezier2Path addLineToPoint: CGPointMake(20, 17.5)];
    [bezier2Path addLineToPoint: CGPointMake(20, 11)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(24, 14.5)];
    [bezier2Path addCurveToPoint: CGPointMake(14.5, 24) controlPoint1: CGPointMake(24, 19.75) controlPoint2: CGPointMake(19.75, 24)];
    [bezier2Path addCurveToPoint: CGPointMake(5, 14.5) controlPoint1: CGPointMake(9.25, 24) controlPoint2: CGPointMake(5, 19.75)];
    [bezier2Path addCurveToPoint: CGPointMake(9.9, 6.19) controlPoint1: CGPointMake(5, 10.92) controlPoint2: CGPointMake(6.98, 7.81)];
    [bezier2Path addCurveToPoint: CGPointMake(14.5, 5) controlPoint1: CGPointMake(11.26, 5.43) controlPoint2: CGPointMake(12.83, 5)];
    [bezier2Path addCurveToPoint: CGPointMake(24, 14.5) controlPoint1: CGPointMake(19.75, 5) controlPoint2: CGPointMake(24, 9.25)];
    [bezier2Path closePath];
    [UIColor.whiteColor setFill];
    [bezier2Path fill];

}

+ (void)drawSFTPIcon
{
    //// Color Declarations
    UIColor* sFTPColor = [UIColor colorWithRed: 0.582 green: 0.039 blue: 0.573 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 29, 29) cornerRadius: 7];
    [sFTPColor setFill];
    [rectanglePath fill];


    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(16.6, 11.45)];
    [bezier3Path addLineToPoint: CGPointMake(16.6, 12.93)];
    [bezier3Path addCurveToPoint: CGPointMake(16.6, 13.2) controlPoint1: CGPointMake(16.6, 13.03) controlPoint2: CGPointMake(16.6, 13.12)];
    [bezier3Path addLineToPoint: CGPointMake(12.53, 13.2)];
    [bezier3Path addCurveToPoint: CGPointMake(12.53, 12.93) controlPoint1: CGPointMake(12.53, 13.04) controlPoint2: CGPointMake(12.53, 12.93)];
    [bezier3Path addCurveToPoint: CGPointMake(12.53, 11.45) controlPoint1: CGPointMake(12.53, 11.45) controlPoint2: CGPointMake(12.53, 11.45)];
    [bezier3Path addCurveToPoint: CGPointMake(14.57, 9.44) controlPoint1: CGPointMake(12.53, 10.34) controlPoint2: CGPointMake(13.44, 9.44)];
    [bezier3Path addCurveToPoint: CGPointMake(16.6, 11.45) controlPoint1: CGPointMake(15.69, 9.44) controlPoint2: CGPointMake(16.6, 10.34)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(14.57, 8.29)];
    [bezier3Path addCurveToPoint: CGPointMake(13.12, 8.63) controlPoint1: CGPointMake(14.05, 8.29) controlPoint2: CGPointMake(13.56, 8.42)];
    [bezier3Path addCurveToPoint: CGPointMake(11.37, 11.45) controlPoint1: CGPointMake(12.08, 9.16) controlPoint2: CGPointMake(11.37, 10.22)];
    [bezier3Path addCurveToPoint: CGPointMake(11.37, 12.93) controlPoint1: CGPointMake(11.37, 11.45) controlPoint2: CGPointMake(11.37, 11.45)];
    [bezier3Path addCurveToPoint: CGPointMake(11.37, 13.25) controlPoint1: CGPointMake(11.37, 12.93) controlPoint2: CGPointMake(11.37, 13.06)];
    [bezier3Path addCurveToPoint: CGPointMake(11.23, 13.29) controlPoint1: CGPointMake(11.32, 13.26) controlPoint2: CGPointMake(11.27, 13.27)];
    [bezier3Path addCurveToPoint: CGPointMake(10.57, 13.97) controlPoint1: CGPointMake(10.92, 13.4) controlPoint2: CGPointMake(10.69, 13.63)];
    [bezier3Path addCurveToPoint: CGPointMake(10.49, 14.96) controlPoint1: CGPointMake(10.49, 14.2) controlPoint2: CGPointMake(10.49, 14.45)];
    [bezier3Path addLineToPoint: CGPointMake(10.49, 18.06)];
    [bezier3Path addCurveToPoint: CGPointMake(10.57, 19.18) controlPoint1: CGPointMake(10.49, 18.57) controlPoint2: CGPointMake(10.48, 18.91)];
    [bezier3Path addCurveToPoint: CGPointMake(11.18, 19.87) controlPoint1: CGPointMake(10.68, 19.48) controlPoint2: CGPointMake(10.84, 19.76)];
    [bezier3Path addCurveToPoint: CGPointMake(12.18, 19.95) controlPoint1: CGPointMake(11.41, 19.95) controlPoint2: CGPointMake(11.67, 19.95)];
    [bezier3Path addLineToPoint: CGPointMake(16.77, 19.95)];
    [bezier3Path addCurveToPoint: CGPointMake(17.86, 19.86) controlPoint1: CGPointMake(17.28, 19.95) controlPoint2: CGPointMake(17.58, 19.95)];
    [bezier3Path addCurveToPoint: CGPointMake(18.59, 19.18) controlPoint1: CGPointMake(18.16, 19.76) controlPoint2: CGPointMake(18.47, 19.52)];
    [bezier3Path addCurveToPoint: CGPointMake(18.68, 18.06) controlPoint1: CGPointMake(18.67, 18.95) controlPoint2: CGPointMake(18.68, 18.57)];
    [bezier3Path addLineToPoint: CGPointMake(18.68, 14.96)];
    [bezier3Path addCurveToPoint: CGPointMake(18.59, 13.93) controlPoint1: CGPointMake(18.68, 14.45) controlPoint2: CGPointMake(18.68, 14.2)];
    [bezier3Path addCurveToPoint: CGPointMake(17.9, 13.28) controlPoint1: CGPointMake(18.48, 13.63) controlPoint2: CGPointMake(18.25, 13.4)];
    [bezier3Path addCurveToPoint: CGPointMake(17.81, 12.93) controlPoint1: CGPointMake(17.81, 13.15) controlPoint2: CGPointMake(17.81, 13.05)];
    [bezier3Path addLineToPoint: CGPointMake(17.81, 11.45)];
    [bezier3Path addCurveToPoint: CGPointMake(14.57, 8.29) controlPoint1: CGPointMake(17.81, 9.71) controlPoint2: CGPointMake(16.33, 8.29)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(24.04, 14.5)];
    [bezier3Path addCurveToPoint: CGPointMake(14.54, 24) controlPoint1: CGPointMake(24.04, 19.75) controlPoint2: CGPointMake(19.79, 24)];
    [bezier3Path addCurveToPoint: CGPointMake(5.04, 14.5) controlPoint1: CGPointMake(9.29, 24) controlPoint2: CGPointMake(5.04, 19.75)];
    [bezier3Path addCurveToPoint: CGPointMake(9.94, 6.19) controlPoint1: CGPointMake(5.04, 10.92) controlPoint2: CGPointMake(7.02, 7.81)];
    [bezier3Path addCurveToPoint: CGPointMake(14.54, 5) controlPoint1: CGPointMake(11.3, 5.43) controlPoint2: CGPointMake(12.87, 5)];
    [bezier3Path addCurveToPoint: CGPointMake(24.04, 14.5) controlPoint1: CGPointMake(19.79, 5) controlPoint2: CGPointMake(24.04, 9.25)];
    [bezier3Path closePath];
    [UIColor.whiteColor setFill];
    [bezier3Path fill];

}

@end
