% timing inputs in milliseconds
function realign_smooth_WB(mydir, expression,FWHM)
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
    spm_realign(in, reaFlags);
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
    
   
end


