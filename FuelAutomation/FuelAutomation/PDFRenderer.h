//
//  PDFRenderer.h
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface PDFRenderer : NSObject

+(void)drawPDF:(NSString*)fileName;

+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels;

+(void)drawLogo;


+(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns;


+(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns;

@end
