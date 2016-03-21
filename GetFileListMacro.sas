%MACRO GetFileList(directoryPath);
%PUT Using Directory Path *** &directoryPath ***;
FILENAME scr "&directoryPath";

/* OPEN THE DIRECTORY */
DATA _null_;
	%LET dir_id = %SYSFUNC(DOPEN(scr));
	IF &dir_id = 0 THEN PUT "Directory could not be opened.";
	ELSE PUT "Assigned Directory ID = &dir_id";
	%LET num_items = %SYSFUNC(DNUM(&dir_id));
RUN;

/* Loop through the directory, read the name of each file, and pass it to the PatentParse macro. */
%LET i = 1;
%DO %WHILE (&i <= &num_items);
	%LET item_name = %SYSFUNC(DREAD(&dir_id, &i));
	%LET filePath = %UNQUOTE(&directoryPath)\&item_name;
	%PatentParse_V14("&filePath")
	%IF %SYSFUNC(EXIST(work.patent_data_all)) %THEN %DO;
		DATA work.patent_data_all;
			SET work.patent_data_all work.patent_data;
		RUN;
	%END;
	%ELSE %DO;
		DATA work.patent_data_all;
			SET work.patent_data;
		RUN;
	%END;
	%LET i = %EVAL(&i + 1);
%END;

/* CLOSE THE DIRECTORY */
DATA _null_;
	%LET dir_closed = %SYSFUNC(DCLOSE(&dir_id));
	IF &dir_closed = 0 THEN PUT "Directory successfully closed.";
	ELSE PUT "****  FAILED TO CLOSE DIRECTORY  ****";
RUN;

%MEND GetFileList;

