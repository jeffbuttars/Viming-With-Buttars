/***
 Completely rewritten by Austin Cheney on 2009-04-29 to avoid accessing
 the DOM.
 
 This is part of jsdifflib v1.0. <http://snowtide.com/jsdifflib>
 
 Copyright (c) 2007, Snowtide Informatics Systems, Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the
 distribution.
 * Neither the name of the Snowtide Informatics Systems nor the names
 of its contributors may be used to endorse or promote products
 derived from this software without specific prior written
 permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ***/
/* Author: Chas Emerick <cemerick@snowtide.com> */
/* diffview rebuilt by Austin Cheney */
/* charcomp created by Austin Cheney */
/**
 * Builds and returns a visual diff view.  The single parameter,
 * 'params', should contain the following values:
 *
 * - baseTextLines: the array of strings that was used as the base
 *       text input to SequenceMatcher
 * - newTextLines: the array of strings that was used as the new
 *       text input to SequenceMatcher
 * - opcodes: the array of arrays returned by
 *       SequenceMatcher.get_opcodes()
 * - baseTextName: the title to be displayed above the base text
 *       listing in the diff view; defaults to "Base Text"
 * - newTextName: the title to be displayed above the new text
 *       listing in the diff view; defaults to "New Text"
 * - contextSize: the number of lines of context to show around
 *       differences; by default, all lines are shown
 * - inline: if 0, a side-by-side diff view is generated
 *       (default); if 1, an inline diff view is generated
 * - output: if this is provided a value of "webdownload" an extra
 *       depth of character escapes are performed to compensate for
 *       the rendering of character entities as they pass through
 *       the DOM, so that the string literal value is preserved.
 */
var diffview = function (baseTextLines, newTextLines, baseTextName, newTextName, contextSize, inline, lang) {
    "use strict";
    var thead = "<table class='diff'><thead><tr><th></th>" + ((inline === true) ? "<th></th><th class='texttitle'>" + baseTextName + " vs. " + newTextName + "</th></tr></thead><tbody>" : "<th class='texttitle'>" + baseTextName + "</th><th></th><th class='texttitle'>" + newTextName + "</th></tr></thead><tbody>"),
        tbody = [],
        tfoot = "<tr><th class='author' colspan='" + ((inline === true) ? "3" : "4") + "'>Original diff view created as DOM objects by <a href='http://snowtide.com/jsdifflib'>jsdifflib</a>. Diff view recreated as a JavaScript array by <a href='http://mailmarkup.org/'>Austin Cheney</a>.</th></tr></tfoot></table>",
        node = [],
        rows = [],
        idx,
        opcodes,
        opleng,
        change,
        code,
        b,
        be,
        n,
        ne,
        z,
        rowcnt,
        i,
        jump,

        //This is the difference algorithm
        difference = function (a, b, isjunk) {
            var isbjunk,
                matching_blocks = [],
                b2j = [],
                opcodes = [],
                answer = [],
                get_matching_blocks = function () {
                    var idx,
                        alo,
                        ahi,
                        blo,
                        bhi,
                        qi,
                        i,
                        j,
                        k,
                        x,
                        i2,
                        j2,
                        k2,
                        la = a.length,
                        lb = b.length,
                        queue = [
                            [0, la, 0, lb]
                        ],
                        block = 0,
                        k1 = block,
                        j1 = k1,
                        i1 = j1,
                        non_adjacent = [],
                        ntuplecomp = function (a, b) {
                            var i,
                                mlen = Math.max(a.length, b.length);
                            for (i = 0; i < mlen; i += 1) {
                                if (a[i] < b[i]) {
                                    return -1;
                                }
                                if (a[i] > b[i]) {
                                    return 1;
                                }
                            }
                            return (a.length === b.length) ? 0 : ((a.length < b.length) ? -1 : 1);
                        },
                        find_longest_match = function (alo, ahi, blo, bhi) {
                            var i,
                                newj2len,
                                jdict,
                                jkey,
                                k,
                                besti = alo,
                                bestj = blo,
                                bestsize = 0,
                                j = null,
                                j2len = {},
                                nothing = [],
                                dictget = function (dict, key, defaultValue) {
                                    return (dict && dict[key]) ? dict[key] : defaultValue;
                                };
                            for (i = alo; i < ahi; i += 1) {
                                newj2len = {};
                                jdict = dictget(b2j, a[i], nothing);
                                for (jkey in jdict) {
                                    if (jdict.hasOwnProperty(jkey)) {
                                        j = jdict[jkey];
                                        if (j >= blo) {
                                            if (j >= bhi) {
                                                break;
                                            }
                                            k = dictget(j2len, j - 1, 0) + 1;
                                            newj2len[j] = k;
                                            if (k > bestsize) {
                                                besti = i - k + 1;
                                                bestj = j - k + 1;
                                                bestsize = k;
                                            }
                                        }
                                    }
                                }
                                j2len = newj2len;
                            }
                            while (besti > alo && bestj > blo && !isbjunk(b[bestj - 1]) && a[besti - 1] === b[bestj - 1]) {
                                besti -= 1;
                                bestj -= 1;
                                bestsize += 1;
                            }
                            while (besti + bestsize < ahi && bestj + bestsize < bhi && !isbjunk(b[bestj + bestsize]) && a[besti + bestsize] === b[bestj + bestsize]) {
                                bestsize += 1;
                            }
                            while (besti > alo && bestj > blo && isbjunk(b[bestj - 1]) && a[besti - 1] === b[bestj - 1]) {
                                besti -= 1;
                                bestj -= 1;
                                bestsize += 1;
                            }
                            while (besti + bestsize < ahi && bestj + bestsize < bhi && isbjunk(b[bestj + bestsize]) && a[besti + bestsize] === b[bestj + bestsize]) {
                                bestsize += 1;
                            }
                            return [besti, bestj, bestsize];
                        };
                    while (queue.length) {
                        qi = queue.pop();
                        alo = qi[0];
                        ahi = qi[1];
                        blo = qi[2];
                        bhi = qi[3];
                        x = find_longest_match(alo, ahi, blo, bhi);
                        i = x[0];
                        j = x[1];
                        k = x[2];
                        if (k) {
                            matching_blocks.push(x);
                            if (alo < i && blo < j) {
                                queue.push([alo, i, blo, j]);
                            }
                            if (i + k < ahi && j + k < bhi) {
                                queue.push([i + k, ahi, j + k, bhi]);
                            }
                        }
                    }
                    matching_blocks.sort(ntuplecomp);
                    for (idx in matching_blocks) {
                        if (matching_blocks.hasOwnProperty(idx)) {
                            block = matching_blocks[idx];
                            i2 = block[0];
                            j2 = block[1];
                            k2 = block[2];
                            if (i1 + k1 === i2 && j1 + k1 === j2) {
                                k1 += k2;
                            } else {
                                if (k1) {
                                    non_adjacent.push([i1, j1, k1]);
                                }
                                i1 = i2;
                                j1 = j2;
                                k1 = k2;
                            }
                        }
                    }
                    if (k1) {
                        non_adjacent.push([i1, j1, k1]);
                    }
                    non_adjacent.push([la, lb, 0]);
                    matching_blocks = non_adjacent;
                    return matching_blocks;
                },
                set_seq2 = (function () {
                    isjunk = isjunk ? isjunk : function (c) {
                        var whitespace = {
                            " ": true,
                            "\t": true,
                            "\n": true,
                            "\f": true,
                            "\r": true
                        };
                        if (whitespace.hasOwnProperty(c)) {
                            return whitespace[c];
                        }
                    };
                    opcodes = null;
                    var chain_b = (function () {
                        var i,
                            elt,
                            indices,
                            n = b.length,
                            populardict = {},
                            junkdict = {};
                        for (i = 0; i < b.length; i += 1) {
                            elt = b[i];
                            if (b2j[elt]) {
                                indices = b2j[elt];
                                if (n >= 200 && indices.length * 100 > n) {
                                    populardict[elt] = 1;
                                    delete b2j[elt];
                                } else {
                                    indices.push(i);
                                }
                            } else {
                                b2j[elt] = [i];
                            }
                        }
                        for (elt in populardict) {
                            if (populardict.hasOwnProperty(elt)) {
                                delete b2j[elt];
                            }
                        }
                        if (isjunk) {
                            for (elt in populardict) {
                                if (populardict.hasOwnProperty(elt) && isjunk(elt)) {
                                    junkdict[elt] = 1;
                                    delete populardict[elt];
                                }
                            }
                            for (elt in b2j) {
                                if (b2j.hasOwnProperty(elt) && isjunk(elt)) {
                                    junkdict[elt] = 1;
                                    delete b2j[elt];
                                }
                            }
                        }
                        isbjunk = function (key) {
                            if (junkdict.hasOwnProperty(key)) {
                                return junkdict[key];
                            }
                        };
                    }()),
                        result = (function () {
                            var idx,
                                block,
                                ai,
                                bj,
                                size,
                                tag,
                                i = 0,
                                j = 0,
                                blocks = get_matching_blocks();
                            for (idx in blocks) {
                                if (blocks.hasOwnProperty(idx)) {
                                    block = blocks[idx];
                                    ai = block[0];
                                    bj = block[1];
                                    size = block[2];
                                    tag = '';
                                    if (i < ai && j < bj) {
                                        tag = 'replace';
                                    } else if (i < ai) {
                                        tag = 'delete';
                                    } else if (j < bj) {
                                        tag = 'insert';
                                    }
                                    if (tag) {
                                        answer.push([tag, i, ai, j, bj]);
                                    }
                                    i = ai + size;
                                    j = bj + size;
                                    if (size) {
                                        answer.push(['equal', ai, i, bj, j]);
                                    }
                                }
                            }
                        }());
                }());
            return answer;
        },
        stringAsLines = function (str) {
            var lfpos = str.indexOf("\n"),
                crpos = str.indexOf("\r"),
                linebreak = ((lfpos > -1 && crpos > -1) || crpos < 0) ? "\n" : "\r",
                lines = str.replace(/\&/g, "&amp;").replace(/\$#lt;/g, "%#lt;").replace(/\$#gt;/g, "%#gt;").replace(/</g, "$#lt;").replace(/>/g, "$#gt;");
            if (linebreak === "\n") {
                str = str.replace(/\r/g, "");
            } else {
                str = str.replace(/\n/g, "");
            }
            return lines.split(linebreak);
        },

        addCells = function (row, tidx, tend, textLines, change) {
            if (tidx < tend) {
                if (change !== "replace") {
                    textLines = textLines[tidx].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                }
                row.push("<th>" + (tidx + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;") + "</th>");
                row.push("<td class='" + change + "'>" + textLines + "</td>");
                return tidx + 1;
            } else {
                row.push("<th></th><td class='empty'></td>");
                return tidx;
            }
        },
        addCellsInline = function (row, tidx, tidx2, textLines, change) {
            row.push("<th>" + ((tidx === null) ? "" : (tidx + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;")) + "</th>");
            row.push("<th>" + ((tidx2 === null) ? "" : (tidx2 + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;")) + "</th>");
            if (tidx === null) {
                tidx = tidx2;
            }
            row.push("<td class='" + change + "'>" + textLines[tidx].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;") + "</td></tr>");
        },
        //This function is the heart behind the per character logic of the
        //Pretty Diff engine.  The logic from diff lib performs comparisons
        //per lines of code, but does not illustrate per character
        //differences for the diffview output.
        charcomp = function (c, d) {
            var i,
                j,
                k = 0,
                n,
                p,
                r = 0,
                ax,
                bx,
                zx,
                entity,
                compare,

                //Some older versions of browsers were having trouble comparing
                //between single and double quotes as string literals.  To speed
                //processing for newer browsers remove these lines.
                a = c.replace(/\'/g, "$#39;").replace(/\"/g, "$#34;").replace(/\&nbsp;/g, " ").replace(/\&#160;/g, " "),
                b = d.replace(/\'/g, "$#39;").replace(/\"/g, "$#34;").replace(/\&nbsp;/g, " ").replace(/\&#160;/g, " ");

            //This is simply a fail safe.  The logic in diffview should
            //prevent indentical items from entering charcomp, but....
            if (a === b) {
                return;
            } else {
                ax = a.split('');
                bx = b.split('');
                if (ax.length >= bx.length) {
                    zx = ax.length;
                } else if (bx.length > ax.length) {
                    zx = bx.length;
                }

                //This is a massive amount of code for a very simple task
                //Entities that have been split per character along with
                //their containing data must be reconstituted so that they
                //can be accurately interpreted as a single array index.
                entity = function (z) {
                    var a = z.length,
                        b = [];
                    for (n = 0; n < a; n += 1) {
                        if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#gt;") {
                            z[n] = '$#gt;';
                            z[n + 1] = "";
                            z[n + 2] = "";
                            z[n + 3] = "";
                            z[n + 4] = "";
                        } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#lt;") {
                            z[n] = '$#lt;';
                            z[n + 1] = "";
                            z[n + 2] = "";
                            z[n + 3] = "";
                            z[n + 4] = "";
                        } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] + z[n + 5] === "&nbsp;") {
                            z[n] = ' ';
                            z[n + 1] = "";
                            z[n + 2] = "";
                            z[n + 3] = "";
                            z[n + 4] = "";
                            z[n + 5] = "";
                            //If the two lines for replacing quote
                            //characters with entities from appoximately
                            //50 lines above were removed then these
                            //last two if conditions can also be removed
                            //to increase processing speed.
                        } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#34;") {
                            z[n] = "&#34;";
                            z[n + 1] = "";
                            z[n + 2] = "";
                            z[n + 3] = "";
                            z[n + 4] = "";
                        } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#39;") {
                            z[n] = "&#39;";
                            z[n + 1] = "";
                            z[n + 2] = "";
                            z[n + 3] = "";
                            z[n + 4] = "";
                        }
                    }
                    for (n = 0; n < a; n += 1) {
                        if (z[n] !== "" && z[n] !== undefined) {
                            b.push(z[n]);
                        }
                    }
                    return b;
                };
                ax = entity(ax);
                bx = entity(bx);
                for (i = 0; i < zx; i += 1) {
                    if (ax[i] === "&" && bx[i] !== "&") {
                        bx.splice(i, 0, "", "", "", "");
                    } else if (bx[i] === "&" && ax[i] !== "&") {
                        ax.splice(i, 0, "", "", "", "");
                    }
                }

                //This function actually determines if the same character
                //positions in two compared arrays match.  If not an <em>
                //tag is opened.  If a match is then detected, or if a space
                //is being compared to an undefined character the <em> tag
                //is closed.  This logic occurs for the duraction of the
                //character length of given lines of code so that many
                //separate matches can be specified perline.
                compare = function () {
                    var em = /<em>/g;
                    for (i = k; i < zx; i += 1) {
                        if (ax[i] === bx[i]) {
                            r = i;
                        } else {
                            if (n !== 1 && ax[i] !== bx[i] && !em.test(ax[i]) && !em.test(bx[i]) && !em.test(ax[i - 1]) && !em.test(bx[i - 1])) {
                                if (ax[i] !== undefined && bx[i] !== undefined) {
                                    ax[i] = "<em>" + ax[i];
                                    bx[i] = "<em>" + bx[i];
                                    errorout += 1;
                                } else if (ax[i] === undefined && bx[i] !== undefined) {
                                    ax[i] = "<em> ";
                                    bx[i] = "<em>" + bx[i];
                                    errorout += 1;
                                } else if (ax[i] !== undefined && bx[i] === undefined) {
                                    ax[i] = "<em>" + ax[i];
                                    bx[i] = "<em> ";
                                    errorout += 1;
                                }
                                n = 1;
                            } else if (ax[i] === undefined && (bx[i] === '' || bx[i] === ' ')) {
                                ax[i] = ' ';
                            } else if (bx[i] === undefined && (ax[i] === '' || ax[i] === ' ')) {
                                bx[i] = ' ';
                            }
                            break;
                        }
                    }
                    for (j = i + 1; j < zx; j += 1) {
                        if (ax[j] === bx[j]) {
                            ax[j - 1] = ax[j - 1] + "</em>";
                            bx[j - 1] = bx[j - 1] + "</em>";
                            k = j;
                            n = 0;
                            break;
                        } else if (ax[j] !== undefined && bx[j] === undefined) {
                            bx[j] = " ";
                        } else if (ax[j] === undefined && bx[j] !== undefined) {
                            ax[j] = " ";
                        }
                    }
                    if (j === zx && n === 1) {
                        if (ax[j - 1].indexOf("</em>") === -1) {
                            ax[ax.length - 1] = ax[ax.length - 1] + "</em>";
                        }
                        if (bx[j - 1].indexOf("</em>") === -1) {
                            bx[bx.length - 1] = bx[bx.length - 1] + "</em>";
                        }
                    }
                };

                //This logic determines if the entire line of code has not
                //been evaluated so that the compare function can fire
                //again.  This logic is what allows multiple comparisons per
                //line of code.
                for (p = 0; p < zx; p += 1) {
                    if (r + 1 !== zx) {
                        compare();
                    }
                }

                //Final computation before charcomp is finished.
                c = ax.join("").replace(/\$#lt;/g, "&lt;").replace(/\$#gt;/g, "&gt;").replace(/$#34;/g, "\"").replace(/$#39;/g, "'").replace(/ /g, "&#160;");
                d = bx.join("").replace(/\$#lt;/g, "&lt;").replace(/\$#gt;/g, "&gt;").replace(/$#34;/g, "\"").replace(/$#39;/g, "'").replace(/ /g, "&#160;");
            }
            return [c, d];
        };

    //This logic was altered to write errors as text output instead
    //of throwing creative JavaScript errors.
    if (baseTextLines === null) {
        return "Error: Cannot build diff view; baseTextLines is not defined.";
    }
    if (newTextLines === null) {
        return "Error: Cannot build diff view; newTextLines is not defined.";
    }

    baseTextLines = stringAsLines(baseTextLines);
    newTextLines = stringAsLines(newTextLines);
    opcodes = difference(baseTextLines, newTextLines);
    opleng = opcodes.length;

    //Adds two cells to the given row; if the given row corresponds
    //to a real line number (based on the line index tidx and the
    //endpoint of the range in question tend), then the cells will
    //contain the line number and the line of text from textLines at
    //position tidx (with the class of the second cell set to the name
    //of the change represented), and tidx + 1 will be returned.
    //Otherwise, tidx is returned, and two empty cells are added to the
    //given row.
    for (idx = 0; idx < opleng; idx += 1) {
        code = opcodes[idx];
        change = code[0];
        b = code[1];
        be = code[2];
        n = code[3];
        ne = code[4];
        rowcnt = Math.max(be - b, ne - n);
        for (i = 0; i < rowcnt; i += 1) {

            // jump ahead if we've alredy provided leading context
            //or if this is the first range
            if (contextSize && opcodes.length > 1 && ((idx > 0 && String(i) === contextSize) || (idx === 0 && i === 0)) && change === "equal") {
                jump = rowcnt - ((idx === 0 ? 1 : 2) * contextSize);
                if (jump > 1) {
                    node.push("<tr><th>...</th>" + ((inline === true) ? "" : "<td class='skip'></td>") + "<th>...</th><td class='skip'></td></tr>");
                    b += jump;
                    n += jump;
                    i += jump - 1;
                    // skip last lines if they're all equal
                    if (idx + 1 === opcodes.length) {
                        break;
                    }
                }
            }
            if (change !== "equal") {
                errorout += 1;
            }

            //Draw the output for the inline type of diff
            if (inline === true) {
                node.push("<tr>");
                if (change === "insert") {
                    addCellsInline(node, null, n, newTextLines, change);

                    //All diff lines receive a change value of "replace"
                    //for both inline and side by side diffs.
                } else if (change === "replace") {
                    if (b < be && n < ne && baseTextLines[b] !== newTextLines[n]) {
                        z = charcomp(baseTextLines[b], newTextLines[n]);
                        baseTextLines[b] = z[0];
                        newTextLines[n] = z[1];
                        errorout -= 1;
                    }
                    if (b < be) {
                        addCellsInline(node, b, null, baseTextLines, "delete");
                    }
                    if (b < be && n < ne) {
                        node.push("<tr>");
                    }
                    if (n < ne) {
                        addCellsInline(node, null, n, newTextLines, "insert");
                    }
                } else if (change === "delete") {
                    addCellsInline(node, b, null, baseTextLines, change);
                } else if (b < be || n < ne) {
                    baseTextLines[b] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                    addCellsInline(node, b, n, baseTextLines, change);
                }
                b += 1;
                n += 1;

                //Draw the output for the side by side type of diff
            } else {
                node.push("<tr>");

                //All diff lines receive a change value of "replace"
                //for both inline and side by side diffs.
                if (change === "replace") {
                    if (b < be && n < ne && baseTextLines[b] !== newTextLines[n]) {
                        z = charcomp(baseTextLines[b], newTextLines[n]);
                        errorout -= 1;
                    } else if (baseTextLines[b] !== undefined && newTextLines[n] !== undefined) {
                        z = [];
                        z[0] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                        z[1] = newTextLines[n].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                    } else if (baseTextLines[b] === undefined || newTextLines[n] === undefined) {
                        z = [];
                        if (baseTextLines[b] !== undefined) {
                            z[0] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                            z[1] = "";
                        } else if (newTextLines[n] !== undefined) {
                            z[1] = newTextLines[n].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                            z[0] = "";
                        }
                    }
                    b = addCells(node, b, be, z[0], change);
                    n = addCells(node, n, ne, z[1], change);
                } else {
                    b = addCells(node, b, be, baseTextLines, change);
                    n = addCells(node, n, ne, newTextLines, change);
                }
                node.push("</tr>");
            }
        }
    }
    rows.push(node.join(""));
    tbody.push(rows.join(""));
    return (thead + tbody.join("") + "</tbody><tfoot>" + tfoot).replace(/\%#lt;/g, "$#lt;").replace(/\%#gt;/g, "$#gt;");
};