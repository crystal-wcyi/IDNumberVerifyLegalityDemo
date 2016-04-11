//
//  ViewController.m
//  IDNumberVerifyLegalityTest
//
//  Created by crystal on 16/4/11.
//  Copyright © 2016年 crystal. All rights reserved.
//

#import "ViewController.h"
#import "NSString+ValidPersonID.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *identityInputTF;
@property (weak, nonatomic) IBOutlet UILabel *verifyResultLabel;
- (IBAction)vertifyClickAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)vertifyClickAction:(id)sender {
    NSString *textFieldString = self.identityInputTF.text;
    if ([textFieldString length] != 0)
    {
        if ([textFieldString hyb_isValidPersonID])
        {
            self.verifyResultLabel.text = @"输入的身份证号合法";
        }
        else
        {
            self.verifyResultLabel.text = @"输入的身份证号不合法";
        }
    }
    else
    {
        self.verifyResultLabel.text = @"输入的内容为空！";
    }
}
@end
