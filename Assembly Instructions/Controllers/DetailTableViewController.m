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
		self.title = self.instruction.name;
		self.nameField.text = self.instruction.name;
		self.tagsField.text = self.instruction.tags;
		self.briefTextView.text = self.instruction.brief;
		self.detailTextView.text = self.instruction.detail;
		self.exampleTextView.text = self.instruction.example;
		self.additionalTextView.text = self.instruction.additional;
	}
	else {
		[self toggleEditing:rightButton];
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

		[self saveInstruction];
	}
	
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)saveInstruction {
	
	if (self.nameField.text.length < 1) {
		[SVProgressHUD showErrorWithStatus:@"Name too short"];
		return;
	}
	if (self.tagsField.text.length < 1) {
		[SVProgressHUD showErrorWithStatus:@"Tags too short"];
		return;
	}
	
	NSManagedObjectContext *context = [AppDelegate managedObjectContext];
	
	if (!self.instruction)
		self.instruction = [[ASMInstruction alloc] initWithEntity:[NSEntityDescription entityForName:@"ASMInstruction" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
	
	self.instruction.name = self.nameField.text;
	self.instruction.tags = self.tagsField.text;
	self.instruction.brief = self.briefTextView.text;
	self.instruction.detail = self.detailTextView.text;
	self.instruction.example = self.exampleTextView.text;
	self.instruction.additional = self.additionalTextView.text;
	
	NSError *error;
	
	if (![context save:&error])
		NSLog(@"Error in saving: %@", error);
	
	self.title = self.instruction.name;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if (isEditing)
			return 2;
		return 0;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = 44.f;
	CGRect textRect;
	CGSize textSize = CGSizeMake(SWidth - 44.f, 44.f);
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.f]};
	if (indexPath.section == 1) {
		textRect = [self.briefTextView.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
		rowHeight = textRect.size.height;
	}
	else if (indexPath.section == 2) {
		textRect = [self.detailTextView.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
		rowHeight = textRect.size.height;
	}
	else if (indexPath.section == 3) {
		textRect = [self.exampleTextView.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
		rowHeight = textRect.size.height;
	}
	else if (indexPath.section == 4) {
		textRect = [self.additionalTextView.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
		rowHeight = textRect.size.height;
	}
	return MAX(44.f, rowHeight);
}

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
