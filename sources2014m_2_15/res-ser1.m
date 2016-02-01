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
 #####   ######   ####    #####     #     #####   ########
 #    #  #       #          #       #       #     #      #
 #    #  #####    ####      #       #       #      #    #
 #####   #            #     #       #       #       ####
 #   #   #       #    #     #       #       #      #    #
 #    #  ######   ####      #       #       #     ########
 #
 #
 #
 #
 #                 RES-SER1.m
 #                 ===========
 #
 #
 #                      zones restituees par l'application
 #
 #
 #
 #
 #
 #
regle 9500:
application :  iliad , bareme ,batch;
MCDV = 1 * positif(V_0AM + 0)
     + 2 * positif(V_0AC + 0)
     + 3 * positif(V_0AD + 0)
     + 4 * positif(V_0AV + 0)
     + 5 * positif(V_0AO + 0);
SFM = si  ( BOOL_0AM=1 ) 
          alors ( si (V_0AP+0=1)
                  alors ( si (V_0AF+0=1)
                          alors (1)
                          sinon (2)
                          finsi)
                  sinon ( si (V_0AF+0=1) 
                          alors (3)
                          sinon ( si ( V_0AS+0=1 et
                          (AGV >= LIM_AGE_LET_S ou AGC >= LIM_AGE_LET_S)
                                      )
                                  alors (4)
                                  finsi)
                          finsi)
                  finsi)
       finsi;
regle 9501:
application : batch , iliad, bareme ;

BOOL_V = positif(V_0AV+0) * positif(1 - BOOL_0AZ) 
			  * ((1 - positif(PAC + V_0CH + 0))
			     + positif(PAC + V_0CH + 0) * (3 - null(EAC + V_0CH + 0))) ;
BOOL_CDV = positif( BOOL_V + V_0AC + V_0AD + 0);
BOOL_PACSFL = 1 - positif( PAC +V_0CH + 0);
BOOL_W = positif(V_0AW + 0) * positif_ou_nul( AGV - LIM_AGE_LET_S );
SFCD1 = ( 15 * positif(V_0AN + 0) * (1 - positif(V_0AP + 0)) * (1 - positif(V_0AG + 0)) * (1 - BOOL_W)         
 
       + 2 * positif(V_0AP + 0) * (1-positif(V_0AL+0))          


       + 14 * positif(V_0AG + 0) * (1 - positif(V_0AP + 0)) * (1 - BOOL_W)                   

       + 7 * BOOL_W * (1 - positif(V_0AP + 0)))
       
       * (1-positif(V_0AL+0)) * BOOL_CDV * BOOL_PACSFL;

regle 9507:
application : batch , iliad ,  bareme ;
SFL = positif (V_0AL + 0) * BOOL_CDV * BOOL_PACSFL *

      ( 2 * positif(V_0AP + 0) 

      + 9 * ( 1 - BOOL_W ) * positif( 1- V_0AP + 0) * positif(1-(V_0AG + 0)) * positif (1-(V_0AN+0))  

      + 7 * BOOL_W * positif(1-(V_0AP + 0)) 

      + 15 * positif (V_0AN +0) * ( 1 - BOOL_W ) * positif(1-(V_0AG + 0)) * positif(1-(V_0AP + 0)) 

      + 14 * positif (V_0AG +0) * ( 1 - BOOL_W ) * positif(1-(V_0AP + 0))) ;
regle 9502:
application : batch , iliad , bareme ;



SFCD2 = positif(PAC+V_0CH) * positif(V_0AC + V_0AD + null(2- BOOL_V)) *
	(
		positif(V_0AP+0) * ( 10 * positif(V_0BT+0) * (1-positif(V_0AV))
 			            + 2 * positif(V_0AV)
                                    + 2 * (1 - positif(V_0AV)) *(1 - positif(V_0BT+0)))
          + (1-positif(V_0AP+0)) * ( 11 * positif(V_0BT+0)) * (1-positif(V_0AV+0))
	);
regle 9503:
application : batch , iliad , bareme ;

SFV1 = 2 * positif(V_0AP + 0) * null(BOOL_V - 3) ;

regle 9504:
application : batch , iliad ,  bareme ;
SFV2 = si ( V_0AV+0=1 et BOOL_0AZ =1)
       alors (si (V_0AP+0=1)
              alors (si (V_0AF+0=1)
                     alors (1)
                     sinon (2)
                     finsi)
              sinon (si (V_0AF+0=1)
                     alors (3)
                     sinon (si (V_0AW+0=1)
                            alors (7)
                            finsi)
                     finsi)  
              finsi)
        finsi;
regle 9505:
application : batch , iliad , bareme ;

BOOL_0AM = positif(positif(V_0AM + 0) + positif(V_0AO + 0)) ;

regle 9506:
application : batch , iliad , bareme ;
SFUTILE = SFM + SFCD1 + SFCD2 + SFV1 + SFV2 + SFL ;
regle 9510:
application : batch , iliad ;
NATPENA = si ((APPLI_COLBERT+APPLI_ILIAD+APPLI_COLBERT=1) et  
	     (CMAJ =7 ou CMAJ =8 ou CMAJ=9 ou CMAJ=10 ou CMAJ=11 ou CMAJ=12 ou CMAJ=17 ou CMAJ=18 ))
          alors (1)
          sinon ( si ( CMAJ = 2 )
                  alors (2)
                  sinon ( si ( CMAJ=3 ou CMAJ=4 ou CMAJ=5 ou CMAJ=6 ) 
                          alors (4)
                          finsi
                        )
                  finsi
                 )
           finsi;
regle 901:
application : iliad ;
TSALV = TSBNV;
TSALC = TSBNC;
regle 902:
application : iliad , batch  ;
TSALP = TSBN1 + TSBN2 + TSBN3 + TSBN4;
regle 903 :
application : iliad , batch  ;
pour i = V,C,1..4:
F10Ai = si (IND_10i = 0 ou
       (IND_10i = 1 et IND_10MIN_0i = 0))
        alors (max(FRDAi,DFNi))
       finsi;
regle 90301 :
application :  iliad , batch  ;
F10AP = somme(i=1..4:F10Ai);  
regle 90302 :
application : iliad , batch  ;
pour i = V,C,1..4:
F10Bi = si (IND_10i = 1 et IND_10MIN_0i = 1)
        alors (10MINSi)
       finsi;
regle 90303 :
application : iliad , batch  ;
F10BP = somme(i=1..4:F10Bi);
regle 904 :
application : iliad , batch  ;
pour i = V,C,1,2,3,4:
DEDSi =  (10MINSi - DFNi) * (1-positif(F10Bi)) * IND_10i ;
regle 90401 :
application :  iliad , batch  ;
DEDSP = somme( i=1..4: DEDSi ) ;
regle 905 :
application : iliad , batch ;
PRV = PRBRV;
PRC = PRBRC;
PRP = PRBR1 + PRBR2 + PRBR3 + PRBR4 ;
PRZV = PENINV;
PRZC = PENINC;
PRZP = PENIN1 + PENIN2 + PENIN3 + PENIN4 ;
PALIP = PALI1 + PALI2 + PALI3 + PALI4;
regle 906 :
application : iliad , batch  ;
pour i = V,C:
AB10i = APRi;
AB10P = APR1 + APR2 + APR3 + APR4 ;
regle 909:
application : iliad , batch ;
TSPRT =  (TSNNV + PRRV
        + TSNNC + PRRC
        + TSNN1 + PRR1
        + TSNN2 + PRR2
        + TSNN3 + PRR3
        + TSNN4 + PRR4);
regle 9011 :
application : iliad , batch ;
pour i = V,C,P:
RBAi = BAHREi + 4BAHREi
     + BACREi + 4BACREi
     + BAFORESTi
     + BAFi + BAFPVi- BACDEi - BAHDEi;
regle 9013 :
application : iliad , batch ;
pour i= V,C,P:
BIPi =
   BICNOi  
 - BICDNi
 + BIHNOi  
 - BIHDNi
  ; 

pour i= V,C,P:                                           
BIPNi = BIPTAi + BIHTAi ;                        
BIPN  = BIPNV + BIPNC + BIPNP ;                          
                                                         

pour i= V,C,P:                                           
MIBRi = MIBVENi + MIBPRESi ;
MIBR = somme(i=V,P,C: MIBRi);
pour i= V,C,P:                                           
MLOCDECi = MIBGITEi + LOCGITi + MIBMEUi ;
pour i= V,C,P:                                           
MIBRABi = MIB_ABVi + MIB_ABPi ;
pour i= V,C,P:                                           
MLOCABi = MIB_ABNPVLi + MIB_ABNPPLi ;
pour i= V,C,P:                                           
MIBRNETi = max (0,MIBRi - MIBRABi );
MIBRNET = somme(i=V,C,P:MIBRNETi);
pour i= V,C,P:                                           
MLOCNETi = max (0,MLOCDECi - MLOCABi );
MLOCNET = somme(i=V,C,P:MLOCNETi);
pour i= V,C,P:                                           
MIBNPRi = MIBNPVENi + MIBNPPRESi ;
pour i= V,C,P:                                           
MIBNPRABi = MIB_ABNPVi + MIB_ABNPPi ;
pour i= V,C,P:                                           
MIBNPRNETi = max (0,MIBNPRi - MIBNPRABi );
regle 9014 :
application : iliad , batch  ;

pour i=V,C,P:
BINi = 
   BICREi  
 - BICDEi 
 + BICHREi  
 - BICHDEi
 ;  

regle 90141 :
application : iliad , batch  ;

pour i=V,C,P:
BINNi= BINTAi + BINHTAi;
regle 9015 :
application : iliad , batch  ;
BNCV = BNHREV + BNCREV - BNHDEV - BNCDEV;
BNCC = BNHREC + BNCREC - BNHDEC - BNCDEC;
BNCP = BNHREP + BNCREP - BNHDEP - BNCDEP;
BNCAFFV = positif(present(BNHREV) + present(BNCREV) + present(BNHDEV) + present(BNCDEV));
BNCAFFC = positif(present(BNHREC) + present(BNCREC) + present(BNHDEC) + present(BNCDEC));
BNCAFFP = positif(present(BNHREP) + present(BNCREP) + present(BNHDEP) + present(BNCDEP));
regle 9016 :
application : iliad , batch  ;
DIDABNCNP1 = min(NOCEPIMP+SPENETNPF, DABNCNP1+DABNCNP2+DABNCNP3+DABNCNP4+DABNCNP5+DABNCNP6);
DIDABNCNP =  min(DABNCNP1+DABNCNP2+DABNCNP3+DABNCNP4+DABNCNP5+DABNCNP6,max(DIDABNCNP11731,max(DIDABNCNP1_P,DIDABNCNP1P2))) * positif(DEFRIBNC)*(1-PREM8_11)
             + max(0,min(NOCEPIMP+SPENETNPF, DABNCNP1+DABNCNP2+DABNCNP3+DABNCNP4+DABNCNP5+DABNCNP6)) * (1-positif(DEFRIBNC))
             + 0 * PREM8_11;
regle 90249 :
application : iliad , batch ;

BNCIF = (1-positif(ART1731BIS)) *  max (0,NOCEPIMP+SPENETNPF-DABNCNP6 -DABNCNP5 -DABNCNP4 -DABNCNP3 -DABNCNP2 -DABNCNP1) 
        + positif(ART1731BIS) * ((1-positif(DEFRIBNC)*(1-PREM8_11)) * max (0,NOCEPIMP+SPENETNPF-DIDABNCNP)
                                  + positif(DEFRIBNC)*(1-PREM8_11) * max (0,NOCEPIMP+SPENETNPF-DIDABNCNP+DEFBNCNP)
                                )
          ;
regle 9024 :
application : iliad , batch ;
BRCM = RCMABD + RCMTNC + RCMAV + RCMHAD + RCMHAB + REGPRIV;
regle 90240 :
application : iliad , batch ;
BRCMQ = REVACT + REVPEA + PROVIE + DISQUO + RESTUC + INTERE;
BRCMTOT = RCMAB + RTNC + RAVC + RCMNAB + RTCAR + RCMPRIVM;
regle 90241 :
application : iliad , batch  ;
RRCM = max(0,RCM);
regle 9026 :
application : iliad , batch  ;
B1FIS = max( RCM+2RCM+3RCM+4RCM+5RCM+6RCM+7RCM , 0 );
regle 9028 :
application : iliad , batch  ;
DRFRP = ((1-positif(IPVLOC)) * (abs (DFCE+DFCG) * (1-positif(RFMIC))
             + positif(RFMIC) *  abs(min(0,RFMIC - MICFR - RFDANT)) ))
             * (1-positif(ART1731BIS))
             + ART1731BIS * DEFRFNONI;
regle 9030 :
application :  iliad , batch  ;


DLMRN1TXM = - min(0,MIB_NETCT *(1-positif(MIBNETPTOT))
                          +SPENETCT * (1 - positif(SPENETPF)));
DLMRN1 = ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)) * abs(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                 + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                 * positif_ou_nul(DEFBIC5+DEFBIC4+DEFBIC3+DEFBIC2+DEFBIC1-(somme(i=V,C,P:BICNPi)+MIB_NETNPCT))
                 * (DEFBIC5+DEFBIC4+DEFBIC3+DEFBIC2+DEFBIC1-(somme(i=V,C,P:BICNPi)+MIB_NETNPCT))
                 * null(DLMRN6+DLMRN5+DLMRN4+DLMRN3+DLMRN2))
		 * (1-positif(ART1731BIS))
		 + (
                   DEFBICNPF * positif(ART1731BIS*(1-PREM8_11)))
                 + (BICHDEV+BICHDEC+BICHDEP+BICDEV+BICDEC+BICDEP) * positif(ART1731BIS*PREM8_11);
regle 903092 :
application :  iliad , batch  ;
DLMRN2 = positif(DEFBIC1) * (
                 ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT))* DEFBIC1
                 + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                 * min(max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4-DEFBIC3-DEFBIC2,0)-DEFBIC1,DEFBIC1)*(-1)
                 * positif_ou_nul(DEFBIC1-max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4-DEFBIC3-DEFBIC2,0)))
		 * (1-positif(ART1731BIS))
                  + min(DEFBIC1,DEFNP - DEFNPI) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFBIC1 * positif(ART1731BIS*PREM8_11));
regle 903093 :
application :  iliad , batch  ;
DLMRN3 = positif(DEFBIC2) * (
                  ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT))* DEFBIC2
                  + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
* min(max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4-DEFBIC3,0)-DEFBIC2,DEFBIC2)*(-1)
                  * positif_ou_nul(DEFBIC2-max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4-DEFBIC3,0)))
		 * (1-positif(ART1731BIS))
                  + min(DEFBIC2,DEFNP - DEFNPI-DLMRN2) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFBIC2 * positif(ART1731BIS*PREM8_11));
regle 903094 :
application :  iliad , batch  ;
DLMRN4 = positif(DEFBIC3) * (
                  ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT))  * DEFBIC3
                  + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                  * min(max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4,0)-DEFBIC3,DEFBIC3)*(-1)
                  * positif_ou_nul(DEFBIC3-max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5-DEFBIC4,0)))
		 * (1-positif(ART1731BIS))
                  + min(DEFBIC3,DEFNP - DEFNPI-DLMRN2-DLMRN3) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFBIC3 * positif(ART1731BIS*PREM8_11));
regle 903095 :
application :  iliad , batch  ;
DLMRN5 = positif(DEFBIC4) * (
                  ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)) * DEFBIC4
                  + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                  * min(max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5,0)-DEFBIC4,DEFBIC4)*(-1)
                  * positif_ou_nul(DEFBIC4-max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6-DEFBIC5,0)))
		 * (1-positif(ART1731BIS))
                  + min(DEFBIC4,DEFNP - DEFNPI-DLMRN2-DLMRN3-DLMRN4) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFBIC4 * positif(ART1731BIS*PREM8_11));
regle 903096 :
application :  iliad , batch  ;
DLMRN6 =  positif(DEFBIC5) * (
                  ((1-positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)) * DEFBIC5
                  + positif_ou_nul(somme(i=V,C,P:BICNPi)+MIB_NETNPCT)
                  * min(max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6,0)-DEFBIC5,DEFBIC5)*(-1)
                  * positif_ou_nul(DEFBIC5-max(somme(i=V,C,P:BICNPi)+MIB_NETNPCT-DEFBIC6,0)))
		 * (1-positif(ART1731BIS))
                  + min(DEFBIC5,DEFNP - DEFNPI-DLMRN2-DLMRN3-DLMRN4-DLMRN5) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFBIC5 * positif(ART1731BIS*PREM8_11));
regle 903097 :
application :  iliad , batch  ;
DLMRN = max(0, DEFNP - BICNPV*positif(BICNPV)-BICNPC*positif(BICNPC)-BICNPP*positif(BICNPP)
                     + abs(BICNPV)*(1-positif(BICNPV))*null(DLMRN1)
                     + abs(BICNPC)*(1-positif(BICNPC))*null(DLMRN1)
                     + abs(BICNPP)*(1-positif(BICNPP))*null(DLMRN1)) + DLMRN1;
TOTDLMRN = somme(i=1..6:DLMRNi);
DLMRNTXM = max(0,DEFNP - BICNPV*positif(BICNPV)-BICNPC*positif(BICNPC)-BICNPP*positif(BICNPP)
         +MIB_NETCT+MIB_NETNPCT+SPENETCT+SPENETNPCT + DLMRN1 
               );
regle 90305: 
application :  iliad , batch  ;
DRCVM = DPVRCM ;
regle 9031 :
application : iliad , batch  ;
BALNP = max(0,NOCEPIMP);
NOCEP =           ANOCEP - ((min(DNOCEP,DNOCEP1731+0) * positif(ART1731BIS) + DNOCEP * (1 - positif(ART1731BIS*PREM8_11))) 
			 +(min(DABNCNP6,DABNCNP61731+0) * positif(ART1731BIS) + DABNCNP6 * (1 - positif(ART1731BIS*PREM8_11)))
			 +(min(DABNCNP5,DABNCNP51731+0) * positif(ART1731BIS) + DABNCNP5 * (1 - positif(ART1731BIS*PREM8_11)))
                         +(min(DABNCNP4,DABNCNP41731+0) * positif(ART1731BIS) + DABNCNP4 * (1 - positif(ART1731BIS*PREM8_11)))
                         +(min(DABNCNP3,DABNCNP31731+0) * positif(ART1731BIS) + DABNCNP3 * (1 - positif(ART1731BIS*PREM8_11)))
                         +(min(DABNCNP2,DABNCNP21731+0) * positif(ART1731BIS) + DABNCNP2 * (1 - positif(ART1731BIS*PREM8_11)))
                         +(min(DABNCNP1,DABNCNP11731+0) * positif(ART1731BIS) + DABNCNP1 * (1 - positif(ART1731BIS*PREM8_11))));
regle 9032 :
application : iliad , batch  ;
DALNP = (1-positif(IPVLOC)) * (BNCDF1+BNCDF2+BNCDF3+BNCDF4+BNCDF5+BNCDF6);
regle 9033 :
application :  iliad , batch  ;
DESV =  REPSOF;
regle 9042 :
application : batch, iliad  ;
VLHAB = max ( 0 , IPVLOC ) ;
regle 9043 :
application : iliad , batch  ;
DFANT = (DEFAA5 + DEFAA4 + DEFAA3 + DEFAA2 + DEFAA1 + DEFAA0) * (1 - positif(ART1731BIS*PREM8_11) ) * (1 - positif(IPVLOC));
DFANTPROV = min(0,(RG - DAR ) *(1-positif(RE168+TAX1649)) + positif(RE168+TAX1649) * (RE168+TAX1649)) + SOMDEFICIT;
DFANTIMPU = (1 - positif(IPVLOC)) * (
                        (DEFAA5 + DEFAA4 + DEFAA3 + DEFAA2 + DEFAA1 + DEFAA0) * (1 - positif(ART1731BIS)) 
                        +  max(0,min(SOMDEFICIT,-max(DFANTPROV1731,max(DFANTPROV_P,DFANTPROVP2))+SOMDEFICIT))
                                     * positif(DEFRIGLOBINF+DEFRIGLOBSUP) * (1-PREM8_11));
DAR_REP =  somme (i=0..4:DEFAAi ) * (1 - positif(IPVLOC));
regle 9044 :
application : iliad , batch  ;
RRBG = ((RG - DAR ) *(1-positif(RE168+TAX1649)) + positif(RE168+TAX1649) * (RE168+TAX1649)) * (1-ART1731BIS)
        + ((RG - (DAR - DFANTIMPU)) *(1-positif(RE168+TAX1649)) + positif(RE168+TAX1649) * (RE168+TAX1649)) * ART1731BIS;
RRRBG = max(0 , RRBG);
DRBG = min(0 , RRBG);
regle 9045 :
application : iliad , batch  ;

DDCSG = (V_BTCSGDED * (1-present(DCSG)) + DCSG) * (1-null(4 -V_REGCO)) 
        + positif(RCMSOC+0) * (1 - positif(null(2-V_REGCO)+null(4-V_REGCO)))
                            * (1 - positif(present(RE168)+present(TAX1649)))
          * arr( min( RCMSOC , RCMABD + REVACT + RCMAV + PROVIE + RCMHAD + DISQUO + RCMHAB + INTERE ) 
                    * TX051/100) ; 

RDCSG = max (min(DDCSG , RBG + TOTALQUO - SDD) , 0);
regle 9047 :
application : iliad , batch  ;
DPALE =  somme(i=1..4:CHENFi+NCHENFi);
RPALE = max(0,min(somme(i=1..4:min(NCHENFi,LIM_PENSALENF)+min(arr(CHENFi*MAJREV),LIM_PENSALENF)),
                RBG-DDCSG+TOTALQUO-SDD)) *(1-V_CNR);
regle 9049 :
application : iliad , batch  ;
DNETU = somme(i=1..4: CHENFi);
RNETU = max(0,min(somme(i=1..4:min(CHENFi,LIM_PENSALENF)),
                RBG+TOTALQUO-SDD-RPALE)) *(1-V_CNR);
regle 9050 :
application : iliad , batch  ;
DPREC = CHNFAC;
regle 9051 :
application : iliad , batch  ;
DFACC = CHRFAC;
RFACC = max( min(DFA,RBG - RPALE - RPALP  - DDCSG + TOTALQUO - SDD) , 0);
regle 9052 :
application : iliad ;
TRANSFERT = R1649+PREREV+RE168+TAX1649;
regle 9054 :
application : iliad , batch  ;
RPALP = max( min(TOTPA,RBG - RPALE - DDCSG + TOTALQUO - SDD) , 0 ) * (1 -V_CNR);
DPALP = PAAV + PAAP ;
regle 9055 :
application : iliad , batch  ;
DEDIV = (1-positif(RE168+TAX1649))*CHRDED;
RDDIV = max( min(DEDIV * (1 - V_CNR),RBG - RPALE - RPALP - RFACC - DDCSG + TOTALQUO - SDD ) , 0 );

regle 90551 :
application : iliad , batch  ;

NUPROPT = REPGROREP2 + REPGROREP1 + REPGROREP11 + REPGROREP12 + REPGROREP13 + NUPROP ;

NUREPAR = min(NUPROPT , max(0,min(PLAF_NUREPAR, RRBG - RPALE - RPALP - RFACC - RDDIV - APERPV - APERPC - APERPP - DDCSG + TOTALQUO - SDD))) 
	  * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPNUREPART = max( NUPROPT - NUREPAR , 0 ) ;
 
REPAR5 = max( REPGROREP2 - NUREPAR , 0 ) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPAR4 = ( positif_ou_nul(REPGROREP2 - NUREPAR) * REPGROREP1
	 + (1-positif_ou_nul(REPGROREP2 - NUREPAR)) * max(REPGROREP1 + REPGROREP2 - NUREPAR , 0 )) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPAR3 = ( positif_ou_nul(REPGROREP1 + REPGROREP2 - NUREPAR) * REPGROREP11
	 + (1-positif_ou_nul(REPGROREP1 + REPGROREP2 - NUREPAR)) * max( REPGROREP11 + REPGROREP1 + REPGROREP2 - NUREPAR , 0 )) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPAR2 = ( positif_ou_nul(REPGROREP1 + REPGROREP2 + REPGROREP11 - NUREPAR) * REPGROREP12
	 + (1-positif_ou_nul(REPGROREP1 + REPGROREP2 + REPGROREP11 - NUREPAR)) * max( REPGROREP12 + REPGROREP11 + REPGROREP1 + REPGROREP2 - NUREPAR , 0 )) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPAR1 = ( positif_ou_nul(REPGROREP1 + REPGROREP2 + REPGROREP11 + REPGROREP12 - NUREPAR) * REPGROREP13
	 + (1-positif_ou_nul(REPGROREP1 + REPGROREP2 + REPGROREP11 + REPGROREP12 - NUREPAR)) 
                                                                               * max( REPGROREP13 + REPGROREP12 + REPGROREP11 + REPGROREP1 + REPGROREP2 - NUREPAR , 0 )) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPAR = max( REPNUREPART - REPAR5 - REPAR4 - REPAR3 - REPAR2 - REPAR1, 0 ) * ((V_REGCO+0) dans (1,3,5,6,7)) ;

REPNUREPAR =  REPAR5 + REPAR4 + REPAR3 + REPAR2 + REPAR1 + REPAR ;

regle 9059 :
application : iliad , batch  ;
CHTOT = max( 0 , 
   min( DPA + DFA + (1-positif(RE168+TAX1649))*CHRDED + APERPV + APERPC + APERPP + NUREPAR , RBG
       - DDCSG + TOTALQUO - SDD) 
           )  * (1-V_CNR);
regle 9060 :
application : iliad , batch  ;
ABMAR = min(ABTMA,  max(RNG + TOTALQUO - SDD - SDC - ABTPA , 0));
regle 9061 :
application : iliad , batch  ;
ABVIE = min(ABTPA,max(RNG+TOTALQUO-SDD-SDC,0));
regle 9062 :
application : iliad , batch  ;
RNI =   (1-ART1731BIS) * (positif(RG+R1649+PREREV) * arr(RI1) * (1-positif(RE168+TAX1649)) + (RE168+TAX1649) * positif(RE168+TAX1649))
        + ART1731BIS * (positif(RG+R1649+PREREV+SOMDEFICIT) * arr(RI1) * (1-positif(RE168+TAX1649)) + (RE168+TAX1649) * positif(RE168+TAX1649));
regle 9063 :
application :  iliad , batch  ;
TOTALQUORET = min(TOTALQUO,max(TOTALQUO1731,max(TOTALQUO_P,TOTALQUOP2)));
RNIDF = (1 - positif_ou_nul( RG-DAR+TOTALQUO )) 
         * (
         (1 - positif_ou_nul(RG + TOTALQUO)) *
          (((RG + TOTALQUO) * (-1)) + DAR_REP)
         + null(RG+TOTALQUO) * (DAR_REP)
         + positif(RG + TOTALQUO) *
           (positif(RG + TOTALQUO - DEFAA5) * (RG + TOTALQUO - DAR )
	   + (1 -positif(RG + TOTALQUO - DEFAA5)) * DAR_REP)
           ) * (1-positif(ART1731BIS))
        + max(0,FRNV-FRDV+FRNC-FRDC+FRN1-FRD1+FRN2-FRD2+FRN3-FRD3+FRN4-FRD4+SOMDEFICITHTS-DEFAA5
                - (BACDEV + BAHDEV + BACDEC + BAHDEC + BACDEP + BAHDEP ) * (1-positif(SEUIL_IMPDEFBA + 1 - SHBA - (REVTP-BA1) -(
                                somme(i=1..3 : GLNi) +max(0,4BAQV+4BAQC+4BAQP + BAHQTOTMIN + BAHQTOTMAXN) +GLN4V + GLN4C+ somme (i=V,C,1..4: PENALIMi)+
                                somme(i=V,C,1..4: PENFi)+somme (i=V,C,1..4:TSNN2TSi)+somme (i=V,C,1..4:TSNN2REMPi)
                               +somme (i=V,C,1..4:PRR2i)+T2RV+2RCM + 3RCM + 4RCM + 5RCM + 6RCM + 7RCM+2REVF+3REVF )))) * positif(ART1731BIS) * PREM8_11
        + ( positif(DFANTIMPU - DFANT) * max(0,DFANTIMPU - TOTALQUORET - DEFAA5)
         + (1-positif(DFANTIMPU - DFANT)) * max(0,DFANTIMPU-TOTALQUORET- max(0,DEFAA5+DFANTIMPU-TOTALQUORET-DFANT))
           ) * positif(ART1731BIS)  * (1-PREM8_11)
           ;

RNIDF1 = (((1-positif_ou_nul(RG + TOTALQUO)) * DEFAA0
        + positif_ou_nul(RG + TOTALQUO) * 
        min(max(RG+TOTALQUO-DEFAA5 -DEFAA4 -DEFAA3 -DEFAA2 -DEFAA1,0) -DEFAA0, DEFAA0)*(-1)
     * positif_ou_nul(DEFAA0 -max(RG+TOTALQUO-DEFAA5 -DEFAA4 -DEFAA3 -DEFAA2 -DEFAA1,0)))
          * (1-positif(ART1731BIS))
                  + min(DEFAA0,RNIDF) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFAA0 * positif(ART1731BIS*PREM8_11));

RNIDF2 = (((1 - positif_ou_nul(RG + TOTALQUO)) * (DEFAA1)
        + positif_ou_nul(RG + TOTALQUO) *
        min(max(RG+TOTALQUO-DEFAA5-DEFAA4-DEFAA3-DEFAA2,0)-DEFAA1,DEFAA1)*(-1)
        * positif_ou_nul(DEFAA1-max(RG+TOTALQUO-DEFAA5-DEFAA4-DEFAA3-DEFAA2,0)))
          * (1-positif(ART1731BIS))
                  + min(DEFAA1,RNIDF - RNIDF1) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFAA1 * positif(ART1731BIS*PREM8_11));

RNIDF3 = (((1 - positif_ou_nul(RG + TOTALQUO)) * (DEFAA2)
        + positif_ou_nul(RG + TOTALQUO) * 
        min(max(RG+TOTALQUO-DEFAA5 -DEFAA4 -DEFAA3,0) -DEFAA2, DEFAA2)*(-1)
     * positif_ou_nul(DEFAA2 -max(RG+TOTALQUO-DEFAA5 -DEFAA4 -DEFAA3,0)))
          * (1-positif(ART1731BIS))
                  + min(DEFAA2,RNIDF - RNIDF1 - RNIDF2) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFAA2 * positif(ART1731BIS*PREM8_11));

RNIDF4 = (((1 - positif_ou_nul(RG + TOTALQUO)) * (DEFAA3)
        + positif_ou_nul(RG + TOTALQUO) * 
        min(max(RG+TOTALQUO-DEFAA5 -DEFAA4,0) -DEFAA3, DEFAA3)*(-1)
     * positif_ou_nul(DEFAA3 -max(RG+TOTALQUO-DEFAA5 -DEFAA4,0)))
          * (1-positif(ART1731BIS))
                  + min(DEFAA3,RNIDF - RNIDF1 - RNIDF2 - RNIDF3) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFAA3 * positif(ART1731BIS*PREM8_11));

RNIDF5 = (((1 - positif_ou_nul(RG + TOTALQUO)) * (DEFAA4)
        + positif_ou_nul(RG + TOTALQUO) * 
        min(max(RG+TOTALQUO-DEFAA5,0) -DEFAA4, DEFAA4)*(-1) * positif_ou_nul(DEFAA4 -max(RG+TOTALQUO-DEFAA5,0)))
          * (1-positif(ART1731BIS))
                  + min(DEFAA4,RNIDF - RNIDF1 - RNIDF2 - RNIDF3 - RNIDF4) * positif(ART1731BIS*(1-PREM8_11))
                  + DEFAA4 * positif(ART1731BIS*PREM8_11));
RNIDF0 = ((1-positif(RG + TOTALQUO)) * (RG + TOTALQUO) * (-1))
          * (1-positif(ART1731BIS))
        + 
                    (RNIDF - RNIDF1 - RNIDF2 - RNIDF3 - RNIDF4 - RNIDF5) * positif(ART1731BIS);
regle 90631 :
application : batch,iliad ;
RNICOL = (RNI + RNIDF);
regle 9064 :
application : iliad , batch  ;
TTPVQ = TONEQUOHT;
regle 9069 :
application : iliad , batch  ;
TEFF = VARIPTEFP - VARIPTEFN + TEFFREVTOT ; 
TEFFP_1 = max(0, TEFF);
TEFFP_2 = (max(0, TEFF) * null(SOMMEMOND_2+0)
        + positif(SOMMEMOND_2) *  max(0,IPTEFP+DEFZU-IPTEFN)) * (1-PREM8_11)
         + max(0,IPTEFP+DEFZU-IPTEFN) * PREM8_11;
TEFFP = TEFFP_1 * (1-positif(SOMMEMOND_2))+ TEFFP_2* positif(positif(SOMMEMOND_2+0)+PREM8_11);
TEFFN_1 = (1-positif_ou_nul(TEFF)) * ( min(0, TEFF) * (-1) ) + 0;
TEFFN_2 = ((1-positif_ou_nul(TEFF)) * ( min(0, TEFF) * (-1) ) + 0) * null(SOMMEMOND_2+0) * (1-PREM8_11) + 0;
TEFFN = TEFFN_1 * (1-positif(SOMMEMOND_2)) + TEFFN_2 * positif(SOMMEMOND_2);
RDMO = TEFF + (VARRMOND * positif(SOMMEMOND_2) + RMOND * (1 - positif(SOMMEMOND_2*PREM8_11)))
                           - (VARDMOND * positif(SOMMEMOND_2) + DMOND * (1 - positif(SOMMEMOND_2*PREM8_11)));

RMONDT = positif(RMOND + DEFZU - DMOND) * (RMOND + DEFZU - DMOND) ;

DMONDT = max(0 , RMOND + DEFZU - DMOND) ;
RMOND_1 =  RMOND;
RMOND_2 =  (max(0,RMOND + DEFZU - DMOND) * positif(SOMMEMOND_2) * (1-PREM8_11)
           + RMOND *  null(SOMMEMOND_2+0)) * (1-PREM8_11)
           + max(0,RMOND + DEFZU - DMOND) * PREM8_11 ;
DMOND_1 =  DMOND;
DMOND_2 =  DMOND *  null(SOMMEMOND_2+0)+0*(1-PREM8_11);
regle 90691 :
application : iliad , batch ;
FRF = somme (i=V,C,1,2,3,4: FRDi * (1-IND_10i))*(1-positif(APPLI_COLBERT+APPLI_OCEANS));
regle 9070 :
application : iliad , batch;
QUOHPV = somme(i=VO,CJ,PC:TSQi + PRQi)+ PALIQV + PALIQC + PALIQP
       + BAQV + BAQC + BAQP
       + BRCMQ + RFQ + somme(x=1..3;i=V,C:GLDxi) ;
regle 90705:
application : iliad ;
TX_CSG = T_CSG * (1-positif(APPLI_OCEANS));
TX_RDS = T_RDS * (1-positif(APPLI_OCEANS));
TX_PREL_SOC = (positif(V_EAG + V_EAD) * (T_PREL_SOCDOM)
              + positif(( 1-V_EAD ) * ( 1-V_EAG )) * (T_PREL_SOC))
	      * (1-V_CNR) * (1-positif(APPLI_OCEANS));
TX_IDCSG = T_IDCSG * (1-positif(APPLI_OCEANS));
regle 90707:
application : batch, iliad ;

SURIMP = IPSURSI ;

REPPLU = CREDPVREP + V_BTPVREP * (1-present(CREDPVREP)) ;

regle 90708:
application : iliad ;
INDM14 = positif_ou_nul(IREST - LIM_RESTIT) * (1-positif(APPLI_OCEANS));
regle 90709:
application : iliad ;
INDDEFICIT = positif(RNIDF1 + DEFBA6 + DEFBA5 + DEFBA4 + DEFBA3 + DEFBA2 +DEFBA1
		   + DRFRP + DLMRN1 + DALNP + IRECR + DPVRCM + MIBDREPV + MIBDREPC
                   + MIBDREPP + MIBDREPNPV + MIBDREPNPC + MIBDREPNPP + SPEDREPV + SPEDREPC
                   + SPEDREPP + SPEDREPNPV + SPEDREPNPC + SPEDREPNPP) * (1-positif(APPLI_OCEANS));
regle 4070121:
application : iliad , batch  ;
RP = somme (i=V,C: TSNNi + TSNN2i + BICIMPi + BICNPi + BNNi +  max(0,BANi) + BAEi)
                 + (min (0,BANV) + min (0,BANC)) *
                 (1 - positif(1 + SEUIL_IMPDEFBA - SHBA - REVQTOTQHT
                 - (REVTP - BA1)  ))
                 + max(0 , ANOCEP - ((min(DNOCEP,DNOCEP1731+0) * positif(ART1731BIS) + DNOCEP * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP6,DABNCNP61731+0) * positif(ART1731BIS) + DABNCNP6 * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP5,DABNCNP51731+0) * positif(ART1731BIS) + DABNCNP5 * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP4,DABNCNP41731+0) * positif(ART1731BIS) + DABNCNP4 * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP3,DABNCNP31731+0) * positif(ART1731BIS) + DABNCNP3 * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP2,DABNCNP21731+0) * positif(ART1731BIS) + DABNCNP2 * (1 - positif(ART1731BIS*PREM8_11)))
		 +(min(DABNCNP1,DABNCNP11731+0) * positif(ART1731BIS) + DABNCNP1 * (1 - positif(ART1731BIS*PREM8_11)))
		 ) ) + somme(i=1..3:GLNi) ;

regle 666998:
application :  iliad, batch;

AGREPAPER = PALIV + PALIC + PALIP + PENSALV + PENSALC + PENSALP ;

AGREPARET = RPALE + RPALP ;

AGREPPE = max(0,PPETOTX-PPERSA) ;

AGREDTARDIF = positif(RETIR + RETTAXA + RETPCAP + RETLOY + RETHAUTREV + RETCS + RETRD + RETPS
                      + RETCVN + RETCDIS + RETGLOA + RETRSE1 + RETRSE2 + RETRSE3 + RETRSE4 + RETRSE5 + RETREGV
                      + RETARPRIM + FLAG_RETARD + 0) ;
AGABAT = ABVIE + ABMAR;
AGREVTP = REVTP;
AGREI = REI;
AGPENA = PTOTIRCS ;
AGRECI = max(0,INE + IRE + CICAP + CICHR - AGREPPE);
AGRECITOT = INE + IRE + CICAP + CICHR;
