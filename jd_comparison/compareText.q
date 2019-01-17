files:`li`sp`jp`rand;
{x set raze read0 hsym `$"C:/tmp/",string[x],".txt"} each files;
clean:{trim lower x (ssr[;;""])/y}[;",.();:<>/"];
combo:raze {x cross (y except x)}[;files] each files;
a:desc combo!{
    s:"," sv asc (inter). distinct each " "vs' clean each value each x;
    r:count[(inter). v]%count distinct raze v:distinct each " "vs' clean each value each x;
    0N!("+"sv string x)," Score: ",string[r]," - ",s;
    r
} each combo;
show a

