//
//   Copyright 2014 Slack Technologies, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "UIView+SLKAdditions.h"

#import "SLKUIConstants.h"

NSTimeInterval slk_durationForBounceParameter(BOOL bounce) {
    return bounce ? 0.65 : 0.2;
}

@implementation UIView (SLKAdditions)

- (void)slk_animateLayoutIfNeededWithBounce:(BOOL)bounce options:(UIViewAnimationOptions)options animations:(void (^)(void))animations
{
    [self slk_animateLayoutIfNeededWithBounce:bounce options:options animations:animations completion:NULL];
}

- (void)slk_animateLayoutIfNeededWithBounce:(BOOL)bounce options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    [self slk_animateLayoutIfNeededWithDuration:slk_durationForBounceParameter(bounce) bounce:bounce options:options animations:animations completion:completion];
}

- (void)slk_animateLayoutIfNeededWithDuration:(NSTimeInterval)duration bounce:(BOOL)bounce options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    [self slk_animateWithDuration:duration
                           bounce:bounce
                          options:options
                       animations:^{
                           if (animations) {
                               animations();
                           }
												 
                           [self layoutIfNeeded];
                       } completion:completion];
}

- (void)slk_animateWithBounce:(BOOL)bounce options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    [self slk_animateWithDuration:slk_durationForBounceParameter(bounce) bounce:bounce options:options animations:animations completion:completion];
}

- (void)slk_animateWithDuration:(NSTimeInterval)duration bounce:(BOOL)bounce options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    if (bounce) {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.7
                            options:options
                         animations:animations
                         completion:completion];
    }
    else {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:animations
                         completion:completion];
    }
}

- (NSArray<__kindof NSLayoutConstraint *> *)slk_constraintsForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", attribute];
    return [self.constraints filteredArrayUsingPredicate:predicate];
}

- (NSLayoutConstraint *)slk_constraintForAttribute:(NSLayoutAttribute)attribute firstItem:(id)first secondItem:(id)second
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d AND firstItem = %@ AND secondItem = %@", attribute, first, second];
    return [[self.constraints filteredArrayUsingPredicate:predicate] firstObject];
}

@end
