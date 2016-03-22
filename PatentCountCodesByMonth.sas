/*This code analyses how the USPTO transitioned to the CPC system by month.
  It determines whether the patent has just an assigned USPC, just an assigned CPC, or both.
  It creates a count of each situation by month, for each month from Jan 2013 to Dec 2015,
	which is the timeframe over which the USPTO transitioned from USPC to CPC.*/

/* Define library where patent data is stored. */
LIBNAME pats "C:\Users\Mprice79\Documents\MP_Patents\Patent_SAS";

*Append 2013 to 2015 patents together;
data all_patents;
	set 
	  	pats.patent_data_2013
		pats.patent_data_2014
		pats.patent_data_2015
		;
		*Create a yymonth variable from the grant_date;
		yrmonth=substrn(grant_date,1,6);
	run;

*Need to sort dataset before first. and last. variables become available to use;
Proc sort data=all_patents out=sorted_patents;	
	by yrmonth;
	run;

/*This data step groups the data by month and counts the number of patents with cpc code only, uspc code only,
	and both cpc and uspc codes.  Unfortunately detecting missing values did not work on this data, so I needed to
	use the "anyalnum" function to detect if the cpc or uspc was missing. Doing it 6 times as I have is processing
	time intensive.  If I created 2 variables to hold the results of the "anyalnum" function, 
	then did the if/then, it might be faster. */
	
data pats.counts_patents;
	set sorted_patents;
	by yrmonth; *yrmonth is my group by variable;
	*I must retain the values of the count variables while reading in a yrmonth (where yrmonth is the "by"/sort variable);
	retain cpc_only_count uspc_only_count have_both_count;
	*Reinitialize counts to 0 at the start of a new month.;
	if first.yrmonth then do;
		cpc_only_count=0;
		uspc_only_count=0;
		have_both_count=0; 
	end;
	
	if (anyalnum(main_uspc) > 0 )	and (anyalnum(cpc_m_section) = 0) then uspc_only_count+1;  
	if (anyalnum(cpc_m_section) > 0) and (anyalnum(main_uspc) = 0) then cpc_only_count+1;
	if (anyalnum(cpc_m_section) > 0) and (anyalnum(main_uspc) > 0)  then have_both_count+1;   
	
	*Output the counts when I'm done processing a yrmonth.;
	if last.yrmonth=1 then output;
	keep yrmonth cpc_only_count uspc_only_count have_both_count;
	
	run; 
