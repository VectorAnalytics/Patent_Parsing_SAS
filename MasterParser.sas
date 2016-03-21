/*This code will parse a folder of XML files.*/

/* Substitute your macro file paths here */
%INCLUDE "H:\Patent\Programs\GetFileListMacro.sas";
%INCLUDE "H:\Patent\Programs\RemoveTagsMacro.sas";
%INCLUDE "H:\Patent\Programs\PatentParse_V14.sas";

/*The cleanText variable is used in the RemoveTagsMacro.*/
%GLOBAL cleanText;

/* Substitute the folder where you would like to store the utility patents dataset */
LIBNAME pats "C:\Users\mprice79\Documents\MP_Patents\Patent_SAS";

/* Substitute your ExtractedDownloads folder path here */
%LET pathPrefix = C:\Users\mprice79\Documents\MP_Patents\Patent_xml\2016;

/*The GetFileList macro does two things: (1) it counts the number of xml files you have in the folder to
parse and uses that num to set the loop and (2) it invokes the ParentParser file with does the actual parsing
of the xml into the patent variables we need and keeps only the utility patents. The following line of code
invokes this macro.*/

%GetFileList(&pathPrefix)

/*Output the completely parsed and appended final dataset to both a permanent sas dataset
a csv file.*/
/*Rename the permanent sas datatable and the csv file as needed.*/

DATA pats.patent_data_2016;
	SET work.patent_data_all;	
RUN;

Proc export data=work.patent_data_all
	outfile="C:\Users\mprice79\Documents\MP_Patents\Patent_CSV\Patent_data_2016.csv"
	dbms=csv
	replace;
	run;
