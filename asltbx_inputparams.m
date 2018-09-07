% timing inputs in milliseconds
function asltbx_inputparams(mydir, expression, e1exp, Labeltime,Delaytime,TE,minTR,nslices,FWHM)
cd(mydir);

inputdir = mydir;
inputfiles = dir(expression);

spm;
global defaults;
defaults = spm('Defaults','fmri');

%%%%%%%%%%%%%%%%
%%REALIGN
%%%%%%%%%%%%%%%%
defs = defaults.realign;
% Flags to pass to routine to calculate realignment parameters
% (spm_realign)
% as (possibly) seen at spm_realign_ui,
reaFlags = struct(...
    'quality', defs.estimate.quality,...  % estimation quality
    'fwhm', 5,...                         % smooth before calculation
    'rtm', 1,...                          % whether to realign to mean
    'PW',''...                            %
    );
% Flags to pass to routine to create resliced images
% (spm_reslice)
resFlags = struct(...
    'interp', 1,...                       % trilinear interpolation
    'wrap', defs.write.wrap,...           % wrapping info (ignore...)
    'mask', defs.write.mask,...           % masking (see spm_reslice)
    'which',2,...                         % write reslice time series for later use
    'mean',1);                            % do write mean image
%grab file to realign with GUI
%Select both the ASL data and the M0 data in order to register M0 data to ASL data
%P = spm_select
for j = 1:length(inputfiles),
    
    in = fullfile(inputdir,inputfiles(j).name);
    spm_realign_asl(in, reaFlags);
    % Run reslice
    spm_reslice(in, resFlags);
    
    %%%%%%%%%%%%%%%%%
    %%SMOOTH
    %%%%%%%%%%%%%%%%%
    if nargin < 8
        FWHM = 5;
    end

    P = fullfile(inputdir,strcat('r',inputfiles(j).name));
    Q = fullfile(inputdir,strcat('sr',inputfiles(j).name));
    spm_smooth(P,Q,FWHM);
    
    if(strfind(in,e1exp))
        %%%%%%%%%%%%%%%%%
        %%MASK
        %%%%%%%%%%%%%%%%%
        %make a BET call ( SPM masking is just intensity based and does not work
        %particularly well)
        bet_in = strcat(inputdir,'/','mean',inputfiles(j).name);
        basename = strtok(inputfiles(j).name,'.');
        bet_out = strcat(inputdir,'/','mean',basename,'_brain');
        bet_out_mask = strcat(inputdir,'/','mean',basename,'_brain_mask');
        system(sprintf('bet %s %s -m', bet_in, bet_out));
        system(sprintf('fslchfiletype NIFTI %s',bet_out_mask));
        bet_out_mask = strcat(inputdir,'/','mean',basename,'_brain_mask.nii');
        %%%%%%%%%%%%%%%%%%%
        %%PERFUSION CALC
        %%%%%%%%%%%%%%%%%%%
        maskimg = bet_out_mask;
        Filename = Q;
        M0img = [];
        FirstimageType = 1;
        SubtractionType = 2; %sinc subtraction
        SubtractionOrder = 0;
        Flag = [1 1 1 0 1 1 0 1 1]; % [MaskFlag,MeanFlag,CBFFlag,BOLDFlag,OutPerfFlag,OutCBFFlag,QuantFlag,ImgFormatFlag,D4Flag]
        Timeshift = 0.5; %for sinc subtraction only
        AslType = 1; % 1 = CASL
        labeff = 0.85; %0.85 for pCASL, same in Yuhan's script - this should be measured for onsite scanner - has it?
        MagType = 1; %1 for 3 T
        Slicetime = (minTR - Labeltime - Delaytime)/nslices;
        M0roi = [];
        asl_perf_subtract(Filename,FirstimageType, SubtractionType, SubtractionOrder,Flag,Timeshift,AslType,labeff,MagType,Labeltime/1000, Delaytime/1000,Slicetime,TE,M0img,M0roi,maskimg)
    end
end


