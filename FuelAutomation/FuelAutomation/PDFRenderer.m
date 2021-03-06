//
//  PDFRenderer.m
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//
//


#import "PDFRenderer.h"
#import <CoreText/CoreText.h>

@implementation PDFRenderer


+(void)drawPDF:(NSString*)fileName
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
//	CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 100, 1900, 1000), nil);// to change size ov pdf
	
	
    
   // [self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];
    
    [self drawLabels];
    [self drawLogo];
    
    int xOrigin = 50;
    int yOrigin = 130;
    
    int rowHeight = 50;
    int columnWidth = 120;
    
    int numberOfRows = 8;
    int numberOfColumns = 15;
    
    [self drawTableAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    [self drawTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


+(void)drawPDFOld:(NSString*)fileName
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
   // [self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];
    
    CGPoint from = CGPointMake(0, 0);
    CGPoint to = CGPointMake(200, 300);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    
    UIImage* logo = [UIImage imageNamed:@"ray-logo.png"];
    CGRect frame = CGRectMake(20, 100, 300, 60);
    
    [PDFRenderer drawImage:logo inRect:frame];
    
    [self drawLabels];
    [self drawLogo];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)drawText
{
//    
//    NSString* textToDraw = @"Hello World";
//    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
//    // Prepare the text using a Core Text Framesetter
//    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
	
    
//    CGRect frameRect = CGRectMake(0, 0, 300, 50);
//    CGMutablePathRef framePath = CGPathCreateMutable();
//    CGPathAddRect(framePath, NULL, frameRect);
//    
//    // Get the frame that will do the rendering.
//    CFRange currentRange = CFRangeMake(0, 0);
//    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
//    CGPathRelease(framePath);
//    
//    // Get the graphics context.
//    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
//    
//    // Put the text matrix into a known state. This ensures
//    // that no old scaling factors are left in place.
//    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
//    
//    
//    // Core Text draws from the bottom-left corner up, so flip
//    // the current transform prior to drawing.
//    CGContextTranslateCTM(currentContext, 0, 100);
//    CGContextScaleCTM(currentContext, 1.0, -1.0);
//    
//    // Draw the frame.
//    CTFrameDraw(frameRef, currentContext);
//    
//    CFRelease(frameRef);
//    CFRelease(stringRef);
//    CFRelease(framesetter);
}

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}


+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{

    [image drawInRect:rect];

}

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}


+(void)drawLabels
{
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
			
			
			UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
			[label setFont:boldFont];
			

            

            [self drawText:label.text inFrame:label.frame];
        }
    }
    
}


+(void)drawLogo
{
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            
            UIImage* logo = [UIImage imageNamed:@"ray-logo.png"];
            [self drawImage:logo inRect:view.frame];
        }
    }
    
}


+(void)drawTableAt:(CGPoint)origin 
    withRowHeight:(int)rowHeight 
   andColumnWidth:(int)columnWidth 
      andRowCount:(int)numberOfRows 
   andColumnCount:(int)numberOfColumns

{
   
    for (int i = 0; i <= numberOfRows; i++) {
        
        int newOrigin = origin.y + (rowHeight*i);
        
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
        
        
    }
    
    for (int i = 0; i <= numberOfColumns; i++) {
        
        int newOrigin = origin.x + (columnWidth*i);
        
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        
        [self drawLineFromPoint:from toPoint:to];
        
        
    }
}

+(void)drawTableDataAt:(CGPoint)origin 
    withRowHeight:(int)rowHeight 
   andColumnWidth:(int)columnWidth 
      andRowCount:(int)numberOfRows 
   andColumnCount:(int)numberOfColumns
{
    int padding = 10; 
    
    NSArray* headers = [NSArray arrayWithObjects:@"Customer", @"Airport", @"Tail#", @"Aircraft Type",@"Flight Type",@"Arr Flight#",@"Dept Flight#",@"Days",@"Arrival Time",@"Departure Time",@"From",@"To",@"Effective Date",@"Expiry Date",@"Comments",nil];
	
	
	
	
    NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"cus1", @"Hyd", @"ABC", @"FDG521",@"HS", @"Flight no", @"Flight no", @"Mon",@"10:00",@"12:00",@"Hyd",@"Mum",@"24:06:16",@"25:06:16",@"Nice", nil];
	  NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"cus1", @"Hyd", @"ABC", @"FDG521",@"HS", @"Flight no", @"Flight no", @"Mon",@"10:00",@"12:00",@"Hyd",@"Mum",@"24:06:16",@"25:06:16",@"Nice", nil];
	  NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"cus1", @"Hyd", @"ABC", @"FDG521",@"HS", @"Flight no", @"Flight no", @"Mon",@"10:00",@"12:00",@"Hyd",@"Mum",@"24:06:16",@"25:06:16",@"Nice", nil];
	  NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"cus1", @"Hyd", @"ABC", @"FDG521",@"HS", @"Flight no", @"Flight no", @"Mon",@"10:00",@"12:00",@"Hyd",@"Mum",@"24:06:16",@"25:06:16",@"Nice", nil];
	  NSArray* invoiceInfo5 = [NSArray arrayWithObjects:@"cus1", @"Hyd", @"ABC", @"FDG521",@"HS", @"Flight no", @"Flight no", @"Mon",@"10:00",@"12:00",@"Hyd",@"Mum",@"24:06:16",@"25:06:16",@"Nice", nil];
	
    
    NSArray* allInfo = [NSArray arrayWithObjects:headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4,invoiceInfo5, nil];
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
        }
        
    }
    
}@end
