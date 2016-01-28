//
//  ASMInstruction+CoreDataProperties.h
//  Assembly Instructions
//
//  Created by Avikant Saini on 1/28/16.
//  Copyright © 2016 avikantz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ASMInstruction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASMInstruction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *tags;
@property (nullable, nonatomic, retain) NSString *brief;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *additional;
@property (nullable, nonatomic, retain) NSString *example;

@end

NS_ASSUME_NONNULL_END
