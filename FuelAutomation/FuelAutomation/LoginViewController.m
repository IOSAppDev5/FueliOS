//
//  LoginViewController.m
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.userNameTxtFld.delegate = self;
	self.passwordTxtFld.delegate = self;
	
	self.userNameTxtFld.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
	self.passwordTxtFld.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void)viewWillAppear:(BOOL)animated
{
		[self.navigationController setNavigationBarHidden:YES];
	
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[self view] endEditing:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
