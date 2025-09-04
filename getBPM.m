function[BPM] = getBPM(file)

% Initialize variable
BPM = NaN; 

% Open text file
fileID = fopen(file);

% Read file line-by-line
while ~feof(fileID)
    line = fgetl(fileID);
    
    % Check if the line contains the phrase 'Trial start time'
    if contains(line, 'BPM is ')

        % Extract the numeric value using regular expression
        tokens = regexp(line, 'BPM is (\d+)', 'tokens');
        
        if ~isempty(tokens)
            % Convert the extracted string to a number
            BPM = str2double(tokens{1}{1});
            break; % Stop reading after finding the trial start time
        end

    end

end

% Close the file
fclose(fileID);

end