//
//  ScheduleFlightViewController.m
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//

#import "ScheduleFlightViewController.h"
#import "AFNetworking.h"
#import "Services.h"
#import "JGProgressHUD.h"

@interface ScheduleFlightViewController ()
{
	NSString *isSelected;
	UIView *viewforPicker;
	NSMutableArray *airportArray;
	NSMutableArray *customertArray;
	NSDateFormatter *df;
	JGProgressHUD *hud;
	NSMutableArray *airLinesData;
	NSMutableArray *airportData;
	NSMutableArray *flightScheduleData;
	
	NSString *documentsDirectory;//path of csv.
}

@end

@implementation ScheduleFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"View flight schedule";
	
	//airportArray = [[NSMutableArray alloc] init];
	//customertArray = [[NSMutableArray alloc] init];
	df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM-dd-yyyy"];
	
	
	
	
 // Add some data for demo purposes.
// [airportArray addObject:@"Hyderabad"];
// [airportArray addObject:@"Mumbai"];
// [airportArray addObject:@"Banglore"];
// [airportArray addObject:@"Chennai"];
// [airportArray addObject:@"New Delhi"];
	
// [customertArray addObject:@"Indigo"];
// [customertArray addObject:@"Airlines"];
// [customertArray addObject:@"Jet Airways"];
// [customertArray addObject:@"Spice"];
// [customertArray addObject:@"Indian"];
	
	[self getAddressListJsonRequest:@"GetAirLinesData"];
	[self getAddressListJsonRequest:@"GetAirPortsData"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startDateBtnActn:(id)sender{
	
	isSelected = @"startbutton";
	[self datepickerimpltn];
	
}

- (IBAction)endDateBtnActn:(id)sender {
	
	isSelected = @"endbutton";
	[self datepickerimpltn];
}

- (IBAction)pickAirportBtnActn:(id)sender {
	
	isSelected = @"pickairport";
	[self datepickerimpltn];
	
}

- (IBAction)pickCustomerBtnActn:(id)sender {
	
	isSelected = @"pickcustomer";
	[self datepickerimpltn];
}

-(void)datepickerimpltn{
	
	[viewforPicker removeFromSuperview];
	
	
	
	
 viewforPicker = [[UIView alloc]init];
	
 viewforPicker.backgroundColor = [UIColor whiteColor];
	
	
	
	// button done on datepicker
	
	UIButton *dateDoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
	dateDoneBtn.backgroundColor = [UIColor blackColor];
	dateDoneBtn.alpha = 0.6;
	[dateDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
	[dateDoneBtn addTarget:self action:@selector(closeDatepicker) forControlEvents:UIControlEventTouchUpInside];
	[viewforPicker addSubview:dateDoneBtn];
	
	if ([isSelected isEqualToString:@"startbutton"]||[isSelected isEqualToString:@"endbutton"])
	{
		
	
	// datepicker on view
	_datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40 , [UIScreen mainScreen].bounds.size.width, 300)];
	_datePicker.datePickerMode = UIDatePickerModeDate;
	_datePicker.date = [NSDate date];
	//_datePicker.maximumDate=[NSDate date];
	
	
	
	if ([isSelected isEqualToString:@"startbutton"]) {
		
		self.startDateTXtFld.text = [NSString stringWithFormat:@"%@",
									 [df stringFromDate:_datePicker.date]];
	}
	else if([isSelected isEqualToString:@"endbutton"])
	{
		
		NSString *dateStr = self.startDateTXtFld.text;
	
		NSDate *date = [df dateFromString:dateStr];
		NSDate *minDate = date;
		[_datePicker setMinimumDate:minDate];
		
		self.endDateTxtFld.text = [NSString stringWithFormat:@"%@",
								   [df stringFromDate:_datePicker.date]];
	}
	
	
	
	[self.datePicker addTarget:self
						action:@selector(LabelChange:)
			  forControlEvents:UIControlEventValueChanged];
	_datePicker.backgroundColor = [UIColor whiteColor];
	[viewforPicker addSubview:_datePicker];
		
	}// end date picker
	
	else if ([isSelected isEqualToString:@"pickairport"]||[isSelected isEqualToString:@"pickcustomer"])
	{
		_airPortCustomerPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40 , [UIScreen mainScreen].bounds.size.width, 300)];
		_airPortCustomerPicker.delegate = self;
		
		_airPortCustomerPicker.dataSource = self;
		
		_airPortCustomerPicker.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
		
		_airPortCustomerPicker.showsSelectionIndicator = YES;
		
		_airPortCustomerPicker.backgroundColor = [UIColor clearColor];
		
		[_airPortCustomerPicker selectRow:0 inComponent:0 animated:YES];
		
		if ([isSelected isEqualToString:@"pickairport"])
		{
			self.pickAirportTxtFld.text =[airportArray objectAtIndex:0];
		}
		else if ([isSelected isEqualToString:@"pickcustomer"])
		{
			
			self.pickCustomerTxtFld.text =  [customertArray objectAtIndex:0];
		}
		
		[viewforPicker addSubview:_airPortCustomerPicker];
		
		
	}
	
	// view for date picker
	
	[UIView animateWithDuration:0.5 animations:^{
		viewforPicker.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-300 , [UIScreen mainScreen].bounds.size.width, 300);
		
	} completion:^(BOOL finished) {
		[self.view addSubview:viewforPicker];
	}];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	
	return 1;
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	NSInteger Coun;
	
	if ([isSelected isEqualToString:@"pickairport"])
	{
		Coun = [airportArray count];
	}
	else if ([isSelected isEqualToString:@"pickcustomer"])
	{
		Coun = [customertArray count];
	}
	
	return Coun;
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	
	if ([isSelected isEqualToString:@"pickairport"])
	{
		return  [airportArray objectAtIndex:row];
	}
	else
		return  [customertArray objectAtIndex:row];
	
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([isSelected isEqualToString:@"pickairport"])
	{
		  self.pickAirportTxtFld.text =[airportArray objectAtIndex:row];
	}
	else
		
		self.pickCustomerTxtFld.text =  [customertArray objectAtIndex:row];

}


-(void)closeDatepicker
{
	[UIView animateWithDuration:0.5 animations:^{
		viewforPicker.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height+300 , [UIScreen mainScreen].bounds.size.width, 300);
		
	} completion:^(BOOL finished) {
		[viewforPicker removeFromSuperview];
		
		[self validateDate];
		
	}];
}




- (void)LabelChange:(id)sender{
	
	[df setDateFormat:@"MM-dd-yyyy"];
	if ([isSelected isEqualToString:@"startbutton"]) {
		
		self.startDateTXtFld.text = [NSString stringWithFormat:@"%@",
									 [df stringFromDate:_datePicker.date]];
	}
	else if([isSelected isEqualToString:@"endbutton"])
	{
		
		NSString *dateStr = self.startDateTXtFld.text;
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MM-dd-yyyy"];
		NSDate *date = [dateFormat dateFromString:dateStr];
		NSDate *minDate = date;
		[_datePicker setMinimumDate:minDate];
		self.endDateTxtFld.text = [NSString stringWithFormat:@"%@",
									 [df stringFromDate:_datePicker.date]];
	}

	
	NSLog(@"%@",[NSString stringWithFormat:@"%@",
				 [df stringFromDate:_datePicker.date]]);
	
}

-(void)validateDate
{
	//start date
	
	NSString *dateStr = self.startDateTXtFld.text;
	NSDate *date = [df dateFromString:dateStr];
	NSDate *startDateTovalidate = date;
	
	//end date
	NSString *dateend = self.endDateTxtFld.text;
	NSDate *dateEnd = [df dateFromString:dateend];
	NSDate *endDateTovalidate = dateEnd;
	
	if ([startDateTovalidate compare:endDateTovalidate] == NSOrderedDescending) {
		NSLog(@"date1 is later than date2");
		
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Start date should be before the end date." preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		[alertController addAction:ok];
		
		[self presentViewController:alertController animated:YES completion:nil];
		
	} else if ([startDateTovalidate compare:endDateTovalidate] == NSOrderedAscending) {
		NSLog(@"date1 is earlier than date2");
		
		
		
	} else {
		NSLog(@"dates are the same");
		
	}
	
	
}

-(void) getAddressListJsonRequest:(NSString *)method {
	
	[self showProgressHud];
	
	NSURL *URL = [NSURL URLWithString:[ NSString stringWithFormat:@"%@%@",urlString,method]];
	
	// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString *userId = [defaults objectForKey:@"userID"];
	
	NSDictionary *params = @{@"type": @"GET"};
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	
	[manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
		
		if (responseObject) {
//			if ([[responseObject valueForKey:@"Status"] isEqualToString:@"Success"])
//			{
			
			
				NSLog(@"%@",responseObject);
			
			if ([method isEqualToString:@"GetAirLinesData"]) {
				
				airLinesData = [[NSMutableArray alloc] initWithArray:responseObject];
				customertArray =[[NSMutableArray alloc] initWithArray:[airLinesData valueForKey:@"CustomerName"]];
				NSLog(@"addressid");
				[self hideProgressHud];

				
			}
			else
			{
				airportData = [[NSMutableArray alloc] initWithArray:responseObject];
				airportArray =[[NSMutableArray alloc] initWithArray:[airportData valueForKey:@"AirPortName"]];
				NSLog(@"addressid");
				[self hideProgressHud];

				
			}
				
		
			
			
		//	}
//			else
//				
//			{
//				[self hideProgressHud];
//				
//				UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert " message:[responseObject valueForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
//				
//				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//				[alertController addAction:ok];
//				
//				
//			}
			
			
			
		}
	[self hideProgressHud];
	}
	 
	 
		  failure:^(NSURLSessionTask *operation, NSError *error) {
			  NSLog(@"Error: %@", error);
			 [self hideProgressHud];
			  
			  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, try again" preferredStyle:UIAlertControllerStyleAlert];
			  
			  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
			  [alertController addAction:ok];
			  
			  [self presentViewController:alertController animated:YES completion:nil];
			  
			  
		  }];
	[self hideProgressHud];
	
}


- (IBAction)flightScheduleDataBtnactn:(id)sender {
	
	if (self.pickCustomerTxtFld.text.length==0|| self.pickAirportTxtFld.text.length==0|| self.startDateTXtFld.text.length==0|| self.endDateTxtFld.text.length==0) {
		
		
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Fields" message:@"All fields are mandatory" preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		[alertController addAction:ok];
		
		[self presentViewController:alertController animated:YES completion:nil];
		
		
	}
	
	else
	{
		
		//start date
		
		NSString *dateStr = self.startDateTXtFld.text;
		NSDate *date = [df dateFromString:dateStr];
		NSDate *startDateTovalidate = date;
		
		//end date
		NSString *dateend = self.endDateTxtFld.text;
		NSDate *dateEnd = [df dateFromString:dateend];
		NSDate *endDateTovalidate = dateEnd;
		
		if ([startDateTovalidate compare:endDateTovalidate] == NSOrderedDescending) {
			NSLog(@"date1 is later than date2");
			
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Start date should be before the end date." preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
			[alertController addAction:ok];
			
			[self presentViewController:alertController animated:YES completion:nil];
			
		}
		
		
		
		else {
			
			[self showProgressHud];
			
			NSURL *URL = [NSURL URLWithString:[ NSString stringWithFormat:@"%@GetFlightScheduleData",urlString]];
			
			
//			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//			NSString *userId = [defaults objectForKey:@"userID"];
			
			
			NSDictionary *params = @{@"AirLineID":@"0",@"AirPortID": @"0" ,@"FromDate":self.startDateTXtFld.text,@"ToDate":self.endDateTxtFld.text,@"ResourceID":@""};
			
			
			AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			
			[manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
				NSLog(@"JSON: %@", responseObject);
				if  (responseObject) {
					
				//	if ([[responseObject valueForKey:@"Status"] isEqualToString:@"Success"]) {
					
					if ([(NSMutableArray *)responseObject count]>0) {
						
						flightScheduleData = [[NSMutableArray alloc] initWithArray:responseObject];
					}
						
					else
					{
						
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, No data found" preferredStyle:UIAlertControllerStyleAlert];
						
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
						[alertController addAction:ok];
						
						[self presentViewController:alertController animated:YES completion:nil];

					}
						
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Congratulations" message:@"test" preferredStyle:UIAlertControllerStyleAlert];
						
						[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
							
						}]];
						
						dispatch_async(dispatch_get_main_queue(), ^ {
							[self presentViewController:alertController animated:YES completion:nil];
						});
						
										
					
					[self hideProgressHud];
				}
				
			}
				  failure:^(NSURLSessionTask *operation, NSError *error) {
					  NSLog(@"Error: %@", error);
					  
					  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, try again" preferredStyle:UIAlertControllerStyleAlert];
					  
					  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
					  [alertController addAction:ok];
					  
					  [self presentViewController:alertController animated:YES completion:nil];
					  
					  
				  }];
			
			[self hideProgressHud];
		}
	}
	
}


-(void)showProgressHud {
	
	hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
	hud.textLabel.text = @"Loading";
	[hud showInView:self.view];
}

-(void)hideProgressHud {
	
	[hud dismiss];
}

// test csv

-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
}

- (IBAction)saveAsFileAction:(id)sender {
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
		[[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
		NSLog(@"Route creato");
	}
	
	NSString *writeString = @""; //don't worry about the capacity, it will expand as necessary
	
	for (int i=0; i<[flightScheduleData count]>0; i++) {
		NSString *allStrng = [NSString stringWithFormat:@"%@, %@, %@, %@, %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@, \n",[[flightScheduleData objectAtIndex:i]valueForKey:@"CustomerName"],[[flightScheduleData objectAtIndex:i]valueForKey:@"AirPortName"],[[flightScheduleData objectAtIndex:i]valueForKey:@"TailNo"],[[flightScheduleData objectAtIndex:i]valueForKey:@"AirCraftType"],[[flightScheduleData objectAtIndex:i]valueForKey:@"FlighType"],[[flightScheduleData objectAtIndex:i]valueForKey:@"ArrFlightNo"],[[flightScheduleData objectAtIndex:i]valueForKey:@"DepFlightNo"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsMon"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsThe"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsWed"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsThu"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsFri"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsSat"],[[flightScheduleData objectAtIndex:i]valueForKey:@"IsSun"],[[flightScheduleData objectAtIndex:i]valueForKey:@"ArrTime"],[[flightScheduleData objectAtIndex:i]valueForKey:@"DepTime"],[[flightScheduleData objectAtIndex:i]valueForKey:@"FromAirport"],[[flightScheduleData objectAtIndex:i]valueForKey:@"ToAirport"]]; //the \n will put a newline in
		writeString = [writeString stringByAppendingString:allStrng];
	}
	
	//Moved this stuff out of the loop so that you write the complete string once and only once.
	NSLog(@"writeString :%@",writeString);
	
	NSFileHandle *handle;
	handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
	//say to handle where's the file fo write
	[handle truncateFileAtOffset:[handle seekToEndOfFile]];
	//position handle cursor to the end of file
	[handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
	
	}







@end
