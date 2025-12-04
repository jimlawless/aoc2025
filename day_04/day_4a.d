import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;

void doit(string fname) {
    auto file = File(fname,"r");
    int count=0;
    string [] arr;
   
    foreach(line; file.byLineCopy()) {
        arr~=line;
    }
    // [row][col]
    auto one_off = [ [-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1] ] ;
    for(int i=0;i<arr.length;i++) {
        int roll_count;
        for(int j=0;j<arr[i].length;j++) {
            roll_count=0;
            if(arr[i][j]=='@') {
                for(int k=0;k<one_off.length;k++) {
                    if(find_roll(arr,i+one_off[k][0],j+one_off[k][1])) {
                        roll_count++;
                    }
                }
                if(roll_count<4) {
                    count++;
                }
            }
        }
    }
      
    writeln(count);
    file.close();
}

bool find_roll(string [] a, int row, int col) {
    if( (row<0)||(col<0)) 
        return false;
    if( (row>=a.length)||(col>=a[0].length)) 
        return false;
    if(a[row][col]=='@') 
        return true;
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