
describe "Hxml Grammar", ->

    grammar = null

    beforeEach ->
        waitsForPromise ->
            atom.packages.activatePackage("language-haxe")
        runs ->
            grammar = atom.grammars.grammarForScopeName("source.hxml")

    it "parses the grammar", ->
        expect(grammar).toBeTruthy()
        expect(grammar.scopeName).toBe "source.hxml"
        expect(grammar.name).toBe "Hxml"
        expect(grammar.fileTypes[0]).toBe 'hxml'
        expect(grammar.foldingStopMarker).toBe '\\*\\*/|^\\s*\\}'

    describe "comments", ->
        it "tokenizes comments", ->
            {tokens} = grammar.tokenizeLine('#')
            expect(tokens[0]).toEqual value: '#', scopes: ['source.hxml', 'comment.line.number-sign.hxml', 'punctuation.definition.comment.haxe']

    describe "arguments", ->
        args = ['-cp','-js','-lua','-swf','-as3','-neko','-php','-cpp','-cppia','-cs','-java','-python','-hl','-xml','-main','-lib','-D','-v','-debug','-dce','-swf-version','-swf-header','-swf-lib','-swf-lib-extern','-java-lib','-net-lib','-net-std','-c-arg','-x','-resource','-prompt','-cmd','--flash-strict','--no-traces','--gen-hx-classes','--next','--each','--display','--no-output','--times','--no-inline','--no-opt','--php-front','--php-lib','--php-prefix','--remap','--interp','--macro','--eval','--wait','--connect','--cwd','-version','--help-defines','--help-metas','-help','--help','--each']
        for arg in args
            it "tokenizes the #{arg} arg", ->
                {tokens} = grammar.tokenizeLine(arg)
                expect(tokens[0]).toEqual value: arg, scopes: ['source.hxml', 'keyword.compiler.arguments.hxml']

    describe "flags", ->
        flags = ['absolute-path','advanced-telemetry','annotate-source','as3','check-xml-proxy','core-api','core-api-serialize','cppia','dce','dce-debug','debug','display','display-stdin','dll-export','dll-import','doc-gen','dump','dump-dependencies','dump-ignore-var-ids','dynamic-interface-closures','erase-generics','fast-cast','fdb','file-extension','flash-strict','flash-use-stage','force-lib-check','force-native-property','format-warning','gencommon-debug','haxe-boot','haxe-ver','hxcpp-api-level','include-prefix','interp','java-ver','jquery-ver','js-classic','js-es5','js-unflatten','keep-old-output','loop-unroll-max-cost','lua-jit','lua-ver','macro','macro-times','neko-source','neko-v1','net-target','net-ver','network-sandbox','no-analyzer','no-compilation','no-copt','no-debug','no-deprecation-warnings','no-flash-override','no-inline','no-macro-cache','no-opt','no-pattern-matching','no-root','no-simplify','no-swf-compress','no-traces','objc','php-prefix','real-position','replace-files','scriptable','shallow-expose','source-header','source-map-content','swc','swf-compress-level','swf-debug-password','swf-direct-blit','swf-gpu','swf-metadata','swf-preloader-frame','swf-protected','swf-script-timeout','swf-use-doabc','sys','unsafe','use-nekoc','use-rtti-doc','vcproj']
        for flag in flags
            it "tokenizes the #{flag} flag", ->
                {tokens} = grammar.tokenizeLine(flag)
                expect(tokens[0]).toEqual value: flag, scopes: ['source.hxml', 'keyword.compiler.flags.hxml']
