//
//  ListTableViewController.m
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "ListTableViewController.h"
#import "DetailTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController {
	NSMutableArray *instructions;
	BOOL searching;
	UIBarButtonItem *deleteButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	instructions = [NSMutableArray new];
	[self fetchInstructions];
	
	deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSelectedRows:)];
	
	self.clearsSelectionOnViewWillAppear = NO;
	
	// Fix editing problems...
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	// TO DO - Add sections?
}

- (void)viewDidAppear:(BOOL)animated {

	if (searching)
		[self filterInstructions];
	else
		[self fetchInstructions];
	
}

- (void)fetchInstructions {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ASMInstruction"];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	NSError *error;
	instructions = [[[AppDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

	[self.tableView reloadData];
	
}

- (void)filterInstructions {
	
	[self fetchInstructions];

	[instructions filterUsingPredicate:[NSPredicate predicateWithFormat:@"tags contains[cd] %@ OR brief contains[cd] %@", self.searchBar.text, self.searchBar.text]];
	
	[self.tableView reloadData];
	
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (searching)
		return [NSString stringWithFormat:@"%li INSTRUCTIONS.", instructions.count];
	return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (searching)
		return @"";
	return [NSString stringWithFormat:@"%li INSTRUCTIONS.", instructions.count];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (self.isEditing) {
//		if ([tableView indexPathsForSelectedRows].count > 0)
//			self.navigationItem.rightBarButtonItem = deleteButton;
//	}
//	else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
//		self.navigationItem.rightBarButtonItem = self.addBarButton;
//	}
}

#pragma mark - Delete multiple

- (void)deleteSelectedRows:(id)sender {
	
	NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
	
	NSManagedObjectContext *context = [AppDelegate managedObjectContext];
	
	UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		
		for (NSInteger i = 0; i < indexPaths.count; ++i) {
			NSIndexPath *indexPath = [indexPaths objectAtIndex:i];
			ASMInstruction *instruction = [instructions objectAtIndex:indexPath.row];
			[instructions removeObject:instruction];
			[context deleteObject:instruction];
		}
		
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error in saving: %@", error.localizedDescription);
		}
		
		self.navigationItem.rightBarButtonItem = self.addBarButton;
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView reloadData];
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete?" message:[NSString stringWithFormat:@"Are you sure you want to delete %li items. This action is irreversible.", indexPaths.count] preferredStyle:UIAlertControllerStyleActionSheet];
	[alertController addAction:deleteAction];
	[alertController addAction:cancelAction];
	
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchBar.text.length > 0) {
		searching = YES;
		[self filterInstructions];
	}
	else {
		searching = NO;
		[self fetchInstructions];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self fetchInstructions];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.searchBar resignFirstResponder];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if (self.isEditing)
		return NO;
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"instructionDetailSegue"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		ASMInstruction *instruction = [instructions objectAtIndex:indexPath.row];
		DetailTableViewController *dtvc = [segue destinationViewController];
		dtvc.instruction = instruction;
	}
}


@end
