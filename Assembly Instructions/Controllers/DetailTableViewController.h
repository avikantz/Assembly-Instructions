//
//  DetailTableViewController.h
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UITextView *briefTextView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *exampleTextView;
@property (weak, nonatomic) IBOutlet UITextView *additionalTextView;

@property (nonatomic, strong) ASMInstruction *instruction;

@end
