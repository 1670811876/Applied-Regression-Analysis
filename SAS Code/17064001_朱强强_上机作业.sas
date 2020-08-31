/*导入数据*/
data work.project;
input employment gdp pct1 pct2 pct3 cpi population;
cards;
1.4	28014.94	0.4298	19.014	80.5562	101.9097	2170.7
3.5	18549.19	0.9109	40.9376	58.1515	102.1116	1557
3.7	34016.32	9.2014	46.5841	44.2145	101.7292	7519.52
3.4	15528.42	4.6313	43.6547	51.714	101.1124	3702
3.6	16096.21	10.2494	39.7589	49.9916	101.7054	2529
3.8	23409.24	8.1262	39.2999	52.5739	101.3574	4369
3.5	14944.53	7.3295	46.8299	45.8406	101.5655	2717
4.2	15902.6817	18.6462	25.5341	55.8197	101.3498	3788.7
3.9	30632.99	0.3616	30.4595	69.1788	101.6779	2418
3	85869.76	4.7108	45.0157	50.2735	101.7424	8029.3
2.7	51768.26	3.7357	42.9454	53.3189	102.1188	5657
2.9	27018	    9.5576	47.5175	42.9249	101.232	    6255
3.9	32182.09	6.8831	47.7107	45.4062	101.177	    3911
3.3	20006.31	9.1734	48.1247	42.7019	101.9878	4622
3.4	72634.1491	6.6535	45.3545	47.992	101.5179	10005.83
2.8	44552.83	9.2907	47.3719	43.3374	101.3651	9559.13
2.6	35478.09	9.9469	43.5248	46.5284	101.5459	5902
4	33902.96	8.8441	41.7235	49.4325	101.4264	6860.15
2.5	89705.23	4.0259	42.3699	53.6042	101.5077	11169
2.2	18523.26	15.5388	40.2243	44.2369	101.6134	4885
2.3	4462.54	    21.5761	22.327	56.097	102.845	    926
3.4	19424.73	6.5694	44.1942	49.2364	101.0086	3075.16
4	36980.22	11.526	38.7454	49.7286	101.4121	8302
3.2	13540.8256	15.0085	40.0872	44.9043	100.9102	3580
3.2	16376.34	14.279	37.8898	47.8312	100.9498	4800.5
2.7	1310.92	    9.3614	39.1824	51.4562	101.6396	337
3.3	21898.81	7.9523	49.6962	42.3515	101.6374	3835
2.7	7459.8995	11.525	34.3408	54.1342	101.3898	2626
3.1	2624.83	    9.0829	44.2852	46.632	101.4978	598
3.9	3443.56	    7.2779	45.8993	46.8228	101.5916	682
2.6	10881.96	14.2607	39.7988	45.9405	102.1868	2445
;
run;
proc standard data=work.project out=work.project mean=0 std=1;
var gdp pct1 pct2 pct3 cpi population;
run;
proc print data=work.project;
run;
/*对所选变量间是否存在线性关系进行检验(alpha=10%)*/
proc corr;
	var employment gdp pct1 pct2 pct3 cpi population;
run;
/*以调查失业率为因变量，以GDP为自变量构建一元线性回归模型，并检验模型及其系数是否通过检验*/
proc reg data=work.project;
	model employment=gdp;
run;
/*给定置信水平为99%时构建回归系数估计值的置信区间和失业率的均值置信区间，并绘制出置信区间的图形*/
proc reg data=work.project;
	model employment=gdp/clb clm alpha=0.01;
run;
/*计算该模型的残差、标准化残差、学生化残差、删除残差和R型学生化残差，并利用这些残差绘制残差图以判断是否存在异方差*/
proc reg data=work.project;
	model employment=gdp/r partial;
	output out=res_data residual=res student=stu_res press=press_res rstudent=rstu_res h=h;
run;
data res_data;
	set res_data;
	std_res=stu_res*sqrt(1-h);
run;
proc print data=res_data;
run;
proc reg data=work.project;
	model employment=gdp/r partial;
	plot r.*p.;
	plot student.*p.;
	plot press.*p.;
	plot rstudent.*p.;
run;
/*分别采用box-cox法和加权最小二乘法重新估计模型，并对新估计的模型残差再次进行残差分析*/
proc transreg data=work.project detail ss2;
	model boxcox(employment)=identity(gdp);
	output out=work.box_cox;
run;
proc reg data=work.box_cox;
	model employment=tgdp/r p;
	plot r.*p.;
run;
data work.project_w;
	set work.project;
	array row{9} w1-w9; /*w1-w9为不同m时的权数值*/
	array p{9} (-2,-1.5,-1,-0.5,0,0.5,1,1.5,2);
	do i=1 to 9;
		row(i)=1/gdp**p{i};
end;
run;
proc print data=work.project_w;
run;
proc reg data=work.project_w;
	model employment=gdp/r p;
	weight wwork.project;
	output out=work.wls residual=r predicted=p;
run;
proc gplot data=work.wls;
	plot r*p;
run;
/*构建包含经济发展、物价水平、产业结构、人口规模等因素的多元线性回归模型，并对模型进行拟合、检验*/
proc reg data=work.project;
	model employment=gdp pct1 pct2 pct3 cpi population;
	output out=res_multi r=res_multi student=stu_res press=press_res rstudent=rstu_res h=h;
run;
/*判断该样本中是否有单位为杠杆点或强影响点，若存在的话是分析删除该单位对模型系数估计的影响和对模型拟合效果的影响*/
data work.res_multi_new(where=(stu_res>2 or stu_res<-2));   
     set res_multi;
run;
proc print data=work.res_multi_new;
run;
*删除异常值;
data work.res_multi_new;   
	set res_multi;
	if employment=1.4 then delete; 
	if employment=4.2 then delete;
run;
proc print data=work.res_multi_new;
run;
*重新进行拟合;
proc reg data=work.res_multi_new;
	model employment=gdp pct1 pct2 pct3 cpi population;
run;
/*检验所构建的多元线性模型的残差是否服从正态分布*/
proc univariate data=res_multi plot;
	var res_multi;
run;
