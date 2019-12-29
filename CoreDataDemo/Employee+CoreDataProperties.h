//
//  Employee+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by Gpf on 2019/12/27.
//  Copyright © 2019 Gpf. All rights reserved.
//
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *birthday;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float height;

@end

NS_ASSUME_NONNULL_END
