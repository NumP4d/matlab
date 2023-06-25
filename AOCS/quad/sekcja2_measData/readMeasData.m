
clear;

% Czujnik siły 5 kN zakres - 9
% Przyspieszenie m/s^2

%  \/    \/
% Q 2 -- 1 Q LOWER -> HIGHER +4
%  |      | 
%  |      |
% Q 4 -- 3 Q

%---------------------

sampleFreq = 500;

fieldsizes = [ 1*4, 50*2, 9*4 ];
fieldtypes = { '1*int32', '50*uint16', '9*float' };
% timeStamp, CANCommData, [ imuAcc, imuGyro, imuMagneto ]
% int64 50*uint16 9*float

%------------------------

%fileList = {'AoCS_sek1_0'};
%fileList = {'AoCS_sek1_00'};
%fileList = {'AoCS_sek1_1'};
%fileList = {'AoCS_sek2_1'};
fileList = {'AoCS_sek3_1'};
%fileList = {'AoCS_sek4_1'};

for filePtr = 1 : length(fileList)
    
fileName = fileList{filePtr};
%------------------------

alfaMR = [ 72/180*pi, 72/180*pi, 63/180*pi, 63/180*pi ];

gravAcc = 9.81;

%-----------------

accSensorOrientationMatrix = [ -0.0627, -0.998, 0.0;
                                0.0, 0.9941, 0.1083;
                                0.2074, -0.9783, 0.0;
                                0.6223, 0.7828, 0.0;
                                0.0, 0.1288, 0.9917;
                                0.0, 0.0782, 0.9969;
                                0.0, 0.1030, 0.9947;
                                0.0, -0.0314, 0.9995 ];

lvdtCorrMatrix = [ 0.074 0.074 0.060 0.060 ];

%------------------------
    
timeStampSig = binFileData(fileName, fieldsizes, fieldtypes, 1, 1);
mcuMat = uint16(binFileData(fileName, fieldsizes, fieldtypes, 2, 50));
imuMat = binFileData(fileName, fieldsizes, fieldtypes, 3, 9);

%----------------------

sampleCount = length(timeStampSig);

%-----------------
% acc reorientation  

accAxisMeasMatRaw = cat(3, ...
            mcuMat(:, 1:3), mcuMat(:, 11:13), mcuMat(:, 21:23), mcuMat(:, 31:33), ...
            mcuMat(:, 4:6), mcuMat(:, 14:16), mcuMat(:, 24:26), mcuMat(:, 34:36) );
accAxisMeasMat = 1/1000*9.81*double(reshape(typecast(accAxisMeasMatRaw(:), 'int16'), ...
    size(accAxisMeasMatRaw, 1), size(accAxisMeasMatRaw, 2), size(accAxisMeasMatRaw, 3)));

accMeasRaw = repmat(permute(accSensorOrientationMatrix, [ 3, 2, 1]), [ sampleCount, 1, 1 ]) .* accAxisMeasMat;

unsprungSprungAccSig = permute(sum(accMeasRaw, 2), [ 1 3 2 ]);
%unsprungSprungAccSig = unsprungSprungAccSig - gravAcc;

% lvdt mesasurements

susDisMeasRaw = mcuMat(:, 41:44);
susDisMeas = (1/2048 * double(reshape(typecast(susDisMeasRaw(:), 'int16'), size(susDisMeasRaw, 1), size(susDisMeasRaw, 2))) -5.0)/ 10.0;
susDisSig = [ lvdtCorrMatrix(3) * susDisMeas(:,3), lvdtCorrMatrix(4) * susDisMeas(:,4), ...
                            lvdtCorrMatrix(1) * susDisMeas(:,1), lvdtCorrMatrix(2) * susDisMeas(:,2) ];
                        
sbrio_susDisMeas = 1/2048 * double(reshape(typecast(susDisMeasRaw(:), 'int16'), size(susDisMeasRaw, 1), size(susDisMeasRaw, 2)));

% ext sbrio acc measurements

extAccSigRaw1 = mcuMat(:, 45);
extAccSigRaw2 = mcuMat(:, 46);

extAccSig1 = 1/2048 * double(typecast(extAccSigRaw1, 'int16'));
extAccSig2 = 1/2048 * double(typecast(extAccSigRaw2, 'int16'));

% imu gyro measurements
imuAccSig = imuMat(:,1:3);  % [ m /s^2 ]
imuGyroSig = imuMat(:,4:6);  % [ rad /s ]

% ctrl current

currentMeasRaw = [ mcuMat(:, 9), mcuMat(:, 19), mcuMat(:, 29), mcuMat(:, 39) ];
ctrlCurrentSig = 1/1500 * double(reshape(typecast(currentMeasRaw(:), 'int16'), size(currentMeasRaw, 1), size(currentMeasRaw, 2)));

currentSetRaw = [ mcuMat(:, 10), mcuMat(:, 20), mcuMat(:, 30), mcuMat(:, 40) ];
ctrlCurrentSetSig = 1/1500 * double(reshape(typecast(currentSetRaw(:), 'int16'), size(currentSetRaw, 1), size(currentSetRaw, 2)));

%---------------------------
startPtrMat = find(diff(unsprungSprungAccSig(:,1)));
%startPtr = startPtrMat(1);
startPtr = 1;
%---------------------------
%---------------------------
% cropping beginning zeroes

timeStampSig = timeStampSig(startPtr:end, :);

unsprungSprungAccSig = unsprungSprungAccSig(startPtr:end, :);
ctrlCurrentSig = ctrlCurrentSig(startPtr:end, :);
ctrlCurrentSetSig = ctrlCurrentSetSig(startPtr:end, :);

sbrio_susDisMeas = sbrio_susDisMeas(startPtr:end, :);
susDisSig = susDisSig(startPtr:end, :);

extAccSig1 = extAccSig1(startPtr:end, :);
extAccSig2 = extAccSig2(startPtr:end, :);

imuAccSig = imuAccSig(startPtr:end, :);
imuGyroSig = imuGyroSig(startPtr:end, :);

%----------------------------------------
% storing data

%{
save(matName, 'sampleFreq', 'extAccSig' );
%}

end

%-------------------

tVec = 1/sampleFreq * (0 : length(timeStampSig)-1)';

for figPtr = 1 : 8
  figure(figPtr);
  plot(tVec, unsprungSprungAccSig(:,figPtr));
end

figure(9);
plot(tVec, extAccSig1);









