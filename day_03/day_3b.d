import std.stdio;
import std.conv;
import std.file;
import std.datetime.stopwatch;

unittest {
    assert(joltage("987654321111111")==987654321111L);
    assert(joltage("234234234234278")==434234234278L);
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
    string largest;
    while(line.length!=12) {
        largest="";
        for(int i=0;i<line.length;i++) {
            string s="";
            for(int j=0;j<line.length;j++) {
                if(j!=i) {
                    s=s ~ line[j];

                }
            }
            if(s>largest) 
                largest=s;
        }
        line=largest;
    }
    return to!long(line);
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
