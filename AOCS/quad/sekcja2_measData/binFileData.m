function fileData = binFileData(fileName, fieldsizes, fieldtypes, fieldPtr, varLength)  

  skip = @(n) sum([fieldsizes(1:n-1) fieldsizes(n+1:end)]); %sum up of field sizes except field n
  offset = @(n) sum(fieldsizes(1:n-1)); %offset to element n+1
  
  %------------------------
  
  fid = fopen(fileName);

  fseek(fid, offset(fieldPtr), -1);
  rawFileData = fread(fid, fieldtypes{fieldPtr}, skip(fieldPtr));
  
  fclose(fid);
  
  %------------------------  
  
  fileData = reshape(rawFileData', varLength, 1/varLength * length(rawFileData))';  
  
end