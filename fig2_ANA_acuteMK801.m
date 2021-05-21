
% Raw data for theta
MK_801_hipp= ...
[3.040000e-008
1.170000e-008
1.340000e-008
2.680000e-008
2.600000e-008
7.220000e-009
8.150000e-009
4.890000e-008
4.170000e-008
8.630000e-009
2.920000e-008
2.420000e-008
6.440000e-008
2.420000e-008
1.120000e-008
1.240000e-008
1.420000e-008
1.490000e-008
2.390000e-009
4.220000e-008
1.200000e-008
1.310000e-008
3.480000e-008
3.960000e-008
1.000000e-008
2.080000e-008
5.980000e-008
2.880000e-008
4.400000e-008
1.710000e-008
3.980000e-007
9.130000e-009
9.180000e-008];

Saline_hipp=...
[4.820000e-008
1.830000e-008
6.090000e-008
6.180000e-008
2.910000e-008
1.660000e-007
6.030000e-008
1.690000e-007
3.400000e-008
6.200000e-008
1.540000e-007
6.650000e-008
1.230000e-007];

Saline_mPFC=...
[3.070000e-008
1.080000e-008
2.140000e-007
1.290000e-008
2.510000e-008
2.330000e-007
1.280000e-007
2.860000e-008
2.570000e-008
1.850000e-008
5.640000e-008
4.100000e-008
1.150000e-008]

MK_801_mPFC=...
[1.130000e-008
1.280000e-008
1.400000e-008
1.810000e-008
1.330000e-008
9.650000e-009
1.770000e-008
4.220000e-009
6.650000e-009
1.910000e-008
1.830000e-008
9.920000e-009
1.500000e-008
7.470000e-009
1.230000e-008
1.760000e-008
9.810000e-009
6.480000e-009
6.490000e-008
1.330000e-008
1.430000e-008
1.190000e-008
1.580000e-007
3.390000e-009
6.940000e-010
1.060000e-008
6.300000e-009
1.520000e-008
3.150000e-008
5.660000e-008
2.110000e-008
3.400000e-009
8.800000e-008];

Saline_MSN=...
[5.870000e-008
1.660000e-008
6.060000e-008
1.970000e-008
2.970000e-008
1.800000e-007
1.670000e-008
2.190000e-008
1.230000e-008
1.640000e-008
0.00000126
4.110000e-008
1.460000e-008];

MK_801_MSN=...
[5.440000e-009
5.670000e-009
5.240000e-009
1.370000e-007
1.170000e-008
1.490000e-008
1.670000e-008
7.550000e-009
1.140000e-008
6.340000e-009
6.830000e-009
7.950000e-009
6.660000e-009
5.910000e-009
1.640000e-008
1.230000e-008
1.470000e-008
7.430000e-009
9.070000e-008
8.750000e-009
1.340000e-008
1.250000e-008
5.120000e-009
1.030000e-008
5.100000e-009
8.970000e-009
8.980000e-009
1.910000e-008
3.320000e-008
1.640000e-008
1.240000e-007
2.700000e-008
1.850000e-007];

Saline_Thal=...
[3.090000e-008
1.310000e-008
6.240000e-008
1.490000e-007
2.050000e-008
2.630000e-007
1.960000e-008
2.500000e-008
1.620000e-008
7.610000e-007
1.890000e-008
3.320000e-008
1.010000e-008];

MK_801_thal=...
[7.440000e-009
1.170000e-008
5.960000e-009
8.020000e-009
1.620000e-008
1.130000e-008
6.960000e-009
2.300000e-009
1.560000e-008
7.460000e-009
1.030000e-008
8.660000e-009
1.100000e-008
1.060000e-008
3.500000e-008
8.290000e-009
9.430000e-009
7.230000e-009
1.020000e-007
1.370000e-008
1.760000e-008
4.300000e-007
7.960000e-008
8.330000e-009
4.090000e-011
9.960000e-009
4.130000e-009
2.470000e-008
3.530000e-008
1.760000e-008
3.530000e-007
4.120000e-008
2.880000e-008];

hipp=[Saline_hipp; MK_801_hipp]; 
mpfc=[Saline_mPFC; MK_801_mPFC];
MSN=[Saline_MSN; MK_801_MSN];
Thal=[Saline_Thal; MK_801_thal];

numS=length(Saline_hipp);
IXS=zeros(length(hipp),1);
IXS(1:numS)=1;


%% Theta
figure;
subplot 141
[p_h]=bar_plot_with_p_publish_updated(10*log10((sqrt(hipp)*1e6)),IXS==1,IXS==0,'Theta PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])
subplot 142
[p_mp]=bar_plot_with_p_publish_updated(10*log10((sqrt(mpfc)*1e6)),IXS==1,IXS==0,'Theta PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 143
[p_ms]=bar_plot_with_p_publish_updated(10*log10((sqrt(MSN)*1e6)),IXS==1,IXS==0,'Theta PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 144
[p_t]=bar_plot_with_p_publish_updated(10*log10((sqrt(Thal)*1e6)),IXS==1,IXS==0,'Theta PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

bonf_holm([p_h p_mp p_ms p_t])
set(gcf,'Position',[232   716   688   192])
%% RAW data for low gamma
MK_801_hipp= ...
[1.350000e-008
1.250000e-008
9.740000e-009
2.390000e-008
2.080000e-008
6.110000e-009
6.110000e-009
2.200000e-008
6.440000e-008
7.810000e-009
3.740000e-008
2.040000e-008
7.720000e-008
8.900000e-009
1.020000e-008
6.190000e-009
6.450000e-009
1.660000e-008
4.370000e-009
2.050000e-008
2.210000e-008
1.160000e-008
2.470000e-008
6.450000e-008
1.060000e-008
1.490000e-008
8.450000e-008
9.240000e-009
1.760000e-008
1.530000e-008
3.430000e-007
2.150000e-008
7.960000e-008];

Saline_hipp=...
[3.090000e-008
1.310000e-008
6.240000e-008
1.490000e-007
2.050000e-008
2.630000e-007
1.960000e-008
2.500000e-008
1.620000e-008
7.610000e-007
1.890000e-008
3.320000e-008
1.010000e-008];

Saline_mPFC=...
[1.600000e-008
1.530000e-008
1.320000e-007
1.590000e-008
3.920000e-008
1.250000e-007
5.280000e-008
2.210000e-008
1.770000e-008
1.890000e-008
3.230000e-008
1.500000e-008
2.230000e-008];

MK_801_mPFC=...
[1.340000e-008
1.150000e-008
1.520000e-008
2.950000e-008
1.690000e-008
4.940000e-009
5.170000e-009
3.750000e-009
1.530000e-008
1.150000e-008
1.030000e-008
8.620000e-009
1.510000e-008
8.440000e-009
9.670000e-009
8.610000e-009
7.150000e-009
7.410000e-009
3.710000e-008
9.620000e-009
7.610000e-009
1.170000e-008
2.320000e-008
5.490000e-009
4.080000e-010
1.310000e-008
1.120000e-008
1.150000e-008
1.510000e-008
7.470000e-009
1.370000e-008
2.350000e-009
5.130000e-008];

Saline_MSN=...
[3.660000e-008
1.470000e-008
3.470000e-008
1.300000e-008
2.860000e-008
1.230000e-007
1.270000e-008
1.560000e-008
8.300000e-009
1.430000e-008
0.00000101
1.480000e-008
1.360000e-008];

MK_801_MSN=...
[7.250000e-009
4.800000e-009
3.400000e-009
9.870000e-008
1.840000e-008
6.950000e-009
2.240000e-008
5.740000e-009
6.540000e-009
3.580000e-009
3.810000e-009
1.160000e-008
5.760000e-009
4.570000e-009
1.390000e-008
7.410000e-009
1.680000e-008
9.430000e-009
5.190000e-008
6.410000e-009
6.840000e-009
8.060000e-009
4.690000e-009
7.080000e-009
4.480000e-009
7.160000e-009
7.300000e-009
9.830000e-009
1.320000e-008
6.440000e-009
6.870000e-008
1.710000e-008
3.730000e-008];

Saline_Thal=...
[2.230000e-008
1.400000e-008
3.570000e-008
1.270000e-007
1.050000e-008
1.480000e-007
1.960000e-008
1.660000e-008
8.710000e-009
1.010000e-007
1.280000e-008
1.180000e-008
1.200000e-008];

MK_801_thal=...
[7.650000e-009
7.680000e-009
4.060000e-009
1.120000e-008
2.050000e-008
1.970000e-008
4.230000e-009
1.780000e-009
6.340000e-009
4.350000e-009
5.850000e-009
9.710000e-009
6.280000e-009
5.640000e-009
1.940000e-008
1.000000e-008
6.190000e-009
9.180000e-009
5.830000e-008
7.460000e-009
9.440000e-009
3.310000e-007
4.540000e-008
8.610000e-009
6.060000e-011
7.960000e-009
6.790000e-009
8.840000e-009
1.230000e-008
6.100000e-009
2.030000e-007
2.260000e-008
1.830000e-008];

hipp=[Saline_hipp; MK_801_hipp]; 
mpfc=[Saline_mPFC; MK_801_mPFC];
MSN=[Saline_MSN; MK_801_MSN];
Thal=[Saline_Thal; MK_801_thal];

numS=length(Saline_hipp);
IXS=zeros(length(hipp),1);
IXS(1:numS)=1;



%%
figure;
subplot 141
[p_h]=bar_plot_with_p_publish_updated(10*log10((sqrt(hipp)*1e6)),IXS==1,IXS==0,'Low Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 142
[p_mp]=bar_plot_with_p_publish_updated(10*log10((sqrt(mpfc)*1e6)),IXS==1,IXS==0,'Low Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 143
[p_ms]=bar_plot_with_p_publish_updated(10*log10((sqrt(MSN)*1e6)),IXS==1,IXS==0,'Low Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 144
[p_t]=bar_plot_with_p_publish_updated(10*log10((sqrt(Thal)*1e6)),IXS==1,IXS==0,'Low Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

set(gcf,'Position',[232   716   688   192])

bonf_holm([p_h p_mp p_ms p_t])

%% High gammma

MK_801_hipp= ...
[2.310000e-008
1.550000e-008
7.520000e-009
1.530000e-008
1.450000e-008
3.010000e-009
3.280000e-009
1.580000e-008
2.890000e-008
9.770000e-009
1.960000e-008
9.680000e-009
2.550000e-008
6.540000e-009
1.200000e-008
4.290000e-009
2.580000e-009
8.750000e-009
4.310000e-009
1.960000e-008
7.940000e-009
1.010000e-008
1.650000e-008
2.210000e-008
7.610000e-009
9.160000e-009
2.730000e-008
5.990000e-009
1.180000e-008
6.440000e-009
2.270000e-007
1.030000e-008
2.980000e-008];

Saline_hipp=...
[1.880000e-008
1.770000e-008
2.240000e-008
1.980000e-008
2.810000e-008
1.180000e-007
1.650000e-008
9.060000e-008
1.150000e-008
1.150000e-008
3.140000e-008
1.960000e-008
5.720000e-008];

Saline_mPFC=...
[1.200000e-008
1.350000e-008
1.150000e-007
1.100000e-008
2.790000e-008
1.840000e-007
8.880000e-008
8.140000e-009
9.110000e-009
1.150000e-008
2.140000e-008
8.310000e-009
1.270000e-008];

MK_801_mPFC=...
[7.000000e-009
9.470000e-009
5.350000e-009
2.540000e-008
8.650000e-009
2.220000e-009
4.380000e-009
3.410000e-009
7.890000e-009
1.160000e-008
2.460000e-008
1.320000e-008
1.200000e-008
8.750000e-009
1.160000e-008
4.160000e-009
2.930000e-009
3.270000e-009
2.420000e-008
1.310000e-008
5.630000e-009
1.310000e-008
1.890000e-008
7.740000e-009
2.910000e-010
6.630000e-009
1.060000e-008
5.950000e-009
8.190000e-009
1.880000e-009
8.740000e-009
1.960000e-009
3.990000e-008];

Saline_MSN=...
[1.910000e-008
7.490000e-009
2.230000e-008
1.030000e-008
3.530000e-008
1.110000e-007
9.800000e-009
6.230000e-009
5.190000e-009
5.620000e-009
9.360000e-007
8.410000e-009
8.130000e-009];

MK_801_MSN=...
[7.020000e-009
1.110000e-008
3.670000e-009
7.350000e-008
2.320000e-008
3.160000e-009
1.100000e-008
6.660000e-009
1.180000e-008
3.020000e-009
8.560000e-009
1.140000e-008
7.760000e-009
6.870000e-009
1.190000e-008
4.140000e-009
5.790000e-009
5.140000e-009
3.380000e-008
1.100000e-008
5.240000e-009
9.260000e-009
5.650000e-009
8.670000e-009
9.630000e-009
4.590000e-009
9.300000e-009
1.010000e-008
8.430000e-009
6.820000e-009
4.760000e-008
8.590000e-009
1.590000e-008];

Saline_Thal=...
[1.370000e-008
9.540000e-009
2.290000e-008
1.320000e-007
8.510000e-009
1.190000e-007
2.350000e-008
6.040000e-009
5.450000e-009
1.420000e-008
8.700000e-009
1.150000e-008
8.100000e-009];

MK_801_thal=...
[1.220000e-008
1.250000e-008
4.460000e-009
1.420000e-008
2.090000e-008
8.350000e-009
3.810000e-009
2.410000e-009
1.590000e-008
2.980000e-009
8.700000e-009
7.420000e-009
1.330000e-008
5.950000e-009
1.940000e-008
4.970000e-009
3.200000e-009
6.300000e-009
3.800000e-008
1.110000e-008
7.890000e-009
2.390000e-007
3.300000e-008
1.530000e-008
1.460000e-010
6.330000e-009
3.250000e-009
5.960000e-009
7.820000e-009
5.710000e-009
1.620000e-007
1.100000e-008
1.100000e-008];

hipp=[Saline_hipp; MK_801_hipp]; 
mpfc=[Saline_mPFC; MK_801_mPFC];
MSN=[Saline_MSN; MK_801_MSN];
Thal=[Saline_Thal; MK_801_thal];

numS=length(Saline_hipp);
IXS=zeros(length(hipp),1);
IXS(1:numS)=1;



%%
figure;
subplot 141
[p_h]=bar_plot_with_p_publish_updated(10*log10((sqrt(hipp)*1e6)),IXS==1,IXS==0,'High Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 142
[p_mp]=bar_plot_with_p_publish_updated(10*log10((sqrt(mpfc)*1e6)),IXS==1,IXS==0,'High Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 143
[p_ms]=bar_plot_with_p_publish_updated(10*log10((sqrt(MSN)*1e6)),IXS==1,IXS==0,'High Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])

subplot 144
[p_t]=bar_plot_with_p_publish_updated(10*log10((sqrt(Thal)*1e6)),IXS==1,IXS==0,'High Gamma PSD 7',false,false)
xticklabels({'Saline' 'MK-801'})
ylim([10 25])
set(gcf,'Position',[232   716   688   192])

bonf_holm([p_h p_mp p_ms p_t])