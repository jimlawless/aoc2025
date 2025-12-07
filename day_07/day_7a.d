import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.conv;

void doit(string fname) {
    auto file = File(fname,"r");
    long count=0;
    char[][] lines;
    int pos=-1;   
    foreach(line; file.byLineCopy()) {
        lines~=line.dup;
    }
    for(int i=0;i<lines[0].length;i++) {
        if(lines[0][i]=='S') {
            pos=i;
            break;
        }
    }
    countSplits(lines,count,1,pos);
    writeln(count);
    file.close();
}

void countSplits(ref char[][] lines,ref long count,int depth, int pos) {
    if(depth==lines.length)
        return;
    char c=lines[depth][pos];
    if( (c=='.')||(c=='|')) {
        lines[depth][pos]='|';
        countSplits(lines,count,depth+1,pos);
    }
    else
    if(c=='*')
        return;
    else
    if(c=='^') {
        count++;
        lines[depth][pos]='*';
        countSplits(lines,count,depth+1,pos-1);
        countSplits(lines,count,depth+1,pos+1);
    }
    else
        writeln("Error ! Character is ",c);
    return;
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