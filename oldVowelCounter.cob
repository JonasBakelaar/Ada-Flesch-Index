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
	               if(i+1 <= stringLength) then
	                   if(
	                   (Element(line, i) = 'e' or Element(line, i) = 'E')
	                    and 
	                   (Element(line, i+1) = 's' or Element(line, i+1) = 'S'
	                    or Element(line, i+1) = 'd' or Element(line, i+1) = 'D'
	                    or Element(line, i+1) = ' ' or Element(line, i+1) = '.' or Element(line, i+1) = ';' or Element(line, i+1) = '?' or Element(line, i+1) = '!' or Element(line, i+1) = ':'  or (i+1 > stringLength)) ) then
	                        put_line("Subtracting from ES, ED or E!");
	                        --vowelTempCount := vowelTempCount - 1;
	                   elsif (Element(line, i+1) = 'a' or Element(line, i+1) = 'A'
	                          or Element(line, i+1) = 'e' or Element(line, i+1) = 'E' 
	                          or Element(line, i+1) = 'i' or Element(line, i+1) = 'I'
	                          or Element(line, i+1) = 'o' or Element(line, i+1) = 'O'
	                          or Element(line, i+1) = 'u' or Element(line, i+1) = 'U'
	                          or Element(line, i+1) = 'y' or Element(line, i+1) = 'Y') then
	                          put_line("Subtracting from double vowel!");
	                          --vowelTempCount := vowelTempCount - 1;
	                   else
	                       vowelTempCount := vowelTempCount + 1;
	                   end if;
	               end if;
	            end if;
            i := i + 1;
            exit when i = stringLength+1;
        end loop;
