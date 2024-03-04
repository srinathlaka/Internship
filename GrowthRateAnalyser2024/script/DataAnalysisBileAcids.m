function [Data_Drug,parameters_Drug] = DataAnalysisBileAcids(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin,decline,sequential)


if sequential==1

    if decline==1
        [Data_Drug,parameters_Drug] = plateDrugAllSequenceDecline(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin); %fit without drug feeds fit with drug with decline phase
    else
        [Data_Drug,parameters_Drug] = plateDrugAllSequence(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin); %fit without drug feeds fit with drug
    end

else

    if decline==1
        [Data_Drug,parameters_Drug] = plateDrugAllDecline(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin); %independent fits with decline phase
    else
        [Data_Drug,parameters_Drug] = plateDrugAllSequence(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin); %fit without drug feeds fit with drug
    end
    [Data_Drug,parameters_Drug] = plateDrugAll(filename,Data_Drug,parameters_Drug,Data_bkg_model,tin,tdrug,tfin); %two independent fits without and with drug

end
%[Data061_Cipro,parameters061_Cipro] = plateDrugAllDeath(filename,Data061_Cipro,parameters061_Cipro,Data_bkg_model,tin,tdrug,tfin); %death pahse


end