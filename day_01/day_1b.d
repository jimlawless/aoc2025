import std.stdio;
import std.conv;
import std.file;
import std.array;
import std.datetime.stopwatch;

void doit(string fname) {
    auto file = File(fname,"r");
    int count;    
    int rotations;
    int position=50;
    int rval;
    int zeroes;
    foreach(line; file.byLineCopy()) {
        rotations=0;
        rval=to!int(line[1..$]);
        zeroes=rval / 100;
        rval=rval % 100 ;
        if(line[0]=='R') {
            rotations=rval;
        }     
        else 
        if(line[0]=='L'){
            rotations=rval*-1;
        }
        else {
            writeln("Error! ",line);       
            return;
        }
        int previous_position=position;
        position+=rotations;
        if(position>99) {
            zeroes++;
            position=position-100;
        }
        else
        if(position<0) {
            if(previous_position!=0)
                zeroes++;
            position=100+position;
        }
        else
        if(position==0) {
            zeroes++;
        }
        count+=zeroes;
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
