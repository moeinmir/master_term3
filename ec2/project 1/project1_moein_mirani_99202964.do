clear
import excel "F:\eco\term 3\master_term3\ec2\project 1\data.xlsx", sheet("Sheet1") firstrow
destring year povertypercentage	unemploymentpercentage	laborforceparticipation	laborforceparticipationfemale	urbanpopulation	gdppercapita education, replace force
asdoc sum povertypercentage	unemploymentpercentage	laborforceparticipation	laborforceparticipationfemale	urbanpopulation	gdppercapita education
*filling the missing places
tset year
ipolate povertypercentage year, gen(pp) epolate 
ipolate unemploymentpercentage year, gen(uep) epolate 
ipolate laborforceparticipation year, gen(lfpp) epolate 
ipolate laborforceparticipationfemale year, gen(lfpfp) epolate 
ipolate urbanpopulation year, gen(upp) epolate 
ipolate gdppercapita year, gen(gdppc) epolate 
ipolate education year, gen(edu) epolate 
asdoc corr pp uep lfpp lfpfp upp gdppc edu

*testing for autocorrelation
tset year
xcorr gdppc pp, lags(3) xlabel(-10(1)10,grid)
xcorr edu pp, lags(3) xlabel(-10(1)10,grid)

*testing for stationary
asdoc dfuller pp ,lag(5)
asdoc dfuller edu ,lag(5)
asdoc dfuller gdppc ,lag(5)

* ols
regress pp edu gdppc
outreg2 using results, word replace
predict e,resid
asdoc corr e lfpp lfpfp upp uep


*GMM1

gmm (pp - {b2}*edu -{b3}*gdppc- {b0}), ///
instruments(lfpp lfpfp upp uep i.year) 
outreg2 using results, word replace



*GMM2

gmm (pp - {b2}*edu -{b3}*gdppc- {b0}), ///
instruments(lfpfp upp uep i.year) 
outreg2 using results, word replace






