function [output] = read_data(datafile)
    fileID = fopen(['data/', datafile], 'r');
    formatSpec = '%lf';
    output = fscanf(fileID, formatSpec);
    fclose(fileID);
end

