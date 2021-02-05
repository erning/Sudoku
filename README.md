# Sudoku

```swift
let origin = Sudoku.Grid([
    0, 0, 0, 4, 0, 6, 0, 0, 0,
    7, 0, 0, 2, 0, 0, 0, 9, 0,
    0, 0, 0, 0, 5, 3, 0, 0, 4,
    0, 1, 3, 0, 0, 0, 0, 4, 9,
    0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 4, 5, 0, 0, 0, 0, 2,
    3, 7, 0, 0, 6, 0, 0, 1, 0,
    5, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 2, 0, 0, 0, 0, 7, 0, 0,
])
let solver = Sudoku.DefaultSolver()

if let solution = solver.solve(origin) {
    print(solution.solved)
    print()

    var grid = solution.origin
    print(grid)
    print()
    for step in solution.steps {
        grid[step.position] = step.number
        print(grid)
        print()
    }
} else {
    print("Unable to solve the puzzle")
}
````
