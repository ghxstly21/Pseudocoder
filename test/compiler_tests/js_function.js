// This is a function that adds two numbers, x and y
function add(x,y) {
    let z = 5
    let other = 3
    if(x > 10) {
        z = f(x)
    } else {
        z = g(x + 5)
    }
    if (y < 10) {
        other = g(y)
    }
    while(x === y) {
        console.log("They are equal!")
    }
    return z + other;
}

/*
The following functions will multiply a number

"console.log is also used to test the for loop"

by 10

and divide it by 10
 */

function f(x) {
    for(let i = 1; i <= 10; i++) {
        console.log("This prints 10 times!")
    }
    return x * 10;
}

function g(number) {
    return number / 10;
}