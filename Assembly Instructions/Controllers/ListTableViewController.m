//
//  ListTableViewController.m
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController {
	NSMutableArray *instructions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	instructions = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
	
	[SVProgressHUD showWithStatus:@"Loading..."];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ASMInstruction"];
		[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
		NSError *error;
		instructions = [[[AppDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[SVProgressHUD dismiss];
			[self.tableView reloadData];
		});
	});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return instructions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
	
	ASMInstruction *instruction = [instructions objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [instruction.name uppercaseString];
	cell.detailTextLabel.text = instruction.brief;
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		ASMInstruction *instruction = [instructions objectAtIndex:indexPath.row];
		[instructions removeObject:instruction];
		
		NSManagedObjectContext *context = [AppDelegate managedObjectContext];
		[context deleteObject:instruction];
		
		NSError *error;
		if (![context save:&error])
			NSLog(@"Error in saving: %@", error.localizedDescription);
		
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
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
