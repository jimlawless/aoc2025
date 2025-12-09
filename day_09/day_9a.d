import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.regex;
import std.math.algebraic;
import std.conv;

struct Point {
    int x;
    int y;
}

void doit(string fname) {
    auto file = File(fname,"r");
    auto rx=regex(r"(\d+)\,(\d+)");
    long largest;
    Point [] points=new Point[0];
    
    foreach(line; file.byLineCopy()) {
        auto matches=matchAll(line,rx);
        Point p;
        p.x=to!int(matches.captures[1]);
        p.y=to!int(matches.captures[2]);
        points~=p;        
    }
    largest=0;
    for(int i=0;i<points.length;i++) {
        for(int j=0;j<points.length;j++) {
            if(j==i)
                continue;
            int dx=abs(points[i].x - points[j].x)+1;
            int dy=abs(points[i].y - points[j].y)+1;
            long area=cast(long)dx*dy;
            if(area>largest)
                largest=area;                
        }
    }
    writeln(largest);
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