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
                sentenceCount := sentenceCount + 1;
            end if;
            i := i + 1;
            exit when i = stringLength+1;
        end loop;    
    end getSentenceCount;
    
    procedure getVowelCount(vowelCount: in out integer; line: in unbounded_string) is
        stringLength: integer := 0;
        i: integer := 1;
        letterCount: integer := 0;
        vowelTempCount: integer := 0;
    begin
        stringLength := length(line);
        loop
            if(Element(line, i) = ' ' or Element(line, i) = '.' or Element(line, i) = ';' or Element(line, i) = '?' or Element(line, i) = '!' or Element(line, i) = ':' or (i+1 > stringLength)) then
                -- Takes into account words with more than one vowel of 3 or less letters in length
                if(letterCount <= 3) then
                    --Only add 1 syllable for 3 letter words
                    vowelCount := vowelCount + 1;
                else
                    -- Add the totals from the loop
                    put_line( integer'image(vowelCount) & " + " & integer'image(vowelTempCount));
                    if(vowelTempCount <= 0) then
                        vowelCount := vowelCount + 1;
                    else 
                        vowelCount := vowelCount + vowelTempCount;
                    end if;
                end if;
                letterCount := 0;
                vowelTempCount := 0;
            else
                letterCount := letterCount + 1;
            end if;
	            if(Element(line, i) = 'a' or Element(line, i) = 'A'
	               or Element(line, i) = 'e' or Element(line, i) = 'E' 
	               or Element(line, i) = 'i' or Element(line, i) = 'I'
	               or Element(line, i) = 'o' or Element(line, i) = 'O'
	               or Element(line, i) = 'u' or Element(line, i) = 'U'
	               or Element(line, i) = 'y' or Element(line, i) = 'Y') then
	               vowelTempCount := vowelTempCount + 1;
	               if(i+1 <= stringLength) then
	                   if(
	                   (Element(line, i) = 'e' or Element(line, i) = 'E')
	                    and 
	                   (Element(line, i+1) = 's' or Element(line, i+1) = 'S'
	                    or Element(line, i+1) = 'd' or Element(line, i+1) = 'D'
	                    or Element(line, i+1) = ' ' or Element(line, i+1) = '.' or Element(line, i+1) = ';' or Element(line, i+1) = '?' or Element(line, i+1) = '!' or Element(line, i+1) = ':') ) then
	                        vowelTempCount := vowelTempCount - 1;
	                   elsif (Element(line, i+1) = 'a' or Element(line, i+1) = 'A'
	                          or Element(line, i+1) = 'e' or Element(line, i+1) = 'E' 
	                          or Element(line, i+1) = 'i' or Element(line, i+1) = 'I'
	                          or Element(line, i+1) = 'o' or Element(line, i+1) = 'O'
	                          or Element(line, i+1) = 'u' or Element(line, i+1) = 'U'
	                          or Element(line, i+1) = 'y' or Element(line, i+1) = 'Y') then
	                          vowelTempCount := vowelTempCount - 1;
	                   end if;
	               end if;
	            end if;
            i := i + 1;
            exit when i = stringLength+1;
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
                elsif(Element(line, i) /= ' ' and (Element(line, i+1) = '.' or Element(line, i+1) = ';' or Element(line, i+1) = '?' or Element(line, i+1) = '!' or Element(line, i+1) = ':')) then
                    -- If it's the end of a sentence, add to word count
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
    end readFile;

begin

    -- Input the file name
    getFileName(fileName);
 
    -- Call buildLEXICON, which will build the dictionary of words to find anagrams in and populate the array of dictionary words.
    readFile(fileName);
    
end fleschindex;
