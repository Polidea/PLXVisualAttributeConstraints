/*

 Copyright (c) 2013, Kamil Jaworski, Polidea
 All rights reserved.

 mailto: kamil.jaworski@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY KAMIL JAWORSKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KAMIL JAWORSKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#import <Kiwi/Kiwi.h>

#import <CoreData/CoreData.h>

#import "PLXAttributeConstraintVisualFormatAtom.h"
#import "PLAttributeConstraintVisualFormatLexerStub.h"
#import "PLXAttributeConstraintVisualFormatParser.h"
#import "PLXAttributeConstraintVisualFormatLibSpecHelpers.h"

#define EXP_SHORTHAND


SPEC_BEGIN(PLXAttributeConstraintVisualFormatParserSpec)

        describe(@"PLXAttributeConstraintVisualFormatParser", ^{

            __block PLAttributeConstraintVisualFormatLexerStub *lexerMock;
            __block PLXAttributeConstraintVisualFormatParser *parser;
            __block UIView *first;
            __block UIView *second;
            __block NSDictionary *views;

            beforeEach(^{

                first = [[UIView alloc] initWithFrame:CGRectZero];
                second = [[UIView alloc] initWithFrame:CGRectZero];

                views = @{
                        @"first" : first,
                        @"second" : second
                };

                lexerMock = nil;

            });

            context(@"should parse sample input", ^{
                it(@"#1", ^{

                    lexerMock = [PLAttributeConstraintVisualFormatLexerStub stubWithAtomsArray:@[

                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeIdentifier stringData:@"first" startIndex:0],
                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeDot stringData:@"." startIndex:5],
                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeIdentifier stringData:@"top" startIndex:6],

                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeRelationEqual stringData:@"==" startIndex:9],

                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeIdentifier stringData:@"second" startIndex:11],
                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeDot stringData:@"." startIndex:17],
                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeIdentifier stringData:@"top" startIndex:18],

                            [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeEndOfInput stringData:nil startIndex:21],

                    ]];

                    parser = [[PLXAttributeConstraintVisualFormatParser alloc] initWithLexer:lexerMock];

                    NSLayoutConstraint *parsed = [parser parseConstraintWithViews:views];
                    NSLayoutConstraint *reference = [NSLayoutConstraint constraintWithItem:first
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:second
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1 constant:0];

                    BOOL success = [PLXAttributeConstraintVisualFormatLibSpecHelpers isConstraint:parsed equalToConstraint:reference];

                    [[theValue(success) should] equal:theValue(YES)];

                });
            });

        });

        SPEC_END
