import std.file;

import vivint.csv;

int main(string[] args)
{
    const arg_offset = 1;

    string[][] data;

    File input  = stdin;
    File output = stdout;
    
    if (args.length > 1)
    {
        const input_path = args[1];

        writefln("Reading from file: \"%s\"", input_path);
        
        input = new File(input_path, FileMode.In);
    }
    
    auto data = load_tsd(input);

    if (args.length > 2)
    {
        const output_path = args[2];
        
        writefln("Writing to file: \"%s\"", output_path);

        output = new File(output_path, FileMode.Out);
    }
    
    save_csv(output, data);

    return 0;
}