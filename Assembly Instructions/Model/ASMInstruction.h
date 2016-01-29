//
//  ASMInstruction.h
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASMInstruction : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (NSManagedObject *)initWithEntity:(NSEntityDescription *)entity withDict:(id)dict insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "ASMInstruction+CoreDataProperties.h"
