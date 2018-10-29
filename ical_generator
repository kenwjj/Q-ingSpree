{[export_path;ltd_expiry_path;holiday_path;exportflag;calType] 

    // Variants of Calendars
    calType:$[calType=`;`Trading`Clearing;enlist calType];
    gen:{[export_path;ltd_expiry_path;holiday_path;exportflag;calType]

    filename:$[`Trading in calType;(export_path,"sgxdtcalendar.ics");`Clearing in calType;(export_path,"sgxdccalendar.ics")];
    calendarname:"SGX Derivatives ",(string calType)," Calendar";
    // Construct header constants
    main_header:flip (`col1`col2)!(enlist "BEGIN";enlist "VCALENDAR");
    props:("2.0";"-//Microsoft Corporation//Outlook 16.0 MIMEDIR//EN";"PUBLISH";calendarname;calendarname);
    main_header_preamble:([] col1:("VERSION";"PRODID";"METHOD";"X-WR-CALNAME";"X-WR-CALDESC"); col2:props);
    timezone_header:([] col1:("BEGIN";"TZID";"BEGIN";"DTSTART";"TZOFFSETFROM";"TZOFFSETTO";"END";"END");col2:("VTIMEZONE";"Malay Peninsula Standard Time";"STANDARD";"16010101T000000";"+0800";"+0800";"STANDARD";"VTIMEZONE"));
    main_footer:flip (`col1`col2)!(enlist "END";enlist "VCALENDAR");

    // Generate event function
    generateItem:{[st;et;created;label;title]
             getUniqueID:{raze string md5 ((string x),y)}; 
             convertDate:{(string `date$x) except "."};
                      
             item:()!(); 
             item[`BEGIN]:"VEVENT";
             item[`UID]:getUniqueID[st;title];
             item[`CATEGORIES]:label;
             item[`DTSTAMP]: convertDate[created];
             item[`$"DTSTART;VALUE=DATE"]: convertDate[st];
             item[`$"DTEND;VALUE=DATE"]: convertDate[et+1];
             item[`SUMMARY]: title;
             item[`END]:"VEVENT";
             flip (`col1`col2)!((string key item);(value item))
        };

        // Load files
        loadExpiryLTDCSV:{[path] ("*DD**"; enlist ",") 0:hsym `$path};
        loadHolidays:{[path]  ("s*D*"; enlist ",") 0:hsym `$path};
             
        ltd_expiry:loadExpiryLTDCSV[ltd_expiry_path];

        // When not trading calType add the [O] or [F] postfix
        expiry:$[`Trading in calType;
            (select expiry:"," sv {(x,"[",(1#y),"]")}'[underlying;insttype] by date:expiry from ltd_expiry where not null expiry);
            (select expiry:"," sv {(x,"[",(1#y),"]")}'[series;insttype] by date:expiry from ltd_expiry where not null expiry)
        ];
        // When not trading calType add the [O] or [F] postfix
        ltd:$[`Trading in calType;
            (select ltd:"," sv {(x,"[",(1#y),"]")}'[underlying;insttype] by date:ltd from ltd_expiry where not null ltd);
            (select ltd:"," sv {(x,"[",(1#y),"]")}'[series;insttype] by date:ltd from ltd_expiry where not null ltd)
        ];

        holidays:loadHolidays[holiday_path];
        holidays:select holiday:{"," sv x}[string distinct holidaycentre] by date:eventdate from holidays;

        // only for display
        format:`date xasc (ltd uj expiry uj holidays);

        consolidated:(select date,event:expiry, event_type:`expiry from expiry),
            (select date,event:ltd, event_type:`ltd from ltd),
            (select date,event:holiday, event_type:`holiday from holidays);

        consolidated:select distinct date, event, event_type from consolidated;
        
    	consolidatedXL:select from consolidated where ({count "," vs x} each event) > 25;
    	consolidatedXL:update t:{"," vs x} each event from consolidatedXL;
    	consolidatedXL: ungroup select event_type,date, {25 cut x} each t from consolidatedXL;
    	consolidatedXL:select date, event:{"," sv x} each t,event_type from consolidatedXL;
    	
    	consolidated: select from consolidated where ({count "," vs x} each event) <= 25;
    	consolidated:consolidated,consolidatedXL;
        
        formatEvents:{
            format_line:{
                /dict:(`ltd`expiry`holiday)!(("▲";"◼";"X"));  
                dict:(`ltd`expiry`holiday)!(("LTD";"FSP Date";"Holiday"));  
                dict[x],": ",y
            };
            summary:format_line[x[`event_type];x[`event]];
            label:((`ltd`expiry`holiday)!("Blue Category";"Green Category";"Orange Category"))[x[`event_type]];
            (`timestamp$x[`date];`timestamp$x[`date]+1;.z.P;label;summary)
        };

        // generate events    
        events:raze generateItem .'formatEvents each consolidated;
        export:(main_header,main_header_preamble,timezone_header,events,main_footer);

        if[exportflag;(hsym `$filename) 0:1_":" 0:export];
        export
    };  

    show raze gen[export_path;ltd_expiry_path;holiday_path;exportflag;] each calType

    };
