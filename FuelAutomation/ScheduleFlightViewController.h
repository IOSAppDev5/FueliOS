//
//  ScheduleFlightViewController.h
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleFlightViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *startDateTXtFld;
@property (strong, nonatomic) IBOutlet UITextField *endDateTxtFld;

@property (strong, nonatomic) IBOutlet UITextField *pickAirportTxtFld;

@property (strong, nonatomic) IBOutlet UITextField *pickCustomerTxtFld;

@property (strong, nonatomic) UIToolbar *keyboardToolbar;


@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *airPortCustomerPicker;

- (IBAction)startDateBtnActn:(id)sender;
- (IBAction)endDateBtnActn:(id)sender;
- (IBAction)pickAirportBtnActn:(id)sender;
- (IBAction)pickCustomerBtnActn:(id)sender;

@end
