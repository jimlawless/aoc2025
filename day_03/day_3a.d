import std.stdio;
import std.conv;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.format;

unittest {
    assert(joltage("811111111111119")==89L);
}

void doit(string fname) {
    auto file = File(fname,"r");
    long sum=0;
    foreach(line; file.byLineCopy()) {
        sum+=joltage(line);
    }
    writeln(sum);
    file.close();
}

long joltage(string line) {
    char d1='0';
    char d2='0';    
    long j;
    int pos=0;
    for(int i=0;i<line.length-1;i++) {
        char c=line[i];
        if(c>d1) {
            d1=c;
            pos=i;
        }
    }
    for(int i=pos+1;i<line.length;i++) {
        char c=line[i];
        if(c>d2) {
            d2=c;
        }                            
    }
    j=to!long(format("%c%c",d1,d2));
    return j;
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
