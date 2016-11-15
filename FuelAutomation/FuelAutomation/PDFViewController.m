//
//  PdfViewController.h
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//
//

#import "PDFViewController.h"
#import "CoreText/CoreText.h"
#import "PDFRenderer.h"

@implementation PDFViewController
{
	NSString *filePath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{ 
    NSString* fileName = [self getPDFFileName];

    [PDFRenderer drawPDF:fileName];
    
//	NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//	[[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [self showPDFFile];
	
	UIBarButtonItem *sharePdf = [[UIBarButtonItem alloc]
								   initWithTitle:@"Share"
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(sharePdf)];
	self.navigationItem.rightBarButtonItem = sharePdf;
	
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showPDFFile
{
    NSString* pdfFileName = [self getPDFFileName];
   
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height)];
	
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    

    [self.view addSubview:webView];
	
	// save Pdf
	
	NSData *dataPdf = [NSData dataWithContentsOfURL:url];
	
	//Get path directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Create PDF_Documents directory
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
	[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	
	filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"Flight Schedule"];
	
	[dataPdf writeToFile:filePath atomically:YES];
	
	
	
	
   
}

-(NSString*)getPDFFileName
{
    NSString* fileName = @"Flight Schedule.PDF";
    
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;

}
-(void)sharePdf
{
	// share Pdf
	NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
	UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Test", pdfData] applicationActivities:nil];
	
	[self presentViewController:activityViewController animated:YES completion:nil];
	
}


						  
						  


@end
