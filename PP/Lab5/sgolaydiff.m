function wy=sgolaydiff(y,H)
%Program do wyg�adzania metod� SG
%wy=sgf(y,k,f);
% y - sygnal 
% H - macierz Ha.

%[f ~] = size(H);

    f = length(H);

    y=y(:);
    ly=length(y);
    m=(f-1)/2;
    %H=sgolay(k,f);
    wy=y;
    for i=m+1:ly-m
        oknoy=y(i-m:i+m);
        oknoy=oknoy(:);
        %wy(i)=H(m+1,:)*oknoy;
        wy(i) = sum(H .* oknoy);
    end

%     oknop=y(1:f);
%     oknop=oknop(:);
%     wy(1:m)=sum(H(1:m).*oknop);
% 
%     oknok=y(ly-f+1:ly);
%     wy(ly-m+1:ly)=sum(H(m+2:f).*oknok);

end
