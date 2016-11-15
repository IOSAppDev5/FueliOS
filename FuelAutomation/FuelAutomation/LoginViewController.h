//
//  LoginViewController.h
//  FuelAutomation
//
//  Created by Girish Chandra on 15/09/16.
//  Copyright © 2016 ito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtFld;

@end
