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

    let result = solver.solve(origin)
    switch result {
    case let .success(solution):
        print(solution.final)
        print()

        var grid = solution.origin
        print(grid)
        print()
        for step in solution.steps {
            grid[step.position] = step.number
            print(grid)
            print()
        }
    case .invalid:
        print("the puzlle is invalid")
    case .failure:
        print("unable to solve the puzzle")
    }
````
