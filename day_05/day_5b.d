import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.conv;

void doit(string fname) {
    auto file = File(fname,"r");
    long count=0;
    long[][] ranges;
    long left,right;
    int i,j;
    bool changed;
    foreach(line; file.byLineCopy()) {
        if(line.length<1) {
            break;
        }
        string[] tmp=line.split("-");
        left=to!long(tmp[0]);
        right=to!long(tmp[1]);
        changed=false;
        for(i=0;i<ranges.length;i++) {
            if((left>=ranges[i][0])&&(left<=ranges[i][1])) {
                if(right>ranges[i][1]) {
                    changed=true;
                    ranges[i][1]=right;
                    continue;
                }
            }
            if((right>=ranges[i][0])&&(right<=ranges[i][1])) {
                changed=true;
                if(left<ranges[i][0]) {
                    changed=true;
                    ranges[i][0]=left; 
                    continue;
                }
            }
        }    
        if(changed)
            continue;
        long []pair=new long[2];
        pair[0]=left;
        pair[1]=right;
        ranges~=pair;
    }
    // compress overlaps
    changed=true;
    int change_count;
    for(;;) {
        change_count=0;
        for(j=0;j<ranges.length;j++) {
            left=ranges[j][0];
            if(left==-1)
                continue;
            right=ranges[j][1];
            changed=false;
            for(i=0;i<ranges.length;i++) {
                if((i==j)||(ranges[i][0]==-1))
                    continue;
                if((left>=ranges[i][0])&&(left<=ranges[i][1])) {
                    if(right>ranges[i][1]) {
                        changed=true;
                        ranges[i][1]=right;
                        continue;
                    }
                }
                if((right>=ranges[i][0])&&(right<=ranges[i][1])) {
                    changed=true;
                    if(left<ranges[i][0]) {
                        changed=true;
                        ranges[i][0]=left; 
                        continue;
                    }
                }
            }
            if(changed) {
                ranges[j][0]=-1;
                change_count++;
            }            
        }
        if(change_count==0)
            break;
    }
    foreach(range; ranges) {
        if(range[0]!=-1) {
            count+=(range[1]-range[0])+1L;
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