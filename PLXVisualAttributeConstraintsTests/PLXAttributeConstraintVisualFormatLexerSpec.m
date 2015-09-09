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

#define EXP_SHORTHAND

#import "PLXAttributeConstraintVisualFormatLexer.h"
#import "PLXAttributeConstraintVisualFormatAtom.h"
#import "PLXAttributeConstraintVisualFormatLexerSpecHelpers.h"

SPEC_BEGIN(PLXAttributeConstraintVisualFormatLexerSpec)

        describe(@"PLXAttributeConstraintVisualFormatLexer", ^{

            __block PLXAttributeConstraintVisualFormatLexer *lexer;

            beforeEach(^{
                lexer = [[PLXAttributeConstraintVisualFormatLexer alloc] init];
            });

            context(@"always", ^{
                it(@"should be awesome", ^{
                    BOOL awesome = YES; // Damn it is!
                    [[theValue(awesome) should] equal:theValue(YES)];
                });
            });

            context(@"parsing empty input string", ^{
                beforeAll(^{
                    lexer.text = @"";
                });
                it(@"should return EOF atom", ^{
                    PLXAttributeConstraintVisualFormatAtom *atom = [lexer next];
                    [[theValue(atom.atomType) should] equal:theValue(PLXAtomTypeEndOfInput)];
                });
                it(@"should keep returning EOF atom", ^{
                    PLXAttributeConstraintVisualFormatAtom *atom = nil;
                    for (int j = 0; j < 5; j++) {
                        atom = [lexer next];
                        [[theValue(atom.atomType) should] equal:theValue(PLXAtomTypeEndOfInput)];
                    }
                });
            });

            context(@"parsing samples", ^{

                it(@"should return all supported atoms", ^{

                    lexer = [[PLXAttributeConstraintVisualFormatLexer alloc] initWithText:@" . <= == >= identifier + - 23.45 56 ident2 *"];

                    BOOL success = [PLXAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                             returnsAtomsTypesAndStringDataInOrder:
                                                                     @[
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(0)],
                                                                             @[@(PLXAtomTypeDot), @".", @(1)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(2)],
                                                                             @[@(PLXAtomTypeRelationLessOrEqual), @"<=", @(3)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(5)],
                                                                             @[@(PLXAtomTypeRelationEqual), @"==", @(6)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(8)],
                                                                             @[@(PLXAtomTypeRelationGreaterOrEqual), @">=", @(9)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(11)],
                                                                             @[@(PLXAtomTypeIdentifier), @"identifier", @(12)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(22)],
                                                                             @[@(PLXAtomTypePlus), @"+", @(23)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(24)],
                                                                             @[@(PLXAtomTypeMinus), @"-", @(25)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(26)],
                                                                             @[@(PLXAtomTypeFloatingPointNumber), @"23.45", @(27)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(32)],
                                                                             @[@(PLXAtomTypeFloatingPointNumber), @"56", @(33)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(35)],
                                                                             @[@(PLXAtomTypeIdentifier), @"ident2", @(36)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(42)],
                                                                             @[@(PLXAtomTypeAsterisk), @"*", @(43)],
                                                                             @[@(PLXAtomTypeEndOfInput), [NSNull null], @(44)]
                                                                     ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });
                
                it(@"should return correct atoms #1", ^{

                    lexer = [[PLXAttributeConstraintVisualFormatLexer alloc] initWithText:@" control1.attr1  <= control2.attr56  "];

                    BOOL success = [PLXAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                             returnsAtomsTypesAndStringDataInOrder:
                                                                     @[
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(0)],
                                                                             @[@(PLXAtomTypeIdentifier), @"control1", @(1)],
                                                                             @[@(PLXAtomTypeDot), @".", @(9)],
                                                                             @[@(PLXAtomTypeIdentifier), @"attr1", @(10)],
                                                                             @[@(PLXAtomTypeWhitespace), @"  ", @(15)],
                                                                             @[@(PLXAtomTypeRelationLessOrEqual), @"<=", @(17)],
                                                                             @[@(PLXAtomTypeWhitespace), @" ", @(19)],
                                                                             @[@(PLXAtomTypeIdentifier), @"control2", @(20)],
                                                                             @[@(PLXAtomTypeDot), @".", @(28)],
                                                                             @[@(PLXAtomTypeIdentifier), @"attr56", @(29)],
                                                                             @[@(PLXAtomTypeWhitespace), @"  ", @(35)],
                                                                             @[@(PLXAtomTypeEndOfInput), [NSNull null], @(37)],
                                                                     ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"should return correct atoms #2", ^{

                    lexer = [[PLXAttributeConstraintVisualFormatLexer alloc] initWithText:@"a.b.<===>=234.65<=qwer"];

                    BOOL success = [PLXAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                             returnsAtomsTypesAndStringDataInOrder:
                                                                     @[
                                                                             @[@(PLXAtomTypeIdentifier), @"a"],
                                                                             @[@(PLXAtomTypeDot), @"."],
                                                                             @[@(PLXAtomTypeIdentifier), @"b"],
                                                                             @[@(PLXAtomTypeDot), @"."],
                                                                             @[@(PLXAtomTypeRelationLessOrEqual), @"<="],
                                                                             @[@(PLXAtomTypeRelationEqual), @"=="],
                                                                             @[@(PLXAtomTypeRelationGreaterOrEqual), @">="],
                                                                             @[@(PLXAtomTypeFloatingPointNumber), @"234.65"],
                                                                             @[@(PLXAtomTypeRelationLessOrEqual), @"<="],
                                                                             @[@(PLXAtomTypeIdentifier), @"qwer"],
                                                                             @[@(PLXAtomTypeEndOfInput), [NSNull null]],
                                                                     ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });

                it(@"should return correct identifiers atoms", ^{

                    lexer = [[PLXAttributeConstraintVisualFormatLexer alloc] initWithText:@"_ident1 ident1 abc abc_abc __"];

                    BOOL success = [PLXAttributeConstraintVisualFormatLexerSpecHelpers assertLexer:lexer
                                                             returnsAtomsTypesAndStringDataInOrder:
                                                                     @[
                                                                             @[@(PLXAtomTypeIdentifier), @"_ident1"],
                                                                             @[@(PLXAtomTypeWhitespace), @" "],
                                                                             @[@(PLXAtomTypeIdentifier), @"ident1"],
                                                                             @[@(PLXAtomTypeWhitespace), @" "],
                                                                             @[@(PLXAtomTypeIdentifier), @"abc"],
                                                                             @[@(PLXAtomTypeWhitespace), @" "],
                                                                             @[@(PLXAtomTypeIdentifier), @"abc_abc"],
                                                                             @[@(PLXAtomTypeWhitespace), @" "],
                                                                             @[@(PLXAtomTypeIdentifier), @"__"],
                                                                             @[@(PLXAtomTypeEndOfInput), [NSNull null]],
                                                                     ]
                    ];

                    [[theValue(success) should] equal:theValue(YES)];

                });


            });

        });

        SPEC_END
