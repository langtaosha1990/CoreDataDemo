//
//  Employee+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by Gpf on 2019/12/27.
//  Copyright © 2019 Gpf. All rights reserved.
//
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
}

@dynamic birthday;
@dynamic name;
@dynamic height;

@end
