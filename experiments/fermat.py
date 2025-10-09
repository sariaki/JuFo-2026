import claripy

solver = claripy.Solver()

x = claripy.BVS('x', 32)  
y = claripy.BVS('y', 32)

# Define the expression: (y < 10 || x * (x + 1) % 2 == 0)
y_less_than_10 = y < 10
x_product_even = (x * (x + 1)) % 2 == 0
expression = claripy.Or(y_less_than_10, x_product_even)

# Check if the expression can be true (satisfiable)
print("Checking if expression can be true...")
if solver.is_true(expression):
    print("The expression is always true.")
elif solver.is_false(expression):
    print("The expression is always false.")
elif solver.satisfiable(extra_constraints=[expression]):
    print("The expression can be true for some values of x and y.")
    # Get example values
    solver.add(expression)
    print(f"Example: x = {solver.eval(x, 1)[0]}, y = {solver.eval(y, 1)[0]}")
else:
    print("The expression cannot be true for any values of x and y.")