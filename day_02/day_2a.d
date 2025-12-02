import std.stdio;
import std.conv;
import std.file;
import std.array;
import std.datetime.stopwatch;

unittest {
    assert(is_valid("999"));
    assert( ! is_valid("9898"));
    assert(is_valid("9897"));    
}

void doit(string fname) {
    auto file = File(fname,"r");
    long sum=0;    
    foreach(line; file.byLineCopy()) {
        auto pairs=line.split(",");
        foreach(p; pairs) {
            auto id_pairs=p.split("-");
            long left=to!long(id_pairs[0]);
            long right=to!long(id_pairs[1]);
            if(left>right) {
                auto tmp=left;
                left=right;
                right=tmp;
            }
            for(long i=left;i<=right;i++) {
                string s=to!string(i);
                if( ! is_valid(s) ) {
                    sum+=i;
                }
            }
        }
    }
    writeln(sum);
    file.close();
}

bool is_valid(string id) {
    int l=id.length;
    if( (l % 2 )==1 ) 
        return true;
    int pos=l / 2;
    for(int i=0;i<pos;i++) {
        if(id[i]!=id[i+pos]) {
            return true;
        }
    }
    return false;
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
