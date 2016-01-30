//
//  DetailTableViewController.m
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController {
	BOOL isEditing;
	UIBarButtonItem *rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	isEditing = NO;
	rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditing:)];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	if (self.instruction) {
		self.nameField.text = self.instruction.name;
		self.tagsField.text = self.instruction.tags;
		self.briefTextView.text = self.instruction.brief;
		self.detailTextView.text = self.instruction.detail;
		self.exampleTextView.text = self.instruction.example;
		self.additionalTextView.text = self.instruction.additional;
	}
}

- (void)toggleEditing:(UIBarButtonItem *)sender {
	isEditing = !isEditing;
	if (isEditing) {
		[rightButton setTitle:@"Done"];
		[rightButton setStyle:UIBarButtonItemStyleDone];
		[self.nameField setEnabled:YES];
		[self.tagsField setEnabled:YES];
		[self.briefTextView setEditable:YES];
		[self.detailTextView setEditable:YES];
		[self.exampleTextView setEditable:YES];
		[self.additionalTextView setEditable:YES];
	}
	else {
		[rightButton setTitle:@"Edit"];
		[rightButton setStyle:UIBarButtonItemStylePlain];
		[self.nameField setEnabled:NO];
		[self.tagsField setEnabled:NO];
		[self.briefTextView setEditable:NO];
		[self.detailTextView setEditable:NO];
		[self.exampleTextView setEditable:NO];
		[self.additionalTextView setEditable:NO];
		[self.view endEditing:YES];
		// Save...
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
