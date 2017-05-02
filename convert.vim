g/^"/d
v/gui/d
%s/^hi /pre>code>span.
%s/\s\+\S\+/\r&;/g
%s/^\(\S\+\)\s*/}\r\1 {/
" Account for how I formed the replacement pattern.
1/^}/m$
%s/guifg=/color:/
%s/guibg=/background-color:/
%s/gui=underline/text-decoration:underline/
%s/gui=italic/font-style:italic/
%s/gui=bold/font-weight:bold/
%s/gui=none\c/font-style:initial/
%s/none\c/inherit/
g/guisp/d
g/undercurl/d
g/^\s*$/d
%s/\s\+$//
%s/^pre.*{\n}\n//
normal gg=G
