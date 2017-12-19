//
//  TeamEntity+CoreDataProperties.m
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 19/12/17.
//  Copyright © 2017 cice. All rights reserved.
//
//

#import "TeamEntity+CoreDataProperties.h"

@implementation TeamEntity (CoreDataProperties)

+ (NSFetchRequest<TeamEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TeamEntity"];
}

@dynamic teamName;
@dynamic isFavorite;
@dynamic competition;

@end
