-- Author: Jonas Bakelaar (0964977)
-- Date: April 8, 2018
-- Description: Program that calculates the Flesch index and Flesch Kincaid Level of a text passage provided through a file.
-- Sources: I used the algorithm at this link: http://www.csc.villanova.edu/~mdamian/Past/csc3990fa08/papers/nlp/talburt_1986.pdf 
--          This algorithm helped set a base for how to count syllables, words and sentences. It also provided a base code/algorithm for how to determine the 
--          flesch index of a particular passage.
--          Additionally, code for checking to ensure a file existed/could be opened was inspired from this link: https://rosettacode.org/wiki/Check_that_file_exists#Ada

with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.characters.handling; use ada.characters.handling;
with ada.Float_Text_IO; use ada.Float_Text_IO;
procedure fleschIndex is
    fileName: unbounded_string;
    line: unbounded_string;
    sentenceCount: integer := 0;
    vowelCount: integer := 0;
    wordCount: integer := 0;
    fleschIndexFinal: float := 0.0;
    wordDivSentence: float := 0.0;
    vowelDivWord: float := 0.0;
    fleschKincaidLevel: float := 0.0;
    
    procedure getFileName(fileName: in out unbounded_string) is
    
    begin
    
        Put_Line("Input file name (or Q to quit)");
        get_line(fileName);
    
    end getFileName;
    
    function checkFileExists (fileName : unbounded_string) return boolean is
      The_File : Ada.Text_IO.File_Type;
    begin
      Open (The_File, In_File, to_String(fileName));
      Close (The_File);
      return True;
    exception
        when Name_Error =>
            return False;
    end checkFileExists;
    
    procedure getSentenceCount(sentenceCount: in out integer; line: in unbounded_string) is
        stringLength: integer := 0;
        i: integer := 1;
    begin
        stringLength := length(line);
        loop
            if(Element(line, i) = '.' or Element(line, i) = ';' or Element(line, i) = '?' or Element(line, i) = '!' or Element(line, i) = ':') then
                sentenceCount := sentenceCount + 1;
            end if;
            i := i + 1;
            exit when i = stringLength+1;
        end loop;    
    end getSentenceCount;
    
    procedure getVowelCount(vowelCount: in out integer; line: in unbounded_string) is
        stringLength: integer := 0;
        i: integer := 1;
        j: integer := 1;
        letterCount: integer := 0;
        vowelTempCount: integer := 0;
        vowelFlag: integer := -1;
        doNothing: Boolean := false;
    begin
        stringLength := length(line);
        --set the vowel count to at least one per word
        loop
            if(i+1 <= stringLength) then
                if(Element(line, i) = ' ' and Element(line, i+1) /= ' ') then
                    -- If there's a space and no space immediately after, add 1 to wordCount
                    vowelCount := vowelCount + 1;
                elsif(Element(line, i) /= ' ' and (i+2 > stringLength)) then
                    -- If it's the end of a sentence, add to word count
                    vowelCount := vowelCount + 1;
                end if;
            end if;
            i := i + 1;
            exit when i = stringLength+1;
        end loop;
        
        --Reset i, another loop to find extra syllables
        i := 1;
        
        --Find more syllables
        loop
            --put_line("i value: " & integer'image(i));
            if(i <= stringLength) then
	            if (Element(line, i) = ' ') then
	                j := i+1;
	                loop
		                if (Element(line, j) = 'a' or Element(line, j) = 'A'
			             or Element(line, j) = 'e' or Element(line, j) = 'E' 
			             or Element(line, j) = 'i' or Element(line, j) = 'I'
			             or Element(line, j) = 'o' or Element(line, j) = 'O'
			             or Element(line, j) = 'u' or Element(line, j) = 'U'
			             or Element(line, j) = 'y' or Element(line, j) = 'Y') then
			                 if(j+1 <= stringLength) then
				                if(
				                 (Element(line, j) = 'e' or Element(line, j) = 'E')
				                 and 
				                 (Element(line, j+1) = ',' or Element(line, j+1) = ' ' or Element(line, j+1) = '.' or Element(line, j+1) = ';' or Element(line, j+1) = '?' or Element(line, j+1) = '!' or Element(line, j+1) = ':'  or (j+1 > stringLength))
				                 and
				                 (Element(line, j-1) /= 'L' and Element(line, j-1) /= 'l')) then
				                    --Do nothing
				                    --put_line("Do nothing flag triggered with " & element(line, j) & " element at i: " & element(line, i));
				                    doNothing := true;
				                elsif(Element(line, j+1) = 'a' or Element(line, j+1) = 'A'
				                 or Element(line, j+1) = 'e' or Element(line, j+1) = 'E' 
				                 or Element(line, j+1) = 'i' or Element(line, j+1) = 'I'
				                 or Element(line, j+1) = 'o' or Element(line, j+1) = 'O'
				                 or Element(line, j+1) = 'u' or Element(line, j+1) = 'U'
				                 or Element(line, j+1) = 'y' or Element(line, j+1) = 'Y') then
				                    --Do nothing
				                    doNothing := true;
				                elsif(j+2 <= stringLength) then
				                    --checks with j+2 (e.g. check for final es and ed
				                    if((Element(line, j) = 'e' or Element(line, j) = 'E')
				                    and
				                      (Element(line, j+1) = 'd' or Element(line, j+1) = 'D'
				                        or Element(line, j+1) = 's' or Element(line, j+1) = 'S')
				                    and
				                      (Element(line, j+2) = ' ' or j+2 > stringLength
				                        or Element(line, j+2) = ',' or Element(line, j+2) = '.' or Element(line, j+2) = ';' or Element(line, j+2) = '?' or Element(line, j+2) = '!' or Element(line, j+2) = ':')) then
				                        --Do nothing
				                        doNothing := true;
				                    end if;
				                end if;
				                --Can add to the vowel count
				                if(doNothing = False) then
			                        vowelFlag := vowelFlag + 1;
			                    end if;
		                    end if;
	                    end if;
	                    doNothing := false;
	                    exit when Element(line, j) = '-' or Element(line, j) = ' ' or Element(line, j) = ',' or Element(line, j) = '.' or Element(line, j) = ';' or Element(line, j) = '?' or Element(line, j) = '!' or Element(line, j) = ':' or j >= stringLength;
	                    j := j + 1;
	                end loop;
	            end if;
	            
	            --If the vowel flag is greater than 0, add the new vowels to the count
	            if(vowelFlag > 0) then
	                vowelCount := vowelCount + vowelFlag;
	            end if;
	            vowelFlag := -1;
	        end if;
            exit when i >= stringLength;
	        i := i+1;
        end loop;
        
    end getVowelCount;
    
    procedure getWordCount(wordCount: in out integer; line: in unbounded_string) is
        stringLength: integer := 0;
        i: integer := 1;
    begin
        stringLength := length(line);
        loop
            if(i+1 <= stringLength) then
                if(Element(line, i) = ' ' and Element(line, i+1) /= ' ') then
                    -- If there's a space and no space immediately after, add 1 to wordCount
                    wordCount := wordCount + 1;
                elsif(Element(line, i) /= ' ' and ((i+2 > stringLength))) then
                    -- If it's the end of a line, add to word count
                    wordCount := wordCount + 1;
                end if;
            end if;
            i := i + 1;
            exit when i = stringLength+1;
        end loop;
    end getWordCount;
    
    procedure calculateFleschIndex(sentenceCount: in out integer; vowelCount: in out integer; wordCount: in out integer; fleschIndexFinal: in out float) is
    begin
        --Avoid odd divisions by 0
        if(sentenceCount = 0) then
            sentenceCount := 1;
        elsif(vowelCount = 0) then
            vowelCount := 1;
        elsif(wordCount = 1) then
            wordCount := 1;
        end if;
        
        --Calculate it
        wordDivSentence := (Float(wordCount)/Float(SentenceCount));
        vowelDivWord := (Float(vowelCount)/Float(wordCount));
        --put_line("206.835 - ((1.015 * (" & Integer'Image(wordCount) & "/" & Integer'Image(sentenceCount) &")) + (84.6 * ("& Integer'Image(vowelCount) &"/"& Integer'Image(wordCount) &"))");
        fleschIndexFinal := (206.835 - ((1.015 * (wordDivSentence)) + (84.6 * (vowelDivWord))));
        
    end calculateFleschIndex;
 
    function calculateFleschKincaidLevel(sentenceCount: integer; wordCount: integer; vowelCount: integer) return float is
        r: float := 0.0;
        sentenceCountTemp: integer := 0;
        vowelCountTemp: integer := 0;
        wordCountTemp: integer := 0;
    begin
        --Ensure values are not 0
        sentenceCountTemp := sentenceCount;
        vowelCountTemp := vowelCount;
        wordCountTemp := wordCount;
        
        if(sentenceCountTemp = 0) then
            sentenceCountTemp := 1;
        elsif(vowelCountTemp = 0) then
            vowelCountTemp := 1;
        elsif(wordCountTemp = 1) then
            wordCountTemp := 1;
        end if;
    
        --Perform calculation
        wordDivSentence := (Float(wordCountTemp)/Float(SentenceCountTemp));
        vowelDivWord := (Float(vowelCountTemp)/Float(wordCountTemp));
        --put_line("((0.39*(" & integer'Image(wordCountTemp) & "/"& integer'Image(sentenceCountTemp) & ")+(11.8*(" & integer'image(vowelCountTemp) & "/" & integer'image(wordCountTemp) & ")))-15.59)" );
        r := ((0.39*(wordDivSentence)+(11.8*(vowelDivWord)))-15.59);
        return r;
    end calculateFleschKincaidLevel;
    
    procedure readFile(fileName: in unbounded_string) is
        infp : file_type;
        line : unbounded_string;
    begin
        open(infp, in_file, To_String(fileName));
        loop
            exit when end_of_file(infp);
            -- process each line from the file
            get_line(infp,line);
            getSentenceCount(sentenceCount,line);
            getWordCount(wordCount, line);
            getVowelCount(vowelCount, line);
        end loop;
        close(infp);
        calculateFleschIndex(sentenceCount, vowelCount, wordCount, fleschIndexFinal);
        put_line(" ");
        put_Line("----The Results----");
        put_line("Sentence Count: " & Integer'Image(sentenceCount));
        put_line("Syllable Count: " & Integer'Image(vowelCount));
        put_line("Word count: " & Integer'Image(wordCount));
        put("Flesch Index: ");
        put(fleschIndexFinal, Fore => 2, Aft => 2, Exp => 0);
        put_line(" ");
        put("Flesch Kincaid Level: ");
        put(calculateFleschKincaidLevel(sentenceCount, wordCount, vowelCount), Fore => 2, Aft =>2, Exp =>0);
        put_line(" ");
        put_line(" ");
        sentenceCount := 0;
        wordCount := 0;
        vowelCount := 0;
    end readFile;

begin
    loop
        -- Input the file name
        getFileName(fileName);
        
        -- If user enters "Q", quit the program
        exit when fileName = "Q";
        
        if(checkFileExists(fileName) = false) then
            put_line("File could not be opened!");
        else
         -- Call the main program functionality which reads the file and determines the Flesch Index and Flesch Kincaid Level.
            readFile(fileName);
        end if;
    end loop;
end fleschIndex;
