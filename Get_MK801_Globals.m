function [GP]= Get_MK801_Globals()

GP.Bad_LFP_Rat_Days=[
    1127 13];

GP.MK801_Rats
GP.Saline_Rats

%will want an excel file to look up what channel corresponds to which
%region on which day for which rat

GP.SessionLists %have be info on thresholds and which channel is where  % ALOT LIKE SESSION LISTS IN GAMMA
%will want a threshold for each day that you manually set

GP.ThetaRange
GP.LowGammaRange
GP.HighGammaRange



%EXAMPLE THINGS TO PUT IN
% [GP.Root_dir, GP.SessionList_dir, GP.Data_dir, GP.Analysis_dir, GP.Processed_data_dir ] = LD_get_directories;
% GP.Bad_LFP_Rats = [8700]; % bad lfp on this rat for SLEEP. Behavior seems OK. Not sure why.
% GP.dir_images = {'-->' '<--'};
% % NOTE: in original Session list files - it listed that CSC13 was the EMG
% % for 8957. This is not true. It was CSC14. I fixed the master session
% % lists to correct for this.
% GP.Eyeblink_Learners = [8419 8646 8820 8417 8700 8886 8981];
% GP.Eyeblink_NON_Learners = [8570 8645 8957 8564 8778];
% GP.Old_remapping_rats = [8417 8886 8981]; % 8700 is a bad rat
% GP.Young_non_remapping_rats = [8570 8645 8646 8957];
% GP.Old_non_remapping_rats = [8564 8778];
% % Lindsey added these...
% GP.Remapper=[8419 8820 8417 8700 8886 8981];
% GP.NoRemapper=[8570 8645 8646 8957 8564];
% GP.Maze_Diameter_cm = 85;
% GP.Maze_Circumference_cm = 2*pi*(GP.Maze_Diameter_cm /2);
% GP.Maze_Diameter_pixels = 392;
% GP.cm_per_pixel = GP.Maze_Diameter_cm/GP.Maze_Diameter_pixels; % conversion from camera pixels to cm.
% GP.cm_per_degree = GP.Maze_Circumference_cm/360; % ?? CM per degree.
% GP.Tracking_Sample_Rate_Hz = 30;
% % How many degrees makes up 20 cm on the track.
% GP.Control_Zone_Size_cm = 22.5; % Note this is 30 degrees. How convenient.
% GP.Control_Zone_Size_deg = GP.Control_Zone_Size_cm/GP.cm_per_degree; % Note this is 30 degrees. How convenient.
% GP.Lin_Pos_Bounds = [7 353];
% GP.RewardZoneLinPos = [32 328];
% GP.StartZoneLinPos = [80 270];
% GP.StimZoneLinPos = [140 256]; % eyeballed from TI data.
% GP.Control_Zone_Pos(1) = GP.StimZoneLinPos(1) + diff( GP.StimZoneLinPos)/2 - GP.Control_Zone_Size_deg/2 ;
% GP.Control_Zone_Pos(2) = GP.Control_Zone_Pos(1) + GP.Control_Zone_Size_deg;
% 
% 
% 
% 
% GP.CIPL_diff = [8419	10.5
%     8570	-6.3
%     8645	0.4
%     8646	2.2
%     8820	232.3
%     8957	-1.3
%     8417	64.3
%     8564	-109
%     8700	-17
%     8778	-38.2
%     8886	-88.4
%     8981	-55.3 ];
% 
% GP.Day_first_Learned_LtR_RtL = [ 8419	4	4
%     8570	nan	nan
%     8645	nan	19
%     8646	8	8
%     8820	21	21
%     8957	nan	nan
%     8417	12	18
%     8564	nan	nan
%     8700	3	5
%     8778	nan	nan
%     8886	2	2
%     8981	8	2 ];
% 
% GP.Day_Remapped = [8419	14
%     8570	nan
%     8645	nan
%     8646	nan
%     8820	16
%     8957	nan
%     8417	29
%     8564	nan
%     8700	28
%     8778	nan
%     8886	14
%     8981	18 ];
% 
% GP.Young  = [8419 8570 8645 8646 8820 8957];
% GP.Old = [8417 8564 8700 8778 8886 8981];
% GP.Sessions_with_bad_EMG = [8646 15];
% GP.LowGamma_Range=[30 55]; %Tort=30 to 60, %Zhang 30-50, %Colgin 25-55, Amemiya an Redish 30-55
% GP.HighGamma_Range=[65 90]; %Zhang 60-120, %Zheng 60-100 (Cogin) , Amemiya and Redish 60-90
% 
% GP.Watermaze =[];
% GP.Color.Old = [.7 0 .7];
% GP.Color.Young = [.1 .7 .1];
% GP.Color.Learner = [.2 .2 .99] ;
% tmp = lines(6);
% GP.Color.NonLearner = tmp(2,:);
% GP.Color.Shuffle = tmp(3,:);
% GP.Color.L2R = tmp(4,:);
% GP.Color.R2L = tmp(5,:);
% GP.cm_per_pixel = GP.Maze_Diameter_cm/GP.Maze_Diameter_pixels; % conversion from camera pixels to cm.
% GP.cm_per_degree = GP.Maze_Circumference_cm/360; % ?? CM per degree.
% GP.Tracking_Sample_Rate_Hz = 30;
% % How many degrees makes up 20 cm on the track.
% GP.Control_Zone_Size_cm = 22.5; % Note this is 30 degrees. How convenient.
% GP.Control_Zone_Size_deg = GP.Control_Zone_Size_cm/GP.cm_per_degree; % Note this is 30 degrees. How convenient.
% GP.Lin_Pos_Bounds = [7 353];
% GP.RewardZoneLinPos = [32 328];
% GP.StartZoneLinPos = [80 270];
% GP.StimZoneLinPos = [140 256]; % eyeballed from TI data.
% GP.Control_Zone_Pos(1) = GP.StimZoneLinPos(1) + diff( GP.StimZoneLinPos)/2 - GP.Control_Zone_Size_deg/2 ;
% GP.Control_Zone_Pos(2) = GP.Control_Zone_Pos(1) + GP.Control_Zone_Size_deg;