import claripy

x = claripy.BVS('x', 32)
y = claripy.BVS('y', 32)
z = claripy.BVS('z', 32)

cube_eq = (x * x * x) + (y * y * y) - (z * z * z)

solver = claripy.Solver()
solver.add(x.SGT(2))      # x > 0
solver.add(y.SGT(2))      # y > 0
solver.add(z.SGT(2))      # z > 0
solver.add(cube_eq == 0)  # x^3 + y^3 == z^3

if solver.satisfiable():
    model = solver.model()
    xv = model[x].as_long()
    yv = model[y].as_long()
    zv = model[z].as_long()
    print(f"Found a positive solution: x={xv}, y={yv}, z={zv}")
else:
    print("No positive integer solution exists for x^3 + y^3 = z^3.")
