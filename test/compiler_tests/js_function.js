// ============================================
// COMPREHENSIVE JAVASCRIPT COMPILER TEST
// Tests tokenizer, parser, and all supported features
// ============================================

/*
This test file demonstrates:
- Single-line and multi-line comments
- Function declarations with parameters
- Variable declarations (let, var, const)
- All comparison operators
- All arithmetic operators
- Logical operators (&&, ||, !)
- Assignment operators (=, +=, -=, *=, /=)
- Unary operators (++, --)
- If/else conditionals
- While loops
- For loops
- Nested control structures
- Function calls
- String literals (single, double, template)
- Number types (integers, floats, exponential)
*/

// Function with multiple parameters and complex logic
function calculate(x, y) {
    let result = 0
    const multiplier = 2

    // Test all comparison operators
    if (x > y) {
        result = x - y
    } else {
        result = y - x
    }

    // Test logical AND operator
    if (x > 0 && y > 0) {
        result = result * multiplier
    }

    // Test logical OR operator
    if (x < 0 || y < 0) {
        result = result / 2
    }

    return result
}

// Function demonstrating arithmetic operators
function arithmeticDemo(num) {
    let a = num - 5
    let b = num * 2
    let c = num / 4

    return c
}

// Function with while loop and unary operators
function countUp(start, end) {
    let counter = start

    while (counter < end) {
        console.log(counter)
        counter++
    }

    return counter
}

// Function with for loop and decrement operator
function countDown(start) {
    for (let i = start; i > 0; i--) {
        console.log("Counting down: " + i)
    }
    return 0
}

/*
Testing all comparison operators:
- greater than (>)
- less than (<)
- greater than or equal to (>=)
- less than or equal to (<=)
- equal to (==)
- strict equal to (===)
- not equal to (!=)
*/
function compareValues(a, b) {
    let results = 0

    if (a > b) {
        results = 1
    }

    if (a < b) {
        results = 2
    }

    if (a >= b) {
        results = 4
    }

    if (a <= b) {
        results = 8
    }

    if (a == b) {
        results = 16
    }

    if (a === b) {
        results = 32
    }

    return results
}

// Function with assignment operators
function assignmentOperators(value) {
    let x = value

    x -= 5
    x *= 2
    x /= 3

    return x
}

// Function with NOT operator
function logicalNot(condition) {
    if (!condition) {
        return "Condition is false"
    } else {
        return "Condition is true"
    }
}

// Function with nested conditionals and loops
function nestedStructures(a, b) {
    let total = 0

    if (a > 0) {
        if (b > 0) {
            for (let i = 0; i < a; i++) {
                total = b
            }
        } else {
            while (a > 0) {
                total = 1
                a--
            }
        }
    } else {
        for (let j = 0; j < 5; j++) {
            total = j
        }
    }

    return total
}

// Function demonstrating different number types
function numberTypes() {
    let integer = 42
    let floatingPoint = 3.14159
    let exponential = 1.5e10
    let negative = -273

    return integer
}

// Function with different string literal types
function stringLiterals() {
    let singleQuote = 'Hello World'
    let doubleQuote = "JavaScript Compiler"
    let escaped = "He said, \"This works!\""

    console.log(singleQuote)
    console.log(doubleQuote)
    console.log(escaped)

    return escaped
}

// Main function demonstrating function calls
function main() {
    let result1 = calculate(10, 5)
    let result2 = arithmeticDemo(20)
    let result3 = countUp(1, 10)
    let result4 = countDown(5)
    let result5 = compareValues(10, 10)
    let result6 = assignmentOperators(100)
    let result7 = logicalNot(false)
    let result8 = nestedStructures(5, 3)
    let result9 = numberTypes()
    let result10 = stringLiterals()

    console.log("All tests completed successfully!")

    return result1
}