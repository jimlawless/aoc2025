import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.conv;
import std.regex;

void doit(string fname) {
    auto file = File(fname,"r");
    long sum=0;
    string[] lines;
   
    foreach(line; file.byLineCopy()) {
        lines ~= line;
    }
    
    // pivot array 90 degrees to the left
    string []rotate=new string[0];    
    for(int col=(lines[0].length)-1;col>=0;col--) {
        char []carr=new char[0];
        for(int row=0;row<lines.length;row++) {
            carr~=lines[row][col];
        }
        rotate~=to!string(carr);
    }

    // parse each line and add to series of terms 
    // with forward-polish-notation    
    auto rx=regex(r"([0-9]+|[+]|[*])");
    string[] terms=new string[0];
    foreach(line; rotate) {
        auto matches=matchAll(line,rx);
        foreach(match; matches) {
            terms~=match[0];
        }
    }
    long accum=0;
    string op="";
    // process stream of FPN operations
    for(int i=terms.length-1;i>=0;i--) {
        if(terms[i]=="+") {
            op="+";
            sum+=accum;
            accum=0;
            continue;
        }
        if(terms[i]=="*") {
            op="*";
            sum+=accum;
            accum=0;
            continue;
        }                              
        long operand=to!long(terms[i]);
        if(op=="+")
            accum=(accum==0) ? operand : accum + operand ;
        else
            accum=(accum==0) ? operand : accum * operand ;
    }
    sum+=accum;
    writeln(sum);
    file.close();
}

void main(string[] args) {
    if(args.length < 2) {
        writeln("Syntax:\n\t",args[0]," filename\n");
        return;
    }
    auto sw = StopWatch(AutoStart.no);
    sw.start();
    try {
        doit(args[1]);
    }
    catch(FileException e) {
        writeln("Exception: ", e.msg);
    }
    sw.stop();
    writeln("Elapsed time: ",sw.peek());
}