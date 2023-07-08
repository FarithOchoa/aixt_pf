// Project Name: Aixt project, https://gitlab.com/fermarsan/aixt-project.git
// File Name: stmt.v
// Author: Fernando Martínez Santa
// Date: 2023
// License: MIT
//
// Description: code generation for statements.
module aixt_cgen

import v.ast
import v.token

fn (mut gen Gen) fn_decl(node ast.FnDecl) string {
	mut out := ''
	if node.is_main {
		out += if gen.setup.value('backend').string() == 'nxc' { 'task ' } else { '' }
		out += '${gen.setup.value('main_ret_type').string()} '
		out += 'main(${gen.setup.value('main_params').string()}) {\n'
		// println('fn stmts:\t${node.stmts}')
		for st in node.stmts {
			out += gen.ast_node(st)
			// println('fn stmt:\t${st}')
		}
		out += if gen.setup.value('main_ret_type').string() == 'int' { 'return 0;\n}' } else { '}' }
		out = if out[0] == ` ` { out[1..] } else { out }
	} else {
		for a in node.attrs {
			out += '${a.name} '
		}
		out += '${gen.setup.value(ast.new_table().type_symbols[node.return_type].str()).string()} '	// return type
		out += '${node.name.after('.')}('
		out += if node.params.len != 0 { 
			'${'__v.ast.Param__, '.repeat(node.params.len)}'#[..-2] + ') {\n' 
		} else {
			') {\n'
		}
		out += '${'__v.ast.Stmt__'.repeat(node.stmts.len)}}\n'
		out = if out[0] == ` ` { out[1..] } else { out }
	}
	return out
}

fn (mut gen Gen) assign_stmt(node ast.AssignStmt) string {
	mut out := ''
	for i in 0 .. node.left.len {
		var_type := gen.setup.value(ast.new_table().type_symbols[node.right_types[i]].str())
		if node.op == token.Kind.decl_assign { // in case of declaration
			if node.right[i].type_name() == 'v.ast.CastExpr' {	// in case of casting expression
				out += if var_type.string() == 'char []' {
					'char ${gen.ast_node(node.left[i])}[] = ${gen.ast_node((node.right[i] as ast.CastExpr).expr)};\n'
				} else {
					'${var_type.string()} ${gen.ast_node(node.left[i])} = ${gen.ast_node((node.right[i] as ast.CastExpr).expr)};\n'
				}			
			} else {
				out += if var_type.string() == 'char []' {
					'char ${gen.ast_node(node.left[i])}[] = ${gen.ast_node(node.right[i])};\n'
				} else {
					'${var_type.string()} ${gen.ast_node(node.left[i])} = ${gen.ast_node(node.right[i])};\n'
				}
			}
		} else { // for the rest of assignments
			out += '${gen.ast_node(node.left[i])} ${node.op} ${gen.ast_node(node.right[i])};\n'
		}
	}
	return out
}

fn (mut gen Gen) expr_stmt(node ast.ExprStmt) string {
	mut out := ''
	// println('__${node.expr.type_name()}__')
	gen.out = gen.out.replace_once('__v.ast.Stmt__', '__${node.expr.type_name()}__;\n')
	gen.ast_node(node.expr)
	return out
}

fn (mut gen Gen) return_stmt(node ast.Return) string {
	mut out := ''
	// Be Careful....... multiple values return
	gen.out = gen.out.replace_once('__v.ast.Stmt__', 'return __${node.exprs[0].type_name()}__;\n')
	return out
}

fn (mut gen Gen) branch_stmt(node ast.BranchStmt) string {
	mut out := ''
	gen.out = gen.out.replace_once('__v.ast.Stmt__', '${node.str()};\n')
	return out
}

fn (mut gen Gen) for_stmt(node ast.ForStmt) string {
	// println('===${node}===')
	// println('===${node.children()}===')
	println('${node.cond.type_name()}')
	mut out := 'while('
	out += if node.is_inf { 'true) {\n' } else { '__${node.cond.type_name()}__) {\n' }
	out += '${'__v.ast.Stmt__'.repeat(node.stmts.len)}}\n'
	gen.out = gen.out.replace_once('__v.ast.Stmt__', out)
	// if !node.is_inf {
	// 	println('--for condition--')
	// 	os.write_file('temp.v', node.cond.str()) or {}
	// 	// temp_file := parser.parse_file('temp.v', gen.table, .skip_comments, gen.pref)
	// 	// walker.inspect(temp_file, unsafe { nil }, unsafe { gen.visit_gen })
	// 	// println('$temp_file')
	// }
	return out
}

// fn (mut gen Gen) block_stmts(stmts []Stmt) {
// 	gen.out += '${node.str()};\n'
// }