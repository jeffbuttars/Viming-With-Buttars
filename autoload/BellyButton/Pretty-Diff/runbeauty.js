
var js_summary = {};
load('js-beautify.js');

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

/*JSBEAUTYOPTS = {*/
/*outfile:'outfilename',*/
/*funcargs:[]*/
/*}*/

var body = readSTDIN() || arguments[0],
	res = js_beautify(body);
/*res = js_beautify.apply(this, JSBEAUTYOPTS.funcargs.concat([body])),*/

print(res);
