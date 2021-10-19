clear
import excel "F:\eco\term 3\master_term3\ec2\project 1\data.xlsx", sheet("Sheet1") firstrow
destring year povertypercentage	consumerpriceindex	unemploymentpercentage	laborforceparticipation	laborforceparticipationfemale	urbanpopulation	gdppercapita education, replace force
asdoc sum povertypercentage	consumerpriceindex	unemploymentpercentage	laborforceparticipation	laborforceparticipationfemale	urbanpopulation	gdppercapita education
*filling the missing places
tset year
ipolate povertypercentage year, gen(pp) epolate 
ipolate consumerpriceindex year, gen(cpi) epolate 
ipolate unemploymentpercentage year, gen(uep) epolate 
ipolate laborforceparticipation year, gen(lfpp) epolate 
ipolate laborforceparticipationfemale year, gen(lfpfp) epolate 
ipolate urbanpopulation year, gen(upp) epolate 
ipolate gdppercapita year, gen(gdppc) epolate 
ipolate education year, gen(edu) epolate 
asdoc corr pp cpi uep lfpp lfpfp upp gdppc edu

*running the original regresion
regress pp uep upp gdppc lfpp lfpfp cpi edu , robust
outreg2 using results, word replace


ivregress gmm pp uep upp gdppc lfpp lfpfp cpi edu 
outreg2 using results, word replace

ivregress 2sls pp upp gdppc cpi (lfpfp edu = lfpp upp uep)
outreg2 using results, word replace






*serial correllation between dependant variable and independant variables lags
tset year
xcorr uep pp, lags(10) xlabel(-10(1)10,grid)
xcorr upp pp, lags(10) xlabel(-10(1)10,grid)
xcorr gdppc pp, lags(10) xlabel(-10(1)10,grid)
xcorr edu pp, lags(10) xlabel(-10(1)10,grid)
xcorr cpi pp, lags(10) xlabel(-10(1)10,grid)
xcorr lfpp pp, lags(10) xlabel(-10(1)10,grid)


*which lags should we use in the regresion
asdoc varsoc lfpp pp, maxlag(10)


*replacing the lag the AIC gave us
generate lfpp10=L10.lfpp
regress pp uep upp gdppc lfpp10 cpi edu , robust
outreg2 using results, word replace
*replacing the log of GDP
generate loggdppc=log(gdppc)
regress pp uep upp loggdppc lfpp10 cpi edu , robust
outreg2 using results, word replace

*testing for the stationary

asdoc dfuller pp ,lag(5)
asdoc dfuller uep ,lag(5)
asdoc dfuller upp ,lag(5)
asdoc dfuller loggdppc ,lag(5)
asdoc dfuller edu ,lag(5)
asdoc dfuller lfpp10 ,lag(5)
asdoc dfuller cpi ,lag(5)

*testing for the first difference stationary

g pp1=D.pp
g upp1=D.upp
g loggdppc1=D.loggdppc
g edu1=D.edu
g lfpp101=D.lfpp10
g cpi1=D.cpi

asdoc dfuller pp1 ,lag(5)
asdoc dfuller upp1 ,lag(5)
asdoc dfuller loggdppc1 ,lag(5)
asdoc dfuller edu1 ,lag(5)
asdoc dfuller lfpp101 ,lag(5)
asdoc dfuller cpi1 ,lag(5)


*final regresion

regress pp uep loggdppc1  edu , robust
outreg2 using results, word replace

save "Desktop.dta"
save "Desktop.xls"


