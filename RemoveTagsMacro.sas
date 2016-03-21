%MACRO RemoveTag(textValue, grantNum);

/*
This macro accepts a text value. It removes all tagsets and returns the new text value via the cleanText macro variable.
Any text between the "<" and ">" brackets, inclusive of the brackets themselves, is removed.
Commented PUT statements are for testing purposes.
*/

/*%PUT GRANT NUMBER IS &grantNum;*/
/*%PUT Starting with text value &textValue;*/
	/* Iterate through the text value until the "<" symbol is no longer found. */
	%DO %WHILE (%SYSFUNC(FINDC(&textValue,'<')) > 0);
		%LET startPosition = %SYSFUNC(FINDC(&textValue,'<')); /*Start position is position of "<" */
		/*%PUT Start position is &startPosition;*/
		%LET endPosition = %SYSFUNC(FINDC(&textValue,'>'));/*End position is position of ">" */
		/*%PUT End position is &endPosition;*/
		/* Set tagText variable equal to entire tagset, inclusive of brackets (e.g., '<doc-number>'). */
		%LET tagText = %SYSFUNC(SUBSTR(&textValue,&startPosition,%EVAL(&endPosition - &startPosition + 1)));
		/*%PUT Text to remove is *&tagText*;*/
		%LET textValue = %SYSFUNC(TRANSTRN(&textValue,&tagText,)); /* Replace occurrences of tagText with an empty string. */
		%LET textValue = %SYSFUNC(TRANWRD(&textValue,"  "," ")); /* Replace any resulting double spaces with single spaces. */
	%END;
	/*%PUT Final text is ***&textValue***;*/
	/* Set the cleanText macro variable equal to the processed text value. */
	%LET cleanText = &textValue;
%MEND RemoveTag;

/* UNCOMMENT LINE BELOW TO TEST */
/*%RemoveTag(Here is some <someTag> text </someTag>)*/
