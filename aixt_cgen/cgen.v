// Project Name: Aixt project, https://gitlab.com/fermarsan/aixt-project.git
// File Name: cgen.v
// Author: Fernando Martínez Santa
// Date: 2023
// License: MIT
//
// Description: This file contains the C code generation fucntions of the Aixt project.

module aixt_cgen

// import os
import v.ast
// import v.token
import v.pref
import v.parser
import v.checker
import toml

pub struct Gen {
mut:
	file  &ast.File  = unsafe { nil }
	table &ast.Table = unsafe { nil }
	out   string
pub mut:
	pref  &pref.Preferences = unsafe { nil }
	setup toml.Doc //= unsafe { nil }
}

pub fn (mut gen Gen) gen(source_path string) string {
	// gen.pref.is_script = true
	gen.file = parser.parse_file(source_path, gen.table, .skip_comments, gen.pref)
	// println('${'='.repeat(50)}\n${gen.file}${'='.repeat(50)}\n')
	mut checker_ := checker.new_checker(gen.table, gen.pref)
	checker_.check(mut gen.file)
	gen.out = gen.ast_node(gen.file) // starts from the main node (file)
	gen.out_format()
	return gen.out
}

fn (mut gen Gen) ast_node(node ast.Node) string {
	print('${node.type_name().after('v.ast.')} -> ')
	match node {
		ast.File {
			return gen.ast_file(node)
		}
		ast.Stmt {
			return gen.stmt(node)
		}
		ast.Expr {
			return gen.expr(node)
		}
		ast.ConstField {
			return gen.const_field(node)
		}
		ast.IfBranch { // statements block of "if" and "else" expressions
			return gen.if_branch(node)
		}
		ast.CallArg {
			return gen.call_arg(node)
		}
		ast.Param {
			return gen.param(node)
		}
		else {
			return ''
		} //'Error: Not defined node.\n' }
	}
}

fn (mut gen Gen) visit_gen(node &ast.Node, data voidptr) bool {
	print('${node.type_name().after('v.ast.')} -> ')
	// println(gen.file.path)
	match node {
		ast.File {
			// gen.out = '// Aixt project ('
			// gen.out += if gen.setup.value('backend').string() == 'nxc' { 'NXC ' }  else { 'C ' }
			// gen.out += 'generated code)\n// Device = ${gen.setup.value('device').string()}'
			// gen.out += '\n// Board = ${gen.setup.value('board').string()}\n\n'
			// for h in gen.setup.value('headers').array() {			// append the header files
			//     gen.out +=  if h.string() != '' { '#include <${h.string()}>\n' } else { '' }
			// }
			// gen.out += '\n'
			// // gen.out += '#include "api/builtin.h"\n'
			// for m in gen.setup.value('macros').array() { 			// append the macros
			//     gen.out += if m.string() != '' { '#define ${m.string()}\n' } else { '' }
			// }
			// gen.out += '\n'
			// for c in gen.setup.value('configuration').array() {		// append the configuration lines
			//     gen.out += '${gen.setup.value('config_operator').string()} ${c.string()}\n'
			// }
		}
		// ast.Stmt {
		// 	println('${node.type_name().after('v.ast.')}:\t\t${node}')
		// 	match node {
		// 		ast.FnDecl {
		// 			if node.is_main {
		// 				gen.out += if gen.setup.value('backend').string() == 'nxc' { 'task ' } else { '' }
		// 				gen.out += '${gen.setup.value('main_ret_type').string()} '
		// 				gen.out += 'main(${gen.setup.value('main_params').string()}) {\n'
		// 				gen.out += '${'__v.ast.Stmt__'.repeat(node.stmts.len)}'
		// 				gen.out += if gen.setup.value('main_ret_type').string() == 'int' { 'return 0;\n}' } else { '}' }
		// 				gen.out = if gen.out[0] == ` ` { gen.out[1..] } else { gen.out }
		// 			} else {
		// 				for a in node.attrs {
		// 					gen.out += '${a.name} '
		// 				}
		// 				gen.out += '${gen.setup.value(ast.new_table().type_symbols[node.return_type].str()).string()} '	// return type
		// 				gen.out += '${node.name.after('.')}('
		// 				gen.out += if node.params.len != 0 {
		// 					'${'__v.ast.Param__, '.repeat(node.params.len)}'#[..-2] + ') {\n'
		// 				} else {
		// 					') {\n'
		// 				}
		// 				gen.out += '${'__v.ast.Stmt__'.repeat(node.stmts.len)}}\n'
		// 				gen.out = if gen.out[0] == ` ` { gen.out[1..] } else { gen.out }
		// 			}
		// 		}
		// 		ast.AssignStmt {
		// 			mut assign := ''
		// 			for i in 0 .. node.left.len {
		// 				var_type := gen.setup.value(ast.new_table().type_symbols[node.right_types[i]].str())
		// 				if node.op == token.Kind.decl_assign { // in case of declaration
		// 					if node.right[i].type_name() == 'v.ast.CastExpr' {	// in case of casting expression
		// 						assign += if var_type.string() == 'char []' {
		// 							'char __${node.left[i].type_name()}__[] = __${(node.right[i] as ast.CastExpr).expr.type_name()}__;\n'
		// 						} else {
		// 							'${var_type.string()} __${node.left[i].type_name()}__ = __${(node.right[i] as ast.CastExpr).expr.type_name()}__;\n'
		// 						}								
		// 					} else {
		// 						assign += if var_type.string() == 'char []' {
		// 							'char __${node.left[i].type_name()}__[] = __${node.right[i].type_name()}__;\n'
		// 						} else {
		// 							'${var_type.string()} __${node.left[i].type_name()}__ = __${node.right[i].type_name()}__;\n'
		// 						}
		// 					}
		// 				} else { // for the rest of assignments
		// 					assign += '__${node.left[i].type_name()}__ ${node.op} __${node.right[i].type_name()}__;\n'
		// 				}
		// 			}
		// 			gen.out = gen.out.replace_once('__v.ast.Stmt__', assign)
		// 		}
		// 		ast.ExprStmt {
		// 			// println('__${node.expr.type_name()}__')
		// 			gen.out = gen.out.replace_once('__v.ast.Stmt__', '__${node.expr.type_name()}__;\n')
		// 		}
		// 		ast.Return {
		// 			// Be Careful....... multiple values return
		// 			gen.out = gen.out.replace_once('__v.ast.Stmt__', 'return __${node.exprs[0].type_name()}__;\n')
		// 		}
		// 		ast.BranchStmt {
		// 			gen.out = gen.out.replace_once('__v.ast.Stmt__', '${node.str()};\n')
		// 		}
		// 		ast.ForStmt {
		// 			// println('===${node}===')
		// 			// println('===${node.children()}===')
		// 			println('${node.cond.type_name()}')
		// 			mut out := 'while('
		// 			out += if node.is_inf { 'true) {\n' } else { '__${node.cond.type_name()}__) {\n' }
		// 			out += '${'__v.ast.Stmt__'.repeat(node.stmts.len)}}\n'
		// 			gen.out = gen.out.replace_once('__v.ast.Stmt__', out)
		// 			if !node.is_inf {
		// 				println('--for condition--')
		// 				os.write_file('temp.v', node.cond.str()) or {}
		// 				// temp_file := parser.parse_file('temp.v', gen.table, .skip_comments, gen.pref)
		// 				// walker.inspect(temp_file, unsafe { nil }, unsafe { gen.visit_gen })
		// 				// println('$temp_file')
		// 			}
		// 		}
		// 		else {}
		// 	}
		// }
		// ast.Expr {
		// println('${node.type_name().after('v.ast.')}:\t\t${node}')
		// 	match node {
		// 		ast.IfExpr { // basic shape of an "if" expression
		// 			mut out := 'if(__v.ast.Expr__){\n__v.ast.Stmt__}\n'
		// 			out += if node.has_else { 'else{\n__v.ast.Stmt__}\n' } else { '' }
		// 			gen.out = gen.out.replace_once('__v.ast.IfExpr__', out)
		// 		}
		// 		ast.CallExpr {
		// 			mut call_expr := '${node.name.after('.')}('
		// 			call_expr += if node.args.len != 0 {
		// 				'__v.ast.CallArg__, '.repeat(node.args.len)#[..-2] + ')'
		// 			} else {
		// 				')'
		// 			}
		// 			gen.out = gen.out.replace_once('__v.ast.CallExpr__', call_expr)
		// 		}
		// 		ast.ParExpr {
		// 			gen.out = gen.out.replace_once('__v.ast.ParExpr__', '(__${node.expr.type_name()}__)')
		// 			// println(node.expr)
		// 		}
		// 		ast.InfixExpr {
		// 			gen.out = gen.out.replace_once('__v.ast.InfixExpr__',
		// 										   '__${node.left.type_name()}__ ${node.op} __${node.right.type_name()}__')
		// 		}
		// 		ast.PrefixExpr {
		// 			gen.out = gen.out.replace_once('__v.ast.PrefixExpr__', '${node.op}__${node.right.type_name()}__')
		// 		}
		// 		ast.PostfixExpr {
		// 			gen.out = gen.out.replace_once('__v.ast.PostfixExpr__', '__${node.expr.type_name()}__${node.op}')
		// 		}
		// 		ast.CastExpr {
		// 			var_type := gen.setup.value(ast.new_table().type_symbols[node.typ].str())
		// 			gen.out = gen.out.replace_once('__v.ast.CastExpr__', '(${var_type.string()})(${node.expr})')
		// 		}
		// 		ast.Ident {
		// 			gen.out = gen.out.replace_once('__v.ast.Ident__', node.name)
		// 		}
		// 		ast.StringLiteral {
		// 			gen.out = gen.out.replace_once('__v.ast.StringLiteral__', '"${node.val}"')
		// 		}
		// 		ast.CharLiteral {
		// 			gen.out = gen.out.replace_once('__v.ast.CharLiteral__', "'${node.val}'")
		// 		}
		// 		ast.FloatLiteral {
		// 			gen.out = gen.out.replace_once('__v.ast.FloatLiteral__', node.val)
		// 		}
		// 		ast.IntegerLiteral {
		// 			out := if node.str().contains('0o') {	// if it is an octal literal
		// 				node.val.int().str() 				// turn it into decimal
		// 			} else {
		// 				node.val
		// 			}
		// 			gen.out = gen.out.replace_once('__v.ast.IntegerLiteral__', out)
		// 		}
		// 		ast.BoolLiteral {
		// 			gen.out = gen.out.replace_once('__v.ast.BoolLiteral__', node.val.str())
		// 		}
		// 		else {}
		// 	}
		// }
		ast.ConstField {
			mut assign := ''
			var_type := gen.setup.value(ast.new_table().type_symbols[node.typ].str())
			if node.expr.type_name() == 'v.ast.CastExpr' { // in case of casting expression
				assign += if var_type.string() == 'char []' {
					'const char ${node.name.after('.')}[] = __${(node.expr as ast.CastExpr).expr.type_name()}__;\n'
				} else {
					'const ${var_type.string()} ${node.name.after('.')} = __${(node.expr as ast.CastExpr).expr.type_name()}__;\n'
				}
			} else {
				assign += if var_type.string() == 'char []' {
					'const char ${node.name.after('.')}[] = __${node.expr.type_name()}__;\n'
				} else {
					'const ${var_type.string()} ${node.name.after('.')} = __${node.expr.type_name()}__;\n'
				}
			}
			gen.out += assign
		}
		ast.IfBranch { // statements block of "if" and "else" expressions
			gen.out = gen.out.replace_once('__v.ast.Expr__', '${node.cond}')
			gen.out = gen.out.replace_once('__v.ast.Stmt__', '${'__v.ast.Stmt__'.repeat(node.stmts.len)}')
		}
		ast.CallArg {
			gen.out = gen.out.replace_once('__v.ast.CallArg__', '__${node.expr.type_name()}__')
		}
		ast.Param {
			var_type := gen.setup.value(ast.new_table().type_symbols[node.typ].str())
			gen.out = gen.out.replace_once('__v.ast.Param__', '${var_type.string()} ${node.name}')
		}
		else {}
	}
	// println(gen.out + '\n' + '_'.repeat(60))	
	return true
}

fn (mut gen Gen) out_format() {
	gen.out = gen.out.replace('}\n;', '}')
	mut temp := ''
	mut ind_count := 0
	for c in gen.out {
		match rune(c) {
			`\n` {
				temp += '\n' + '\t'.repeat(ind_count)
			}
			`{` {
				ind_count++
				temp += rune(c).str()
			}
			`}` {
				ind_count--
				temp += rune(c).str()
			}
			else {
				temp += rune(c).str()
			}
		}
	}
	temp = temp.replace('\t}', '}')
	gen.out = temp
}

// creating settings.h
// ast.File {
// base_path := os.dir(gen.file.path)
// // println(base_path)
// mut out_settings := os.create('${base_path}/settings.h') or {	// creates the settings.h file
// 	println('Failed to create file')			// from setup.toml
// 	return false
// }
// defer { out_settings.close() }

// mut s := '#ifndef _SETTINGS_H_\n#define _SETTINGS_H_\n\n#include "api/builtin.h"\n'
// // println(gen.setup.value('headers').array())
// for h in gen.setup.value('headers').array() {			// append the header files
//     s +=  if h.string() != '' { '#include <${h.string()}>\n' } else { '' }
// }
// s += '\n'
// for m in gen.setup.value('macros').array() { 			// append the macros
//     s += if m.string() != '' { '#define ${m.string()}\n' } else { '' }
// }
// s += '\n'
// for c in gen.setup.value('configuration').array() {		// append the configuration lines
//     s += '${gen.setup.value('config_operator').string()} ${c.string()}\n'
// }
// s += '\n#endif  //_SETTINGS_H_'
// out_settings.write_string(s) or {
// 	println('Failed to write file')
// 	return false
// }

// gen.out += if gen.setup.value('backend').string() != 'nxc' { '#include "../../settings.h"\n\n' } else {''}
// s += '// ' + self.moduleDef + '\n'  // module definition
// s += self.includes + '\n'           // user defined headers files
// for td in self.topDecl:
//     s += '{}\n'.format(td) #top level declarations
// if not self.main:       #adds the main function structure if not exist
//     s += 'task' if gen.setup.value('nxc'] else ''
//     s += gen.setup.value('main_ret_type'] if gen.setup.value('main_ret_type'] != 'none' else ''
//     s += ' main('
//     s += gen.setup.value('main_params'] if gen.setup.value('main_params'] != 'none' else ''
//     s += ') {'
//     for i in gen.setup.value('initialization']:
//         s += i + '\n' if i != '' else ''
//     s += '\n\t'
//     s += self.transpiled.replace('\n','\n\t')[:-1]
//     s += 'return 0;\n}' if gen.setup.value('main_ret_type'] == 'int' else '}'
// else:
//     s += self.transpiled
// # s = s.replace('};','}')
// outText.write(s)