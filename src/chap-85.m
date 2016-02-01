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

regle 8501 :
application : iliad , batch  ;
 pour i= V,C,P:                                           
BIPTAi = (BICNOi - (BICDNi * (1 - positif(ART1731BIS*PREM8_11))) );           
pour i= V,C,P:                                           
BIPTTAi = (BIPTAi + BI1Ai);              
regle 8503 :
application : iliad , batch  ;

pour i= V,C,P:                                           
BINTAi = (BICREi -  BICDEi * (1 - positif(ART1731BIS*PREM8_11)) );        
                                                         
pour i= V,C,P:                                           
BINTTAi = (BINTAi + BI2Ai);           
regle 8506 :
application : iliad , batch  ;
 
pour i= V,C,P:                                           
BI12Ai = BI1Ai +  BI2Ai;

regle 8508 :
application : iliad , batch  ;

pour i= V,C,P:                                           
BITAi = BIPTAi + BINTAi;

pour i= V,C,P:                                           
BITTAi = BITAi + BI12Ai;
regle 857:
application : iliad , batch  ;
BI1 = somme(i=V,C,P:BI1i);
BI2 = somme(i=V,C,P:BI2i);
regle 8571:
application : iliad , batch  ;
pour i = V,C,P:
BI1i = BI1Ai;
pour i = V,C,P:
BI2i = BI2Ai;
regle 8580:
application : iliad , batch ;
pour i = V,P,C:
BIHTAi = max(0,arr((BIHNOi - (BIHDNi * (1 - positif(ART1731BIS*PREM8_11)))) * MAJREV))
         + min(0,(BIHNOi - (BIHDNi * (1 - positif(ART1731BIS*PREM8_11) ))) );

pour i = V,P,C:
BINHTAi = max(0,arr((BICHREi - BICHDEi * (1 - positif(ART1731BIS*PREM8_11)))*MAJREV))
          + min(0,(BICHREi -  BICHDEi * (1 - positif(ART1731BIS*PREM8_11))))  ;
regle 85200:
application : iliad , batch ;

pour i = V,C,P:
MIB_TVENi = MIBVENi + MIBNPVENi + MIBGITEi+LOCGITi;

pour i = V,C,P:
MIB_TPRESi = MIBPRESi + MIBNPPRESi + MIBMEUi;

pour i = V,C,P:
MIB_TTi = MIB_TVENi + MIB_TPRESi;

regle 85240:
application : iliad , batch ;

pour i = V,C,P:
MIB_AVi = min ( MIB_TVENi,
                         (max(MIN_MBIC,
                              arr( MIB_TVENi*TX_MIBVEN/100))
                         )
              );
pour i = V,C,P:
PMIB_AVi = min ( MIBVENi,
                         (max(MIN_MBIC,
                              arr( MIBVENi*TX_MIBVEN/100))
                         )
              );


pour i = V,C,P:
MIB_APi = min ( MIB_TPRESi,
                         (max(MIN_MBIC,
                              arr(MIB_TPRESi*TX_MIBPRES/100))
                         )
               );
pour i = V,C,P:
PMIB_APi = min ( MIBPRESi,
                         (max(MIN_MBIC,
                              arr(MIBPRESi*TX_MIBPRES/100))
                         )
               );



regle 85250:
application : iliad , batch ;

pour i = V,C,P:
MIB_ABVi = max(0,arr(MIB_AVi * MIBVENi / MIB_TVENi));
pour i = V,C,P:
MIB_ABNPVi = max(0,arr(MIB_AVi * MIBNPVENi / MIB_TVENi))* positif(present(MIBGITEi)+present(LOCGITi))
	      + (MIB_AVi - MIB_ABVi) * (1 - positif(present(MIBGITEi)+present(LOCGITi)));
pour i = V,C,P:
MIB_ABNPVLi = (MIB_AVi - MIB_ABVi - MIB_ABNPVi) * positif(present(MIBGITEi)+present(LOCGITi));

pour i = V,C,P:
MIB_ABPi = max(0,arr(MIB_APi * MIBPRESi / MIB_TPRESi));
pour i = V,C,P:
MIB_ABNPPi = max(0,arr(MIB_APi * MIBNPPRESi / MIB_TPRESi)) * present(MIBMEUi)
	      + (MIB_APi - MIB_ABPi) * (1 - present(MIBMEUi));
pour i = V,C,P:
MIB_ABNPPLi = (MIB_APi - MIB_ABPi - MIB_ABNPPi) *  present(MIBMEUi);


regle 85260:
application : iliad , batch ;

pour i = V,C,P:
MIB_NETVi = MIBVENi - MIB_ABVi;
MIBNETVF = somme(i=V,C,P:MIB_NETVi) ;
pour i = V,C,P:
MIB_NETNPVi = MIBNPVENi - MIB_ABNPVi;
MIBNETNPVF = somme(i=V,C,P:MIB_NETNPVi);
pour i = V,C,P:
MIB_NETNPVLi = MIBGITEi+ LOCGITi - MIB_ABNPVLi;
pour i = V,C,P:
MIBNETNPVLSi = arr(MIB_NETNPVLi * MIBGITEi / (MIBGITEi + LOCGITi));
pour i = V,C,P:
MIBNETNPVLNSi = MIB_NETNPVLi - MIBNETNPVLSi;
MIBNETNPVLF = somme(i=V,C,P:MIB_NETNPVLi);

pour i = V,C,P:
MIB_NETPi = MIBPRESi - MIB_ABPi;
MIBNETPF = somme(i=V,C,P:MIB_NETPi) ;
pour i = V,C,P:
MIB_NETNPPi = MIBNPPRESi - MIB_ABNPPi;
MIBNETNPPF = somme(i=V,C,P:MIB_NETNPPi);
pour i = V,C,P:
MIB_NETNPPLi = MIBMEUi - MIB_ABNPPLi;
MIBNETNPPLF = somme(i=V,C,P:MIB_NETNPPLi);

pour i = V,C,P:
PMIB_NETVi = MIBVENi - PMIB_AVi;
pour i = V,C,P:
PMIB_NETPi = MIBPRESi - PMIB_APi;



regle 85265:
application : iliad , batch ;
MIB_NETCT = MIBPVV + MIBPVC + MIBPVP - BICPMVCTV - BICPMVCTC - BICPMVCTP;

MIB_NETNPCT = MIBNPPVV + MIBNPPVC + MIBNPPVP - MIBNPDCT ;


regle 85270:
application : iliad , batch ;

pour i=V,C,P:
MIB_P1Ai = MIB1Ai - MIBDEi ;
pour i=V,C,P:
MIB_NP1Ai = MIBNP1Ai - MIBNPDEi ;
pour i=V,C,P:
MIB_1Ai = max(0,MIB_P1Ai + MIB_NP1Ai);
MIB_1AF = max (0, somme(i=V,C,P:MIB_1Ai));
regle 85390:
application : iliad , batch ;
pour i = V,C,P:
REVIBI12i = BIH1i + BIH2i + BI1Ai + BI2Ai;
regle 85700:
application : iliad , batch ;
BICPF = somme(i=V,C,P:BIPTAi+BIHTAi+MIB_NETVi+MIB_NETPi) + MIB_NETCT  ; 
regle 85730:
application : iliad , batch ;
DEFNP  = somme (i=1,2,3,4,5,6:(min(DEFBICi,DEFBICi1731+0) * positif(ART1731BIS*PREM8_11) + DEFBICi * (1 - positif(ART1731BIS*PREM8_11))));
TOTDEFNP = null(4-V_IND_TRAIT) * DEFNP
	 + null(5-V_IND_TRAIT) * (ART1731BIS * ( 
                                     min(DEFNP,DEFNPI1731) * (1-PREM8_11)
                                   + 0 * PREM8_11
                                              )
                                +  min(DEFNP,DEFNPI1731) * (1-ART1731BIS));
regle 857301:
application : iliad , batch ;
pour i = V,C,P:
BICNPi = BINTAi+BINHTAi+  MIB_NETNPVi + MIB_NETNPPi ;
regle 857302:
application : iliad , batch ;
BICNPF = (1-positif(DEFRIBIC)*(1-PREM8_11)) * max(0,somme(i=V,C,P:BICNPi)+MIB_NETNPCT - DEFNPI) 
         + positif(DEFRIBIC)*(1-PREM8_11) * max(0,somme(i=V,C,P:BICNPi)+MIB_NETNPCT - DEFNPI + DEFBICNPF) ; 
regle 857303:
application : iliad , batch ;
DEFNPI = (abs(min( DEFNP , somme(i=V,C,P:BICNPi*positif(BICNPi))+MIB_NETNPCT))) * positif(BICNPV+BICNPC+BICNPP+MIB_NETNPCT)
	 * (1-positif(ART1731BIS))
         + ART1731BIS * (1-PREM8_11) * min(DEFBIC6+DEFBIC5+DEFBIC4+DEFBIC3+DEFBIC2+DEFBIC1,max(DEFNPI1731,max(DEFNPI_P,DEFNPIP2)));
regle 85740:
application : iliad , batch ;
BICNPR = somme(i=V,C,P:BINTAi);
regle 85750:
application : iliad , batch ;
BI12F = somme(i=V,C,P:REVIBI12i) + MIB_1AF  ; 
regle 85900:
application : iliad , batch  ;                   
pour i=V,C,P:                                       
BICIMPi = BIHTAi +  BIPTAi + MIB_NETVi + MIB_NETPi;
BIN = BICPF + BICNPF ;
regle 85960:
application : batch, iliad ;



DCTMIB = (BICPMVCTV + BICPMVCTC + BICPMVCTP) * positif_ou_nul(BIPN+MIB_NETCT)
	 + (1-positif_ou_nul(BIPN+MIB_NETCT)) * ((BICPMVCTV +BICPMVCTC +BICPMVCTP ) - abs(BIPN+MIB_NETCT))
	 + (1-positif_ou_nul(BIPN+MIB_NETCT)) * null((BICPMVCTV +BICPMVCTC +BICPMVCTP) - abs(BIPN+MIB_NETCT)) * (BICPMVCTV +BICPMVCTC +BICPMVCTP)
	 ;
DCTMIBNP = MIBNPDCT * positif_ou_nul(BINNV+BINNC+BINNP+MIB_NETNPCT)
	 + (1-positif_ou_nul(BINNV+BINNC+BINNP+MIB_NETNPCT)) * (MIBNPDCT - abs(BINNV+BINNC+BINNP+MIB_NETNPCT))
	 + (1-positif_ou_nul(BINNV+BINNC+BINNP+MIB_NETNPCT)) * null(MIBNPDCT - abs(BINNV+BINNC+BINNP+MIB_NETNPCT))*MIBNPDCT
	 ;
regle 90000:
application : iliad , batch  ;                   
VARLOCDEFPROCGAV = min(max(LOCPROCGAV,max(LOCPROCGAV_P,LOCPROCGAVP2)),LOCDEFPROCGAV);
VARLOCDEFPROCGAC = min(max(LOCPROCGAC,max(LOCPROCGAC_P,LOCPROCGACP2)),LOCDEFPROCGAC);
VARLOCDEFPROCGAP = min(max(LOCPROCGAP,max(LOCPROCGAP_P,LOCPROCGAPP2)),LOCDEFPROCGAP);
VARLOCDEFPROV = min(max(LOCPROV,max(LOCPROV_P,LOCPROVP2)),LOCDEFPROV);
VARLOCDEFPROC = min(max(LOCPROC,max(LOCPROC_P,LOCPROCP2)),LOCDEFPROC);
VARLOCDEFPROP = min(max(LOCPROP,max(LOCPROP_P,LOCPROPP2)),LOCDEFPROP);
DEPLOCV = (LOCPROCGAV - LOCDEFPROCGAV) + (LOCPROV - LOCDEFPROV) ;
DEPLOCC = (LOCPROCGAC - LOCDEFPROCGAC) + (LOCPROC - LOCDEFPROC) ;
DEPLOCP = (LOCPROCGAP - LOCDEFPROCGAP) + (LOCPROP - LOCDEFPROP) ;
DENPLOCAFFV = positif(present(LOCNPCGAV) + present(LOCGITCV) + present(LOCDEFNPCGAV) + present(LOCNPV) + present(LOCGITHCV) + present(LOCDEFNPV)) ;
DENPLOCAFFC = positif(present(LOCNPCGAC) + present(LOCGITCC) + present(LOCDEFNPCGAC) + present(LOCNPC) + present(LOCGITHCC) + present(LOCDEFNPC)) ;
DENPLOCAFFP = positif(present(LOCNPCGAPAC) + present(LOCGITCP) + present(LOCDEFNPCGAPAC) + present(LOCNPPAC) + present(LOCGITHCP) + present(LOCDEFNPPAC)) ;

DENPLOCV = (LOCNPCGAV + LOCGITCV - LOCDEFNPCGAV) + (LOCNPV + LOCGITHCV - LOCDEFNPV) ;
DENPLOCC = (LOCNPCGAC + LOCGITCC - LOCDEFNPCGAC) + (LOCNPC + LOCGITHCC - LOCDEFNPC) ;
DENPLOCP = (LOCNPCGAPAC + LOCGITCP - LOCDEFNPCGAPAC) + (LOCNPPAC + LOCGITHCP - LOCDEFNPPAC) ;

PLOCCGAV = LOCPROCGAV - (LOCDEFPROCGAV * (1 - positif(ART1731BIS*PREM8_11) ));
PLOCCGAC = LOCPROCGAC - (LOCDEFPROCGAC * (1 - positif(ART1731BIS*PREM8_11) ));
PLOCCGAPAC = LOCPROCGAP - (LOCDEFPROCGAP * (1 - positif(ART1731BIS*PREM8_11) ));
VARLOCDEFNPCGAV = min(max(LOCNPCGAV+LOCGITCV,max(LOCNPCGAV_P+LOCGITCV_P,LOCNPCGAVP2+LOCGITCVP2)),LOCDEFNPCGAV);
VARLOCDEFNPCGAC = min(max(LOCNPCGAC+LOCGITCC,max(LOCNPCGAC_P+LOCGITCC_P,LOCNPCGACP2+LOCGITCCP2)),LOCDEFNPCGAC);
VARLOCDEFNPCGAP = min(max(LOCNPCGAPAC+LOCGITCP,max(LOCNPCGAPAC_P+LOCGITCP_P,LOCNPCGAPACP2+LOCGITCPP2)),LOCDEFNPCGAPAC);
NPLOCCGAV = LOCNPCGAV + LOCGITCV - LOCDEFNPCGAV * (1 - positif(ART1731BIS*PREM8_11));
NPLOCCGAC = LOCNPCGAC + LOCGITCC - LOCDEFNPCGAC * (1 - positif(ART1731BIS*PREM8_11));
NPLOCCGAPAC = LOCNPCGAPAC + LOCGITCP - LOCDEFNPCGAPAC * (1 - positif(ART1731BIS*PREM8_11));
NPLOCCGASSV = LOCNPCGAV + LOCGITCV - LOCDEFNPCGAV;
NPLOCCGASSC = LOCNPCGAC + LOCGITCC - LOCDEFNPCGAC;
NPLOCCGASSPAC = LOCNPCGAPAC + LOCGITCP - LOCDEFNPCGAPAC;
NPLOCCGASV = arr(NPLOCCGAV * LOCNPCGAV / (LOCNPCGAV + LOCGITCV))* present(LOCNPCGAV) + min(0,NPLOCCGAV) * (1-present(LOCNPCGAV));
NPLOCCGASC = arr(NPLOCCGAC * LOCNPCGAC / (LOCNPCGAC + LOCGITCC))* present(LOCNPCGAC) + min(0,NPLOCCGAC) * (1-present(LOCNPCGAC));
NPLOCCGASP = arr(NPLOCCGAPAC * LOCNPCGAPAC / (LOCNPCGAPAC + LOCGITCP))* present(LOCNPCGAPAC) + min(0,NPLOCCGAPAC) * (1-present(LOCNPCGAPAC));
NPLOCCGANSV = NPLOCCGAV - NPLOCCGASV;
NPLOCCGANSC = NPLOCCGAC - NPLOCCGASC;
NPLOCCGANSP = NPLOCCGAPAC - NPLOCCGASP;
PLOCV = min(0,LOCPROV - (LOCDEFPROV * (1 - positif(ART1731BIS*PREM8_11) )))
				 * positif_ou_nul((LOCDEFPROV * (1 - positif(ART1731BIS*PREM8_11) )) - LOCPROV)
	       + arr(max(0, LOCPROV - (LOCDEFPROV * (1 - positif(ART1731BIS*PREM8_11) ))) * MAJREV) 
						       * positif(LOCPROV - (LOCDEFPROV * (1 - positif(ART1731BIS*PREM8_11) )));
PLOCC = min(0,LOCPROC - (LOCDEFPROC * (1 - positif(ART1731BIS*PREM8_11) ))) 
			  * positif_ou_nul((LOCDEFPROC * (1 - positif(ART1731BIS*PREM8_11) ))- LOCPROC) 
	       + arr(max(0, LOCPROC - (LOCDEFPROC * (1 - positif(ART1731BIS*PREM8_11) ))) * MAJREV) 
					  * positif(LOCPROC - (LOCDEFPROC * (1 - positif(ART1731BIS*PREM8_11) )));
PLOCPAC = min(0,LOCPROP - (LOCDEFPROP * (1 - positif(ART1731BIS*PREM8_11) ))) 
			      * positif_ou_nul((LOCDEFPROP * (1 - positif(ART1731BIS*PREM8_11) ))- LOCPROP) 
	       + arr(max(0, LOCPROP - (LOCDEFPROP * (1 - positif(ART1731BIS*PREM8_11) ))) * MAJREV) 
				   * positif(LOCPROP - (LOCDEFPROP * (1 - positif(ART1731BIS*PREM8_11) )));
VARLOCDEFNPV = min(LOCDEFNPV,max(LOCNPV+LOCGITHCV,max(LOCNPV_P+LOCGITHCV_P,LOCNPVP2+LOCGITHCVP2)));
VARLOCDEFNPC = min(LOCDEFNPC,max(LOCNPC+ LOCGITHCC,max(LOCNPC_P+LOCGITHCC_P,LOCNPCP2+LOCGITHCCP2)));
VARLOCDEFNPP = min(LOCDEFNPPAC,max(LOCNPPAC+LOCGITHCP,max(LOCNPP_P+LOCGITHCP_P,LOCNPPP2+LOCGITHCPP2)));
NPLOCV = min(0,LOCNPV + LOCGITHCV - LOCDEFNPV * (1 - positif(ART1731BIS*PREM8_11))) 
				       * positif_ou_nul(LOCDEFNPV * (1 - positif(ART1731BIS*PREM8_11))- LOCNPV- LOCGITHCV ) 
	       + arr(max(0, LOCNPV + LOCGITHCV - LOCDEFNPV * (1 - positif(ART1731BIS*PREM8_11))) * MAJREV) 
				 * positif(LOCNPV + LOCGITHCV - LOCDEFNPV * (1 - positif(ART1731BIS*PREM8_11)));

NPLOCC = min(0,LOCNPC + LOCGITHCC - LOCDEFNPC * (1 - positif(ART1731BIS*PREM8_11))) 
				       * positif_ou_nul(LOCDEFNPC * (1 - positif(ART1731BIS*PREM8_11))- LOCNPC- LOCGITHCC ) 
	       + arr(max(0, LOCNPC + LOCGITHCC - LOCDEFNPC * (1 - positif(ART1731BIS*PREM8_11))) * MAJREV) 
						 * positif(LOCNPC + LOCGITHCC - LOCDEFNPC * (1 - positif(ART1731BIS*PREM8_11)));

NPLOCPAC = min(0,LOCNPPAC + LOCGITHCP - LOCDEFNPPAC * (1 - positif(ART1731BIS*PREM8_11))) 
				       * positif_ou_nul( LOCDEFNPPAC * (1 - positif(ART1731BIS*PREM8_11))- LOCNPPAC- LOCGITHCP ) 
	       + arr(max(0, LOCNPPAC + LOCGITHCP - LOCDEFNPPAC * (1 - positif(ART1731BIS*PREM8_11))) * MAJREV) 
						 * positif(LOCNPPAC + LOCGITHCP - LOCDEFNPPAC * (1 - positif(ART1731BIS*PREM8_11)));
NPLOCSSV = min(0,LOCNPV + LOCGITHCV - LOCDEFNPV) 
				       * positif_ou_nul(LOCDEFNPV- LOCNPV- LOCGITHCV ) 
	       + arr(max(0, LOCNPV + LOCGITHCV - LOCDEFNPV) * MAJREV) 
				 * positif(LOCNPV + LOCGITHCV -LOCDEFNPC );

NPLOCSSC = min(0,LOCNPC + LOCGITHCC - LOCDEFNPC) 
				       * positif_ou_nul(LOCDEFNPC- LOCNPC- LOCGITHCC ) 
	       + arr(max(0, LOCNPC + LOCGITHCC - LOCDEFNPC) * MAJREV) 
						 * positif(LOCNPC + LOCGITHCC - LOCDEFNPC);

NPLOCSSPAC = min(0,LOCNPPAC + LOCGITHCP - LOCDEFNPPAC) 
				       * positif_ou_nul(LOCDEFNPPAC- LOCNPPAC- LOCGITHCP ) 
	       + arr(max(0, LOCNPPAC + LOCGITHCP - LOCDEFNPPAC) * MAJREV) 
						 * positif(LOCNPPAC + LOCGITHCP - LOCDEFNPPAC);
NPLOCSV = arr(NPLOCV * LOCNPV / (LOCNPV + LOCGITHCV))* positif(LOCNPV) + min(0,NPLOCV) * (1-positif(LOCNPV));
NPLOCSC = arr(NPLOCC * LOCNPC / (LOCNPC + LOCGITHCC))* present(LOCNPC) + min(0,NPLOCC) * (1-positif(LOCNPC));
NPLOCSP = arr(NPLOCPAC * LOCNPPAC / (LOCNPPAC + LOCGITHCP))* positif(LOCNPPAC) + min(0,NPLOCPAC) * (1-positif(LOCNPPAC));
NPLOCNSV = NPLOCV - NPLOCSV;
NPLOCNSC =  NPLOCC - NPLOCSC;
NPLOCNSP = NPLOCPAC - NPLOCSP;
regle 90010:
application : iliad , batch  ;                   
PLOCNETV = PLOCCGAV + PLOCV;
PLOCNETC = PLOCCGAC + PLOCC;
PLOCNETPAC = PLOCCGAPAC + PLOCPAC;
NPLOCNETTV = NPLOCCGAV + NPLOCV + MIB_NETNPVLV + MIB_NETNPPLV ;
NPLOCNETTC = NPLOCCGAC + NPLOCC + MIB_NETNPVLC + MIB_NETNPPLC ;
NPLOCNETTPAC = NPLOCCGAPAC + NPLOCPAC + MIB_NETNPVLP + MIB_NETNPPLP ;
NPLOCNETTSV = NPLOCCGASV + NPLOCSV + MIBNETNPVLSV + MIB_NETNPPLV ;
NPLOCNETTSC = NPLOCCGASC + NPLOCSC + MIBNETNPVLSC + MIB_NETNPPLC ;
NPLOCNETTSP = NPLOCCGASP + NPLOCSP + MIBNETNPVLSP + MIB_NETNPPLP ;
NPLOCNETV = NPLOCCGAV + NPLOCV ;
NPLOCNETC = NPLOCCGAC + NPLOCC ;
NPLOCNETPAC = NPLOCCGAPAC + NPLOCPAC ;
regle 90020:
application : iliad , batch  ;                   
PLOCNETF = PLOCNETV + PLOCNETC + PLOCNETPAC;
TOTDEFLOCNP = LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5
		+ LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1;
TOTDEFLOCNPBIS = null(4-V_IND_TRAIT) * (LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5+ LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1 ) * (1-positif(ART1731BIS*PREM8_11))
                + null(5-V_IND_TRAIT) * max(0,min(LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5+ LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1,
		TOTDEFLOCNP1731*ART1731BIS*(1-PREM8_11)+ (LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5+ LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1)*(1-positif(ART1731BIS*PREM8_11))));
TOTDEFLOCNPPS = LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5
	        + LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1;
NPLOCNETF10 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11)))
						      +(min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF9 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						      +(min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						      +(min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF8 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						      +(min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						      +(min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						      +(min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF7 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF6 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF5,LNPRODEF51731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF5 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF5 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
                                                  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF5,LNPRODEF51731+0) * positif(ART1731BIS*PREM8_11)  + LNPRODEF5 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF4,LNPRODEF41731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF4 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF4 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
                                                  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF5,LNPRODEF51731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF5 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF4,LNPRODEF41731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF4 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF3,LNPRODEF31731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF3 * (1 - positif(ART1731BIS*PREM8_11))));
NPLOCNETF3 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF5,LNPRODEF51731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF5 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF4,LNPRODEF41731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF4 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF3,LNPRODEF31731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF3 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF2,LNPRODEF21731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF2 * (1 - positif(ART1731BIS*PREM8_11))) );
NPLOCNETF2 = NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-((min(LNPRODEF10,LNPRODEF101731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF10 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF9,LNPRODEF91731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF9 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF8,LNPRODEF81731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF8 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF7,LNPRODEF71731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF7 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF6,LNPRODEF61731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF6 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF5,LNPRODEF51731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF5 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF4,LNPRODEF41731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF4 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF3,LNPRODEF31731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF3 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF2,LNPRODEF21731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF2 * (1 - positif(ART1731BIS*PREM8_11))) 
						  + (min(LNPRODEF1,LNPRODEF11731+0) * positif(ART1731BIS*PREM8_11) + LNPRODEF1 * (1 - positif(ART1731BIS*PREM8_11))));
regle 90020195:
application : iliad ,batch;               
NPLOCNETF = positif((1-positif(DEFRILOC))+PREM8_11) * max(0,NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC - DNPLOCIMPU)
         + positif(DEFRILOC)*(1-PREM8_11) *  max(0,NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC- DNPLOCIMPU+DEFLOCNPF);
NPLOCNETSF = max(0,NPLOCNETTSV + NPLOCNETTSC + NPLOCNETTSP-TOTDEFLOCNPBIS);
regle 90020197:
application : iliad ,batch;               
DNPLOCIMPU = (1-DEFRILOC) * (1-PREM8_11) * max(0,min(TOTDEFLOCNP,NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC))
	     + positif(DEFRILOC)*(1-PREM8_11) *
                      min(LNPRODEF10+LNPRODEF9+LNPRODEF8+LNPRODEF7+LNPRODEF6+LNPRODEF5+LNPRODEF4+LNPRODEF3+LNPRODEF2+LNPRODEF1,
                            max(DNPLOCIMPU1731,max(DNPLOCIMPU_P,DNPLOCIMPUP2)));

NPLOCNETFHDEFANT = max(0,NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC);
DEFNPLOCF = min(0,NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC-(TOTDEFLOCNPBIS-LNPRODEF10));
DEFNONPLOC = abs(DEFNPLOCF) ;
regle 90030:
application : iliad , batch  ;
DEFLOC2 = ((1-positif(NPLOCNETF2))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4-LNPRODEF3-LNPRODEF2,0)-LNPRODEF1,LNPRODEF1))
             * positif_ou_nul(LNPRODEF1-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4-LNPRODEF3-LNPRODEF2,0)))
                      * (1-positif(ART1731BIS)) 
                  + min(LNPRODEF1,TOTDEFLOCNP - DNPLOCIMPU) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF1 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC3 =((1- positif(NPLOCNETF3))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4-LNPRODEF3,0)-LNPRODEF2,LNPRODEF2))
             * positif_ou_nul(LNPRODEF2-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4-LNPRODEF3,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF2,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF2 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC4 =((1- positif(NPLOCNETF4))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4,0)-LNPRODEF3,LNPRODEF3))
             * positif_ou_nul(LNPRODEF3-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5-LNPRODEF4,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF3,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF3 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC5 = ((1- positif(NPLOCNETF5))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6 -LNPRODEF5,0)-LNPRODEF4,LNPRODEF4))
             * positif_ou_nul(LNPRODEF4-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6-LNPRODEF5,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF4,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF4 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC6 = ((1- positif(NPLOCNETF6))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6,0)-LNPRODEF5,LNPRODEF5))
             * positif_ou_nul(LNPRODEF5-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7-LNPRODEF6,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF5,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4-DEFLOC5) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF5 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC7 = ((1- positif(NPLOCNETF7))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7,0)-LNPRODEF6,LNPRODEF6))
             * positif_ou_nul(LNPRODEF6-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8-LNPRODEF7,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF6,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4-DEFLOC5-DEFLOC6) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF6 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC8 = ((1- positif(NPLOCNETF8))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8,0)-LNPRODEF7,LNPRODEF7))
             * positif_ou_nul(LNPRODEF7-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9-LNPRODEF8,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF7,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4-DEFLOC5-DEFLOC6-DEFLOC7) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF7 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC9 = ((1- positif(NPLOCNETF9))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9,0)-LNPRODEF8,LNPRODEF8))
             * positif_ou_nul(LNPRODEF8-max(NPLOCNETFHDEFANT-LNPRODEF10-LNPRODEF9,0)))
                      * (1-positif(ART1731BIS))
                  + min(LNPRODEF8,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4-DEFLOC5-DEFLOC6-DEFLOC7-DEFLOC8) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF8 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
DEFLOC10 = ((1- positif(NPLOCNETF10))
             * abs(min(max(NPLOCNETFHDEFANT-LNPRODEF10,0)-LNPRODEF9,LNPRODEF9))
             * positif_ou_nul(LNPRODEF9-max(NPLOCNETFHDEFANT-LNPRODEF10,0)))
                      * (1-positif(ART1731BIS)) 
                  + min(LNPRODEF9,TOTDEFLOCNP - DNPLOCIMPU - DEFLOC2-DEFLOC3-DEFLOC4-DEFLOC5-DEFLOC6-DEFLOC7-DEFLOC8-DEFLOC9) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + LNPRODEF9 * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
regle 900305:
application : iliad , batch  ;
DEFNPLOCFAV = max(0,abs(DEFNPLOCF) - DEFLOC2 - DEFLOC3 - DEFLOC4 - DEFLOC5 - DEFLOC6 - DEFLOC7 - DEFLOC8 - DEFLOC9 - DEFLOC10);
regle 900307:
application : iliad , batch  ;

DEFLOC1 = (positif(DEFNONPLOC) * DEFNPLOCFAV) * (1-positif(ART1731BIS)) 
                           + (
                   DEFLOCNPF * positif(ART1731BIS*(1-PREM8_11)))
                 + (LOCDEFNPCGAV + LOCDEFNPV + LOCDEFNPCGAC + LOCDEFNPC +LOCDEFNPCGAPAC + LOCDEFNPPAC) * ART1731BIS* positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ));
VAREDEFLOCNP = min(TOTDEFLOCNP, NPLOCNETTV+NPLOCNETTC+NPLOCNETTPAC);
regle 900309:
application : iliad , batch  ;
DFBICNPF = (somme(i=V,C,P:BICNPi)+MIB_NETNPCT + DEFNPI+BICDEV+BICDEC+BICDEP+BICHDEV+BICHDEC+BICHDEP);
DEFBICNPF = DEFRIBIC * (1-PREM8_11) * max(0,min(BICDEV+BICDEC+BICDEP+BICHDEV+BICHDEC+BICHDEP,-(max(DFBICNPF1731,max(DFBICNPF_P,DFBICNPFP2))-BICDEV-BICDEC-BICDEP-BICHDEV-BICHDEC-BICHDEP)));
regle 9003095:
application : iliad , batch  ;
DEFLOCNP = (NPLOCNETTV + NPLOCNETTC + NPLOCNETTPAC - DNPLOCIMPU +LOCDEFNPV +LOCDEFNPC +LOCDEFNPPAC +LOCDEFNPCGAV+LOCDEFNPCGAC+LOCDEFNPCGAPAC);
DEFLOCNPF = (DEFRILOC+0) * (1-PREM8_11) * max(0,min(LOCDEFNPV +LOCDEFNPC +LOCDEFNPPAC +LOCDEFNPCGAV+LOCDEFNPCGAC+LOCDEFNPCGAPAC,
                                               -(max(DEFLOCNP1731,max(DEFLOCNP_P,DEFLOCNPP2))-LOCDEFNPV -LOCDEFNPC -LOCDEFNPPAC -LOCDEFNPCGAV-LOCDEFNPCGAC-LOCDEFNPCGAPAC)));
