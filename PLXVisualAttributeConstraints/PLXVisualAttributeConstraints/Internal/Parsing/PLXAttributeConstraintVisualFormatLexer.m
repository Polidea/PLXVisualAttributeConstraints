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


#import "PLXAttributeConstraintVisualFormatLexer.h"
#import "PLXAttributeConstraintVisualFormatAtom.h"

#define PLAttributeConstraintFormatLexerDebuggingLogsEnabled 0

@implementation PLXAttributeConstraintVisualFormatLexer {
    NSUInteger _index;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.text = @"";
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = [text mutableCopy];
    _index = 0;
}

#pragma mark - atoms parsing

- (BOOL)hasNext {
    return _index < _text.length;
}

- (PLXAttributeConstraintVisualFormatAtom *)next {

    if (![self hasNext]) {
        return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeEndOfInput stringData:nil startIndex:_index];
    }
    PLXAttributeConstraintVisualFormatAtom *nextAtom = [self readNextAtom];
    NSAssert(nextAtom != nil, @"Shouldn't return nil.", nil);

#if PLAttributeConstraintFormatLexerDebuggingLogsEnabled
    NSLog(@"PLXAttributeConstraintVisualFormatLexer: returning atom: %@", nextAtom);
#endif

    return nextAtom;

}

- (PLXAttributeConstraintVisualFormatAtom *)readNextAtom {

    PLXAttributeConstraintVisualFormatAtom *atom = nil;

    atom = [self readWhiteSpaceAtom];
    if (atom) return atom;

    atom = [self readOneCharAtoms];
    if (atom) return atom;

    atom = [self readIdentifierAtom];
    if (atom) return atom;

    atom = [self readRelationAtom];
    if (atom) return atom;

    atom = [self readFloatingPointNumberAtom];

    return atom;

}

- (PLXAttributeConstraintVisualFormatAtom *)readRelationAtom {

    unichar c = [_text characterAtIndex:_index];
    NSUInteger initialIndex = _index;

    if (c == '=' || c == '<' || c == '>') {

        BOOL nextCharDoesNotExist = _index + 1 >= _text.length;
        if (nextCharDoesNotExist) {
            NSString *errString = [NSString stringWithFormat:@"At index %@ the beggining of relation was found. Then EOF found (expected: =)",
                                                             @(_index)];
            _index = initialIndex;
            return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeError stringData:errString startIndex:_index];
        }

        unichar secondRelationChar = [_text characterAtIndex:_index + 1];
        BOOL secondRelationCharInvalid = secondRelationChar != '=';
        if (secondRelationCharInvalid) {
            NSString *errString = [NSString stringWithFormat:@"At index %@ the beggining of relation was found. Then on index %@ %c found (expected: =)",
                                                             @(_index), @(_index + 1), secondRelationChar];
            _index = initialIndex;
            return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeError
                                                             stringData:errString
                                                             startIndex:_index + 1];
        }

        _index += 2;

        if (c == '=') {
            return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeRelationEqual stringData:@"==" startIndex:initialIndex];
        } else if (c == '<') {
            return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeRelationLessOrEqual stringData:@"<=" startIndex:initialIndex];
        } else { // >
            return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeRelationGreaterOrEqual stringData:@">=" startIndex:initialIndex];
        }

    }

    return nil;

}

- (PLXAttributeConstraintVisualFormatAtom *)readOneCharAtoms {

    PLXAttributeConstraintVisualFormatAtom *atom = nil;

    atom = [self readPlusAtom];
    if (atom) return atom;

    atom = [self readMinusAtom];
    if (atom) return atom;

    atom = [self readAsteriskAtom];
    if (atom) return atom;

    atom = [self readDotAtom];

    return atom;

}

#pragma mark - specific atoms

- (PLXAttributeConstraintVisualFormatAtom *)readPlusAtom {
    return [self readOneCharAtomWithChar:'+' atomType:PLXAtomTypePlus stringData:@"+"];
}

- (PLXAttributeConstraintVisualFormatAtom *)readMinusAtom {
    return [self readOneCharAtomWithChar:'-' atomType:PLXAtomTypeMinus stringData:@"-"];
}

- (PLXAttributeConstraintVisualFormatAtom *)readAsteriskAtom {
    return [self readOneCharAtomWithChar:'*' atomType:PLXAtomTypeAsterisk stringData:@"*"];
}

- (PLXAttributeConstraintVisualFormatAtom *)readDotAtom {
    return [self readOneCharAtomWithChar:'.' atomType:PLXAtomTypeDot stringData:@"."];
}


// TODO: these 3 functions can be abstracted out somehow, easiest approach is to pass
// start/continue conditions as blocks, but that would be substantially slower... any ideas?

- (PLXAttributeConstraintVisualFormatAtom *)readWhiteSpaceAtom {

    unichar c = [_text characterAtIndex:_index];

    if (isspace(c)) {

        NSUInteger beginOfWhitespaceIndex = _index;
        NSUInteger endOfWhitespaceIndex = _text.length - 1;

        for (NSUInteger i = _index + 1; i < _text.length; i++) {
            if (!isspace([_text characterAtIndex:i])) {
                endOfWhitespaceIndex = i - 1;
                break;
            }
        }

        _index = endOfWhitespaceIndex + 1;

        return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeWhitespace
                                                         stringData:[self textSubstringFromIndex:beginOfWhitespaceIndex
                                                                                         toInder:endOfWhitespaceIndex]
                                                         startIndex:beginOfWhitespaceIndex];

    }

    return nil;

}

- (PLXAttributeConstraintVisualFormatAtom *)readIdentifierAtom {

    unichar c = [_text characterAtIndex:_index];

    BOOL isFirstCharOfIdentifier = (c == '_' || isalpha(c));

    if (isFirstCharOfIdentifier) {

        NSUInteger beginOfIdentifierStringIndex = _index;
        NSUInteger endOfIdentifierStringIndex = _text.length - 1;

        for (NSUInteger i = _index + 1; i < _text.length; i++) {
            unichar currentChar = [_text characterAtIndex:i];
            if (!isalnum(currentChar) && currentChar != '_') {
                endOfIdentifierStringIndex = i - 1;
                break;
            }
        }

        _index = endOfIdentifierStringIndex + 1;

        return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeIdentifier
                                                         stringData:[self textSubstringFromIndex:beginOfIdentifierStringIndex
                                                                                         toInder:endOfIdentifierStringIndex]
                                                         startIndex:beginOfIdentifierStringIndex];

    }

    return nil;

}

- (PLXAttributeConstraintVisualFormatAtom *)readFloatingPointNumberAtom {

    unichar c = [_text characterAtIndex:_index];

    if (isdigit(c)) {

        NSUInteger beginOfNumberStringIndex = _index;
        NSUInteger endOfNumberStringIndex = _text.length - 1;

        BOOL dotSpotted = NO;

        for (NSUInteger i = _index + 1; i < _text.length; i++) {
            unichar currentChar = [_text characterAtIndex:i];
            if (!isdigit(currentChar)) {
                if (!dotSpotted && currentChar == '.') {
                    dotSpotted = YES;
                    continue;
                }
                endOfNumberStringIndex = i - 1;
                break;
            }
        }

        _index = endOfNumberStringIndex + 1;

        return [PLXAttributeConstraintVisualFormatAtom atomWithType:PLXAtomTypeFloatingPointNumber
                                                         stringData:[self textSubstringFromIndex:beginOfNumberStringIndex
                                                                                         toInder:endOfNumberStringIndex]
                                                         startIndex:beginOfNumberStringIndex];

    }

    return nil;

}

- (NSString *)textSubstringFromIndex:(NSUInteger)startIndex toInder:(NSUInteger)toIndex {
    NSAssert(toIndex >= startIndex, @"PLXAttributeConstraintVisualFormatLexer: Invalid indexes. Start < To.", nil);
    return [_text substringWithRange:NSMakeRange(startIndex, toIndex - startIndex + 1)];
}

#pragma mark - helpers

- (PLXAttributeConstraintVisualFormatAtom *)readOneCharAtomWithChar:(unichar)atomChar atomType:(PLXAtomType)atomType stringData:(NSString *)atomStringData {
    unichar c = [_text characterAtIndex:_index];
    if (c == atomChar) {
        NSUInteger atomStartIndex = _index;
        _index += 1;
        return [PLXAttributeConstraintVisualFormatAtom atomWithType:atomType stringData:atomStringData startIndex:atomStartIndex];
    }
    return nil;
}

#pragma mark - checkpoints

- (NSUInteger)currentState {
    return _index;
}

- (void)setCurrentState:(NSUInteger)currentState {
    if (_index != currentState) {
#if PLAttributeConstraintFormatLexerDebuggingLogsEnabled
    NSLog(@"PLXAttributeConstraintVisualFormatLexer: state set to: %@", @(currentState));
#endif
        _index = currentState;
    }
}

#pragma mark -

- (void)omitWhiteSpaces {
    while (_index < _text.length && isspace([_text characterAtIndex:_index])) {
        _index++;
    }
}

@end
