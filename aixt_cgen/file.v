// Project Name: Aixt, https://github.com/fermarsan/aixt.git
// Author: Fernando Martínez Santa
// Date: 2023-2014
// License: MIT
module aixt_cgen

import v.ast

// ast_file is the function for ast.File code generation.
fn (mut gen Gen) ast_file(node ast.File) string {
	// println(node)
    mut out := '// This '
    out += match gen.setup.value('backend').string() {
		'nxc' 		{ 'NXC ' }
		'arduino'	{ 'Arduino ' }  
		else 		{ 'C ' }
	}
    out += 'code was automatically generated by Aixt Project\n'
	out += '// Device = ${gen.setup.value('device').string()}\n'
	out += '// Board = ${gen.setup.value('board').string()}\n'
	out += '// Backend = ${gen.setup.value('backend').string()}\n\n'
    for m in gen.setup.value('macros').array() { 			// append the macros
        out += if m.string() != '' { '#define ${m.string()}\n' } else { '' }
	}
    out += '\n'
    for c in gen.setup.value('configuration').array() {		// append the configuration lines
        out += '${gen.setup.value('config_operator').string()} ${c.string()}\n'    
	}
	out += '\n___includes_block___\n' 
	gen.incls = ''
    for h in gen.setup.value('headers').array() {			// append the header files
        gen.incls +=  if h.string() != '' { '#include <${h.string()}>\n' } else { '' }
	}
	api_path := '${gen.tr_path}/ports/${gen.setup.value('path').string()}/api'
    gen.incls += if gen.setup.value('backend').string() != 'nxc'{
		'#include "${api_path}/builtin.c"\n'
	} else {
		''
	}
	out += '\n___definitions_block___\n' 
	gen.defs = ''

	for st in node.stmts {
		out += gen.ast_node(st)
	}
	return out
}