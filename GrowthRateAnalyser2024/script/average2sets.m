function Data = average2sets(Data1,Data2)

Data = struct();

%time
Data.time = Data1.time;

%mean
Data.Xmean = (Data1.Xmean + Data2.Xmean)./2;
Data.XmeanSmooth = (Data1.XmeanSmooth + Data2.XmeanSmooth)./2;

%std for independent datasets cov=0
Data.Xstd = sqrt(((Data1.Xstd).^2 + (Data2.Xstd).^2)./4);


end