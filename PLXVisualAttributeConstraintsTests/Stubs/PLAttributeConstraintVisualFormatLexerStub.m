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


#import "PLAttributeConstraintVisualFormatLexerStub.h"
#import "PLXAttributeConstraintVisualFormatAtom.h"

@implementation PLAttributeConstraintVisualFormatLexerStub {
    NSArray *_atomsArray;
    NSUInteger _currentIndex;
}

- (id)initWithText:(NSString *)text {
    NSAssert(false, @"Mock does not support this init method", nil);
    return nil;
}

+ (instancetype)stubWithAtomsArray:(NSArray *)atomsArray {
    return [[self alloc] initWithAtomsArray:atomsArray];
}

- (instancetype)initWithAtomsArray:(NSArray *)atomsArray {
    self = [super init];
    if (self) {
        _atomsArray = atomsArray;
        _currentIndex = 0;
    }
    return self;
}

#pragma mark -

- (PLXAttributeConstraintVisualFormatAtom *)next {
    if ([self hasNext]) {
        return _atomsArray[_currentIndex++];
    }
    return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeEndOfInput stringData:nil startIndex:1000];
}

- (BOOL)hasNext {
    return _currentIndex < _atomsArray.count;
}

- (void)omitWhiteSpaces {
    while([self hasNext]) {
        PLXAttributeConstraintVisualFormatAtom *atom = _atomsArray[_currentIndex];
        if(atom.atomType != PLXAtomTypeWhitespace)
            break;
        _currentIndex++;
    }
}

@end
