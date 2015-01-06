//
//  TagsComponent.m
//  EntitySystem
//
//  Created by Zoee Silcock on 27/09/14.
//

#import "TagsComponent.h"

@implementation TagsComponent

- (id)initWithTags:(NSArray*)tags {
    if ((self = [super init])) {
        self.tags = [NSMutableArray arrayWithArray:tags];
    }
    return self;
}

@end
