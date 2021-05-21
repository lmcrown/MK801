%% MK801_Question_Itterator_nonfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Analysis_function=@plot_no_art_psd;

root_results_directory = 'C:\Users\Lindsay\Keck Medicine of USC\MK801_Results';
specific_results_directory = fullfile(root_results_directory, func2str(Analysis_function));
if ~exist(specific_results_directory,'dir')
    mkdir(specific_results_directory)
end
root_data_directory = 'C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG FILES AGAIN\20946-Acute\EEG\20946-PSD7&8-POSTinjs';

%Pre_Recordings_MK801_PSD7
Rat_file_folder='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG\20946-PSD7&8-PREEinjs\MK801\PSD7';
%notice if its a pre or post injection and have that put on the end of the
%file
time=Rat_file_folder(end-18:end-16); %will be PRE or POS
cd(Rat_file_folder)
rats=dir(Rat_file_folder);
good_ix = [];
for ii = 1:length(rats)
    if rats(ii).isdir && ~any(strfind(rats(ii).name,'.') )
        good_ix = [good_ix, ii];
    end
end
dir2 = rats(good_ix); %only rat files that actually have crap in them

for idir=1:length(dir2)
    cd(fullfile(Rat_file_folder,char(dir2(idir).name))) %turn the rat number into a string
    [Dset]=Analysis_function();
     save(fullfile(specific_results_directory,[char(dir2(idir).name) time ]) ,'Dset')
    cd ..
end

%%%%
PLOT_IT=false; %just for a doing a bunch so the graphics dont crap out
Dset = [];
    



if ~exist(specific_results_directory,'dir')
    mkdir(specific_results_directory)
end

cd(root_data_directory);

switch acute_or_chronic
    case acute
    eeg_dir{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG';

    case chronic
    eeg_dir{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Chron\EEG\20946-chronic-PSD7-23';

    case both
        eeg_dir{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG';
        eeg_dir{2}= 'C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Chron\EEG\20946-chronic-PSD7-23';
end
cd(eeg_dir)
switch pre_or_post
    case pre
        inj{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG\20946-PSD7&8-PREEinjs';
        
    case post
        inj{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG\20946-PSD7&8-POSTinjs';
    case both
        inj{1}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG\20946-PSD7&8-PREEinjs';
        inj{2}='C:\Users\Lindsay\Keck Medicine of USC\Zepeda, Nancy - 20946 ALL EEG DATA\20946-Acute\EEG\20946-PSD7&8-POSTinjs';
end
cd(inj{1})
d=find_files(pwd);
for id=1:length(d)
    cd(d{id})
    
end

all_dirs = dir('Mouse*');
for iDir = startdir:length(all_dirs)
    fprintf('running in %s \n',all_dirs(iDir).name);
%     cd(['E:\Lindsey\SD_data\Packaged_Data\' char(all_dirs(iDir).name)]) % in case the whole rat is skipped
    cd(all_dirs(iDir).name)
    dir2 = dir('*Day*');
    good_ix = [];

    for ii = 1:length(dir2)
        if dir2(ii).isdir && ~any(strfind(dir2(ii).name,'.') )
            good_ix = [good_ix, ii];
        end
    end
    dir2 = dir2(good_ix);
    
    for iDir2 = 1:length(dir2)
        if isdir(dir2(iDir2).name)
%            cd(['E:\Lindsey\SD_data\Packaged_Data\' char(all_dirs(iDir).name) '\' char(dir2(iDir2).name)]) % in case the function didnt run on the last file
            cd(dir2(iDir2).name)
%            Analysis_function(); % Run the function (assumes it saves all of the relevant data and images).
             [Dset] = Analysis_function; % Run the function (assumes it saves all of the relevant data and images).

%              [Dset] = Analysis_function(function_input); % Run the function (assumes it saves all of the relevant data and images).
            save(fullfile(specific_results_directory,[all_dirs(iDir).name dir2(iDir2).name ]) ,'Dset')
            cd ..
        else
            continue
        end
    end
    cd ..
end
        msgbox('All done')