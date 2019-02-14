// 1A
nums:"I"$read0`:C:/tmp/aoc/aoc1.txt;
sum nums
// 1B
{s:1_sums z,x;if[not count s inter y;:.z.s[x;(y,s);last s]] first s inter y}[nums;();0]

// 2A
ids:read0`:C:/tmp/aoc/aoc2.txt;
{(count x)*count y}. value group raze {key .[x;();_;1]} each count each'group each count each'value each group each ids

// 2B
{x where x=y}. ids@where any each {{(count where not x=y)=1}[;y] each x}[ids;] each ids

// 3A
coord:update h:"I"$first each ","vs'p, v:"I"$last each ","vs'p, w:"I"$first each "x"vs'd, l:"I"$last each "x"vs'd 
    from update p:first each ":"vs'cnt,d: last each ":"vs'cnt from trim flip (`idx`cnt)!flip "@"vs'read0`:C:/tmp/aoc/aoc3.txt;

sum 1<value count each group raze {raze {(((x[`h]+1) + til x[`w]) cross (x[`v]+1+y))}[x;] each til x[`l]} each coord

// 3B
tab:flip (`id`coord)!raze each flip {((count[a]#`$x[`idx]);a:raze{(((x[`h]+1)+ til x[`w]) cross (x[`v]+1+y))}[x;] each til x[`l])} each coord;
first (`$coord[`idx]) except (asc distinct raze exec id from (select distinct id, c:count i by coord from tab) where c > 1) 

// 4A 
sch:flip (`dt`des)!flip trim "]"vs'1_ 'read0 `:C:/tmp/aoc/aoc4.txt
sch:`dt xasc update dt: ("D"${"20", 2_x}each first each " "vs'dt)+"T"$last each" "vs'dt from sch
sch:update id:fills ?[des like "Guard*";`$@'[" "vs'des;1];`],`$des from sch;
sch:delete from sch where des like "Guard*";
check:update sleeping:(-1+"u"$dt)-til each dur from update dur:?[des like "wakes up";"i"$"u"$dt-prev dt;0] from sch;
maxid:(exec first id from `dur xdesc select sum dur by id from check);
res:0!desc select count i by sleeping from (ungroup check) where id=maxid
("i"$first first res) * "I"$1_string maxid

// 4B
first exec idn*"i"$sleeping from 0!1#`cnt xdesc select idn:first "I"$1_'string[id],cnt:count i by id,sleeping from (ungroup check)

// 5A - redo. have to to match polymers left to right removing 1 pair at a time. 
pol:first read0 `:C:/tmp/aoc/aoc5.txt
d:(reverse a)!a:reverse[.Q.a],.Q.A;
// recursive way - it dies at pol except "tT" due to stackoverflow
collapse:{if[0=sum i:x=y[next x];:x];rem:(x@ (til count x) except b,1+b:$[1=sum v:where i;v;v where 1<>deltas v]);-1 string count[rem];.z.s[rem;y]};
collapse[pol;d]

// 5B
// Loop way - doesnt go into stackoverflow
collapseLoop:{polMod:x;while[0<sum i:polMod=y[next polMod];polMod:(polMod@ (til count polMod) except b,1+b:$[1=sum v:where i;v;v where 1<>deltas v])];polMod};
min {count collapseLoop[x;y]}[;d] each {pol except x} each k:flip (.Q.a;.Q.A)

// 6A
/ coord:asc update id:string i from flip (`x`y)!flip a:"I"$trim"," vs'read0`:C:/tmp/aoc/aoc6.txt;
/ board:{x#enlist x# enlist string "."}[(max coord[`x])|(max coord[`y])+20]
/ board:{x[y[0];y[1]]:y[2];x}/[board;flip value flip coord]

flag:flag,'til count flag:"I"$trim"," vs'read0`:C:/tmp/aoc/aoc6.txt;
coord:update string id from flip (`x`y`id)!flip flag;
gen:{(min x@'y) + til ((max x@'y)-(min x@'y))};
rest:(gen[flag;0] cross gen[flag;1]),\:enlist string ".";

mhd:{abs[(x-z[0])]+abs[(y-z[1])]};
c:`$"col",/:(string exec asc "I"$id from coord where not id like enlist ".");
wc:c!{(?;(like;`id;(enlist;"."));(`mhd;`x;`y;(enlist;x[0];x[1];x[2]));0Ni)} each flag;
tab:update "j"$x, "j"$y from (asc flip (`x`y`id)!flip rest);
tab: ![0!((2!tab) upsert coord);();0b;wc];

mapper:ungroup {(`x`y`distance`coordinate)!((y@`x);(y@`y);a:raze y[x];c)}[c;] each tab;
/ mapper:select from mapper where ([]distance;coordinate) in (select distinct distance,coordinate from (select 1<count i by distance,coordinate from mapper) where x);
mapper:select from (select cnt:count i,last coordinate  by x,y,distance from mapper) where cnt=1;

res:select from mapper where distance=(min;distance) fby ([]x;y);
`cnt xdesc select from ((0!select cnt:count i by id:last each "l" vs'string coordinate from res) lj `id xkey coord) 
where not x in (max gen[flag;0];min gen[flag;0]), not y in (max gen[flag;1];min gen[flag;1])


((0!select cnt:count i by id:last each "l" vs'string coordinate from res) lj `id xkey coord) 

select count i by x,y from tab


update total:x+y from coord