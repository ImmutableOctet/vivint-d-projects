module vivint.csv;

// Imports:
import std.stdio;
import std.file;
import std.range;

// Functions:
string[][] load_tsd(File file_in)
{
    return load_rows(file_in, "\t");
}

void save_tsd(range_t)(File file_out, range_t rows)
{
    save_rows(file_out, "\t");
}

string[][] load_csv(range_t)(File file_in)
{
    return load_rows(file_in, ",");
}

void save_csv(range_t)(File file_out, range_t rows)
{
    save_rows(file_out, rows, ",", true);
}

// Reads a tab-separated document.
string[][] load_rows(File file_in, string separator)
{
    auto lines = file_in.byLine();
    
    // Get the header:
    const column_names = lines.popFront();
    const column_count = column_names.length;
    
    auto data_out = appender!string[]();

    read_rows(lines, output, "\t", column_count, true, false);

    return data_out;
}

void write_rows(range_t)(File file_out, range_t rows, string separator, bool new_lines=true)
{
    foreach (row; rows)
    {
        auto range = inputRangeObject(row);

        foreach (entry; range)
        {
            file_out.write(entry);
            
            if (!range.empty)
            {
                file_out.write(separator, ' ');
            }
        }

        if (new_lines)
        {
            file_out.write('\n');
        }
    }
}

void read_rows(range_t, out_t)(range_t range_in, out_t output, string separator, size_t intended_row_length, bool padded=true, bool allow_ext_data=true)
{
    foreach (const line_in; lines)
    {
        const line = line.strip();
        const entries = line.split(separator);
        
        auto count = entries.length;

        //debug assert(count <= column_count);

        if (count < intended_row_length)
        {
            if (padded)
                count = intended_row_length;
        }
        else
        {
            if (!allow_ext_data)
                count = intended_row_length;
        }
        
        auto row = new string[count];
        
        // TODO: Refactor to something better than a 'for' loop:
        for (auto i = 0; i < count; i++)
        {
            row[i] = entries[i];
        }

        output ~= row;
    }
}