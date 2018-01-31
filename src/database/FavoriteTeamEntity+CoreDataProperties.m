//
//  FavoriteTeamEntity+CoreDataProperties.m
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "FavoriteTeamEntity+CoreDataProperties.h"

@implementation FavoriteTeamEntity (CoreDataProperties)

+ (NSFetchRequest<FavoriteTeamEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FavoriteTeamEntity"];
}

@dynamic idCompetitionServer;
@dynamic isFavorite;
@dynamic teamName;

@end
