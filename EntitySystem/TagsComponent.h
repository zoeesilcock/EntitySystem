//
//  TagsComponent.h
//  EntitySystem
//
//  Created by Zoee Silcock on 27/09/14.
//

#import <Foundation/Foundation.h>
#import "Component.h"

@interface TagsComponent : Component

@property (strong) NSMutableArray *tags;

- (id)initWithTags:(NSArray *)tags;

@end
