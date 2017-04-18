## data from imdb/wiki
Vyear=1958
Vduration=128
Vgross=3200000
Vbudget=2479000
Vcriticreviews=201
Vuservotes=267005
Vuserreviews=706
VcolorColor=0
VcountryNZ=0
VcountryUK=0
VratingG=0
VratingPG13=1
VratingR=0
VratingUnrated=0
Vscore=8.4

mmod.est=sqrt(coef(mmod)[1]+Vyear*coef(mmod)[2]+sqrt(Vduration)*coef(mmod)[3]+sqrt(Vgross)*coef(mmod)[4]+Vbudget*coef(mmod)[5]+sqrt(Vcriticreviews)*coef(mmod)[6]+sqrt(Vuservotes)*coef(mmod)[7]+sqrt(Vuserreviews)*coef(mmod)[8]+VcolorColor*coef(mmod)[9]+VcountryNZ*coef(mmod)[10]+VcountryUK*coef(mmod)[11]+VratingG*coef(mmod)[12]+VratingPG13*coef(mmod)[13]+VratingR*coef(mmod)[14]+VratingUnrated*coef(mmod)[15]+sqrt(Vcriticreviews*Vuserreviews)*coef(mmod)[16]+sqrt(Vgross)*Vbudget*coef(mmod)[17])
# predicts score of 8.55, difference of 0.15
rmod.est=sqrt(coef(rmod)[1]+Vyear*coef(rmod)[2]+sqrt(Vduration)*coef(rmod)[3]+sqrt(Vgross)*coef(rmod)[4]+Vbudget*coef(rmod)[5]+sqrt(Vcriticreviews)*coef(rmod)[6]+sqrt(Vuservotes)*coef(rmod)[7]+sqrt(Vuserreviews)*coef(rmod)[8]+VratingPG13*coef(rmod)[9]+sqrt(Vgross)*coef(rmod)[10])
# predicts score of 8.4, spot on
tmod.est=sqrt(coef(tmod)[1]+Vbudget*coef(tmod)[2]+sqrt(Vuservotes)*coef(tmod)[3]+sqrt(Vduration)*coef(tmod)[4])
# predicts score of 7.72, difference of -0.68

