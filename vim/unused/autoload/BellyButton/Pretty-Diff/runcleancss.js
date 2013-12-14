var css_summary = {};
load('cleanCSS.js');

var readSTDIN = function() {
    var line, 
        input = [], 
        emptyCount = 0,
        i;

    line = readline();
    while (emptyCount < 25) {
        input.push(line);
        if (line) {
            emptyCount = 0;
        } else {
            emptyCount += 1;
        }
        line = readline();
    }

    input.splice(-emptyCount);
    return input.join("\n");
};

/*
* size is the character size of an indentation
* character is the character that makes up an indentation
* comment determines whether or not code comments should be indented
	to match the code or whitespace collapsed and left justified if
	passed the value "noindent"
* alter is whether or not the source code should be manipulated to
	correct some violations
*/
var args = [readSTDIN(), 
	CSSCLEANOPTS.size || 4,
	CSSCLEANOPTS.character || ' ',
	CSSCLEANOPTS.comment || '',
	CSSCLEANOPTS.alter || true
];

var res = cleanCSS.apply(this, args);

print(res);
