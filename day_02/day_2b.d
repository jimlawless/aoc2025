import std.stdio;
import std.conv;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.regex;

unittest {
    assert(! is_valid("12341234"));
    assert( is_valid("123451234"));
    assert(! is_valid("123123123"));
    assert(! is_valid("1111111"));  
    assert(! is_valid("3333333"));    
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
                if( !is_valid(s) ) {
                    sum+=i;
                }
            }
        }
    }
    writeln(sum);
    file.close();
}

bool is_valid(string id) {
    int len=id.length;
    for(int i=0;i<len/2;i++) {
        if(len%(i+1)==0) {
            string needle=id[0..i+1];
            string haystack=id[i+1..$]; 
            if(!is_valid_recurse(needle,haystack))
                return false;
        }
    }
    return true;
}

bool is_valid_recurse(string needle,string haystack) {
    if(needle==haystack)
        return false;
    if(needle==haystack[0..needle.length]) 
        return is_valid_recurse(needle,haystack[needle.length..$]);
    return true;
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
