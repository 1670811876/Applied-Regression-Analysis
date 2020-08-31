/*3.1*/
proc import datafile='E:\Applied Regression Analysis\SAS\data-table-B1.csv' out = file_data;
getnames=yes;
run;
proc print data=work.file_data;
run;
proc reg data=file_data;
model y=x2 x7 x8;
run;
proc reg data=file_data;
model y=x2 x7 x8 / selection=stepwise slentry=0.05 slstay=0.05;
run;
/*3.2*/
data file_data_fit;
input y_fit;
cards;
3.5811
4.0960
1.9556
4.5248
-1.6178
2.1847
-0.9184
2.1533
0.1433
2.6088
1.2408
1.8195
-0.2776
-0.6078
2.3818
-0.6200
-1.7997
3.1303
0.9760
1.4828
3.5384
-0.5506
3.3205
2.1039
1.2129
1.4286
0.7363
3.7985
;
run;
data file_data_fit;
merge file_data file_data_fit;
run;
proc print data=file_data_fit;
run;
proc corr data=file_data_fit;
var y y_fit;
run;
/*3.3*/
proc reg data=file_data;
model y=x2 x7 x8/clb alpha=0.05;
run;
data file_data_new1;
input x2 x7 x8;
cards;
2300 56.0 2100
;
run;
data file_data1;
set file_data_new1 file_data;
run;
proc reg data=file_data;
model y=x2 x7 x8/clm alpha=0.05;
run;
quit;
/*3.4*/
proc reg data=file_data;
model y=x7 x8/p;
run;
proc reg data=file_data;
model y=x7 x8/clb alpha=0.05;
run;
data file_data_new2;
input x7 x8;
cards;
56.0 2100
;
run;
data file_data2;
set file_data_new2 file_data;
run;
proc reg data=file_data2;
model y=x7 x8/clm alpha=0.05;
run;
quit;
