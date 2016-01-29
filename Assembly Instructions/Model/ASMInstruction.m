//
//  ASMInstruction.m
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "ASMInstruction.h"

@implementation ASMInstruction

// Insert code here to add functionality to your managed object subclass

- (NSManagedObject *)initWithEntity:(NSEntityDescription *)entity withDict:(id)dict insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	
	if (self) {
		self.name = [NSString stringWithFormat:@"%@", dict[@"Name"]];
		NSArray *tags = [NSArray arrayWithObject:dict[@"Alias"]];
		self.tags = [tags componentsJoinedByString:@" "];
		self.brief = [NSString stringWithFormat:@"%@", dict[@"Brief"]];
		self.detail = [NSString stringWithFormat:@"%@", dict[@"Description"]];
	}
	
	return self;
}

@end
