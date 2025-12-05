import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.conv;

void doit(string fname) {
    auto file = File(fname,"r");
    int count=0;
    long[][] ranges;
   
    foreach(line; file.byLineCopy()) {
        if(line.length<1) {
            break;
        }
        string[] tmp=line.split("-");
        ranges~=new long[2];
        ranges[ranges.length-1][0]=to!long(tmp[0]);
        ranges[ranges.length-1][1]=to!long(tmp[1]);
    }
    foreach(line; file.byLineCopy()) {
        long food=to!long(line);
        foreach(range; ranges) {
            if( (food>=range[0]) && (food<=range[1])) {
                count++;
                break;
            }
        }
    }     
    writeln(count);
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