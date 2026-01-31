// 1. Template literal with escapes
let msg = `Hello, ${name}\nHow are you?`;

// 2. Mixed quote types
console.log('She said "hi" and left.');
console.log("It's fine.");

// 3. Escaped backslash in string
let path = "C:\\Users\\Dharma\\file.txt";

// 4. Weird chaining
console.log.debug?.().toString?.()?.length;

// 5. Comments (inline & multiline)
/*
 Multi-line comment
 // inside
*/
let x = 42; // trailing comment

// 6. Arrow functions + fat arrows
const add = (a, b) => a + b;

// 7. Nullish and logical coalescing
const val = x ?? y && z || false;

// 8. Regular expression literal edge
const pattern = /"[^"]+"/g;

// 9. Unicode escape
let emoji = "\u{1F600}";
