function blackboxmodel = choosemodel(m)

if m==1
    blackboxmodel = @ModelSaturationSwitchDeath;
elseif m==2
    blackboxmodel = @ModelLagSaturationSwitchDeath;
elseif m==3
    blackboxmodel = @ModelLagLinearSaturationSwitchDeath;
elseif m==4
    blackboxmodel = @ModelLagLinearSaturation;
elseif m==5
    blackboxmodel = @ModelLagLinearLagSaturation;
elseif m==6
    blackboxmodel = @ModelLagLinearLagExp;
elseif m==7
    blackboxmodel = @ModelExpSwitchDeath;
elseif m==8
   blackboxmodel = @ModelSaturationSwitchSaturationDeath;
elseif m==9
  blackboxmodel = @ModelSaturationSwitchSaturationExpDeath;
elseif m==10
  blackboxmodel = @ModelSaturationSwitchSaturationExpDeath;
elseif m==11
    blackboxmodel = @ModelExpSaturation;
elseif m==12
    blackboxmodel = @ModelLinear2;
elseif m==13
    blackboxmodel = @ModelLagExpExpDeath;
elseif m==14
   blackboxmodel = @ModelLagExpSaturation;
elseif m==15
    blackboxmodel = @ModelESESES;
elseif m==16
   blackboxmodel = @ModelESESEES;
end



end