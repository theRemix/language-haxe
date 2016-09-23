
###
fs = require 'fs'
path = require 'path'

TextEditor = null

buildTextEditor = (params) ->
    if atom.workspace.buildTextEditor?
        atom.workspace.buildTextEditor(params)
    else
        TextEditor ?= require('atom').TextEditor
        new TextEditor(params)
###

describe "Haxe Grammar", ->

    grammar = null

    beforeEach ->
        waitsForPromise ->
            atom.packages.activatePackage("language-haxe")
        runs ->
            grammar = atom.grammars.grammarForScopeName("source.haxe")

    it "parses the grammar", ->
        expect(grammar).toBeTruthy()
        expect(grammar.scopeName).toBe "source.haxe"
        expect(grammar.name).toBe "Haxe"
        expect(grammar.fileTypes[0]).toBe "hx"

    describe "keywords", ->
        keywords = ['break','catch','continue','do']
        for keyword in keywords
            it "tokenizes the #{keyword} keyword", ->
                {tokens} = grammar.tokenizeLine(keyword)
                #expect(tokens[0]).toEqual value: '$break', scopes: ['source.js']
                #expect(tokens[0]).toEqual value: keyword, scopes: ['source.haxe','keyword.control.haxe.flow-control.2']

    describe "numbers", ->
        it "tokenizes hexadecimals", ->
            {tokens} = grammar.tokenizeLine('0x1D306')
            expect(tokens[0]).toEqual value: '0x1D306', scopes: ['source.haxe', 'constant.numeric.haxe']
        it "tokenizes decimals", ->
            {tokens} = grammar.tokenizeLine('1234')
            expect(tokens[0]).toEqual value: '1234', scopes: ['source.haxe', 'constant.numeric.haxe']
            #{tokens} = grammar.tokenizeLine('5e-10')
            #expect(tokens[0]).toEqual value: '5e-10', scopes: ['source.js', 'constant.numeric.haxe']
            {tokens} = grammar.tokenizeLine('9.')
            expect(tokens[0]).toEqual value: '9', scopes: ['source.haxe', 'constant.numeric.haxe']
            #expect(tokens[1]).toEqual value: '.', scopes: ['source.haxe', 'constant.numeric.decimal.hx', 'meta.delimiter.decimal.period.hx']

    describe "switch statements", ->
        it "tokenizes the switch keyword", ->
            {tokens} = grammar.tokenizeLine('switch(){}')
            expect(tokens[0]).toEqual value: 'switch', scopes: ['source.haxe', 'keyword.control.haxe.flow-control.2'] # TODO
        it "tokenizes switch expression", ->
            {tokens} = grammar.tokenizeLine('switch(foo + bar){}')
            expect(tokens[0]).toEqual value: 'switch', scopes: ['source.haxe', 'keyword.control.haxe.flow-control.2'] # TODO
            expect(tokens[1]).toEqual value: '(', scopes: ['source.haxe', 'meta.scope.field-completions.haxe']
            #expect(tokens[2]).toEqual value: 'foo ', scopes: ['source.haxe', 'meta.scope.field-completions.haxe']
            #expect(tokens[3]).toEqual value: '+', scopes: ['source.haxe', 'meta.scope.field-completions.haxe']
            #expect(tokens[4]).toEqual value: ' bar', scopes: ['source.haxe', 'meta.switch-statement.js']
            #expect(tokens[5]).toEqual value: ')', scopes: ['source.haxe', 'meta.switch-statement.js', 'punctuation.definition.switch-expression.end.bracket.round.js']

    describe "function calls", ->
        #it "tokenizes function calls", ->
            #{tokens} = grammar.tokenizeLine('functionCall()')
            #expect(tokens[0]).toEqual value: 'functionCall', scopes: ['source.haxe']
            #expect(tokens[1]).toEqual value: '(', scopes: ['source.haxe']
            #expect(tokens[1]).toEqual value: '(', scopes: ['source.js', 'meta.function-call.js', 'meta.arguments.js', 'punctuation.definition.arguments.begin.bracket.round.js']
            #expect(tokens[2]).toEqual value: ')', scopes: ['source.js', 'meta.function-call.js', 'meta.arguments.js', 'punctuation.definition.arguments.end.bracket.round.js']

    describe "strings and functions", ->
        it "doesn't confuse them", ->
            delimsByScope =
                "string.quoted.double.js": '"'
                "string.quoted.single.js": "'"
            for scope, delim of delimsByScope
                {tokens} = grammar.tokenizeLine('a.push(' + delim + 'x' + delim + ' + y + ' + delim + ':function()' + delim + ');')
                expect(tokens[0]).toEqual value: 'a', scopes: ['source.haxe'] #,'meta.scope.field-completions.haxe']
                #expect(tokens[1]).toEqual value: '.', scopes: ['source.haxe']
