#*************************************************************************************************************************
#
#Copyright or © or Copr.[DGFIP][2015]
#
#Ce logiciel a été initialement développé par la Direction Générale des 
#Finances Publiques pour permettre le calcul de l'impôt sur le revenu 2015 
#au titre des revenus perçus en 2014. La présente version a permis la 
#génération du moteur de calcul des chaînes de taxation des rôles d'impôt 
#sur le revenu de ce millésime.
#
#Ce logiciel est régi par la licence CeCILL 2.1 soumise au droit français 
#et respectant les principes de diffusion des logiciels libres. Vous pouvez 
#utiliser, modifier et/ou redistribuer ce programme sous les conditions de 
#la licence CeCILL 2.1 telle que diffusée par le CEA, le CNRS et l'INRIA  sur 
#le site "http://www.cecill.info".
#
#Le fait que vous puissiez accéder à cet en-tête signifie que vous avez pris 
#connaissance de la licence CeCILL 2.1 et que vous en avez accepté les termes.
#
#**************************************************************************************************************************
regle 8610 :
application : iliad , batch  ;
BNNSV = positif(BNHREV - (BNHDEV * (1 - positif(ART1731BIS*PREM8_11))))
				   * arr((BNHREV-(BNHDEV * (1 - positif(ART1731BIS*PREM8_11))))*MAJREV) 
				+ (1-positif_ou_nul(BNHREV-(BNHDEV * (1 - positif(ART1731BIS*PREM8_11)))))
				   *(BNHREV-(BNHDEV * (1 - positif(ART1731BIS*PREM8_11) )));

BNNSC = positif(BNHREC - (BNHDEC * (1 - positif(ART1731BIS*PREM8_11))))
				   * arr((BNHREC-(BNHDEC * (1 - positif(ART1731BIS*PREM8_11))))*MAJREV) 
				+ (1-positif_ou_nul(BNHREC-(BNHDEC * (1 - positif(ART1731BIS*PREM8_11)))))
				   *(BNHREC-(BNHDEC * (1 - positif(ART1731BIS*PREM8_11) )));

BNNSP = positif(BNHREP - (BNHDEP * (1 - positif(ART1731BIS*PREM8_11) )))
				   * arr((BNHREP-(BNHDEP * (1 - positif(ART1731BIS*PREM8_11))))*MAJREV) 
				+ (1-positif_ou_nul(BNHREP-(BNHDEP * (1 - positif(ART1731BIS*PREM8_11)))))
				   *(BNHREP-(BNHDEP * (1 - positif(ART1731BIS*PREM8_11) )));

BNNAV = (BNCREV - BNCDEV * (1 - positif(ART1731BIS*PREM8_11))) ;
BNNAC = (BNCREC - BNCDEC * (1 - positif(ART1731BIS*PREM8_11))) ;
BNNAP = (BNCREP - BNCDEP * (1 - positif(ART1731BIS*PREM8_11))) ;
BNNAAV = (BNCAABV - BNCAADV * (1 - positif(ART1731BIS*PREM8_11))) ;
BNNAAC = (BNCAABC - BNCAADC * (1 - positif(ART1731BIS*PREM8_11))) ;
BNNAAP = (BNCAABP - BNCAADP * (1 - positif(ART1731BIS*PREM8_11))) ;
regle 862:
application : iliad , batch  ;
VARDNOCEPV = min(max(DNOCEP,max(DNOCEP_P,DNOCEPP2)),ANOCEP);
VARDNOCEPC = min(max(DNOCEPC,max(DNOCEPC_P,DNOCEPCP2)),ANOVEP);
VARDNOCEPP = min(max(DNOCEPP,max(DNOCEPP_P,DNOCEPPP2)),ANOPEP);
NOCEPV = ANOCEP - DNOCEP + (BNCAABV - BNCAADV); 

NOCEPC = ANOVEP - DNOCEPC + (BNCAABC - BNCAADC); 

NOCEPP = ANOPEP - DNOCEPP + (BNCAABP - BNCAADP); 

NOCEPIMPV = positif(ANOCEP - DNOCEP * (1 - positif(ART1731BIS*PREM8_11)))
		    *arr((ANOCEP- DNOCEP * (1 - positif(ART1731BIS*PREM8_11)))*MAJREV) 
	   + positif_ou_nul(DNOCEP * (1 - positif(ART1731BIS*PREM8_11))-ANOCEP)
	           *(ANOCEP- DNOCEP * (1 - positif(ART1731BIS*PREM8_11)))+BNNAAV;

NOCEPIMPC = positif(ANOVEP - DNOCEPC * (1 - positif(ART1731BIS*PREM8_11)))
			    *arr((ANOVEP- DNOCEPC * (1 - positif(ART1731BIS*PREM8_11)))*MAJREV) 
	   + positif_ou_nul(DNOCEPC * (1 - positif(ART1731BIS*PREM8_11))-ANOVEP)
			    *(ANOVEP- DNOCEPC * (1 - positif(ART1731BIS*PREM8_11)))+BNNAAC;

NOCEPIMPP = positif(ANOPEP - DNOCEPP * (1 - positif(ART1731BIS*PREM8_11)))
				    *arr((ANOPEP- DNOCEPP * (1 - positif(ART1731BIS*PREM8_11)))*MAJREV) 
	   + positif_ou_nul(DNOCEPP * (1 - positif(ART1731BIS*PREM8_11))-ANOPEP)
				    *(ANOPEP- DNOCEPP * (1 - positif(ART1731BIS*PREM8_11)))+BNNAAP;

NOCEPIMP = NOCEPIMPV+NOCEPIMPC+NOCEPIMPP;

TOTDABNCNP = null(4-V_IND_TRAIT) * (DABNCNP6 + DABNCNP5 + DABNCNP4 + DABNCNP3 + DABNCNP2 + DABNCNP1) * (1-positif(ART1731BIS*PREM8_11))
	   + null(5-V_IND_TRAIT) * max(0,min(DABNCNP6 + DABNCNP5 + DABNCNP4 + DABNCNP3 + DABNCNP2 + DABNCNP1,TOTDABNCNP1731*ART1731BIS*(1-PREM8_11)+
				      (DABNCNP6 + DABNCNP5 + DABNCNP4 + DABNCNP3 + DABNCNP2 + DABNCNP1) * (1-positif(ART1731BIS*PREM8_11)))); 

regle 862019:
application : iliad ,batch ;
BNN = (somme(i=V,C,P:BNRi) + SPENETPF + max(0,SPENETNPF + NOCEPIMP - TOTDABNCNP)) * (1-ART1731BIS)
      + (somme(i=V,C,P:BNRi) + SPENETPF + max(0,SPENETNPF + NOCEPIMP - DIDABNCNP+DEFBNCNPF)) * ART1731BIS*(1-PREM8_11)
      + (somme(i=V,C,P:BNRi) + SPENETPF + max(0,SPENETNPF + NOCEPIMP)) * ART1731BIS*PREM8_11
        ;
regle 8621:
application : iliad , batch  ;
pour i = V,C,P:
BNNi =  BNRi + SPENETi;
regle 86211:
application : iliad , batch  ;
pour i = V,C,P:
BNRi = BNNSi + BNNAi;
BNRTOT = BNRV + BNRC + BNRP;
regle 863:
application : iliad , batch  ;
BN1 = somme(i=V,C,P:BN1i);
regle 8631:
application : iliad , batch  ;
pour i = V,C,P:
BN1i = BN1Ai + PVINiE + INVENTi;
regle 864:                                                                    
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
SPETOTi = BNCPROi + BNCNPi;
regle 8641:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
SPEBASABi=SPETOTi;
pour i = V,C,P:                                                                 
SPEABi = arr((max(MIN_SPEBNC,(SPEBASABi * SPETXAB/100))) * 
                       positif_ou_nul(SPETOTi - MIN_SPEBNC)) +
          arr((min(MIN_SPEBNC,SPEBASABi )) * 
                       positif(MIN_SPEBNC - SPETOTi)); 
regle 86411:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
SPEABPi = arr((SPEABi * BNCPROi)/SPETOTi);                                  
pour i = V,C,P:                                                                 
SPEABNPi = SPEABi - SPEABPi;                                  
regle 8642:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
SPENETPi = max (0,(BNCPROi - SPEABPi));                                    
pour i = V,C,P:                                                                 
SPENETNPi = max (0,(BNCNPi - SPEABNPi));
pour i = V,C,P:                                                                 
SPENETi = SPENETPi + SPENETNPi;
SPENET = somme(i=V,C,P:(SPENETi));
regle 8650:
application : iliad , batch  ;                          
SPENETCT = BNCPROPVV + BNCPROPVC + BNCPROPVP - BNCPMVCTV - BNCPMVCTC - BNCPMVCTP  ;
SPENETNPCT = BNCNPPVV + BNCNPPVC + BNCNPPVP - BNCNPDCT;
regle 8660:
application : iliad , batch  ;                          
SPENETPF = somme(i=V,C,P:SPENETPi) + SPENETCT;
SPENETNPF = somme(i=V,C,P:SPENETNPi) + SPENETNPCT;                                    
BNCNPTOT = SPENETPF + SPENETNPF;
regle 8680:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
SPEPVPi = BNCPRO1Ai - BNCPRODEi;
pour i = V,C,P:                                                                 
SPEPVNPi = BNCNP1Ai - BNCNPDEi;
SPEPV = somme(i=V,C,P:max(0,SPEPVPi + SPEPVNPi));

regle 8690:
application :  iliad , batch  ;                          

DCTSPE = positif_ou_nul(BNRTOT+SPENETPF) * BNCPMVCTV
        + ( 1 - positif_ou_nul(BNRTOT+SPENETPF)) * (BNCPMVCTV-abs(BNRTOT+SPENETPF))
        + ( 1 - positif_ou_nul(BNRTOT+SPENETPF)) * null(BNCPMVCTV-abs(BNRTOT+SPENETPF))* BNCPMVCTV
	;
DCTSPENP = positif_ou_nul(NOCEPIMP+SPENETNPF) * BNCNPDCT
        + ( 1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * (BNCNPDCT-abs(NOCEPIMP+SPENETNPF))
        + ( 1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * null(BNCNPDCT-abs(NOCEPIMP+SPENETNPF)) * BNCNPDCT
	;
regle 8691:
application : iliad , batch  ;

BNCDF1 = ((1-positif_ou_nul(NOCEPIMP+SPENETNPF)) * abs(NOCEPIMP+SPENETNPF)
                + positif_ou_nul(NOCEPIMP+SPENETNPF)
                * positif_ou_nul(DABNCNP5+DABNCNP4+DABNCNP3+DABNCNP2+DABNCNP1-NOCEPIMP-SPENETNPF)
                * (DABNCNP5+DABNCNP4+DABNCNP3+DABNCNP2+DABNCNP1-NOCEPIMP-SPENETNPF)
                * null(BNCDF6+BNCDF5+BNCDF4+BNCDF3+BNCDF2))
		* (1-positif(ART1731BIS))
                 +  DEFBNCNPF * positif(ART1731BIS*(1-PREM8_11))
                 + (DNOCEP +DNOCEPC +DNOCEPP +BNCAADV +BNCAADC +BNCAADP) * positif(ART1731BIS*PREM8_11);
regle 86911:
application : iliad , batch  ;                          
BNCDF2 = ((1-positif_ou_nul(NOCEPIMP+SPENETNPF)) * (DABNCNP1)
                + positif_ou_nul(NOCEPIMP+SPENETNPF)
                * min(max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4-DABNCNP3-DABNCNP2,0)-DABNCNP1,DABNCNP1)*(-1)
                * positif_ou_nul(DABNCNP1-max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4-DABNCNP3-DABNCNP2,0)))
		 * (1-positif(ART1731BIS))
                  + min(DABNCNP1,DABNCNP - DIDABNCNP) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DABNCNP1 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));


regle 86912:
application : iliad , batch  ;                          
BNCDF3 = ((1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * (DABNCNP2)
                 + positif_ou_nul(NOCEPIMP+SPENETNPF)
                 * min(max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4-DABNCNP3,0)-DABNCNP2,DABNCNP2)*(-1)
                 * positif_ou_nul(DABNCNP2-max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4-DABNCNP3,0)))
		 * (1-positif(ART1731BIS))
                  + min(DABNCNP2,DABNCNP - DIDABNCNP-BNCDF2) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DABNCNP2 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
regle 86913:
application : iliad , batch  ;                          
BNCDF4 = ((1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * (DABNCNP3)
                 + positif_ou_nul(NOCEPIMP+SPENETNPF)
                 * min(max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4,0)-DABNCNP3,DABNCNP3)*(-1)
                 * positif_ou_nul(DABNCNP3-max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5-DABNCNP4,0)))
		 * (1-positif(ART1731BIS))
                  + min(DABNCNP3,DABNCNP - DIDABNCNP-BNCDF2-BNCDF3) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DABNCNP3 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));

regle 86914:
application : iliad , batch  ;                          
BNCDF5 = ((1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * (DABNCNP4)
                 + positif_ou_nul(NOCEPIMP+SPENETNPF)
                 * min(max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5,0)-DABNCNP4,DABNCNP4)*(-1)
                 * positif_ou_nul(DABNCNP4-max(NOCEPIMP+SPENETNPF-DABNCNP6-DABNCNP5,0)))
		 * (1-positif(ART1731BIS)) 
                  + min(DABNCNP4,DABNCNP - DIDABNCNP-BNCDF2-BNCDF3-BNCDF4) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DABNCNP4 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
regle 86915:
application : iliad , batch  ;                          
BNCDF6 = ((1 - positif_ou_nul(NOCEPIMP+SPENETNPF)) * (DABNCNP5)
                 + positif_ou_nul(NOCEPIMP+SPENETNPF)
                 * min(max(NOCEPIMP+SPENETNPF-DABNCNP6,0)-DABNCNP5,DABNCNP5)*(-1)
                 * positif_ou_nul(DABNCNP5-max(NOCEPIMP+SPENETNPF-DABNCNP6,0)))
		 * (1-positif(ART1731BIS))
                  + min(DABNCNP5,DABNCNP - DIDABNCNP-BNCDF2-BNCDF3-BNCDF4-BNCDF5) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DABNCNP5 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));

regle 8692:
application : iliad , batch  ;                          
DABNCNP = DABNCNP1 + DABNCNP2 + DABNCNP3 + DABNCNP4 + DABNCNP5 + DABNCNP6;
VAREDABNCNP = min(DABNCNP,SPENETNPF + NOCEPIMP);
DEFBNCNP = (NOCEPIMP+SPENETNPF+DIDABNCNP+DNOCEP+DNOCEPC+DNOCEPP+BNCAADV+BNCAADC+BNCAADP );
DEFBNCNPF = DEFRIBNC * (1-PREM8_11) * max(0,min(DNOCEP+DNOCEPC+DNOCEPP+BNCAADV+BNCAADC+BNCAADP,-(max(DEFBNCNP1731,max(DEFBNCNP_P,DEFBNCNPP2))-DNOCEP-DNOCEPC-DNOCEPP-BNCAADV-BNCAADC-BNCAADP)));
