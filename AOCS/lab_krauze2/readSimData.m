close all;
%clear all;
%pkg load signal;
%---------------------

sampleFreq = 500;

%--------------------

fieldsizes = [1*4 2*8 4*8 ]; 
fieldtypes = { '1*int32', '2*double', '4*double' };
% timeStamp roadExc aij 
% int64(long int) 2*double 4*double 

%------------------------

%filePath = [ 'simData/passive_sin/passive_full_prm_000_frontSinExc_0_10' ];
% filePath = [ 'simData/passive_chirp/passive_full_prm_000_frontChirpExc_0_10' ];

%----------------------

roadExcSig = binFileData(filePath, fieldsizes, fieldtypes, 2, 2);

unsprungSprungAccSig = binFileData(filePath, fieldsizes, fieldtypes, 3, 4);
   
%---------------------------------------
%usrednienie
Y11 = unsprungSprungAccSig(:,1);
Y12 = unsprungSprungAccSig(:,2);
Y2 = 0.5 * (unsprungSprungAccSig(:,3) + unsprungSprungAccSig(:,4));  

X1 = roadExcSig(:,1);
X2 = roadExcSig(:,2);    

%----------------------------
% sin

fRange= 0.5:0.1:30.0;
n = 10;

addTime = 1; %[s]

endSampleVec = cumsum(round(n*sampleFreq./fRange)+addTime*sampleFreq);
startSampleVec = [ 1 , endSampleVec(1:end-1)+1 ];



addStartSampleVec = startSampleVec + addTime*sampleFreq;

T_sin = [];
for freqPtr =  1: length(fRange)                  
  startPtr = addStartSampleVec(freqPtr);
  endPtr = endSampleVec(freqPtr);
  
  T_sin = [T_sin; rms(Y2(startPtr:endPtr))/rms(X1(startPtr:endPtr))];
end

[T_czirp, f_czirp] = pwelch(Y2,6000,[],[],sampleFreq);
[T_wym, f_wym] = pwelch(X1,6000,[],[],sampleFreq);

   
% %---------------------------
% % figures
% %---------------------------    
N = length(Y11);
tVec = 1/sampleFreq * (0:N-1);
% 
% figure(1);
% plot(tVec, X1);
% 
% figure(2);
% plot(tVec, X2);
% 
% figure(3);
% plot(tVec, Y11);
% 
% figure(4);
% plot(tVec, Y12);
% 
% figure(5);
% plot(tVec, Y2);
% 
% 
% % figure(10); plot(fRange, T_sin)
%   
% figure; plot(f_czirp,sqrt(T_czirp./T_wym))
%   
