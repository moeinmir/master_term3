import excel "C:\Users\Mahshad Ebrahimi\Downloads\Data_Extract_From_World_Development_Indicators.xlsx", sheet("Sheet1") firstrow
destring Currenthealthexpenditureof GDPpercapitaPPPcurrentint Outofpocketexpenditureof Hospitalbedsper1000people Physiciansper1000people CO2emissionskgperPPPofG Populationages65andabove Populationtotal Populationages014oftotal ,replace force
tsset year
*interpolation the data 
ipolate Currenthealthexpenditureof year , gen(HE) epolate
ipolate GDPpercapitaPPPcurrentint year , gen(GDP) epolate
ipolate Outofpocketexpenditureof year , gen(OPE) epolate
ipolate Hospitalbedsper1000people year , gen(HB) epolate
ipolate Physiciansper1000people year , gen(PH) epolate
ipolate CO2emissionskgperPPPofG year , gen(CO2) epolate
ipolate Populationages65andabove year , gen(POP65) epolate
ipolate Populationtotal year , gen(POP) epolate
ipolate Populationages014oftotal year , gen(POP14) epolate
*DATA statistics 
asdoc summarize HE GDP OPE HB PH CO2 POP
*Statistical description
asdoc corr HE GDP OPE HB PH CO2 POP
* Graphs 
line HE year
line GDP year
line OPE year
line HB year
line PH year
line CO2 year
line POP65 year
line POP year
line POP14 year
kdensity HE , normal
kdensity GDP , normal
kdensity OPE , normal
kdensity HB , normal
kdensity PH , normal
kdensity CO2 , normal
kdensity POP65 , normal
kdensity POP14 , normal
kdensity POP , normal
*OLS regression 
regress HE GDP OPE HB PH CO2 POP
outreg2 using myreg.doc, ctitle(OLS1)
*Autocorrelation 
asdoc estat bgodfrey
*Multicollinearity
asdoc estat vif
regress HE GDP OPE HB PH POP
outreg2 using myreg.doc, append ctitle(OLS2)
*Omitted Variable 
asdoc ovtest 
*Dummy Variable 
predict e,resid
corr POP POP65 POP14
*2SLS Regression (IV Estimation)
asdoc ivregress 2sls HE GDP OPE HB PH  ( POP = POP65 POP14 i.year )
outreg2 using myreg.doc, append ctitle(2SLS)
*GMM Regression 
asdoc ivregress gmm HE GDP OPE HB PH  ( POP = POP65 POP14 i.year )
outreg2 using myreg.doc, append ctitle(GMM)
*Statical test 
estat overid			  
matrix B = e(b)'
matrix list B
matrix VC = e(V)
matrix define R = (1,1,1,1,1,0)
matrix define r= (0)
matrix J = e(N)*(R*B-r)'*inv(R*VC*R')*(R*B-r)
matrix list J
*e(Q)