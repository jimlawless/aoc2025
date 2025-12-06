import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.conv;

void doit(string fname) {
    auto file = File(fname,"r");
    long sum=0;
    string[][] lines;
   
    foreach(line; file.byLineCopy()) {
        lines ~= line.split();
    }
    auto ops=lines[lines.length-1];
    for(int j=0;j<ops.length;j++) {
        long accum=0;
        for(int i=0;i<(lines.length-1);i++) {
            long operand=to!long(lines[i][j]);
            if(ops[j]=="+")
                accum=(accum==0) ? operand : accum + operand ;
            else
                accum=(accum==0) ? operand : accum * operand ;
        }
        sum+=accum;
    }
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