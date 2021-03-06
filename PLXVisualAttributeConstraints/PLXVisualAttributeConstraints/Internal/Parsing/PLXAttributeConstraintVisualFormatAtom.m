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


#import "PLXAttributeConstraintVisualFormatAtom.h"

@implementation PLXAttributeConstraintVisualFormatAtom {

}

+ (NSString *)atomNameForAtomType:(PLXAtomType)type {
    switch (type) {
        case PLXAtomTypeEndOfInput:
            return @"EndOfInput";
        case PLXAtomTypeError:
            return @"PLXAtomTypeError";
        case PLXAtomTypePlus:
            return @"PLXAtomTypePlus";
        case PLXAtomTypeMinus:
            return @"PLXAtomTypeMinus";
        case PLXAtomTypeAsterisk:
            return @"PLXAtomTypeAsterisk";
        case PLXAtomTypeFloatingPointNumber:
            return @"PLXAtomTypeFloatingPointNumber";
        case PLXAtomTypeRelationEqual:
            return @"PLXAtomTypeRelationEqual";
        case PLXAtomTypeRelationLessOrEqual:
            return @"PLXAtomTypeRelationLessOrEqual";
        case PLXAtomTypeRelationGreaterOrEqual:
            return @"PLXAtomTypeRelationGreaterOrEqual";
        case PLXAtomTypeIdentifier:
            return @"PLXAtomTypeIdentifier";
        case PLXAtomTypeDot:
            return @"PLXAtomTypeDot";
        case PLXAtomTypeWhitespace:
            return @"PLXAtomTypeWhitespace";
        default:
            return @"Unknown atom type";
    }
}

- (id)initWithAtomType:(PLXAtomType)atomType stringData:(NSString *)stringData startIndex:(NSUInteger)startIndex {
    self = [super init];
    if (self) {
        _atomType = atomType;
        _stringData = stringData;
        _startIndex = startIndex;
    }

    return self;
}

+ (id)atomWithType:(PLXAtomType)atomType stringData:(NSString *)stringData startIndex:(NSUInteger)startIndex {
    return [[self alloc] initWithAtomType:atomType stringData:stringData startIndex:startIndex];
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"Atom: %@ (type: %@ [%@] index: %@)",
            _stringData,
            [PLXAttributeConstraintVisualFormatAtom atomNameForAtomType:_atomType],
            @(_atomType),
            @(_startIndex)];
}

@end
