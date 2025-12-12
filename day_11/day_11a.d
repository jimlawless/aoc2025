import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;
import std.string;


struct Device {
    int count;
    string []connections;
    int delegate(string key) traverse;
    
    int countHopsToOut(string key) {
        Device d=devices[key];
        if(key=="out") {
            d.count++;
            return d.count;
        }
        foreach(subkey; d.connections) {
            d.count+=d.traverse(subkey);
        }
        d.traverse=&returnCount;
        return d.count;
    }
    int returnCount(string key) {
        return devices[key].count;
    }
}

Device[string] devices;

void doit(string fname) {

    Device outdev;
    outdev.count=0;
    outdev.traverse=&outdev.countHopsToOut;
    devices["out"]=outdev;
    
    auto file = File(fname,"r");
    foreach(line; file.byLineCopy()) {
        string[]words=line.idup.strip.split();
        Device d;
        d.connections=words[1..$];
        d.count=0;
        d.traverse=&d.countHopsToOut;
        devices[words[0][0..3]]=d;
    }
    Device d=devices["you"];
    writeln(d.traverse("you"));
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