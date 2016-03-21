# Patent_Parsing_SAS

MasterParser is the main code to run to parse weekly patents folders (for 2015 and 2016, for example):

  MasterParser contains SAS code that defines libraries (where my XML files are, where I want to save my parsed CSV and SAS datasets) 
  and it calls the GetFileListMacro.
  
    GetFileListMacro goes to the folder where the weekly XMLs are stored and counts how many files (weeks) are there.
    
    GetFileListMacro sets up a do loop equal to the number of files in the folder.
    
      Inside the do loop, GetFileListMacro calls the PatentParse_V14, which parses one weekly XML file.
      PatentParse_V14 calls the RemoveTagsMacro as needed, to remove XML tags from text I need for patent variables.
      After GetFileListMacro finishes with 1 weekly file, it appends that week's patents to patents previously parsed in the do loop.
      It then keeps moving through the do loop, processing every file in the folder.
      When finished, GetFileListMacro passes back to the MasterParser.
      
At the end of MasterParser, I save all patents to a permament SAS dataset and a CSV file.

PatentParse_V17_2013_from3_xml is a special version of PatentParse_V14 that handles 2013 only, as 2013 patents are stored in 3 xmls.

PatentParse_V17_1_xml is a special version of PatentParse_V14 that parses 2011, 2012, and 2014 each separately, because one single xml
  containing all patents for (that) year is available for download.
  
For these last two files (PatentParse_V17_XXXXXX), I didn't need to use MasterParser or GetFileListMacro, as I didn't need to process
  a folder of XML files that varied in the number of files in the folder.
