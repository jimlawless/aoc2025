import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;

void doit(string fname) {
    auto file = File(fname,"r");
    char[][] lines;
    long [int] memo;
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
    long sum=countSplits(lines,1,pos,memo);
    writeln(sum);
    file.close();
}

long countSplits(ref char[][] lines,int depth, int pos,ref long[int]memo) {
    if(depth==lines.length) {
        return 1L;
    }
    char c=lines[depth][pos];
    if( (c=='.')||(c=='|')) {
        lines[depth][pos]='|';
        return countSplits(lines,depth+1,pos,memo);
    }
    else
    if(c=='*') 
        return memo[depth*10000+pos];
    else
    if(c=='^') {
        lines[depth][pos]='*';
        long tmp=countSplits(lines,depth+1,pos-1,memo);
        tmp+=countSplits(lines,depth+1,pos+1,memo);
        memo[depth*10000+pos]=tmp;
        return tmp;
    }
    else
        writeln("Error ! Character is ",c);
    return 0;
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