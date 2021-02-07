#!/usr/bin/python3

import ast, pdb, astor

#with open("demo_sieve.py", "r") as source:
#    tree = ast.parse(source.read())


tree = astor.parse_file("../demo/prime_sieve.py")

class AsmVisitor(ast.NodeTransformer):
    def __init__(self):
        ast.NodeTransformer.__init__(self)
        self.label_idx = 1
        self.label_stack = list()
        self.label_parent = None

    def visit_FunctionDef(self, node):

        self.label_parent = []

        self.generic_visit(node)

        node.body[0:0] = self.label_parent

        return node

    def visit_While(self, node):
        # Prepare labels
        loop_label_name = "l_{}_loop".format(self.label_idx)
        end_label_name = "l_{}_end".format(self.label_idx)
        self.label_idx += 1

        self.label_stack.append((loop_label_name, end_label_name))

        # Process childs
        self.generic_visit(node)

        # Put a start label
        loop_label_node = self.make_label_here(loop_label_name)
        node.body.insert(0, loop_label_node)
        self.label_parent.append(self.make_label_def(loop_label_name))

        # Loop back or exit at the end
        if isinstance(node.body[-1], ast.Break):
            del node.body[-1]
        else:
            node.body.append(self.make_jmp(loop_label_name))

        # Put an end label
        node.body.append(self.make_label_here(end_label_name))
        self.label_parent.append(self.make_label_def(end_label_name))


        # cleanup
        self.label_stack.pop()

        return node.body
        return node

    def visit_If(self, node):
        # Process childs
        self.generic_visit(node)

        if isinstance(node.test, ast.Call):
            node.test.args = [ast.Name()]
            if len(node.body) != 1:
                raise Exception("Unsupported")

            if isinstance(node.body[0], ast.Continue):
                node.test.args[0].id = self.label_stack[-1][0]
            elif isinstance(node.body[0], ast.Break):
                node.test.args[0].id = self.label_stack[-1][1]

            ret = ast.Expr()
            ret.value = node.test

            return ret
        elif isinstance(node.test, ast.UnaryOp):
            if isinstance(node.test.operand, ast.Call) and isinstance(node.test.op, ast.Not):

                skip_label_name = "l_{}_skip".format(self.label_idx)
                self.label_idx += 1

                node.test.operand.args = [ast.Name()]
                node.test.operand.args[0].id = skip_label_name

                # insert operand as expression
                check = ast.Expr()
                check.value = node.test.operand
                node.body.insert(0, check)

                node.body.append(self.make_label_here(skip_label_name))

                self.label_parent.append(self.make_label_def(skip_label_name))

                return node.body
            else:
                raise Exception("Unsupported")

        elif isinstance(node.test, ast.NameConstant):
            if node.test.value == True:
                return node.body
            elif node.test.value == False:
                return []
        else:
            pass

        return node

    def make_label_here(self, name):
        node = ast.Expr()
        node.value = ast.Call()
        node.value.args = []
        node.value.keywords = []
        node.value.func = ast.Attribute()
        node.value.func.attr = "here"
        node.value.func.value = ast.Name()
        node.value.func.value.id = name

        return node

    def make_jmp(self, label):
        node = ast.Expr()
        node.value = ast.Call()
        node.value.func = ast.Name()
        node.value.func.id = "jmp"
        node.value.args = [ast.Name()]
        node.value.args[0].id = label
        node.value.keywords = []

        return node

    def make_label_def(self, name):
        node = ast.Assign()
        node.targets = [ast.Name()]
        node.targets[0].id = name
        node.value = ast.Call()
        node.value.args = []
        node.value.keywords = []
        node.value.func = ast.Name()
        node.value.func.id = "Label"

        return node

tree = AsmVisitor().visit(tree)

print ("#!/usr/bin/python3\n")
print (astor.to_source(tree))
