-- Author: Jonas Bakelaar (0964977)
-- Date: March 4, 2018
-- Description: Program that takes a jumble of letters and prints out the anagrams of that jumble of letters based on the small dictionary provided with Linux
-- Sources: I used the algorithm at this link: https://www.geeksforgeeks.org/write-a-c-program-to-print-all-permutations-of-a-given-string/ 
--          This algorithm helped me find all the permutations of the letter jumble the user provides. Some additional modifications were required to use the algorithm in ADA. 
--          As a result this is not a direct copy of the code in the link, just a reference used to figure out how to get the permutations of a string efficiently.

with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.characters.handling; use ada.characters.handling;
with ada.Float_Text_IO; use ada.Float_Text_IO;
procedure fleschindex is
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
    
        Put_Line("Input file name");
        get_line(fileName);
    
    end getFileName;
    
    procedure getSentenceCount(sentenceCount: in out integer; line: in unbounded_string) is
        stringLength: integer := 0;
        i: integer := 1;
    begin
        stringLength := length(line);
        loop
            if(Element(line, i) = '.' or Element(line, i) = ';' or Element(line, i) = '?' or Element(line, i) = '!' or Element(line, i) = ':') then
                put("Element ");
                put(Element(line, i));
                put(" has caused the sentence count to go up!");
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
                elsif(Element(line, i) /= ' ' and (Element(line, i+1) = '.' or Element(line, i+1) = ';' or Element(line, i+1) = '?' or Element(line, i+1) = '!' or Element(line, i+1) = ':'  or (i+2 > stringLength))) then
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
            put_line("i value: " & integer'image(i));
            if(i+1 <= stringLength) then
	            if (Element(line, i) = ' ') then
	                j := i + 1;
	                loop
	                    if(j+1 <= stringLength) then
		                    if (Element(line, j) = 'a' or Element(line, j) = 'A'
			                 or Element(line, j) = 'e' or Element(line, j) = 'E' 
			                 or Element(line, j) = 'i' or Element(line, j) = 'I'
			                 or Element(line, j) = 'o' or Element(line, j) = 'O'
			                 or Element(line, j) = 'u' or Element(line, j) = 'U'
			                 or Element(line, j) = 'y' or Element(line, j) = 'Y') then
			                    if(
			                     (Element(line, j) = 'e' or Element(line, j) = 'E')
			                     and 
			                     (Element(line, j+1) = ',' or Element(line, j+1) = ' ' or Element(line, j+1) = '.' or Element(line, j+1) = ';' or Element(line, j+1) = '?' or Element(line, j+1) = '!' or Element(line, j+1) = ':'  or (j+1 > stringLength))) then
			                        --Do nothing
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
	                    j := j + 1;
	                    doNothing := false;
	                    exit when Element(line, j) = ' ' or j+1 > stringLength;
	                end loop;
	            end if;
	            
	            --If the vowel flag is greater than 0, add the new vowels to the count
	            if(vowelFlag > 0) then
	                vowelCount := vowelCount + vowelFlag;
	            end if;
	            vowelFlag := -1;
	        end if;
	        i := i+1;
            exit when i > stringLength+1;
        end loop;
        put_line("Syllable count:" & integer'image(vowelCount));
        
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
        put_line("206.835 - ((1.015 * (" & Integer'Image(wordCount) & "/" & Integer'Image(sentenceCount) &")) + (84.6 * ("& Integer'Image(vowelCount) &"/"& Integer'Image(wordCount) &"))");
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
        put_line("((0.39*(" & integer'Image(wordCountTemp) & "/"& integer'Image(sentenceCountTemp) & ")+(11.8*(" & integer'image(vowelCountTemp) & "/" & integer'image(wordCountTemp) & ")))-15.59)" );
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
            getVowelCount(vowelCount, line);
            getWordCount(wordCount, line);
            -- process the line of text
        end loop;
        close(infp);
        calculateFleschIndex(sentenceCount, vowelCount, wordCount, fleschIndexFinal);
        put_line("Sentence Count: " & Integer'Image(sentenceCount));
        put_line("Syllable Count: " & Integer'Image(vowelCount));
        put_line("Word count: " & Integer'Image(wordCount));
        put_line("FleschIndex: " & Integer'Image(Integer(fleschIndexFinal)));
        put("Flesch Kincaid Level: ");
        put(calculateFleschKincaidLevel(sentenceCount, wordCount, vowelCount), Fore => 2, Aft =>2, Exp =>0);
    end readFile;

begin

    -- Input the file name
    getFileName(fileName);
 
    -- Call buildLEXICON, which will build the dictionary of words to find anagrams in and populate the array of dictionary words.
    readFile(fileName);
    
end fleschindex;
