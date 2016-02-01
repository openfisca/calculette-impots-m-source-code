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
 
  ####   #    #    ##    #####      #     #####  #####   ######      #    
 #    #  #    #   #  #   #    #     #       #    #    #  #           #    #
 #       ######  #    #  #    #     #       #    #    #  #####       #    #
 #       #    #  ######  #####      #       #    #####   #           ######
 #    #  #    #  #    #  #          #       #    #   #   #                #
  ####   #    #  #    #  #          #       #    #    #  ######           #
regle 401:
application : bareme, iliad , batch  ;
IRB = IAMD2; 
IRB2 = IAMD2 + TAXASSUR + IPCAPTAXTOT + TAXLOY + CHRAPRES;
regle 40101:
application : iliad , batch  ;
KIR =   IAMD3 ;
regle 4011:
application : bareme , iliad , batch  ;
IAMD1 = IBM13 ;
IAMD2 = IBM23 ;
IAMD2TH = positif_ou_nul(IBM23 - SEUIL_61)*IBM23;
regle 40110:
application : bareme , iliad , batch  ;
IAMD3 = IBM33 - min(ACP3, IMPIM3);
regle 402112:
application : iliad , batch  ;
ANG3 = IAD32 - IAD31;
regle 40220:
application : iliad , batch  ;
ACP3 = max (0 ,
 somme (a=1..4: min(arr(CHENFa * TX_DPAEAV/100) , SEUIL_AVMAXETU)) - ANG3)
        * (1 - positif(V_CR2 + IPVLOC)) * positif(ANG3) * positif(IMPIM3);
regle 403:
application : bareme ,iliad , batch  ;

IBM13 = IAD11 + ITP + REI + AUTOVERSSUP + TAXASSUR + IPCAPTAXTOT  + TAXLOY + CHRAPRES + AVFISCOPTER ;

IBM23 = IAD11 + ITP + REI + AUTOVERSSUP + AVFISCOPTER ;

regle 404:
application : bareme , iliad , batch  ;
IBM33 = IAD31 + ITP + REI;
regle 4041:
application : iliad , batch  ;
DOMITPD = arr(BN1 + SPEPV + BI12F + BA1) * (TX11/100) * positif(V_EAD);
DOMITPG = arr(BN1 + SPEPV + BI12F + BA1) * (TX09/100) * positif(V_EAG);
DOMAVTD = arr((BN1 + SPEPV + BI12F + BA1) * TX05/100) * positif(V_EAD);
DOMAVTG = arr((BN1 + SPEPV + BI12F + BA1) * TX07/100) * positif(V_EAG);
DOMAVTO = DOMAVTD + DOMAVTG;
DOMABDB = max(PLAF_RABDOM - ABADO , 0) * positif(V_EAD)
          + max(PLAF_RABGUY - ABAGU , 0) * positif(V_EAG);
DOMDOM = max(DOMAVTO - DOMABDB , 0) * positif(V_EAD + V_EAG);
ITP = arr((BPTP2 * TX225/100) 
       + (BPTPVT * TX19/100) 
       + (BPTP4 * TX30/100) 
       +  DOMITPD + DOMITPG
       + (BPTP3 * TX16/100) 
       + (BPTP40 * TX41/100)
       + DOMDOM * positif(V_EAD + V_EAG)
       + (BPTP18 * TX18/100)
       + (BPTPSJ * TX19/100)
       + (BPTP24 * TX24/100)
	  )
       * (1-positif(IPVLOC)) * (1 - positif(present(TAX1649)+present(RE168))); 
regle 40412:
application : iliad , batch  ;
REVTP = BPTP2 +BPTPVT+BPTP4+BTP3A+BPTP40+ BPTP24+BPTP18 +BPTPSJ;
regle 40413:
application : iliad , batch  ;
BTP3A = (BN1 + SPEPV + BI12F + BA1) * (1 - positif( IPVLOC ));
BPTPD = BTP3A * positif(V_EAD)*(1-positif(present(TAX1649)+present(RE168)));
BPTPG = BTP3A * positif(V_EAG)*(1-positif(present(TAX1649)+present(RE168)));
BPTP3 = BTP3A * (1 - positif(V_EAD + V_EAG))*(1-positif(present(TAX1649)+present(RE168)));
BTP3G = (BPVRCM) * (1 - positif( IPVLOC ));
BTP2 = PEA * (1 - positif( IPVLOC ));
BPTP2 = BTP2*(1-positif(present(TAX1649)+present(RE168)));
BTPVT = GAINPEA * (1 - positif( IPVLOC ));
BPTPVT = BTPVT*(1-positif(present(TAX1649)+present(RE168)));

BTP18 = (BPV18V + BPV18C) * (1 - positif( IPVLOC ));
BPTP18 = BTP18 * (1-positif(present(TAX1649)+present(RE168))) ;

BPTP4 = (BPCOPTV + BPCOPTC + BPVSK) * (1 - positif(IPVLOC)) * (1 - positif(present(TAX1649) + present(RE168))) ;
BPTP4I = (BPCOPTV + BPCOPTC) * (1 - positif(IPVLOC)) * (1 - positif(present(TAX1649) + present(RE168))) ;
BTPSK = BPVSK * (1 - positif( IPVLOC ));
BPTPSK = BTPSK * (1-positif(present(TAX1649)+present(RE168))) ;

BTP40 = (BPV40V + BPV40C) * (1 - positif( IPVLOC )) ;
BPTP40 = BTP40 * (1-positif(present(TAX1649)+present(RE168))) ;

BTP5 = PVIMPOS * (1 - positif( IPVLOC ));
BPTP5 = BTP5 * (1-positif(present(TAX1649)+present(RE168))) ;
BTPSJ = BPVSJ * (1 - positif( IPVLOC ));
BPTPSJ = BTPSJ * (1-positif(present(TAX1649)+present(RE168))) ;
BTPSB = PVTAXSB * (1 - positif( IPVLOC ));
BPTPSB = BTPSB * (1-positif(present(TAX1649)+present(RE168))) ;
BPTP19 = (BPVSJ + GAINPEA) * (1 - positif( IPVLOC )) * (1 - positif(present(TAX1649) + present(RE168))) ;
BPTP24 = RCM2FA *(1-positif(present(TAX1649)+present(RE168))) * (1 - positif(null(2-V_REGCO) + null(4-V_REGCO)));
ITPRCM = arr(BPTP24 * TX24/100);

BPTPDIV = BTP5 * (1-positif(present(TAX1649)+present(RE168))) ;

regle 4042:
application : iliad , batch  ;


REI = IPREP+IPPRICORSE;

regle 40421:
application : iliad , batch  ;


PPERSATOT = RSAFOYER + RSAPAC1 + RSAPAC2 ;

PPERSA = min(PPETOTX , PPERSATOT) * (1 - V_CNR) ;

PPEFINAL = PPETOTX - PPERSA ;

regle 405:
application : bareme , iliad , batch  ;


IAD11 = ( max(0,IDOM11-DEC11-RED) *(1-positif(V_CR2+IPVLOC))
        + positif(V_CR2+IPVLOC) *max(0 , IDOM11 - RED) )
                                * (1-positif(RE168+TAX1649))
        + positif(RE168+TAX1649) * IDOM16;
regle 40510:
application : bareme , iliad , batch  ;
IREXITI = (present(FLAG_EXIT) * ((1-positif(FLAG_3WBNEG)) * abs(NAPTIR - V_NAPTIR3WB) 
           + positif(FLAG_3WBNEG) * abs(NAPTIR + V_NAPTIR3WB)) * positif(present(PVIMPOS)+present(CODRWB)))
          * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


IREXITS = (
           ((1-positif(FLAG_3WANEG)) * abs(V_NAPTIR3WA+V_NAPTIR3WB*positif(FLAG_3WBNEG)-V_NAPTIR3WB*(1-positif(FLAG_3WBNEG))) 
           + positif(FLAG_3WANEG) * abs(-V_NAPTIR3WA + V_NAPTIR3WB*positif(FLAG_3WBNEG)-V_NAPTIR3WB*(1-positif(FLAG_3WBNEG)))) * positif(present(PVIMPOS)+present(CODRWB))
           + ((1-positif(FLAG_3WANEG)) * abs(V_NAPTIR3WA-NAPTIR)
           + positif(FLAG_3WANEG) * abs(-V_NAPTIR3WA -NAPTIR)) * (1-positif(present(PVIMPOS)+present(CODRWB)))
          ) 
          * present(FLAG_EXIT) * positif(present(PVSURSI)+present(CODRWA))
          * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


IREXIT = IREXITI + IREXITS ;

EXITTAX3 = ((positif(FLAG_3WBNEG) * (-1) * ( V_NAPTIR3WB) + (1-positif(FLAG_3WBNEG)) * (V_NAPTIR3WB)) * positif(present(PVIMPOS)+present(CODRWB))
            + NAPTIR * positif(present(PVSURSI)+present(CODRWA)) * (1-positif(present(PVIMPOS)+present(CODRWB))))
           * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


PVCREA = PVSURSI + CODRWA ;

PVCREB = PVIMPOS + CODRWB ;

regle 406:
application : bareme , iliad , batch  ;
IAD31 = ((IDOM31-DEC31)*(1-positif(V_CR2+IPVLOC)))
        +(positif(V_CR2+IPVLOC)*IDOM31);
IAD32 = ((IDOM32-DEC32)*(1-positif(V_CR2+IPVLOC)))
        +(positif(V_CR2+IPVLOC)*IDOM32);

regle 4052:
application : bareme , iliad , batch  ;

IMPIM3 =  IAD31 ;

regle 4061:
application : bareme , iliad , batch  ;
pour z = 1,2:
DEC1z = ( min (max( arr((SEUIL_DECOTE1 * (1 - BOOL_0AM)) + (SEUIL_DECOTE2 * BOOL_0AM) - IDOM1z),0),IDOM1z) * (1 - V_ANC_BAR)
        + min (max( arr(SEUIL_DECOTEA/2 - (IDOM1z/2)),0),IDOM1z) * V_ANC_BAR)
        * (1 - V_CNR) ;

pour z = 1,2:
DEC3z = ( min (max( arr((SEUIL_DECOTE1 * (1 - BOOL_0AM)) + (SEUIL_DECOTE2 * BOOL_0AM) - IDOM3z),0),IDOM3z) * (1 - V_ANC_BAR)
        + min (max( arr(SEUIL_DECOTEA/2 - (IDOM3z/2)),0),IDOM3z) * V_ANC_BAR)
        * (1 - V_CNR) ;

DEC6 = ( min (max( arr((SEUIL_DECOTE1 * (1 - BOOL_0AM)) + (SEUIL_DECOTE2 * BOOL_0AM) - IDOM16),0),IDOM16) * (1 - V_ANC_BAR)
       + min (max( arr(SEUIL_DECOTEA/2 - (IDOM16/2)),0),IDOM16) * V_ANC_BAR)
       * (1 - V_CNR) ;

regle 407:
application : iliad   , batch ;
      
RED =  RCOTFOR + RSURV + RCOMP + RHEBE + RREPA + RDIFAGRI + RDONS
       + RDUFLOTOT + RPINELTOT
       + RCELTOT
       + RRESTIMO * (1-V_INDTEO)  + V_RRESTIMOXY * V_INDTEO
       + RFIPC + RFIPDOM + RAIDE + RNOUV + RPLAFREPME4
       + RTOURREP 
       + RTOUREPA + RTOUHOTR  
       + RLOGDOM + RLOGSOC + RDOMSOC1 + RLOCENT + RCOLENT
       + RRETU + RINNO + RRPRESCOMP + RFOR 
       + RSOUFIP + RRIRENOV + RSOCREPR + RRESIMEUB + RRESINEUV + RRESIVIEU 
       + RCODOU
       + RLOCIDEFG + RCODJT + RCODJU
       + RREDMEUB + RREDREP + RILMIX + RILMIY + RINVRED + RILMIH + RILMJC
       + RILMIZ + RILMJI + RILMJS + RMEUBLE + RPROREP + RREPNPRO + RREPMEU 
       + RILMIC + RILMIB + RILMIA + RILMJY + RILMJX + RILMJW + RILMJV
       + RILMOA + RILMOB + RILMOC + RILMOD + RILMOE
       + RILMPA + RILMPB + RILMPC + RILMPD + RILMPE
       + RIDOMPROE3   
       + RPATNAT1 + RPATNAT2 + RPATNAT3 + RPATNAT
       + RFORET + RCREAT + RCINE ;

REDTL = ASURV + ACOMP ;

CIMPTL = ATEC + ADEVDUR + TOTBGE ;

regle 4070:
application : bareme ;
RED = V_9UY;
regle 4025:
application : iliad , batch  ;

PLAFDOMPRO1 = max(0 , RRI1_1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV
                          -RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR-RTOUREPA-RCELTOT-RLOCNPRO
                          -RPATNATOT-RDOMSOC1-RLOGSOC ) ;
                          

RIDOMPROE3 = (RIDOMPROE3_1 * (1-ART1731BIS)
              + min(RIDOMPROE3_1 , max(RIDOMPROE3_P+RIDOMPROE3P2, RIDOMPROE31731+0) * (1-PREM8_11)) * ART1731BIS) * (1-V_CNR);
                  


RIDOMPROTOT_1 = RIDOMPROE3_1 ;
RIDOMPROTOT = RIDOMPROE3 ;


RINVEST = RIDOMPROE3 ;


DIDOMPRO = ( RIDOMPRO * (1-ART1731BIS) 
             + min( RIDOMPRO, max(DIDOMPRO_P+DIDOMPROP2 , DIDOMPRO1731+0 )*(1-PREM8_11)) * ART1731BIS ) * (1 - V_CNR) ;

regle 40749:
application : iliad , batch  ;

DFORET = FORET ;

AFORET_1 = max(min(DFORET,LIM_FORET),0) * (1-V_CNR) ;

AFORET = max( 0 , AFORET_1  * (1-ART1731BIS) 
                  + min( AFORET_1 , max(AFORET_P + AFORETP2 , AFORET1731+0) * (1-PREM8_11)) * ART1731BIS
            ) * (1-V_CNR) ;

RAFORET = arr(AFORET_1*TX_FORET/100) ;

RFORET_1 =  max( min( RAFORET , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1) , 0 ) ;

RFORET =  max( 0 , RFORET_1 * (1-ART1731BIS) 
                   + min( RFORET_1 , max( RFORET_P+RFORETP2 , RFORET1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4075:
application : iliad , batch ;

DFIPC = FIPCORSE ;

AFIPC_1 = max( min(DFIPC , LIM_FIPCORSE * (1 + BOOL_0AM)) , 0) * (1 - V_CNR) ;

AFIPC = max( 0, AFIPC_1 * (1-ART1731BIS)
                + min( AFIPC_1 , max( AFIPC_P + AFIPCP2 , AFIPC1731+0 ) * (1-PREM8_11)) * ART1731BIS
           ) * (1 - V_CNR) ;

RFIPCORSE = arr(AFIPC_1 * TX_FIPCORSE/100) * (1 - V_CNR) ;

RFIPC_1 = max( min( RFIPCORSE , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1) , 0) ;

RFIPC = max( 0, RFIPC_1 * (1 - ART1731BIS) 
                + min( RFIPC_1 , max(RFIPC_P+RFIPCP2 , RFIPC1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 40751:
application : iliad , batch ;

DFIPDOM = FIPDOMCOM ;

AFIPDOM_1 = max( min(DFIPDOM , LIMFIPDOM * (1 + BOOL_0AM)) , 0) * (1 - V_CNR) ;

AFIPDOM = max( 0 , AFIPDOM_1 * (1 - ART1731BIS)
               + min( AFIPDOM_1 , max(AFIPDOM_P+ AFIPDOMP2 , AFIPDOM1731+0) * (1-PREM8_11)) * ART1731BIS
	     ) * (1 - V_CNR) ;

RFIPDOMCOM = arr(AFIPDOM_1 * TXFIPDOM/100);

RFIPDOM_1 = max( min( RFIPDOMCOM , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1),0);

RFIPDOM = max( 0 , RFIPDOM_1 * (1 - ART1731BIS) 
                   + min( RFIPDOM_1, max(RFIPDOM_P+RFIPDOMP2 ,  RFIPDOM1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4076:
application : iliad , batch  ;
BSURV = min( RDRESU , PLAF_RSURV + PLAF_COMPSURV * (EAC + V_0DN) + PLAF_COMPSURVQAR * (V_0CH + V_0DP) );

RRS = arr( BSURV * TX_REDSURV / 100 ) * (1 - V_CNR);

DSURV = RDRESU;

ASURV = (BSURV * (1-ART1731BIS)
         + min( BSURV , max( ASURV_P + ASURVP2 , ASURV1731+0 ) * (1-PREM8_11)) * ART1731BIS
        )  * (1-V_CNR);

RSURV_1 = max( min( RRS , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1
			              -RCINE_1-RRESTIMO_1-RSOCREPR_1-RRPRESCOMP_1-RHEBE_1 ) , 0 ) ;

RSURV = max( 0 , RSURV_1 * (1-ART1731BIS) 
                 + min( RSURV_1, max(RSURV_P+RSURVP2 , RSURV1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4100:
application : iliad , batch ;

RRCN = arr(  min( CINE1 , min( max(SOFIRNG,RNG) * TX_CINE3/100 , PLAF_CINE )) * TX_CINE1/100
        + min( CINE2 , max( min( max(SOFIRNG,RNG) * TX_CINE3/100 , PLAF_CINE ) - CINE1 , 0)) * TX_CINE2/100 
       ) * (1 - V_CNR) ;

DCINE = CINE1 + CINE2 ;

ACINE_1 = max(0,min( CINE1 + CINE2 , min( arr(SOFIRNG * TX_CINE3/100) , PLAF_CINE ))) * (1 - V_CNR) ;

ACINE = max( 0, ACINE_1 * (1-ART1731BIS) 
                + min( ACINE_1 , max(ACINE_P+ACINEP2 , ACINE1731+0 ) * (1-PREM8_11)) * ART1731BIS
           ) * (1-V_CNR) ; 

RCINE_1 = max( min( RRCN , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1) , 0 ) ;

RCINE = max( 0, RCINE_1 * (1-ART1731BIS) 
                + min( RCINE_1 , max(RCINE_P+RCINEP2 , RCINE1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4176:
application : iliad , batch  ;
BSOUFIP = min( FFIP , LIM_SOUFIP * (1 + BOOL_0AM));

RFIP = arr( BSOUFIP * TX_REDFIP / 100 ) * (1 - V_CNR);

DSOUFIP = FFIP;

ASOUFIP = (BSOUFIP * (1-ART1731BIS) 
           + min( BSOUFIP , max(ASOUFIP_P + ASOUFIPP2 , ASOUFIP1731+0) * (1-PREM8_11)) * ART1731BIS
          ) * (1-V_CNR) ;

RSOUFIP_1 = max( min( RFIP , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1
			   -RCINE_1-RRESTIMO_1-RSOCREPR_1-RRPRESCOMP_1-RHEBE_1-RSURV_1-RINNO_1) , 0 ) ;

RSOUFIP = max( 0 , RSOUFIP_1 * (1-ART1731BIS) 
                   + min( RSOUFIP_1 , max(RSOUFIP_P+RSOUFIPP2 , RSOUFIP1731+0) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4200:
application : iliad , batch  ;

BRENOV = min(RIRENOV,PLAF_RENOV) ;

RENOV = arr( BRENOV * TX_RENOV / 100 ) * (1 - V_CNR) ;

DRIRENOV = RIRENOV ;

ARIRENOV = (BRENOV * (1-ART1731BIS) 
            + min( BRENOV, max(ARIRENOV_P + ARIRENOVP2 , ARIRENOV1731+0) * (1-PREM8_11)) * ART1731BIS 
           ) * (1 - V_CNR) ;

RRIRENOV_1 = max(min(RENOV , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1-RCINE_1
			     -RRESTIMO_1-RSOCREPR_1-RRPRESCOMP_1-RHEBE_1-RSURV_1-RINNO_1-RSOUFIP_1) , 0 ) ;

RRIRENOV = max( 0 , RRIRENOV_1 * (1-ART1731BIS) 
                    + min(RRIRENOV_1 , max(RRIRENOV_P+RRIRENOVP2 , RRIRENOV1731+0) * (1-PREM8_11)) * ART1731BIS ) ;

regle 40771:
application : iliad , batch  ;

RFC = min(RDCOM,PLAF_FRCOMPTA * max(1,NBACT)) * present(RDCOM)*(1-V_CNR);

NCOMP = ( max(1,NBACT)* present(RDCOM) * (1-ART1731BIS) + min( max(1,NBACT)* present(RDCOM) , NCOMP1731+0) * ART1731BIS ) * (1-V_CNR);

DCOMP = RDCOM;

ACOMP =  RFC * (1-ART1731BIS) 
         + min( RFC , max(ACOMP_P + ACOMPP2 , ACOMP1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

regle 10040771:
application :  iliad , batch  ;
RCOMP_1 = max(min( RFC , RRI1-RLOGDOM-RCREAT) , 0) ;

RCOMP = max( 0 , RCOMP_1 * (1-ART1731BIS) 
                 + min( RCOMP_1 ,max(RCOMP_P+RCOMPP2 , RCOMP1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4077:
application : iliad , batch  ;




DUFREPFI = DUFLOFI ;

DDUFLOGIH = DUFLOGI + DUFLOGH ;

DDUFLOEKL = DUFLOEK + DUFLOEL ;

DPIQABCD = PINELQA + PINELQB + PINELQC + PINELQD ;



ADUFREPFI = DUFLOFI * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


ADUFLOEKL_1 = ( arr( min( DUFLOEL + 0, LIMDUFLO) / 9 ) 
              + arr( min( DUFLOEK + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + 0, LIMDUFLO)) / 9 )
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

ADUFLOEKL = ADUFLOEKL_1 * (1-ART1731BIS) ;


APIQABCD_1 = ( arr( min(PINELQD + 0, LIMDUFLO - min( DUFLOEL + 0, LIMDUFLO)) /9 ) 
                + arr( min(PINELQB + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + 0, LIMDUFLO)) / 9 ) 
                + arr(min( PINELQC + 0, LIMDUFLO - min( DUFLOEL + PINELQD + 0, LIMDUFLO)) /6 )
                + arr(min( PINELQA + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + PINELQB + 0, LIMDUFLO)) / 6)
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

APIQABCD = APIQABCD_1 * (1-ART1731BIS) ;

ADUFLOGIH_1 = ( arr( min( DUFLOGI + 0, LIMDUFLO) / 9 ) +
              arr( min( DUFLOGH + 0, LIMDUFLO - min( DUFLOGI + 0, LIMDUFLO)) / 9 )
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

ADUFLOGIH =  ADUFLOGIH_1 * (1-ART1731BIS) 
             + min( ADUFLOGIH_1, max(ADUFLOGIH_P + ADUFLOGIHP2 , ADUFLOGIH1731 +0 ) * (1-PREM8_11)) * ART1731BIS ;



RDUFLO_EKL = ( arr(arr( min( DUFLOEL + 0, LIMDUFLO) / 9 ) * (TX29/100))
              + arr(arr( min( DUFLOEK + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + 0, LIMDUFLO)) / 9 ) * (TX18/100))
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

RPI_QABCD = ( arr(arr( min(PINELQD + 0, LIMDUFLO - min( DUFLOEL + 0, LIMDUFLO)) /9 ) * (TX29/100)) 
                + arr(arr( min(PINELQB + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + 0, LIMDUFLO)) / 9 ) * (TX18/100)) 
                + arr(arr(min( PINELQC + 0, LIMDUFLO - min( DUFLOEL + PINELQD + 0, LIMDUFLO)) /6 ) * (TX23/100))
                + arr(arr(min( PINELQA + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + PINELQB + 0, LIMDUFLO)) / 6) * (TX12/100))
               ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;



RDUFLO_GIH = ( arr( arr( min( DUFLOGI + 0, LIMDUFLO) / 9 ) * (TX29/100)) +
              arr( arr( min( DUFLOGH + 0, LIMDUFLO - min( DUFLOGI + 0, LIMDUFLO)) / 9 ) * (TX18/100))
             ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;


regle 40772:
application : iliad , batch  ;


RDUFREPFI = max( 0, min( ADUFREPFI , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS)) ;

RDUFLOGIH_1 = max( 0, min( RDUFLO_GIH , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS
                                            -RDUFREPFI)) ;

RDUFLOGIH = max( 0, RDUFLOGIH_1 * (1 - ART1731BIS) 
                    + min ( RDUFLOGIH_1 , max(RDUFLOGIH_P+RDUFLOGIHP2 , RDUFLOGIH1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

RDUFLOEKL_1 = max( 0, min( RDUFLO_EKL , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS
                                            -RDUFREPFI-RDUFLOGIH)) ;

RDUFLOEKL = max( 0, RDUFLOEKL_1 * (1 - ART1731BIS))  ;

RPIQABCD_1 = max( 0, min( RPI_QABCD , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS
                                            -RDUFREPFI-RDUFLOGIH-RDUFLOEKL)) ;

RPIQABCD = max( 0, RPIQABCD_1 * (1 - ART1731BIS)) ;

RDUFLOTOT = RDUFREPFI + RDUFLOGIH + RDUFLOEKL ;
RPINELTOT = RPIQABCD ;

regle 40773:
application : iliad , batch  ;

RIVDUEKL = ( arr( arr( min( DUFLOEL + 0, LIMDUFLO) / 9 ) * (TX29/100)) 
              + arr(arr( min( DUFLOEK + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + 0, LIMDUFLO)) / 9 ) * (TX18/100))
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

RIVDUEKL8 = max (0 , ( arr( min( DUFLOEL + 0, LIMDUFLO) * (TX29/100)) 
                         + arr( min( DUFLOEK + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + 0, LIMDUFLO)) * (TX18/100))
                        ) 
                          - 8 * RIVDUEKL  
                   ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ; 


RIVPIQBD =  ( arr(arr( min(PINELQD + 0, LIMDUFLO - min( DUFLOEL + 0, LIMDUFLO)) /9 ) * (TX29/100))
            + arr(arr( min(PINELQB + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + 0, LIMDUFLO)) / 9 ) * (TX18/100))
            ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ; 

RIVPIQBD8 = max (0 , ( arr( min(PINELQD + 0, LIMDUFLO - min( DUFLOEL + 0, LIMDUFLO)) * (TX29/100)) + 
                        arr( min(PINELQB + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + 0, LIMDUFLO)) * (TX18/100))
                    ) 
                          - 8 * RIVPIQBD  
                ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ; 

RIVPIQAC = ( arr(arr(min( PINELQC + 0, LIMDUFLO - min( DUFLOEL + PINELQD + 0, LIMDUFLO)) /6 ) * (TX23/100))
           + arr(arr(min( PINELQA + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + PINELQB + 0, LIMDUFLO)) / 6) * (TX12/100))
           ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

RIVPIQAC5 = max (0 , ( arr( min(PINELQC + 0, LIMDUFLO - min( DUFLOEL + PINELQD + 0, LIMDUFLO)) * (TX23/100)) + 
                        arr( min(PINELQA + 0, LIMDUFLO - min( DUFLOEL + PINELQD + PINELQC + DUFLOEK + PINELQB + 0, LIMDUFLO)) * (TX12/100))
                     ) 
                          - 5 * RIVPIQAC  
                ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ; 


RIVDUGIH = ( arr( arr( min( DUFLOGI + 0, LIMDUFLO) / 9 ) * (TX29/100)) +
                arr( arr( min( DUFLOGH + 0, LIMDUFLO - min( DUFLOGI + 0, LIMDUFLO)) / 9 ) * (TX18/100))
              ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ;

RIVDUGIH8 = max (0 , ( arr( min( DUFLOGI + 0, LIMDUFLO) * (TX29/100)) +
                          arr( min( DUFLOGH + 0, LIMDUFLO - min( DUFLOGI + 0, LIMDUFLO)) * (TX18/100))
                     ) 
                          - 8 * RIVDUGIH  
                   ) * ( 1 - null( 4-V_REGCO )) * ( 1 - null( 2-V_REGCO )) ; 

REPDUEKL = RIVDUEKL * 7 + RIVDUEKL8 ;
REPIQBD = RIVPIQBD * 7 + RIVPIQBD8 ;
REPIQAC = RIVPIQAC * 4 + RIVPIQAC5 ;
REPDUGIH = RIVDUGIH * 7 + RIVDUGIH8 ;

regle 4078:
application : iliad , batch  ;
BCEL_FABC = arr ( min( CELLIERFA + CELLIERFB + CELLIERFC , LIMCELLIER ) /9 );

BCEL_FD = arr ( min( CELLIERFD , LIMCELLIER ) /5 );

BCEL_2012 = arr( min(( CELLIERJA + CELLIERJD + CELLIERJE + CELLIERJF + CELLIERJH + CELLIERJJ 
		     + CELLIERJK + CELLIERJM + CELLIERJN + 0 ), LIMCELLIER ) /9 );

BCEL_JOQR = arr( min(( CELLIERJO + CELLIERJQ + CELLIERJR + 0 ), LIMCELLIER ) /5 );

BCEL_2011 = arr( min(( CELLIERNA + CELLIERNC + CELLIERND + CELLIERNE + CELLIERNF + CELLIERNH
		     + CELLIERNI + CELLIERNJ + CELLIERNK + CELLIERNM + CELLIERNN + CELLIERNO  + 0 ), LIMCELLIER ) /9 );

BCELCOM2011 = arr( min(( CELLIERNP + CELLIERNR + CELLIERNS + CELLIERNT + 0 ), LIMCELLIER ) /5 );

BCEL_NBGL = arr( min(( CELLIERNB + CELLIERNG + CELLIERNL + 0), LIMCELLIER ) /9 );

BCEL_NQ = arr( min(( CELLIERNQ + 0), LIMCELLIER ) /5 );

BCEL_JBGL = arr( min(( CELLIERJB + CELLIERJG + CELLIERJL + 0), LIMCELLIER ) /9 );

BCEL_JP = arr( min(( CELLIERJP + 0), LIMCELLIER ) /5 );


BCEL_HNO = arr ( min ((CELLIERHN + CELLIERHO + 0 ), LIMCELLIER ) /9 );
BCEL_HJK = arr ( min ((CELLIERHJ + CELLIERHK + 0 ), LIMCELLIER ) /9 );

BCEL_HL = arr ( min ((CELLIERHL + 0 ), LIMCELLIER ) /9 );
BCEL_HM = arr ( min ((CELLIERHM + 0 ), LIMCELLIER ) /9 );


DCELRREDLA = CELRREDLA;

ACELRREDLA = (CELRREDLA * (1-ART1731BIS) 
              + min (CELRREDLA, max(ACELRREDLA_P+ACELRREDLAP2 , ACELRREDLA1731 +0)*(1-PREM8_11)) * ART1731BIS 
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLB = CELRREDLB;

ACELRREDLB = (CELRREDLB * (1-ART1731BIS) 
              + min (CELRREDLB, max(ACELRREDLB_P+ACELRREDLBP2 , ACELRREDLB1731 +0)*(1-PREM8_11)) * ART1731BIS 
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLE = CELRREDLE;

ACELRREDLE = (CELRREDLE * (1-ART1731BIS)
              + min (CELRREDLE , max(ACELRREDLE_P+ACELRREDLEP2 , ACELRREDLE1731 +0)*(1-PREM8_11)) * ART1731BIS 
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLN = CELRREDLN;

ACELRREDLN = (CELRREDLN * (1-ART1731BIS) 
              + min (CELRREDLN, max(ACELRREDLN_P+ACELRREDLNP2 , ACELRREDLN1731 +0)*(1-PREM8_11)) * ART1731BIS 
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLM = CELRREDLM;

ACELRREDLM = (CELRREDLM * (1-ART1731BIS) 
              + min (CELRREDLM, max(ACELRREDLM_P+ACELRREDLMP2 , ACELRREDLM1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLC = CELRREDLC;

ACELRREDLC = (CELRREDLC * (1-ART1731BIS) 
              + min (CELRREDLC, max(ACELRREDLC_P+ACELRREDLCP2 , ACELRREDLC1731 +0)*(1-PREM8_11)) * ART1731BIS 
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLD = CELRREDLD;

ACELRREDLD = (CELRREDLD * (1-ART1731BIS) 
              + min (CELRREDLD, max(ACELRREDLD_P+ACELRREDLDP2 , ACELRREDLD1731 +0)*(1-PREM8_11)) * ART1731BIS 
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLS = CELRREDLS;

ACELRREDLS = (CELRREDLS * (1-ART1731BIS) 
              + min (CELRREDLS, max(ACELRREDLS_P+ACELRREDLSP2 , ACELRREDLS1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLT = CELRREDLT;

ACELRREDLT = (CELRREDLT * (1-ART1731BIS) 
              + min (CELRREDLT, max(ACELRREDLT_P+ACELRREDLTP2 , ACELRREDLT1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLF = CELRREDLF;

ACELRREDLF = (CELRREDLF * (1-ART1731BIS) 
              + min (CELRREDLF, max(ACELRREDLF_P+ACELRREDLFP2 , ACELRREDLF1731 +0)*(1-PREM8_11)) * ART1731BIS 
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLZ = CELRREDLZ;

ACELRREDLZ = (CELRREDLZ * (1-ART1731BIS) 
              + min (CELRREDLZ, max(ACELRREDLZ_P+ACELRREDLZP2 , ACELRREDLZ1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDLX = CELRREDLX;

ACELRREDLX = (CELRREDLX * (1-ART1731BIS) 
              + min (CELRREDLX, max(ACELRREDLX_P+ACELRREDLXP2 , ACELRREDLX1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


DCELRREDMG = CELRREDMG;

ACELRREDMG = (CELRREDMG * (1-ART1731BIS) 
              + min (CELRREDMG, max(ACELRREDMG_P+ACELRREDMGP2 , ACELRREDMG1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELRREDMH = CELRREDMH;

ACELRREDMH = (CELRREDMH * (1-ART1731BIS) 
              + min (CELRREDMH, max(ACELRREDMH_P+ACELRREDMHP2 , ACELRREDMH1731 +0)*(1-PREM8_11)) * ART1731BIS
	     ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHS = CELREPHS; 


ACELREPHS = ( CELREPHS * (1 - ART1731BIS) 
             + min( CELREPHS , max(ACELREPHS_P+ACELREPHSP2 , ACELREPHS1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

DCELREPHR = CELREPHR ;    


ACELREPHR = ( CELREPHR * (1 - ART1731BIS) 
             + min( CELREPHR , max(ACELREPHR_P+ACELREPHRP2 , ACELREPHR1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 


DCELREPHU = CELREPHU ; 


ACELREPHU = ( CELREPHU * (1 - ART1731BIS) 
             + min( CELREPHU , max(ACELREPHU_P+ACELREPHUP2 , ACELREPHU1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

DCELREPHT = CELREPHT; 


ACELREPHT = ( CELREPHT * (1 - ART1731BIS) 
             + min( CELREPHT , max(ACELREPHT_P+ACELREPHTP2 , ACELREPHT1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

DCELREPHZ = CELREPHZ; 


ACELREPHZ = ( CELREPHZ * (1 - ART1731BIS) 
             + min( CELREPHZ , max(ACELREPHZ_P+ACELREPHZP2 , ACELREPHZ1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

DCELREPHX = CELREPHX; 


ACELREPHX = ( CELREPHX * (1 - ART1731BIS) 
             + min( CELREPHX , max(ACELREPHX_P+ACELREPHXP2 , ACELREPHX1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 


DCELREPHW = CELREPHW; 


ACELREPHW = ( CELREPHW * (1 - ART1731BIS) 
             + min( CELREPHW , max(ACELREPHW_P+ACELREPHWP2 , ACELREPHW1731 + 0 )*(1-PREM8_11)) * ART1731BIS 
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

DCELREPHV = CELREPHV; 

ACELREPHV = ( CELREPHV * (1 - ART1731BIS) 
             + min( CELREPHV , max(ACELREPHV_P+ACELREPHVP2 , ACELREPHV1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHF = CELREPHF; 

ACELREPHF = ( CELREPHF * (1 - ART1731BIS) 
             + min( CELREPHF , max(ACELREPHF_P+ACELREPHFP2 , ACELREPHF1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHE = CELREPHE ;    

ACELREPHE = ( CELREPHE * (1 - ART1731BIS) 
             + min( CELREPHE , max(ACELREPHE_P+ACELREPHEP2 , ACELREPHE1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHD = CELREPHD; 

ACELREPHD = ( CELREPHD * (1 - ART1731BIS) 
             + min( CELREPHD , max(ACELREPHD_P+ACELREPHDP2 , ACELREPHD1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHH = CELREPHH; 

ACELREPHH = ( CELREPHH * (1 - ART1731BIS) 
             + min( CELREPHH , max(ACELREPHH_P+ACELREPHHP2 , ACELREPHH1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHG = CELREPHG; 

ACELREPHG = ( CELREPHG * (1 - ART1731BIS) 
             + min( CELREPHG , max(ACELREPHG_P+ACELREPHGP2 , ACELREPHG1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHB = CELREPHB; 

ACELREPHB = ( CELREPHB * (1 - ART1731BIS) 
             + min( CELREPHB , max(ACELREPHB_P+ACELREPHBP2 , ACELREPHB1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPHA = CELREPHA; 

ACELREPHA = ( CELREPHA * (1 - ART1731BIS) 
             + min( CELREPHA , max(ACELREPHA_P+ACELREPHAP2 , ACELREPHA1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
	        * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGU = CELREPGU; 

ACELREPGU = (CELREPGU * (1 - ART1731BIS) 
             + min( CELREPGU , max (ACELREPGU_P+ACELREPGUP2 , ACELREPGU1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGX = CELREPGX; 

ACELREPGX = (CELREPGX * (1 - ART1731BIS) 
             + min( CELREPGX , max (ACELREPGX_P+ACELREPGXP2 , ACELREPGX1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGT = CELREPGT; 

ACELREPGT = (CELREPGT * (1 - ART1731BIS) 
             + min( CELREPGT , max (ACELREPGT_P+ACELREPGTP2 , ACELREPGT1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGS = CELREPGS; 

ACELREPGS = (CELREPGS * (1 - ART1731BIS) 
             + min( CELREPGS , max (ACELREPGS_P+ACELREPGSP2 , ACELREPGS1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGW = CELREPGW; 

ACELREPGW = (CELREPGW * (1 - ART1731BIS) 
             + min( CELREPGW , max (ACELREPGW_P+ACELREPGWP2 , ACELREPGW1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGP = CELREPGP; 

ACELREPGP = (CELREPGP * (1 - ART1731BIS) 
             + min( CELREPGP , max (ACELREPGP_P+ACELREPGPP2 , ACELREPGP1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGL = CELREPGL; 

ACELREPGL = (CELREPGL * (1 - ART1731BIS) 
             + min( CELREPGL , max (ACELREPGL_P+ACELREPGLP2 , ACELREPGL1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGV = CELREPGV; 

ACELREPGV = (CELREPGV * (1 - ART1731BIS) 
             + min( CELREPGV , max (ACELREPGV_P+ACELREPGVP2 , ACELREPGV1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGK = CELREPGK; 

ACELREPGK = (CELREPGK * (1 - ART1731BIS) 
             + min( DCELREPGK , max (ACELREPGK_P+ACELREPGKP2 , ACELREPGK1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPGJ = CELREPGJ; 

ACELREPGJ = (CELREPGJ * (1 - ART1731BIS) 
             + min( CELREPGJ , max (ACELREPGJ_P+ACELREPGJP2 , ACELREPGJ1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYH = CELREPYH; 

ACELREPYH = (CELREPYH * (1 - ART1731BIS) 
             + min( CELREPYH , max (ACELREPYH_P+ACELREPYHP2 , ACELREPYH1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYL = CELREPYL; 

ACELREPYL = (CELREPYL * (1 - ART1731BIS) 
             + min( CELREPYL , max (ACELREPYL_P+ACELREPYLP2 , ACELREPYL1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYG = CELREPYG; 

ACELREPYG = (CELREPYG * (1 - ART1731BIS) 
             + min( CELREPYG , max (ACELREPYG_P+ACELREPYGP2 , ACELREPYG1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYF = CELREPYF; 

ACELREPYF = (CELREPYF * (1 - ART1731BIS) 
             + min( CELREPYF , max (ACELREPYF_P+ACELREPYFP2 , ACELREPYF1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYK = CELREPYK; 

ACELREPYK = (CELREPYK * (1 - ART1731BIS) 
             + min( CELREPYF , max (ACELREPYK_P+ACELREPYKP2 , ACELREPYK1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYE = CELREPYE; 

ACELREPYE = (CELREPYE * (1 - ART1731BIS) 
             + min( CELREPYE , max (ACELREPYE_P+ACELREPYEP2 , ACELREPYE1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYD = CELREPYD; 

ACELREPYD = (CELREPYD * (1 - ART1731BIS) 
             + min( CELREPYD , max (ACELREPYD_P+ACELREPYDP2 , ACELREPYD1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYJ = CELREPYJ; 

ACELREPYJ = (CELREPYJ * (1 - ART1731BIS) 
             + min( CELREPYJ , max (ACELREPYJ_P+ACELREPYJP2 , ACELREPYJ1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYC = CELREPYC; 

ACELREPYC = (CELREPYC * (1 - ART1731BIS) 
             + min( CELREPYC , max (ACELREPYC_P+ACELREPYCP2 , ACELREPYC1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYB = CELREPYB; 

ACELREPYB = (CELREPYB * (1 - ART1731BIS) 
             + min( CELREPYB , max (ACELREPYB_P+ACELREPYBP2 , ACELREPYB1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYI = CELREPYI; 

ACELREPYI = (CELREPYI * (1 - ART1731BIS) 
             + min( CELREPYI , max (ACELREPYI_P+ACELREPYIP2 , ACELREPYI1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELREPYA = CELREPYA; 

ACELREPYA = (CELREPYA * (1 - ART1731BIS) 
             + min( CELREPYA , max (ACELREPYA_P+ACELREPYAP2 , ACELREPYA1731 + 0 )*(1-PREM8_11)) * ART1731BIS)
		* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELHM = CELLIERHM ; 

ACELHM_R = positif_ou_nul( CELLIERHM) * BCEL_HM * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELHM = ( BCEL_HM * (1-ART1731BIS) 
          + min(BCEL_HM , max(ACELHM_P+ACELHMP2 , ACELHM1731+0)*(1-PREM8_11))* ART1731BIS )  
         * (positif_ou_nul(CELLIERHM)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELHL = CELLIERHL ;    

ACELHL_R = positif_ou_nul( CELLIERHL) * BCEL_HL * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELHL = ( BCEL_HL * (1-ART1731BIS) 
          + min(BCEL_HL , max(ACELHL_P+ACELHLP2 , ACELHL1731+0)*(1-PREM8_11))* ART1731BIS )  
         * (positif_ou_nul(CELLIERHL)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


DCELHNO = CELLIERHN + CELLIERHO ;

ACELHNO_R = positif_ou_nul( CELLIERHN + CELLIERHO ) * BCEL_HNO * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELHNO = ( BCEL_HNO * (1-ART1731BIS) 
          + min(BCEL_HNO , max(ACELHNO_P+ACELHNOP2 , ACELHNO1731+0)*(1-PREM8_11))* ART1731BIS )  
         * (positif_ou_nul(CELLIERHN + CELLIERHO)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELHJK = CELLIERHJ + CELLIERHK ;

ACELHJK_R = positif_ou_nul( CELLIERHJ + CELLIERHK ) * BCEL_HJK * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELHJK = ( BCEL_HJK * (1-ART1731BIS) 
          + min(BCEL_HJK , max(ACELHJK_P+ACELHJKP2 , ACELHJK1731+0)*(1-PREM8_11))* ART1731BIS )  
         * (positif_ou_nul(CELLIERHJ + CELLIERHK)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


DCELNQ = CELLIERNQ;

ACELNQ_R = positif_ou_nul( CELLIERNQ) * BCEL_NQ * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELNQ = ( BCEL_NQ * (1-ART1731BIS) 
          + min(BCEL_NQ , max(ACELNQ_P+ACELNQP2, ACELNQ1731+0)*(1-PREM8_11))* ART1731BIS )  
         * (positif_ou_nul(CELLIERNQ)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELNBGL =   CELLIERNB + CELLIERNG + CELLIERNL;

ACELNBGL_R = positif_ou_nul( CELLIERNB + CELLIERNG + CELLIERNL ) * BCEL_NBGL 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELNBGL = ( BCEL_NBGL * (1-ART1731BIS) 
             + min(BCEL_NBGL , max(ACELNBGL_P+ACELNBGLP2 , ACELNBGL1731+0)*(1-PREM8_11))* ART1731BIS )  
           * positif_ou_nul(CELLIERNB + CELLIERNG + CELLIERNL) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELCOM =   CELLIERNP + CELLIERNR + CELLIERNS + CELLIERNT;

ACELCOM_R = positif_ou_nul(CELLIERNP + CELLIERNR + CELLIERNS + CELLIERNT) * BCELCOM2011 
            * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELCOM = ( BCELCOM2011 * (1-ART1731BIS) 
          + min(BCELCOM2011 , max(ACELCOM_P+ACELCOMP2 , ACELCOM1731+0)*(1-PREM8_11))* ART1731BIS )  
          * positif_ou_nul(CELLIERNP + CELLIERNR + CELLIERNS + CELLIERNT) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

CELSOMN = CELLIERNA+CELLIERNC+CELLIERND+CELLIERNE+CELLIERNF+CELLIERNH
	 +CELLIERNI+CELLIERNJ+CELLIERNK+CELLIERNM+CELLIERNN+CELLIERNO;  

DCEL = CELSOMN ; 

ACEL_R = positif_ou_nul( CELSOMN ) * BCEL_2011 * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACEL = (BCEL_2011 * (1 - ART1731BIS) 
        + min(BCEL_2011 , max(ACEL_P+ACELP2 , ACEL1731+0)*(1-PREM8_11)) * ART1731BIS)  
          * positif_ou_nul(CELSOMN) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELJP = CELLIERJP;

ACELJP_R = positif_ou_nul( CELLIERJP) * BCEL_JP * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELJP = (BCEL_JP * (1 - ART1731BIS) 
          + min(BCEL_JP , max(ACELJP_P+ACELJPP2 , ACELJP1731+0)*(1-PREM8_11)) * ART1731BIS)  
          * positif_ou_nul(CELLIERJP) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELJBGL =   CELLIERJB + CELLIERJG + CELLIERJL;

ACELJBGL_R = positif_ou_nul( CELLIERJB + CELLIERJG + CELLIERJL ) * BCEL_JBGL 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELJBGL = (BCEL_JBGL * (1 - ART1731BIS) 
          + min(BCEL_JBGL , max(ACELJBGL_P+ACELJBGLP2 , ACELJBGL1731+0)*(1-PREM8_11)) * ART1731BIS)  
          * positif_ou_nul(CELLIERJB+CELLIERJG+CELLIERJL) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELJOQR =   CELLIERJO + CELLIERJQ + CELLIERJR;

ACELJOQR_R = positif_ou_nul(CELLIERJO + CELLIERJQ + CELLIERJR) * BCEL_JOQR 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELJOQR = (BCEL_JOQR * (1 - ART1731BIS) 
          + min(BCEL_JOQR , max(ACELJOQR_P+ACELJOQRP2 , ACELJOQR1731+0)*(1-PREM8_11)) * ART1731BIS)  
          * positif_ou_nul(CELLIERJO + CELLIERJQ + CELLIERJR) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


CELSOMJ = CELLIERJA + CELLIERJD + CELLIERJE + CELLIERJF + CELLIERJH 
	  + CELLIERJJ + CELLIERJK + CELLIERJM + CELLIERJN;

DCEL2012 = CELSOMJ ; 

ACEL2012_R = positif_ou_nul( CELSOMJ ) * BCEL_2012 * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACEL2012 = (BCEL_2012 * (1 - ART1731BIS) 
            + min( BCEL_2012 , max(ACEL2012_P+ ACEL2012P2 , ACEL20121731+0)*(1-PREM8_11)) * ART1731BIS)  
          * positif_ou_nul(CELSOMJ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELFD = CELLIERFD ;

ACELFD_R = positif_ou_nul(DCELFD) * BCEL_FD * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELFD = (BCEL_FD * (1 - ART1731BIS)
          + min(BCEL_FD, max(ACELFD_P+ACELFDP2 , ACELFD1731+0)*(1-PREM8_11)) * ART1731BIS)
          * positif_ou_nul(DCELFD) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DCELFABC = CELLIERFA + CELLIERFB + CELLIERFC ;

ACELFABC_R = positif_ou_nul(DCELFABC) * BCEL_FABC 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

ACELFABC = (BCEL_FABC * (1 - ART1731BIS) 
            + min(BCEL_FABC , max( ACELFABC_P+ACELFABCP2 , ACELFABC1731+0 )*(1-PREM8_11)) * ART1731BIS)
           * positif_ou_nul(DCELFABC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCEL_HM = positif(CELLIERHM) * arr (ACELHM * (TX40/100)) 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HM_R = positif(CELLIERHM) * arr (ACELHM_R * (TX40/100)) 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HL = positif( CELLIERHL ) * arr (ACELHL * (TX25/100))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HL_R = positif( CELLIERHL ) * arr (ACELHL_R * (TX25/100))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HNO = (  positif(CELLIERHN) * arr(ACELHNO * (TX25/100))
	       + positif(CELLIERHO) * arr(ACELHNO * (TX40/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HNO_R = (  positif(CELLIERHN) * arr(ACELHNO_R * (TX25/100))
	       + positif(CELLIERHO) * arr(ACELHNO_R * (TX40/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HJK = (  positif(CELLIERHJ) * arr(ACELHJK * (TX25/100))
	      + positif(CELLIERHK) * arr(ACELHJK * (TX40/100))
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_HJK_R = (  positif(CELLIERHJ) * arr(ACELHJK_R * (TX25/100))
	      + positif(CELLIERHK) * arr(ACELHJK_R * (TX40/100))
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_NQ = ( positif(CELLIERNQ) * arr(ACELNQ * (TX40/100)) ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_NQ_R = ( positif(CELLIERNQ) * arr(ACELNQ_R * (TX40/100)) ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCEL_NBGL = (  positif(CELLIERNB) * arr(ACELNBGL * (TX25/100))
	       + positif(CELLIERNG) * arr(ACELNBGL * (TX15/100))
	       + positif(CELLIERNL) * arr(ACELNBGL * (TX40/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_NBGL_R = (  positif(CELLIERNB) * arr(ACELNBGL_R * (TX25/100))
	       + positif(CELLIERNG) * arr(ACELNBGL_R * (TX15/100))
	       + positif(CELLIERNL) * arr(ACELNBGL_R * (TX40/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_COM = (  positif(CELLIERNP + CELLIERNT) * arr (ACELCOM * (TX36/100))
               + positif(CELLIERNR + CELLIERNS) * arr (ACELCOM * (TX40/100)) 
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_COM_R = (  positif(CELLIERNP + CELLIERNT) * arr (ACELCOM_R * (TX36/100))
               + positif(CELLIERNR + CELLIERNS) * arr (ACELCOM_R * (TX40/100)) 
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_2011 = (  positif(CELLIERNA + CELLIERNE) * arr (ACEL * (TX22/100))
            + positif(CELLIERNC + CELLIERND + CELLIERNH) * arr (ACEL * (TX25/100))
            + positif(CELLIERNF + CELLIERNJ) * arr (ACEL * (TX13/100))
            + positif(CELLIERNI) * arr (ACEL * (TX15/100))
	    + positif(CELLIERNM + CELLIERNN) * arr (ACEL * (TX40/100))
	    + positif(CELLIERNK + CELLIERNO) * arr (ACEL * (TX36/100))
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_2011_R = (  positif(CELLIERNA + CELLIERNE) * arr (ACEL_R * (TX22/100))
            + positif(CELLIERNC + CELLIERND + CELLIERNH) * arr (ACEL_R * (TX25/100))
            + positif(CELLIERNF + CELLIERNJ) * arr (ACEL_R * (TX13/100))
            + positif(CELLIERNI) * arr (ACEL_R * (TX15/100))
	    + positif(CELLIERNM + CELLIERNN) * arr (ACEL_R * (TX40/100))
	    + positif(CELLIERNK + CELLIERNO) * arr (ACEL_R * (TX36/100))
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_JP = ( positif(CELLIERJP) * arr(ACELJP * (TX36/100)) ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_JP_R = ( positif(CELLIERJP) * arr(ACELJP_R * (TX36/100)) ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCEL_JBGL = (  positif(CELLIERJB) * arr(ACELJBGL * (TX22/100))
	       + positif(CELLIERJG) * arr(ACELJBGL * (TX13/100))
	       + positif(CELLIERJL) * arr(ACELJBGL * (TX36/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_JBGL_R = (  positif(CELLIERJB) * arr(ACELJBGL_R * (TX22/100))
	       + positif(CELLIERJG) * arr(ACELJBGL_R * (TX13/100))
	       + positif(CELLIERJL) * arr(ACELJBGL_R * (TX36/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_JOQR = (  positif(CELLIERJQ) * arr (ACELJOQR * (TX36/100))
               + positif(CELLIERJO + CELLIERJR) * arr (ACELJOQR * (TX24/100)) 
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_JOQR_R = (  positif(CELLIERJQ) * arr (ACELJOQR_R * (TX36/100))
               + positif(CELLIERJO + CELLIERJR) * arr (ACELJOQR_R * (TX24/100)) 
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_2012 = (  positif(CELLIERJA + CELLIERJE + CELLIERJH) * arr (ACEL2012 * (TX13/100)) 
            + positif(CELLIERJD) * arr (ACEL2012 * (TX22/100))
            + positif(CELLIERJF + CELLIERJJ) * arr (ACEL2012 * (TX6/100))
            + positif(CELLIERJK + CELLIERJN) * arr (ACEL2012 * (TX24/100))
	    + positif(CELLIERJM) * arr (ACEL2012 * (TX36/100))
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_2012_R = (  positif(CELLIERJA + CELLIERJE + CELLIERJH) * arr (ACEL2012_R * (TX13/100)) 
            + positif(CELLIERJD) * arr (ACEL2012_R * (TX22/100))
            + positif(CELLIERJF + CELLIERJJ) * arr (ACEL2012_R * (TX6/100))
            + positif(CELLIERJK + CELLIERJN) * arr (ACEL2012_R * (TX24/100))
	    + positif(CELLIERJM) * arr (ACEL2012_R * (TX36/100))
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_FD = positif( CELLIERFD ) * arr (ACELFD * (TX24/100))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_FD_R = positif( CELLIERFD ) * arr (ACELFD_R * (TX24/100))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_FABC = (  positif(CELLIERFA) * arr(ACELFABC * (TX13/100))
             + positif(CELLIERFB) * arr(ACELFABC * (TX6/100))
             + positif(CELLIERFC) * arr(ACELFABC * (TX24/100))
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_FABC_R = (  positif(CELLIERFA) * arr(ACELFABC_R * (TX13/100))
               + positif(CELLIERFB) * arr(ACELFABC_R * (TX6/100))
               + positif(CELLIERFC) * arr(ACELFABC_R * (TX24/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HS = positif(CELREPHS) * arr (ACELREPHS * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HS_R = positif(CELREPHS) * arr (CELREPHS * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HR = positif( CELREPHR ) * arr (ACELREPHR * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HR_R = positif( CELREPHR ) * arr (CELREPHR * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HU = positif( CELREPHU ) * arr (ACELREPHU * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HU_R = positif( CELREPHU ) * arr (CELREPHU * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HT = positif( CELREPHT ) * arr (ACELREPHT * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HT_R = positif( CELREPHT ) * arr (CELREPHT * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HZ = positif( CELREPHZ ) * arr (ACELREPHZ * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HZ_R = positif( CELREPHZ ) * arr (CELREPHZ * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HX = positif( CELREPHX ) * arr (ACELREPHX * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HX_R = positif( CELREPHX ) * arr (CELREPHX * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HW = positif( CELREPHW ) * arr (ACELREPHW * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HW_R = positif( CELREPHW ) * arr (CELREPHW * (TX40/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREP_HV = positif( CELREPHV ) * arr (ACELREPHV * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RCELREP_HV_R = positif( CELREPHV ) * arr (CELREPHV * (TX25/100)) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 2004078:
application : iliad , batch  ;

REDUCAVTCEL = RCOTFOR + RREPA + RAIDE + RDIFAGRI + RFORET + RFIPDOM + RFIPC + RCINE + RRESTIMO + RSOCREPR
	      + RRPRESCOMP + RHEBE + RSURV + RINNO + RSOUFIP + RRIRENOV + RLOGDOM + RCREAT + RCOMP + RRETU
              + RDONS + RDUFLOTOT + RPINELTOT + RNOUV + RPLAFREPME4 + RFOR + RTOURREP + RTOUHOTR + RTOUREPA ;

RCELRREDLA_1 = max( min(ACELRREDLA, IDOM11-DEC11 - REDUCAVTCEL ) , 0 ) ;

RCELRREDLA = max(0, RCELRREDLA_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLA_1 , max(RCELRREDLA_P+RCELRREDLAP2 , RCELRREDLA1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLB_1 = max( min(ACELRREDLB , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDLA_1 ) , 0 ) ;

RCELRREDLB = max(0, RCELRREDLB_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLB_1 , max(RCELRREDLB_P+RCELRREDLBP2 ,RCELRREDLB1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLE_1 = max( min(ACELRREDLE, IDOM11-DEC11 - REDUCAVTCEL 
               - RCELRREDLA_1-RCELRREDLB_1 ) , 0 ) ;

RCELRREDLE = max(0, RCELRREDLE_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLE_1 , max(RCELRREDLE_P+RCELRREDLEP2 ,RCELRREDLE1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLM_1 = max( min(ACELRREDLM, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1 ) , 0 ) ;

RCELRREDLM = max(0, RCELRREDLM_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLM_1 , max(RCELRREDLM_P+RCELRREDLMP2 ,RCELRREDLM1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLN_1 = max( min(ACELRREDLN, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1 ) , 0 ) ;

RCELRREDLN = max(0, RCELRREDLN_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLN_1 , max(RCELRREDLN_P+RCELRREDLNP2 ,RCELRREDLN1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLC_1 = max( min(ACELRREDLC, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1 ) , 0 ) ;

RCELRREDLC = max(0, RCELRREDLC_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLC_1 , max(RCELRREDLC_P+RCELRREDLCP2 ,RCELRREDLC1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLD_1 = max( min(ACELRREDLD , IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1 ) , 0 ) ;

RCELRREDLD = max(0, RCELRREDLD_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLD_1 , max(RCELRREDLD_P+RCELRREDLDP2 ,RCELRREDLD1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLS_1 = max( min(ACELRREDLS , IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 ) , 0 ) ;

RCELRREDLS = max(0, RCELRREDLS_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLS_1 , max(RCELRREDLS_P+RCELRREDLSP2 ,RCELRREDLS1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLT_1 = max( min(ACELRREDLT, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1 ) , 0 ) ;

RCELRREDLT = max(0, RCELRREDLT_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLT_1 , max(RCELRREDLT_P+RCELRREDLTP2 ,RCELRREDLT1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLF_1 = max( min(ACELRREDLF, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1-RCELRREDLT_1 ) , 0 ) ;

RCELRREDLF = max(0, RCELRREDLF_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLF_1 , max(RCELRREDLF_P+RCELRREDLFP2 ,RCELRREDLF1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLZ_1 = max( min(ACELRREDLZ, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1-RCELRREDLT_1-RCELRREDLF_1 ) , 0 ) ;

RCELRREDLZ = max(0, RCELRREDLZ_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLZ_1 , max(RCELRREDLZ_P+RCELRREDLZP2 ,RCELRREDLZ1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDLX_1 = max( min(ACELRREDLX, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1-RCELRREDLT_1-RCELRREDLF_1-RCELRREDLZ_1 ) , 0 ) ;
RCELRREDLX = max(0, RCELRREDLX_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDLX_1 , max(RCELRREDLX_P+RCELRREDLXP2 ,RCELRREDLX1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;


RCELRREDMG_1 = max( min(ACELRREDMG, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1-RCELRREDLT_1-RCELRREDLF_1-RCELRREDLZ_1-RCELRREDLX_1 ) , 0 ) ;

RCELRREDMG = max(0, RCELRREDMG_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDMG_1 , max(RCELRREDMG_P+RCELRREDMGP2 ,RCELRREDMG1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;

RCELRREDMH_1 = max( min(ACELRREDMH, IDOM11-DEC11 - REDUCAVTCEL 
	      - RCELRREDLA_1-RCELRREDLB_1-RCELRREDLE_1-RCELRREDLM_1-RCELRREDLN_1-RCELRREDLC_1-RCELRREDLD_1 
	      - RCELRREDLS_1-RCELRREDLT_1-RCELRREDLF_1-RCELRREDLZ_1-RCELRREDLX_1-RCELRREDMG_1 ) , 0 ) ;

RCELRREDMH = max(0, RCELRREDMH_1 * (1 - ART1731BIS) 
                 + min ( RCELRREDMH_1 , max(RCELRREDMH_P+RCELRREDMHP2 ,RCELRREDMH1731+0) * (1-PREM8_11)) * ART1731BIS 
                ) ;



RCELRREDSOM = somme (i=A,B,E,M,N,C,D,S,T,F,Z,X : RCELRREDLi_1) + RCELRREDMG_1 + RCELRREDMH_1 ;

RCELREPHS_1 = max( min( RCELREP_HS ,IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM) , 0) 
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHS = max( 0, RCELREPHS_1 * (1 - ART1731BIS)
                 + min (RCELREPHS_1 , max(RCELREPHS_P+RCELREPHSP2, RCELREPHS1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHR_1 = max( min( RCELREP_HR ,IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            - RCELREPHS_1 ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHR = max( 0, RCELREPHR_1 * (1 - ART1731BIS)
                 + min (RCELREPHR_1 , max(RCELREPHR_P+RCELREPHRP2, RCELREPHR1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHU_1 = max( min( RCELREP_HU , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
         	                     - RCELREPHS_1-RCELREPHR_1 ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHU = max( 0, RCELREPHU_1 * (1 - ART1731BIS)
                 + min (RCELREPHU_1 , max(RCELREPHU_P+RCELREPHUP2, RCELREPHU1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHT_1 = max( min( RCELREP_HT, IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	                             - RCELREPHS_1-RCELREPHR_1-RCELREPHU_1 ) , 0)
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHT = max( 0, RCELREPHT_1 * (1 - ART1731BIS)
                 + min (RCELREPHT_1 , max(RCELREPHT_P+RCELREPHTP2, RCELREPHT1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHZ_1 = max( min( RCELREP_HZ , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                              - RCELREPHS_1-RCELREPHR_1-RCELREPHU_1-RCELREPHT_1 ) , 0)
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHZ = max( 0, RCELREPHZ_1 * (1 - ART1731BIS)
                 + min (RCELREPHZ_1 , max(RCELREPHZ_P+RCELREPHZP2, RCELREPHZ1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHX_1 = max( min( RCELREP_HX , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                             - RCELREPHS_1-RCELREPHR_1-RCELREPHU_1-RCELREPHT_1-RCELREPHZ_1 ) , 0)
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHX = max( 0, RCELREPHX_1 * (1 - ART1731BIS)
                 + min (RCELREPHX_1 , max(RCELREPHX_P+RCELREPHXP2, RCELREPHX1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHW_1 = max( min( RCELREP_HW , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                             - RCELREPHS_1-RCELREPHR_1-RCELREPHU_1-RCELREPHT_1-RCELREPHZ_1-RCELREPHX_1 ) , 0)
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHW = max( 0, RCELREPHW_1 * (1 - ART1731BIS)
                 + min (RCELREPHW_1 , max(RCELREPHW_P+RCELREPHWP2 , RCELREPHW1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHV_1 = max( min( RCELREP_HV , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                             - RCELREPHS_1-RCELREPHR_1-RCELREPHU_1-RCELREPHT_1-RCELREPHZ_1-RCELREPHX_1-RCELREPHW_1 ) , 0)
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHV = max( 0, RCELREPHV_1 * (1 - ART1731BIS)
                 + min (RCELREPHV_1 , max(RCELREPHV_P+RCELREPHVP2, RCELREPHV1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHF_1 = max( min( ACELREPHF , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHF = max( 0, RCELREPHF_1 * (1 - ART1731BIS)
                 + min (RCELREPHF_1 , max(RCELREPHF_P+RCELREPHFP2, RCELREPHF1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHE_1 = max( min( ACELREPHE , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHE = max( 0, RCELREPHE_1 * (1 - ART1731BIS)
                 + min (RCELREPHE_1 , max(RCELREPHE_P+RCELREPHEP2, RCELREPHE1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHD_1 = max( min( ACELREPHD , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E : RCELREPHi_1) ) , 0)
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHD = max( 0, RCELREPHD_1 * (1 - ART1731BIS)
                 + min (RCELREPHD_1 , max(RCELREPHD_P+RCELREPHDP2, RCELREPHD1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHH_1 = max( min( ACELREPHH , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHH = max( 0, RCELREPHH_1 * (1 - ART1731BIS)
                 + min (RCELREPHH_1 , max(RCELREPHH_P+RCELREPHHP2, RCELREPHH1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHG_1 = max( min( ACELREPHG , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHG = max( 0, RCELREPHG_1 * (1 - ART1731BIS)
                 + min (RCELREPHG_1 , max(RCELREPHG_P+RCELREPHGP2, RCELREPHG1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHB_1 = max( min( ACELREPHB , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHB = max( 0, RCELREPHB_1 * (1 - ART1731BIS)
                 + min (RCELREPHB_1 , max(RCELREPHB_P+RCELREPHBP2, RCELREPHB1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHA_1 = max( min( ACELREPHA , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPHA = max( 0, RCELREPHA_1 * (1 - ART1731BIS)
                 + min (RCELREPHA_1 , max(RCELREPHA_P+RCELREPHAP2, RCELREPHA1731+0) * (1-PREM8_11)) * ART1731BIS ) 
	    * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGU_1 = max( min( ACELREPGU , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGU = max( 0, RCELREPGU_1 * (1 - ART1731BIS)
                 + min (RCELREPGU_1 ,max(RCELREPGU_P+RCELREPGUP2 , RCELREPGU1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGX_1 = max( min( ACELREPGX , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -RCELREPGU_1 ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGX = max( 0, RCELREPGX_1 * (1 - ART1731BIS)
                 + min (RCELREPGX_1 ,max(RCELREPGX_P+RCELREPGXP2 , RCELREPGX1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGT_1 = max( min( ACELREPGT , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X : RCELREPGi_1 ) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGT = max( 0, RCELREPGT_1 * (1 - ART1731BIS)
                 + min (RCELREPGT_1 ,max(RCELREPGT_P+RCELREPGTP2 , RCELREPGT1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGS_1 = max( min( ACELREPGS , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T : RCELREPGi_1 ) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGS = max( 0, RCELREPGS_1 * (1 - ART1731BIS)
                 + min (RCELREPGS_1 ,max(RCELREPGS_P+RCELREPGSP2 , RCELREPGS1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGW_1 = max( min( ACELREPGW , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S : RCELREPGi_1 ) ) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGW = max( 0, RCELREPGW_1 * (1 - ART1731BIS)
                 + min (RCELREPGW_1 ,max(RCELREPGW_P+RCELREPGWP2 , RCELREPGW1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGP_1 = max( min( ACELREPGP , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGP = max( 0, RCELREPGP_1 * (1 - ART1731BIS)
                 + min (RCELREPGP_1 ,max(RCELREPGP_P+RCELREPGPP2 , RCELREPGP1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGL_1 = max( min( ACELREPGL , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGL = max( 0, RCELREPGL_1 * (1 - ART1731BIS)
                 + min (RCELREPGL_1 ,max(RCELREPGL_P+RCELREPGLP2 , RCELREPGL1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGV_1 = max( min( ACELREPGV , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGV = max( 0, RCELREPGV_1 * (1 - ART1731BIS)
                 + min (RCELREPGV_1 ,max(RCELREPGV_P+RCELREPGVP2 , RCELREPGV1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGK_1 = max( min( ACELREPGK , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGK = max( 0, RCELREPGK_1 * (1 - ART1731BIS)
                 + min (RCELREPGK_1 ,max(RCELREPGK_P+RCELREPGKP2 , RCELREPGK1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGJ_1 = max( min( ACELREPGJ , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPGJ = max( 0, RCELREPGJ_1 * (1 - ART1731BIS)
                 + min (RCELREPGJ_1 ,max(RCELREPGJ_P+RCELREPGJP2 , RCELREPGJ1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYH_1 = max( min( ACELREPYH , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYH = max( 0, RCELREPYH_1 * (1 - ART1731BIS)
                 + min (RCELREPYH_1 ,max(RCELREPYH_P+RCELREPYHP2 , RCELREPYH1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYL_1 = max( min( ACELREPYL , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -RCELREPYH_1) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYL = max( 0, RCELREPYL_1 * (1 - ART1731BIS)
                 + min (RCELREPYL_1 ,max(RCELREPYL_P+RCELREPYLP2 , RCELREPYL1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYG_1 = max( min( ACELREPYG , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYG = max( 0, RCELREPYG_1 * (1 - ART1731BIS)
                 + min (RCELREPYG_1 ,max(RCELREPYG_P+RCELREPYGP2 , RCELREPYG1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYF_1 = max( min( ACELREPYF , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYF = max( 0, RCELREPYF_1 * (1 - ART1731BIS)
                 + min (RCELREPYF_1 ,max(RCELREPYF_P+RCELREPYFP2 , RCELREPYF1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYK_1 = max( min( ACELREPYK , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYK = max( 0, RCELREPYK_1 * (1 - ART1731BIS)
                 + min (RCELREPYK_1 ,max(RCELREPYK_P+RCELREPYKP2 , RCELREPYK1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYE_1 = max( min( ACELREPYE , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYE = max( 0, RCELREPYE_1 * (1 - ART1731BIS)
                 + min (RCELREPYE_1 ,max(RCELREPYE_P+RCELREPYEP2 , RCELREPYE1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYD_1 = max( min( ACELREPYD , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYD = max( 0, RCELREPYD_1 * (1 - ART1731BIS)
                 + min (RCELREPYD_1 ,max(RCELREPYD_P+RCELREPYDP2 , RCELREPYD1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYJ_1 = max( min( ACELREPYJ , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E,D : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYJ = max( 0, RCELREPYJ_1 * (1 - ART1731BIS)
                 + min (RCELREPYJ_1 ,max(RCELREPYJ_P+RCELREPYJP2 , RCELREPYJ1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYC_1 = max( min( ACELREPYC , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E,D,J : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYC = max( 0, RCELREPYC_1 * (1 - ART1731BIS)
                 + min (RCELREPYC_1 ,max(RCELREPYC_P+RCELREPYCP2 , RCELREPYC1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYB_1 = max( min( ACELREPYB , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E,D,J,C : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYB = max( 0, RCELREPYB_1 * (1 - ART1731BIS)
                 + min (RCELREPYB_1 ,max(RCELREPYB_P+RCELREPYBP2 , RCELREPYB1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYI_1 = max( min( ACELREPYI , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E,D,J,C,B : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYI = max( 0, RCELREPYI_1 * (1 - ART1731BIS)
                 + min (RCELREPYI_1 ,max(RCELREPYI_P+RCELREPYIP2 , RCELREPYI1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYA_1 = max( min( ACELREPYA , IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM
	                            -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1)
                                    -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                                    -somme (i=H,L,G,F,K,E,D,J,C,B,I : RCELREPYi_1 )) , 0)
	      * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELREPYA = max( 0, RCELREPYA_1 * (1 - ART1731BIS)
                 + min (RCELREPYA_1 ,max(RCELREPYA_P+RCELREPYAP2 , RCELREPYA1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;



RCELHM_1 = max( min( RCEL_HM , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )) , 0)
	  * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHM = max( 0, RCELHM_1 * (1 - ART1731BIS)
              + min (RCELHM_1 , max(RCELHM_P+RCELHMP2 , RCELHM1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHL_1 = (max( min( RCEL_HL , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
                  -RCELHM_1) , 0 ))
	   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHL = max( 0, RCELHL_1 * (1 - ART1731BIS)
              + min (RCELHL_1 , max(RCELHL_P+RCELHLP2 , RCELHL1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHNO_1 = (max( min( RCEL_HNO , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1) , 0 ))
	   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHNO = max( 0, RCELHNO_1 * (1 - ART1731BIS)
              + min (RCELHNO_1 , max(RCELHNO_P+RCELHNOP2 , RCELHNO1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHJK_1 = (max( min( RCEL_HJK , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1) , 0 ))
	   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELHJK = max( 0, RCELHJK_1 * (1 - ART1731BIS)
              + min (RCELHJK_1 , max(RCELHJK_P+RCELHJKP2 , RCELHJK1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELNQ_1 = max( min( RCEL_NQ , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1 ) , 0 )
	 * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELNQ = max( 0, RCELNQ_1 * (1 - ART1731BIS)
              + min (RCELNQ_1 , max(RCELNQ_P+RCELNQP2 , RCELNQ1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELNBGL_1 = max( min( RCEL_NBGL , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1 ) , 0 )
	   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELNBGL = max( 0, RCELNBGL_1 * (1 - ART1731BIS)
              + min (RCELNBGL_1 , max(RCELNBGL_P+RCELNBGLP2 , RCELNBGL1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELCOM_1 = (max( min( RCEL_COM , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1 ) , 0 ))
	  * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELCOM = max( 0, RCELCOM_1 * (1 - ART1731BIS)
              + min (RCELCOM_1 , max(RCELCOM_P+RCELCOMP2 , RCELCOM1731+0) * (1-PREM8_11)
                    ) * ART1731BIS * (1 - positif( null(CMAJ2 - 8) + null(CMAJ2 - 11)))
            ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL_1 = max( min( RCEL_2011 , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1 ) , 0 )
	     * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL = max( 0, RCEL_1 * (1 - ART1731BIS)
              + min (RCEL_1 , max(RCEL_P+RCELP2 , RCEL1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELJP_1 = max( min( RCEL_JP , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1 ) , 0 )
	 * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELJP = max( 0, RCELJP_1 * (1 - ART1731BIS)
              + min (RCELJP_1 , max(RCELJP_P+RCELJPP2 , RCELJP1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELJBGL_1 = max( min( RCEL_JBGL , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1-RCELJP_1 ) , 0 )
	   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELJBGL = max( 0, RCELJBGL_1 * (1 - ART1731BIS)
              + min (RCELJBGL_1 , max(RCELJBGL_P+RCELJBGLP2 , RCELJBGL1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELJOQR_1 = max( min( RCEL_JOQR , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1-RCELJP_1
	          -RCELJBGL_1) , 0 )
	  * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCELJOQR = max( 0, RCELJOQR_1 * (1 - ART1731BIS)
              + min (RCELJOQR_1 , max(RCELJOQR_P+RCELJOQRP2 , RCELJOQR1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL2012_1 = max( min( RCEL_2012 , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1-RCELJP_1
	          -RCELJBGL_1-RCELJOQR_1) , 0 )
	     * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCEL2012 = max( 0, RCEL2012_1 * (1 - ART1731BIS)
              + min (RCEL2012_1 , max(RCEL2012_P+RCEL2012P2 , RCEL20121731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELFD_1 = max( min( RCEL_FD , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1-RCELJP_1
	          -RCELJBGL_1-RCELJOQR_1-RCEL2012_1) , 0 )
	     * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELFD = max( 0, RCELFD_1 * (1 - ART1731BIS)
              + min (RCELFD_1 , max(RCELFD_P+RCELFDP2 , RCELFD1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELFABC_1 = max( min( RCEL_FABC , 
                  IDOM11-DEC11 - REDUCAVTCEL - RCELRREDSOM 
	          -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
                  -somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
                  -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	          -RCELHM_1-RCELHL_1-RCELHNO_1-RCELHJK_1-RCELNQ_1-RCELNBGL_1-RCELCOM_1-RCEL_1-RCELJP_1
	          -RCELJBGL_1-RCELJOQR_1-RCEL2012_1-RCELFD_1) , 0 )
	     * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELFABC = max( 0, RCELFABC_1 * (1 - ART1731BIS)
              + min (RCELFABC_1 , max(RCELFABC_P+RCELFABCP2 , RCELFABC1731+0) * (1-PREM8_11)) * ART1731BIS 
	    ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCELTOT = RCELRREDSOM
	  + somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi) 
          + somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi )
          + somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi )
	  + RCELHM + RCELHL + RCELHNO + RCELHJK + RCELNQ + RCELNBGL + RCELCOM
	  + RCEL + RCELJP + RCELJBGL + RCELJOQR + RCEL2012 + RCELFD + RCELFABC ;

RCELTOT_1 = RCELRREDSOM
	  + somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : RCELREPHi_1) 
          + somme (i=U,X,T,S,W,P,L,V,K,J : RCELREPGi_1 )
          + somme (i=H,L,G,F,K,E,D,J,C,B,I,A : RCELREPYi_1 )
	  + RCELHM_1 + RCELHL_1 + RCELHNO_1 + RCELHJK_1 + RCELNQ_1 + RCELNBGL_1 + RCELCOM_1
	  + RCEL_1 + RCELJP_1 + RCELJBGL_1 + RCELJOQR_1 + RCEL2012_1 + RCELFD_1 + RCELFABC_1 ;

regle 2004079 :
application : iliad , batch  ;


RIVCELFABC1 = (  positif(CELLIERFA) * arr(BCEL_FABC * (TX13/100))
               + positif(CELLIERFB) * arr(BCEL_FABC * (TX6/100))
               + positif(CELLIERFC) * arr(BCEL_FABC * (TX24/100))
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
 
RIVCELFABC8 = (arr((min (CELLIERFA+CELLIERFB+CELLIERFC,LIMCELLIER) * positif(CELLIERFA) * (TX13/100))
          +(min (CELLIERFA+CELLIERFB+CELLIERFC,LIMCELLIER) * positif(CELLIERFB) * (TX6/100))
          +(min (CELLIERFA+CELLIERFB+CELLIERFC,LIMCELLIER) * positif(CELLIERFC) * (TX24/100)))
          -( 8 * RIVCELFABC1))
          * (1 - V_CNR);

RIVCELFD1 = positif( CELLIERFD ) * arr (BCEL_FD * (TX24/100))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RIVCELFD4 = (arr((min (CELLIERFD, LIMCELLIER) * positif(CELLIERFD) * (TX24/100)))
              - ( 4 * RIVCELFD1))
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RIVCEL1 =  RCEL_2011_R * positif(ACEL_R); 

RIVCEL2 = RIVCEL1;

RIVCEL3 = RIVCEL1;

RIVCEL4 = RIVCEL1;

RIVCEL5 = RIVCEL1;

RIVCEL6 = RIVCEL1;

RIVCEL7 = RIVCEL1;

RIVCEL8 = (arr((min (CELSOMN,LIMCELLIER) * positif(CELLIERNM+CELLIERNN) * (TX40/100))
          +(min (CELSOMN,LIMCELLIER) * positif(CELLIERNK+CELLIERNO) * (TX36/100))
	  +(min (CELSOMN,LIMCELLIER) * positif(CELLIERNC+CELLIERND+CELLIERNH) * (TX25/100))
	  +(min (CELSOMN,LIMCELLIER) * positif(CELLIERNA+CELLIERNE) * (TX22/100))
	  +(min (CELSOMN,LIMCELLIER) * positif(CELLIERNI) * (TX15/100))
	  +(min (CELSOMN,LIMCELLIER) * positif(CELLIERNF+CELLIERNJ) * (TX13/100)))
	  -( 8 * RIVCEL1))
	  * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
RIV2012CEL1 =  RCEL_2012_R * positif(ACEL2012_R) ;
RIV2012CEL2 = RIV2012CEL1;
RIV2012CEL3 = RIV2012CEL1;
RIV2012CEL4 = RIV2012CEL1;
RIV2012CEL5 = RIV2012CEL1;
RIV2012CEL6 = RIV2012CEL1;
RIV2012CEL7 = RIV2012CEL1;

RIV2012CEL8 = (arr((min (CELSOMJ,LIMCELLIER) * positif(CELLIERJM) * (TX36/100))
		+(min (CELSOMJ,LIMCELLIER) * positif(CELLIERJK+CELLIERJN) * (TX24/100))
		+(min (CELSOMJ,LIMCELLIER) * positif(CELLIERJD) * (TX22/100))
		+(min (CELSOMJ,LIMCELLIER) * positif(CELLIERJA+CELLIERJE+CELLIERJH) * (TX13/100))
		+(min (CELSOMJ,LIMCELLIER) * positif(CELLIERJF+CELLIERJJ) * (TX6/100)))
	 	-( 8 * RIV2012CEL1))
 		* (1 - V_CNR);


RIVCELNBGL1 =  RCEL_NBGL_R * positif(ACELNBGL_R); 
RIVCELNBGL2 = RIVCELNBGL1;
RIVCELNBGL3 = RIVCELNBGL1;
RIVCELNBGL4 = RIVCELNBGL1;
RIVCELNBGL5 = RIVCELNBGL1;
RIVCELNBGL6 = RIVCELNBGL1;
RIVCELNBGL7 = RIVCELNBGL1;

RIVCELNBGL8 = (arr((min (CELLIERNB+CELLIERNG+CELLIERNL,LIMCELLIER) * positif(CELLIERNB) * (TX25/100))
          +(min (CELLIERNB+CELLIERNG+CELLIERNL,LIMCELLIER) * positif(CELLIERNG) * (TX15/100))
	  +(min (CELLIERNB+CELLIERNG+CELLIERNL,LIMCELLIER) * positif(CELLIERNL) * (TX40/100)))
	  -( 8 * RIVCELNBGL1))
	  * (1 - V_CNR);

RIVCELJBGL1 =  RCEL_JBGL_R * positif(ACELJBGL_R); 
RIVCELJBGL2 = RIVCELJBGL1;
RIVCELJBGL3 = RIVCELJBGL1;
RIVCELJBGL4 = RIVCELJBGL1;
RIVCELJBGL5 = RIVCELJBGL1;
RIVCELJBGL6 = RIVCELJBGL1;
RIVCELJBGL7 = RIVCELJBGL1;

RIVCELJBGL8 = (arr((min (CELLIERJB+CELLIERJG+CELLIERJL,LIMCELLIER) * positif(CELLIERJB) * (TX22/100))
          +(min (CELLIERJB+CELLIERJG+CELLIERJL,LIMCELLIER) * positif(CELLIERJG) * (TX13/100))
	  +(min (CELLIERJB+CELLIERJG+CELLIERJL,LIMCELLIER) * positif(CELLIERJL) * (TX36/100)))
	  -( 8 * RIVCELJBGL1))
	  * (1 - V_CNR);


RIVCELCOM1 =  RCEL_COM_R * positif(ACELCOM_R); 

RIVCELCOM2 = RIVCELCOM1;

RIVCELCOM3 = RIVCELCOM1;

RIVCELCOM4 = (arr((min (CELLIERNP+CELLIERNR+CELLIERNS+CELLIERNT, LIMCELLIER) * positif(CELLIERNP+CELLIERNT) * (TX36/100))
          +(min (CELLIERNP+CELLIERNR+CELLIERNS+CELLIERNT,LIMCELLIER) * positif(CELLIERNR+CELLIERNS) * (TX40/100)))
	  -( 4 * RIVCELCOM1))
	  * (1 - V_CNR);

RIVCELJOQR1 =  RCEL_JOQR_R * positif(ACELJOQR_R); 
RIVCELJOQR2 = RIVCELJOQR1;
RIVCELJOQR3 = RIVCELJOQR1;
RIVCELJOQR4 = (arr((min (CELLIERJO + CELLIERJQ + CELLIERJR, LIMCELLIER) * positif(CELLIERJQ) * (TX36/100))
          +(min (CELLIERJO + CELLIERJQ + CELLIERJR, LIMCELLIER) * positif(CELLIERJO+CELLIERJR) * (TX24/100)))
	  -( 4 * RIVCELJOQR1))
	  * (1 - V_CNR);


RIVCELNQ1 =  RCEL_NQ_R * positif(ACELNQ_R); 

RIVCELNQ2 = RIVCELNQ1;

RIVCELNQ3 = RIVCELNQ1;

RIVCELNQ4 = (arr((min (CELLIERNQ, LIMCELLIER) * positif(CELLIERNQ) * (TX40/100)))
	  -( 4 * RIVCELNQ1))
	  * (1 - V_CNR);

RIVCELJP1 =  RCEL_JP_R * positif(ACELJP_R); 
RIVCELJP2 = RIVCELJP1;
RIVCELJP3 = RIVCELJP1;

RIVCELJP4 = (arr((min (CELLIERJP, LIMCELLIER) * positif(CELLIERJP) * (TX36/100)))
	  -( 4 * RIVCELJP1))
	  * (1 - V_CNR);


RIVCELHJK1 = RCEL_HJK_R * positif(ACELHJK_R) ; 

RIVCELHJK2 = RIVCELHJK1;

RIVCELHJK3 = RIVCELHJK1;

RIVCELHJK4 = RIVCELHJK1;

RIVCELHJK5 = RIVCELHJK1;

RIVCELHJK6 = RIVCELHJK1;

RIVCELHJK7 = RIVCELHJK1;

RIVCELHJK8 = (arr((min ((CELLIERHK + CELLIERHJ + 0 ), LIMCELLIER ) * positif(CELLIERHJ) * (TX25/100))
	     + (min ((CELLIERHK + CELLIERHJ + 0 ), LIMCELLIER ) * positif(CELLIERHK) * (TX40/100)))  
	     - ( 8 * RIVCELHJK1))
	     * (1 - V_CNR);

RIVCELHNO1 = RCEL_HNO_R * positif(ACELHNO_R) ; 

RIVCELHNO2 = RIVCELHNO1;

RIVCELHNO3 = RIVCELHNO1;

RIVCELHNO4 = RIVCELHNO1;

RIVCELHNO5 = RIVCELHNO1;

RIVCELHNO6 = RIVCELHNO1;

RIVCELHNO7 = RIVCELHNO1;

RIVCELHNO8 = (arr((min ((CELLIERHN + CELLIERHO + 0 ), LIMCELLIER ) * positif(CELLIERHN) * (TX25/100))
	     + (min ((CELLIERHN + CELLIERHO + 0 ), LIMCELLIER ) * positif(CELLIERHO) * (TX40/100)))  
	     - ( 8 * RIVCELHNO1))
	     * (1 - V_CNR);

RIVCELHLM1 = RCEL_HL_R * positif(ACELHL_R) + RCEL_HM_R * positif(ACELHM_R); 

RIVCELHLM2 = RIVCELHLM1;

RIVCELHLM3 = RIVCELHLM1;

RIVCELHLM4 = RIVCELHLM1;

RIVCELHLM5 = RIVCELHLM1;

RIVCELHLM6 = RIVCELHLM1;

RIVCELHLM7 = RIVCELHLM1;

RIVCELHLM8 = (arr((min ((CELLIERHL + CELLIERHM + 0 ), LIMCELLIER ) * positif(CELLIERHL) * (TX25/100))
	     + (min ((CELLIERHL + CELLIERHM + 0 ), LIMCELLIER ) * positif(CELLIERHM) * (TX40/100)))  
	     - ( 8 * RIVCELHLM1))
	     * (1 - V_CNR);

RRCELMG = max(0, CELRREDMG - RCELRREDMG) * positif(CELRREDMG) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELMH = max(0, CELRREDMH - RCELRREDMH) * positif(CELRREDMH) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 



RRCEL2012 = ( max(0, CELREPYJ+CELREPYI+CELREPYB+CELREPYA 
                      - RCELREPYJ-RCELREPYI-RCELREPYB-RCELREPYA
                  ) * positif(somme(i= J,I,B,A : CELREPYi))
             + max(0, RCEL_2012_R - RCEL2012) * positif(CELSOMJ) 
             + max(0, RCEL_JOQR_R - RCELJOQR) * positif(somme(i=O,Q,R:CELLIERJi)) 
             + max(0, CELREPGV - RCELREPGV) * positif(CELREPGV)
             + max(0, CELREPGJ - RCELREPGJ) * positif(CELREPGJ)
             + max(0, RCEL_FABC_R - RCELFABC ) * positif(CELLIERFA +CELLIERFB + CELLIERFC)
             + max(0, RCEL_FD_R - RCELFD ) * positif(CELLIERFD)
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLF = (max(0, CELRREDLF - RCELRREDLF)) * positif(CELRREDLF) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLZ = (max(0, CELRREDLZ - RCELRREDLZ)) * positif(CELRREDLZ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLX = (max(0, CELRREDLX - RCELRREDLX)) * positif(CELRREDLX) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RRCEL2011 =  max( 0, ( RCEL_2011_R - RCEL) * positif(CELSOMN) 
                      + ( RCEL_COM_R - RCELCOM) * positif(somme(i=P,R,S,T:CELLIERNi))
                      + ( CELREPYC + CELREPYD + CELREPYK 
                          - RCELREPYC - RCELREPYD - RCELREPYK 
                        ) * positif( somme(i= C,D,K : CELREPYi)) 
                      + ( CELREPGW + CELREPGL + CELREPGK + CELREPHG + CELREPHA + RCEL_JBGL_R + RCEL_JP_R
                          -RCELREPGW - RCELREPGL - RCELREPGK - RCELREPHG - RCELREPHA - RCELJBGL - RCELJP
                        ) * positif( somme(i=W,L,K: CELREPGi) + CELREPHG + CELREPHA + somme(i=B,G,L,P:CELLIERJi)) 
                 )
                   * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RRCELLC = max(0, CELRREDLC - RCELRREDLC) * positif(CELRREDLC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLD = max(0, CELRREDLD - RCELRREDLD) * positif(CELRREDLD) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLS = max(0, CELRREDLS - RCELRREDLS) * positif(CELRREDLS) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLT = max(0, CELRREDLT - RCELRREDLT) * positif(CELRREDLT) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RRCEL2010 = max( 0, ( CELREPYE + CELREPYF + CELREPYL
                       -RCELREPYE - RCELREPYF - RCELREPYL) * positif(CELREPYE + CELREPYF + CELREPYL)  

                   + ( CELREPGX + CELREPGS + CELREPGP
                       - RCELREPGX - RCELREPGS - RCELREPGP) * positif(CELREPGX + CELREPGS + CELREPGP)

	           + ( CELREPHH + CELREPHD + CELREPHB + RCELREP_HW_R + RCELREP_HV_R
                       - RCELREPHH - RCELREPHD - RCELREPHB - RCELREPHW - RCELREPHV) * positif(CELREPHH + CELREPHD + CELREPHB + CELREPHW + CELREPHV)

                   + ( RCEL_NQ_R   + RCEL_NBGL_R + RCEL_HJK_R
		       - RCELNQ - RCELNBGL - RCELHJK ) * positif(somme(i=Q,B,G,L:CELLIERNi) + CELLIERHJ + CELLIERHK)
                 ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RRCELLA = max(0, CELRREDLA - RCELRREDLA) * positif(CELRREDLA) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLB = max(0, CELRREDLB - RCELRREDLB) * positif(CELRREDLB) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLE = max(0, CELRREDLE - RCELRREDLE) * positif(CELRREDLE) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRCELLM = max(0, CELRREDLM - RCELRREDLM) * positif(CELRREDLM) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

RRCELLN = max(0, CELRREDLN - RCELRREDLN) * positif(CELRREDLN) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ; 

RRCELHH = max(0, RCEL_HL_R+RCEL_HM_R+RCEL_HNO_R + somme(i=R,S,T,U,X,Z:RCELREP_Hi_R) 
                 -(RCELHL +RCELHM +RCELHNO  + somme(i=R,S,T,U,X,Z:RCELREPHi)))
               * positif(somme(i=R,S,T,U,X,Z:CELREPHi)+somme(i=L,M,N,O:CELLIERHi)) ;


RRCEL2009 = max(0,  RRCELHH 
                    + ( CELREPGU + CELREPGT + CELREPHF + CELREPHE
                        - RCELREPGU - RCELREPGT - RCELREPHF - RCELREPHE 
                      ) * positif( CELREPGU + CELREPGT + CELREPHF + CELREPHE ) 
                    + ( CELREPYG + CELREPYH - RCELREPYG - RCELREPYH 
                      ) * positif( CELREPYG + CELREPYH ) 
                )  * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

REPCELFABC = 7 * RIVCELFABC1 + RIVCELFABC8;
REPCELFD = 3 * RIVCELFD1 + RIVCELFD4;  

REPCEL = somme(i=1,2,3,4,5,6,7 : RIVCELi) + RIVCEL8;  
REPCEL2012 = somme(i=1,2,3,4,5,6,7 : RIV2012CELi) + RIV2012CEL8;  

REPCELNBGL = somme(i=1,2,3,4,5,6,7 : RIVCELNBGLi) + RIVCELNBGL8;  
REPCELJBGL = somme(i=1,2,3,4,5,6,7 : RIVCELJBGLi) + RIVCELJBGL8;  

REPCELCOM = somme(i=1,2,3 : RIVCELCOMi) + RIVCELCOM4;  
REPCELJOQR = somme(i=1,2,3 : RIVCELJOQRi) + RIVCELJOQR4;  

REPCELNQ = somme(i=1,2,3 : RIVCELNQi) + RIVCELNQ4;  
REPCELJP = somme(i=1,2,3 : RIVCELJPi) + RIVCELJP4;  

REPCELHJK = somme(i=1,2,3,4,5,6,7 : RIVCELHJKi) + RIVCELHJK8;  
REPCELHNO = somme(i=1,2,3,4,5,6,7 : RIVCELHNOi) + RIVCELHNO8;  
REPCELHLM = somme(i=1,2,3,4,5,6,7 : RIVCELHLMi) + RIVCELHLM8;  

regle 40791 :
application : iliad , batch  ;

RITOUR = RILNEUF 
        + RILTRA
	+ RILRES
        + arr((RINVLOCINV + REPINVTOU + INVLOCXN + COD7UY) * TX_REDIL25 / 100)
        + arr((RINVLOCREA + INVLOGREHA + INVLOCXV + COD7UZ) * TX_REDIL20 / 100) ;

RIHOTR = arr((INVLOCHOTR + INVLOGHOT) * TX_REDIL25 / 100) * (1-positif(null(2-V_REGCO)+null(4-V_REGCO)));



DTOURREP = RINVLOCINV + REPINVTOU + INVLOCXN + COD7UY ;

ATOURREP = DTOURREP * (1 - ART1731BIS) 
           + min(DTOURREP , max( ATOURREP_P + ATOURREPP2 ,  ATOURREP1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

DTOUHOTR = INVLOCHOTR + INVLOGHOT ;

ATOUHOTR = (DTOUHOTR * (1 - ART1731BIS) 
            + min(DTOUHOTR , max(ATOUHOTR_P + ATOUHOTRP2 , ATOUHOTR1731 + 0) * (1-PREM8_11)) * ART1731BIS
	   ) * (1 - positif(null(2 - V_REGCO) + null(4 - V_REGCO))) ;

DTOUREPA = RINVLOCREA + INVLOGREHA + INVLOCXV + COD7UZ ;

ATOUREPA = DTOUREPA * (1 - ART1731BIS) 
           + min(DTOUREPA , max(ATOUREPA_P + ATOUREPAP2 , ATOUREPA1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

regle 10040791 :
application : iliad , batch  ;

RTOURREP_1 = max(min( arr(ATOURREP * TX_REDIL25 / 100) , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR) , 0) ;

RTOURREP = RTOURREP_1 * (1-ART1731BIS) 
           + min( RTOURREP_1 , max(RTOURREP_P+RTOURREPP2 , RTOURREP1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

RTOUHOTR_1 = max(min( RIHOTR , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP) , 0)
	    * (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))) ;

RTOUHOTR = RTOUHOTR_1 * (1-ART1731BIS) 
           + min( RTOUHOTR_1 , max(RTOUHOTR_P+RTOUHOTRP2 , RTOUHOTR1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

RTOUREPA_1 = max(min( arr(ATOUREPA * TX_REDIL20 / 100) ,
                      RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR) , 0) ;

RTOUREPA = RTOUREPA_1 * (1-ART1731BIS) 
           + min( RTOUREPA_1 , max(RTOUREPA_P+RTOUREPAP2 , RTOUREPA1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

RTOUR = RTOURREP ;

regle 407011 :
application : iliad , batch  ;
BADCRE = min (CREAIDE, min((LIM_AIDOMI * (1 - positif(PREMAIDE)) + LIM_PREMAIDE * positif(PREMAIDE) 
		           + MAJSALDOM * ( positif_ou_nul(V_ANREV-V_0DA-65)
				         + positif_ou_nul(V_ANREV-V_0DB-65)
						     * BOOL_0AM
				         + V_0CF + V_0DJ + V_0DN 
				         + (V_0CH + V_0DP)/2
				         ) 
		           ),LIM_AIDOMI3 * (1 - positif(PREMAIDE)) + LIM_PREMAIDE2 * positif(PREMAIDE) ) * (1-positif(INAIDE + 0))
                    +  LIM_AIDOMI2 * positif(INAIDE + 0));
BADPLAF = (min((LIM_AIDOMI * (1 - positif(PREMAIDE)) + LIM_PREMAIDE * positif(PREMAIDE) 
		           + MAJSALDOM * ( positif_ou_nul(V_ANREV-V_0DA-65)
				         + positif_ou_nul(V_ANREV-V_0DB-65)
						     * BOOL_0AM
				         + V_0CF + V_0DJ + V_0DN 
				         + (V_0CH + V_0DP)/2
				         ) 
		          ),LIM_AIDOMI3 * (1 - positif(PREMAIDE)) + LIM_PREMAIDE2 * positif(PREMAIDE) ) * (1-positif(INAIDE + 0))
                    +  LIM_AIDOMI2 * positif(INAIDE + 0)) * positif(RVAIDE) ;
BADPLAF2 = (min((LIM_AIDOMI * (1 - positif(PREMAIDE)) + LIM_PREMAIDE * positif(PREMAIDE) 
		           + MAJSALDOM * ( positif_ou_nul(V_ANREV-V_0DA-65)
				         + positif_ou_nul(V_ANREV-V_0DB-65)
						     * BOOL_0AM
				         + ASCAPA  
				         + V_0CF + V_0DJ + V_0DN 
				         + (V_0CH + V_0DP)/2
				         ) 
		          ),LIM_AIDOMI3 * (1 - positif(PREMAIDE)) + LIM_PREMAIDE2 * positif(PREMAIDE) ) * (1-positif(INAIDE + 0))
                    +  LIM_AIDOMI2 * positif(INAIDE + 0)) * positif(RVAIDAS) ;

BAD1 = min(RVAIDE , max(0 , BADPLAF - BADCRE)) ;

BAD2 = min (RVAIDAS , max(0 , BADPLAF2 - BADCRE - BAD1)) ;

BAD = BAD1 + BAD2 ;

RAD = arr(BAD * TX_AIDOMI /100) * (1 - V_CNR) ;

DAIDE = RVAIDE + RVAIDAS ;

AAIDE = (BAD * (1-ART1731BIS) 
         + min(BAD , max(AAIDE_P + AAIDEP2 , AAIDE1731+0) * (1-PREM8_11)) * ART1731BIS) * (1-V_CNR) ;

RAIDE_1 = max( min( RAD , IDOM11-DEC11-RCOTFOR_1-RREPA_1),0);

RAIDE = max( RAIDE_1 * (1-ART1731BIS) 
             + min(RAIDE_1, max(RAIDE_P+RAIDEP2 , RAIDE1731+0) * (1-PREM8_11)) * ART1731BIS , 0 ) ;

regle 4071 :
application : iliad , batch  ;



DPATNAT1 = PATNAT1;
APATNAT1 = (PATNAT1 * (1-ART1731BIS) 
            + min(PATNAT1 , max(APATNAT1_P+APATNAT1P2 , APATNAT11731+0)*(1-PREM8_11)) * ART1731BIS
           ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


DPATNAT2 = PATNAT2;
APATNAT2 = (PATNAT2 * (1-ART1731BIS) 
            + min(PATNAT2 , max(APATNAT2_P+APATNAT2P2 , APATNAT21731+0)*(1-PREM8_11)) * ART1731BIS
           ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


DPATNAT3 = PATNAT3;
APATNAT3 = (PATNAT3 * (1-ART1731BIS) 
            + min(PATNAT3 , max(APATNAT3_P+APATNAT3P2 , APATNAT31731+0)*(1-PREM8_11)) * ART1731BIS
           ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;



DPATNAT = PATNAT4;
APATNAT = (PATNAT4 * (1-ART1731BIS) 
           + min(PATNAT4 , max(APATNAT_P+APATNATP2 , APATNAT1731+0)*(1-PREM8_11)) * ART1731BIS
          ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 20004071 :
application : iliad , batch  ;

 


RPATNAT1_1  = max( min( APATNAT1, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR
                                      -RTOUREPA-RCELTOT-RLOCNPRO) , 0 )
               * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RPATNAT1 = max( 0 , RPATNAT1_1 * (1-ART1731BIS) 
                    + min( RPATNAT1_1 , max(RPATNAT1_P+RPATNAT1P2 , RPATNAT11731+0 ) * (1-PREM8_11)) * ART1731BIS  
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RPATNAT2_1 = max( min( APATNAT2, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR 
			               -RTOUREPA-RCELTOT-RLOCNPRO-RPATNAT1) , 0 )
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RPATNAT2 = max( 0 , RPATNAT2_1 * (1-ART1731BIS) 
                    + min( RPATNAT2_1 , max(RPATNAT2_P+RPATNAT2P2 , RPATNAT21731+0 ) * (1-PREM8_11)) * ART1731BIS 
              )* (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RPATNAT3_1 = max( min( APATNAT3, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR 
			              -RTOUREPA-RCELTOT-RLOCNPRO-RPATNAT1-RPATNAT2) , 0 )
              * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RPATNAT3 = max( 0 , RPATNAT3_1 * (1-ART1731BIS) 
                    + min( RPATNAT3_1 , max(RPATNAT3_P +RPATNAT3P2 , RPATNAT31731+0 ) * (1-PREM8_11)) * ART1731BIS 
              ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RPATNAT_1 = max( min( APATNAT , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4-RFOR-RTOURREP-RTOUHOTR 
			             -RTOUREPA-RCELTOT-RLOCNPRO-RPATNAT1-RPATNAT2-RPATNAT3 ) , 0 ) 
             * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RPATNAT = max( 0 , RPATNAT_1  * (1-ART1731BIS) 
                   + min( RPATNAT_1 , max(RPATNAT_P+RPATNATP2 , RPATNAT1731+0 ) * (1-PREM8_11)) * ART1731BIS  
             ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RPATNATOT = RPATNAT1 + RPATNAT2 + RPATNAT3 + RPATNAT; 
regle 200040711 :
application : iliad , batch  ;

 

REPNATR1 = max(PATNAT1 - RPATNAT1,0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

REPNATR2 = max(PATNAT2 - RPATNAT2,0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

REPNATR3 = max(PATNAT3 - RPATNAT3,0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

REPNATR = max(PATNAT4 -  RPATNAT,0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40704 :
application : iliad , batch  ;

RRI1_1 = (IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE-RRESTIMO
	     -RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
       ) * (1-ART1731BIS)
     + (min(IDOM111731+0,IDOM11) - min(DEC111731+0,DEC11) - min(RCOTFOR1731+0,RCOTFOR) - min(RREPA1731+0,RREPA)
	- min(RFIPDOM1731+0,RFIPDOM) - min(RAIDE1731+0,RAIDE) - min(RDIFAGRI1731+0,RDIFAGRI)
	- min(RFORET1731+0,RFORET) - min(RFIPC1731+0,RFIPC) - min(RCINE1731+0,RCINE) - min(RRESTIMO1731+0,RRESTIMO)
	- min(RSOCREPR1731+0,RSOCREPR) - min(RRPRESCOMP1731+0,RRPRESCOMP) - min(RHEBE1731+0,RHEBE) 
	- min(RSURV1731+0,RSURV) - min(RINNO1731+0,RINNO) - min(RSOUFIP1731+0,RSOUFIP) - min(RRIRENOV1731+0,RRIRENOV)
	) * ART1731BIS ;
RRI1 = IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE-RRESTIMO
            -RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV;

regle 4070111 :
application : iliad , batch  ;
BAH = (min (RVCURE,LIM_CURE) + min(RCCURE,LIM_CURE)) * (1 - V_CNR) ;

RAH = arr (BAH * TX_CURE /100) ;

DHEBE = RVCURE + RCCURE ;

AHEBE = BAH * (1-ART1731BIS)
        + min(BAH , max(AHEBE_P + AHEBEP2 , AHEBE1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

RHEBE_1 = max( min( RAH , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1
			-RCINE_1-RRESTIMO_1-RSOCREPR_1-RRPRESCOMP_1) , 0 );

RHEBE = max( 0, RHEBE_1 * (1-ART1731BIS) 
                + min( RHEBE_1 , max(RHEBE_P+RHEBEP2 , RHEBE1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 407013:
application : iliad , batch  ;

DREPA = RDREP + DONETRAN;

EXCEDANTA = max(0,RDREP + DONETRAN - PLAF_REDREPAS) ;

BAA = min( RDREP + DONETRAN, PLAF_REDREPAS ) ;

RAA = arr( (TX_REDREPAS) / 100 * BAA ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

AREPA = ( BAA * (1-ART1731BIS) 
          + min( BAA, max(AREPA_P + AREPAP2 , AREPA1731+0) * (1-PREM8_11)) * ART1731BIS 
        ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RREPA_1 = max( min( RAA , IDOM11-DEC11-RCOTFOR_1) , 0) ;

RREPA = RREPA_1 * (1-ART1731BIS) 
        + min( RREPA_1 , max(RREPA_P+RREPAP2 , RREPA1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

regle 407014:
application : iliad , batch  ;
DNOUV = REPSNO3 + REPSNO2 + REPSNO1 + REPSNON + COD7CQ + COD7CR + PETIPRISE + RDSNO ;

BSN1 = min (REPSNO3 + REPSNO2 + REPSNO1 + REPSNON + PETIPRISE , LIM_SOCNOUV2 * (1 + BOOL_0AM)) ;
BSN2 = min (COD7CQ + COD7CR + RDSNO , LIM_TITPRISE * (1 + BOOL_0AM) - BSN1) ;

BSNCL = min(REPSNO3 , LIM_SOCNOUV2 * (1 + BOOL_0AM)) ;
RSN_CL =  BSNCL * TX25/100 ;

BSNCM = max(0, min(REPSNO2 , LIM_SOCNOUV2 * (1 + BOOL_0AM) - BSNCL)) ;
RSN_CM = BSNCM * TX22/100 ;

BSNCN = max(0, min(REPSNO1 , LIM_SOCNOUV2 * (1 + BOOL_0AM) - BSNCL - BSNCM)) ;
RSN_CN = BSNCN * TX18/100 ;

BSNCC = max(0, min(REPSNON , LIM_SOCNOUV2 * (1 + BOOL_0AM) - BSNCL - BSNCM - BSNCN)) ;
RSN_CC = BSNCC * TX18/100 ;

BSNCU = max(0, min(PETIPRISE , LIM_SOCNOUV2 * (1 + BOOL_0AM) - BSNCL - BSNCM - BSNCN - BSNCC)) ;
RSN_CU = BSNCU * TX18/100 ;

BSNCQ = max(0, min(COD7CQ , LIM_TITPRISE * (1 + BOOL_0AM) - BSN1)) ;
RSN_CQ = BSNCQ * TX18/100 ;

BSNCR = max(0, min(COD7CR , LIM_TITPRISE * (1 + BOOL_0AM) - BSN1 - BSNCQ)) ;
RSN_CR = BSNCR * TX18/100 ;

BSNCF = max(0, min(RDSNO , LIM_TITPRISE * (1 + BOOL_0AM) - BSN1 - BSNCQ  - BSNCR)) ;
RSN_CF = BSNCF * TX18/100 ;

RSN = arr(RSN_CL + RSN_CM + RSN_CN + RSN_CC + RSN_CU + RSN_CQ + RSN_CR + RSN_CF) * (1 - V_CNR) ;

ANOUV = ((BSN1 + BSN2) * (1-ART1731BIS) 
          + min(BSN1 + BSN2 , max(ANOUV_P + ANOUVP2 , ANOUV1731+0) * (1-PREM8_11)) * ART1731BIS 
        ) * (1 - V_CNR) ;

regle 200407014:
application : iliad , batch  ;

RSNCL = max(0, min(RSN_CL, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT)) ;
RSNCM = max(0, min(RSN_CM, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL )) ;
RSNCN = max(0, min(RSN_CN, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM )) ;
RSNCC = max(0, min(RSN_CC, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM-RSNCN )) ;
RSNCU = max(0, min(RSN_CU, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM-RSNCN-RSNCC )) ;
RSNCQ = max(0, min(RSN_CQ, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM-RSNCN-RSNCC-RSNCU )) ;
RSNCR = max(0, min(RSN_CR, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM-RSNCN-RSNCC-RSNCU-RSNCQ )) ;
RSNCF = max(0, min(RSN_CF, RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RSNCL-RSNCM-RSNCN-RSNCC-RSNCU-RSNCQ-RSNCR )) ;

RNOUV_1 = max( min( RSN , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT) , 0) ;

RNOUV = ( RNOUV_1 * (1-ART1731BIS)
          + min( RNOUV_1, max( RNOUV_P+RNOUVP2 , RNOUV1731 + 0 ) * (1-PREM8_11)) * ART1731BIS 
        ) * (1 - V_CNR) ;


regle 40701:
application : iliad , batch  ;


DPLAFREPME4 = COD7CY ;
APLAFREPME4 = COD7CY * positif(COD7CY) * (1 - V_CNR);
RPLAFREPME4 = max( min( APLAFREPME4 , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU-RDONS 
                                          -RDUFLOTOT-RPINELTOT-RNOUV) , 0) ;

RPENTCY =  RPLAFREPME4 ;

regle 2004070141:
application : iliad , batch  ;

REPINVPME3 = max(0 , REPSNO2 - max(0 , (LIM_SOCNOUV2 * (1+BOOL_0AM)) - min(REPSNO3 , LIM_SOCNOUV2 * (1+BOOL_0AM)))) 
	      * (1 - V_CNR) ; 

REPINVPME2 = max(0 , REPSNO1 - max(0 , (LIM_SOCNOUV2 * (1+BOOL_0AM)) - (min(REPSNO3 , LIM_SOCNOUV2 * (1+BOOL_0AM)) + REPSNO2))) 
	      * (1 - V_CNR) ;

REPINVPME1 = max(0 , REPSNON - max(0 , (LIM_SOCNOUV2 * (1+BOOL_0AM)) - (min(REPSNO3 , LIM_SOCNOUV2 * (1+BOOL_0AM)) + REPSNO2 + REPSNO1)))
	      * (1 - V_CNR) ;

REPINVPMECU = max(0 , PETIPRISE - max(0 , (LIM_SOCNOUV2 * (1+BOOL_0AM)) - (min(REPSNO3 , LIM_SOCNOUV2 * (1+BOOL_0AM)) + REPSNO2 + REPSNO1 + REPSNON)))
	      * (1 - V_CNR) ;

RINVTPME12 = max(0 , COD7CQ - max(0 , (LIM_TITPRISE * (1+BOOL_0AM)) - (min( BSNCL + REPSNO2 + REPSNO1 + REPSNON + PETIPRISE , LIM_SOCNOUV2 * (1 + BOOL_0AM)))))
	      * (1 - V_CNR) ;

RINVTPME13 = max(0 , COD7CR - max(0 , (LIM_TITPRISE * (1 + BOOL_0AM)) 
			     - max(0 , min( BSNCL + REPSNO2 + REPSNO1 + REPSNON + PETIPRISE , LIM_SOCNOUV2 * (1 + BOOL_0AM)) + COD7CQ)))
	      * (1 - V_CNR) ;

RINVTPME14 = max(0 , RDSNO - max(0 , (LIM_TITPRISE * (1 + BOOL_0AM)) 
			     - max(0 , min( BSNCL + REPSNO2 + REPSNO1 + REPSNON + PETIPRISE , LIM_SOCNOUV2 * (1 + BOOL_0AM)) + COD7CQ+COD7CR)))
	      * (1 - V_CNR) ;



regle 407012:
application : iliad , batch  ;


PLAFREPETOT = arr( max(0 , RSNCR + RSNCF + RPLAFREPME4 - 10000)) * (1 - V_CNR) * positif(AVFISCOPTER) ;

PLAFREPSN4 = arr( max(0, RSNCF - 10000 )) * (1 - V_CNR) * positif(AVFISCOPTER) ;

PLAFREPSN3 = arr( max(0, PLAFREPETOT - PLAFREPSN4 )) ;

RPLAFPME13 = PLAFREPSN4 + PLAFREPSN3 ;

regle 40000:
application : iliad , batch  ;

DREDMEUB = REDMEUBLE ;

AREDMEUB = (DREDMEUB * (1 - ART1731BIS) 
           + min(DREDMEUB , max(AREDMEUB_P+AREDMEUBP2, AREDMEUB1731 + 0)*(1-PREM8_11)) * ART1731BIS
           ) * (1 - V_CNR) ;

DREDREP = REDREPNPRO ;

AREDREP = (DREDREP * (1 - ART1731BIS) 
          + min(DREDREP , max(AREDREP_P+AREDREPP2, AREDREP1731 + 0)*(1-PREM8_11)) * ART1731BIS
          ) * (1 - V_CNR) ;

DILMIX = LOCMEUBIX ;

AILMIX_R = DILMIX * (1 - V_CNR) ;

AILMIX = (DILMIX * (1 - ART1731BIS) 
           + min(DILMIX , max(AILMIX_P+AILMIXP2, AILMIX1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMIY = LOCMEUBIY ;

AILMIY = (DILMIY * (1 - ART1731BIS) 
          + min(DILMIY , max(AILMIY_P+AILMIYP2, AILMIY1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMPA = COD7PA ;
AILMPA = DILMPA * (1 - V_CNR) ;


DINVRED = INVREDMEU ;

AINVRED = (DINVRED * (1 - ART1731BIS) 
           + min(DINVRED , max(AINVRED_P+AINVREDP2, AINVRED1731 + 0)*(1-PREM8_11)) * ART1731BIS
          ) * (1 - V_CNR) ;

DILMIH = LOCMEUBIH ;

AILMIH_R = DILMIH * (1 - V_CNR);
AILMIH = (DILMIH * (1-ART1731BIS) 
          + min(DILMIH , max(AILMIH_P+AILMIHP2, AILMIH1731+0)*(1-PREM8_11)) * ART1731BIS
         ) * (1-V_CNR);

DILMJC = LOCMEUBJC ;

AILMJC = (DILMJC * (1 - ART1731BIS) 
          + min(DILMJC , max(AILMJC_P+AILMJCP2, AILMJC1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMPB = COD7PB ;
AILMPB = DILMPB * (1 - V_CNR) ;


DILMIZ = LOCMEUBIZ ;

AILMIZ_R = DILMIZ * (1 - V_CNR) ;
AILMIZ = (DILMIZ * (1-ART1731BIS) 
          + min(DILMIZ , max(AILMIZ_P+AILMIZP2, AILMIZ1731+0)*(1-PREM8_11)) * ART1731BIS
         ) * (1-V_CNR);

DILMJI = LOCMEUBJI ;

AILMJI = (DILMJI * (1 - ART1731BIS) 
          + min(DILMJI , max(AILMJI_P+AILMJIP2, AILMJI1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMPC = COD7PC ;
AILMPC = DILMPC * (1 - V_CNR) ;

DILMJS = LOCMEUBJS ;

AILMJS = (DILMJS * (1 - ART1731BIS) 
          + min(DILMJS , max(AILMJS_P+AILMJSP2, AILMJS1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMPD = COD7PD ;
AILMPD = DILMPD * (1 - V_CNR) ;


DILMPE = COD7PE ;
AILMPE = DILMPE * (1 - V_CNR) ;

DMEUBLE = REPMEUBLE ;

AMEUBLE = (DMEUBLE * (1 - ART1731BIS) 
           + min(DMEUBLE , max(AMEUBLE_P+AMEUBLEP2, AMEUBLE1731 + 0)*(1-PREM8_11)) * ART1731BIS
          ) * (1 - V_CNR) ;

MEUBLERET = arr(DMEUBLE * TX25 / 100) * (1 - V_CNR) ;

DPROREP = INVNPROREP ;

APROREP = (DPROREP * (1-ART1731BIS) 
           + min(DPROREP , max(APROREP_P+APROREPP2, APROREP1731+0)*(1-PREM8_11)) * ART1731BIS
          ) * (1-V_CNR);

RETPROREP = arr(DPROREP * TX25 / 100) * (1 - V_CNR) ;

DREPNPRO = INVREPNPRO ;

AREPNPRO = (DREPNPRO * (1-ART1731BIS) 
            + min(DREPNPRO , max(APROREP_P+APROREPP2, AREPNPRO1731+0)*(1-PREM8_11)) * ART1731BIS
           ) * (1-V_CNR);

RETREPNPRO = arr(DREPNPRO * TX25 / 100) * (1 - V_CNR) ;

DREPMEU = INVREPMEU ;

AREPMEU = (DREPMEU * (1-ART1731BIS) 
           + min(DREPMEU , max(AREPMEU_P+AREPMEUP2, AREPMEU1731+0)*(1-PREM8_11)) * ART1731BIS
          ) * (1-V_CNR);

RETREPMEU = arr(DREPMEU * TX25 / 100) * (1 - V_CNR) ;

DILMIC = LOCMEUBIC ;

AILMIC_R = DILMIC * (1 - V_CNR) ;
AILMIC = (DILMIC * (1 - ART1731BIS) 
          + min(DILMIC , max(AILMIC_P+ AILMICP2, AILMIC1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMIB = LOCMEUBIB ;

AILMIB_R = DILMIB * (1 - V_CNR) ;
AILMIB = (DILMIB * (1 - ART1731BIS) 
          + min(DILMIB , max(AILMIB_P+AILMIBP2, AILMIB1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMIA = LOCMEUBIA ;

AILMIA_R = DILMIA * (1 - V_CNR) ;
AILMIA = (DILMIA * (1 - ART1731BIS)
          + min(DILMIA , max(AILMIA_P+AILMIAP2 , AILMIA1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMJY = LOCMEUBJY ;

AILMJY = (DILMJY * (1 - ART1731BIS) 
          + min(DILMJY , max(AILMJY_P+AILMJYP2 , AILMJY1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMJX = LOCMEUBJX ;

AILMJX = (DILMJX * (1 - ART1731BIS) 
          + min(DILMJX , max(AILMJX_P+AILMJXP2, AILMJX1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMJW = LOCMEUBJW ;

AILMJW = (DILMJW * (1 - ART1731BIS) 
          + min(DILMJW , max(AILMJW_P+AILMJWP2, AILMJW1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMJV = LOCMEUBJV ;

AILMJV = (DILMJV * (1 - ART1731BIS) 
          + min(DILMJV , max(AILMJV_P+AILMJVP2 , AILMJV1731 + 0)*(1-PREM8_11)) * ART1731BIS
         ) * (1 - V_CNR) ;

DILMOE = COD7OE ;
AILMOE = DILMOE * (1 - V_CNR) ; 

DILMOD = COD7OD ;
AILMOD = DILMOD * (1 - V_CNR) ; 

DILMOC = COD7OC ;
AILMOC = DILMOC * (1 - V_CNR) ; 

DILMOB = COD7OB ;
AILMOB = DILMOB * (1 - V_CNR) ; 

DILMOA = COD7OA ;
AILMOA = DILMOA * (1 - V_CNR) ; 

regle 40002:
application : iliad , batch  ;




RREDMEUB_1 = max(min(AREDMEUB , IDOM11-DEC11-REDUCAVTCEL-RCELTOT), 0) ;


RREDMEUB = max(0 , RREDMEUB_1 * (1-ART1731BIS) 
               + min( RREDMEUB_1 , max(RREDMEUB_P+RREDMEUBP2 , RREDMEUB1731+0) * (1-PREM8_11)) * ART1731BIS 
              ) ;

REPMEUIS = (DREDMEUB - RREDMEUB) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40004:
application : iliad , batch  ;


RREDREP_1 = max(min(AREDREP , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                    -RREDMEUB) , 0) ;


RREDREP = max( 0 , RREDREP_1 * (1-ART1731BIS) 
               + min( RREDREP_1 , max(RREDREP_P+RREDREPP2 , RREDREP1731+0 ) * (1-PREM8_11)) * ART1731BIS 
             ) ;

REPMEUIU = (DREDREP - RREDREP) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40006:
application : iliad , batch  ;


RILMIX_1 = max(min(AILMIX , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                  -RREDMEUB-RREDREP) , 0) ;


RILMIX = max(0 , RILMIX_1 * (1-ART1731BIS) 
             + min( RILMIX_1 , max(RILMIX_P+RILMIXP2 , RILMIX1731+0 ) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPMEUIX = (AILMIX_R - RILMIX) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40008:
application : iliad , batch  ;


RILMIY_1 = max(min(AILMIY , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                  -RREDMEUB-RREDREP-RILMIX) , 0) ;


RILMIY = max(0 , RILMIY_1 * (1 - ART1731BIS) 
             + min(RILMIY_1 , max(RILMIY_P+RILMIYP2 , RILMIY1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUIY = (DILMIY - RILMIY) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
 
regle 40009:
application : iliad , batch  ;


RILMPA = max(min(AILMPA , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY) , 0) ;

REPMEUPA = (DILMPA - RILMPA) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40010:
application : iliad , batch  ;


RINVRED_1 = max(min(AINVRED , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                    -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA) , 0) ;


RINVRED = max( 0 , RINVRED_1 * (1-ART1731BIS) 
               + min( RINVRED_1 , max(RINVRED_P+RINVREDP2 , RINVRED1731+0 ) * (1-PREM8_11)) * ART1731BIS 
             ) ;

REPMEUIT = (DINVRED - RINVRED) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40012:
application : iliad , batch  ;


RILMIH_1 = max(min(AILMIH , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED) , 0) ;


RILMIH = max(0 , RILMIH_1 * (1 - ART1731BIS)
             + min(RILMIH_1 , max(RILMIH_P+RILMIHP2 , RILMIH1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ; 

REPMEUIH = (AILMIH_R - RILMIH) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40014:
application : iliad , batch  ;


RILMJC_1 = max(min(AILMJC , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH) , 0) ;


RILMJC = max(0 , RILMJC_1 * (1 - ART1731BIS) 
             + min(RILMJC_1 , max( RILMJC_P+RILMJCP2 , RILMJC1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJC = (DILMJC - RILMJC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40015:
application : iliad , batch  ;


RILMPB = max(min(AILMPB , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC) , 0) ;

REPMEUPB = (DILMPB - RILMPB) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40016:
application : iliad , batch  ;


RILMIZ_1 = max(min(AILMIZ , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB) , 0) ;


RILMIZ = max( 0 , RILMIZ_1 * (1-ART1731BIS) 
              + min( RILMIZ_1 , max(RILMIZ_P+RILMIZP2 , RILMIZ1731+0 ) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPMEUIZ = (AILMIZ_R - RILMIZ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40018:
application : iliad , batch  ;


RILMJI_1 = max(min(AILMJI , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ) , 0) ;


RILMJI = max(0 , RILMJI_1 * (1 - ART1731BIS) 
             + min(RILMJI_1 , max( RILMJI_P+RILMJIP2 , RILMJI1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJI = (DILMJI - RILMJI) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40019:
application : iliad , batch  ;


RILMPC = max(min(AILMPC , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI) , 0) ;

REPMEUPC = (DILMPC - RILMPC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40020:
application : iliad , batch  ;


RILMJS_1 = max(min(AILMJS , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC) , 0) ;


RILMJS = max(0 , RILMJS_1 * (1 - ART1731BIS) 
             + min(RILMJS_1 , max( RILMJS_P+RILMJSP2 , RILMJS1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJS = (DILMJS - RILMJS) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40021:
application : iliad , batch  ;


RILMPD = max(min(AILMPD , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS) , 0) ;

REPMEUPD = (DILMPD - RILMPD) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40022:
application : iliad , batch  ;


RILMPE = max(min(AILMPE , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD) , 0) ;

REPMEUPE = (DILMPE - RILMPE) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40023:
application : iliad , batch  ;


RMEUBLE_1 = max(min(MEUBLERET , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                      -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                      -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE) , 0) ;


RMEUBLE = max( 0 , RMEUBLE_1 * (1-ART1731BIS) 
               + min( RMEUBLE_1 , max( RMEUBLE_P+RMEUBLEP2 , RMEUBLE1731+0) * (1-PREM8_11)) * ART1731BIS 
             ) ;

REPMEUIK = (MEUBLERET - RMEUBLE) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40024:
application : iliad , batch  ;


RPROREP_1 = max(min( RETPROREP , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                       -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                       -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE) , 0) ;


RPROREP = max( 0 , RPROREP_1 * (1-ART1731BIS) 
               + min( RPROREP_1 , max( RPROREP_P+RPROREPP2 , RPROREP1731+0 ) * (1-PREM8_11)) * ART1731BIS 
             ) ;

REPMEUIR = (RETPROREP - RPROREP) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40026:
application : iliad , batch  ;


RREPNPRO_1 = max(min( RETREPNPRO , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                         -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                         -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                         -RPROREP ) , 0) ;


RREPNPRO = max( 0 , RREPNPRO_1 * (1-ART1731BIS) 
                + min( RREPNPRO_1 , max( RREPNPRO_P+RREPNPROP2 , RREPNPRO1731+0) * (1-PREM8_11)) * ART1731BIS 
              ) ;

REPMEUIQ = (RETREPNPRO - RREPNPRO) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40028:
application : iliad , batch  ;


RREPMEU_1 = max(min(RETREPMEU , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                      -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                      -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                      -RPROREP-RREPNPRO ) , 0) ;


RREPMEU = max( 0 , RREPMEU_1 * (1-ART1731BIS) 
               + min( RREPMEU_1 , max(RREPMEU_P+RREPMEUP2 , RREPMEU1731+0) * (1-PREM8_11)) * ART1731BIS 
             ) ;

REPMEUIP = (RETREPMEU - RREPMEU) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40030:
application : iliad , batch  ;


RILMIC_1 = max(min(AILMIC , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU ) , 0) ;


RILMIC = max( 0 , RILMIC_1 * (1-ART1731BIS) 
              + min( RILMIC_1 , max(RILMIC_P+RILMICP2 , RILMIC1731+0 ) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPMEUIC = (AILMIC_R - RILMIC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40032:
application : iliad , batch  ;


RILMIB_1 = max(min(AILMIB , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC ) , 0) ;


RILMIB = max( 0 , RILMIB_1 * (1-ART1731BIS) 
              + min( RILMIB_1 , max(RILMIB_P+RILMIBP2, RILMIB1731+0 ) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPMEUIB = (AILMIB_R - RILMIB) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40034:
application : iliad , batch  ;


RILMIA_1 = max(min(AILMIA , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB ) , 0) ;


RILMIA = max(0 , RILMIA_1 * (1 - ART1731BIS) 
             + min(RILMIA_1 , max(RILMIA_P+RILMIAP2 , RILMIA1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUIA = (AILMIA_R - RILMIA) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;
  
regle 40036:
application : iliad , batch  ;


RILMJY_1 = max(min(AILMJY , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA ) , 0) ;


RILMJY = max(0 , RILMJY_1 * (1 - ART1731BIS) 
             + min(RILMJY_1 , max(RILMJY_P+RILMJYP2 , RILMJY1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJY = (DILMJY - RILMJY) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40038:
application : iliad , batch  ;


RILMJX_1 = max(min(AILMJX , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY ) , 0) ;


RILMJX = max(0 , RILMJX_1 * (1 - ART1731BIS) 
             + min(RILMJX_1 , max(RILMJX_P+RILMJXP2 , RILMJX1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJX = (DILMJX - RILMJX) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40040:
application : iliad , batch  ;


RILMJW_1 = max(min(AILMJW , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX ) , 0) ;


RILMJW = max(0 , RILMJW_1 * (1 - ART1731BIS) 
             + min(RILMJW_1 , max(RILMJW_P+RILMJWP2 , RILMJW1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJW = (DILMJW - RILMJW) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40042:
application : iliad , batch  ;


RILMJV_1 = max(min(AILMJV , IDOM11-DEC11-REDUCAVTCEL-RCELTOT 
                                  -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                  -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                  -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                  -RILMJW) , 0) ;


RILMJV = max(0 , RILMJV_1 * (1 - ART1731BIS) 
             + min(RILMJV_1 , max(RILMJV_P+RILMJVP2 , RILMJV1731 + 0) * (1-PREM8_11)) * ART1731BIS
            ) ;

REPMEUJV = (DILMJV - RILMJV) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40043:
application : iliad , batch  ;

RILMOE = max(min(AILMOE , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV) , 0) ;

REPMEUOE = (DILMOE - RILMOE) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RILMOD = max(min(AILMOD , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE) , 0) ;

REPMEUOD = (DILMOD - RILMOD) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RILMOC = max(min(AILMOC , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD) , 0) ;

REPMEUOC = (DILMOC - RILMOC) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RILMOB = max(min(AILMOB , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC) , 0) ;

REPMEUOB = (DILMOB - RILMOB) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RILMOA = max(min(AILMOA , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB) , 0) ;

REPMEUOA = (DILMOA - RILMOA) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40044:
application : iliad , batch  ;

REPMEUTOT1 = REPRESIMEUB + REPMEUIK + REPMEUIQ + REPMEUIR + RESIVIEUREP ;

REPMEUTOT2 = REPMEUIP + MEUBLEREP + REPRESIVIEU ;

regle 40050:
application : iliad , batch  ;

DRESIMEUB = VIEUMEUB ;

DRESIVIEU = RESIVIEU + RESIVIANT ;

DRESINEUV = LOCRESINEUV + MEUBLENP + INVNPROF1 + INVNPROF2 ;

DLOCIDEFG = LOCMEUBID + LOCMEUBIE + LOCMEUBIF + LOCMEUBIG ;

DCODJTJU = LOCMEUBJT + LOCMEUBJU ;

DCODOU = COD7OU ;



ACODOU = arr(min(PLAF_RESINEUV , COD7OU) / 9) * (1 - V_CNR) ;

ACODJT = min(PLAF_RESINEUV , LOCMEUBJT) * (1 - V_CNR) ;
ACODJU = min(PLAF_RESINEUV - ACODJT , LOCMEUBJU) * (1 - V_CNR) ;

ACODJTJU_1 = arr(ACODJT / 9) + arr(ACODJU / 9) ;
ACODJTJU = ACODJTJU_1 * (1 -ART1731BIS)
           + min(ACODJTJU_1 , max(ACODJTJU_P+ACODJTJUP2, ACODJTJU1731 + 0)*(1-PREM8_11)) * ART1731BIS ;

ACODIE = min(PLAF_RESINEUV , LOCMEUBIE) * (1 - V_CNR) ;
ACODIF = min(PLAF_RESINEUV - ACODIE , LOCMEUBIF) * (1 - V_CNR) ;
ACODID = min(PLAF_RESINEUV - ACODIE - ACODIF , LOCMEUBID) * (1 - V_CNR) ;
ACODIG = min(PLAF_RESINEUV - ACODIE - ACODIF - ACODID , LOCMEUBIG) * (1 - V_CNR) ;

ALOCIDEFG_1 = arr(ACODIE / 9) + arr(ACODIF / 9) + arr(ACODID / 9) + arr(ACODIG / 9) ; 
ALOCIDEFG = ALOCIDEFG_1 * (1 - ART1731BIS) 
            + min(ALOCIDEFG_1 , max(ALOCIDEFG_P+ALOCIDEFGP2, ALOCIDEFG1731 + 0)*(1-PREM8_11)) * ART1731BIS ;
ACODIL = min(PLAF_RESINEUV , MEUBLENP) * (1 - V_CNR) ;
ACODIN = min(PLAF_RESINEUV - ACODIL , INVNPROF1) * (1 - V_CNR) ;
ACODIJ = min(PLAF_RESINEUV - ACODIL - ACODIN , LOCRESINEUV) * (1 - V_CNR) ;
ACODIV = min(PLAF_RESINEUV - ACODIL - ACODIN - ACODIJ , INVNPROF2) * (1 - V_CNR) ;

ARESINEUV_1 = arr(ACODIL / 9) + arr(ACODIN / 9) + arr(ACODIJ / 9) + arr(ACODIV / 9) ; 
ARESINEUV = ARESINEUV_1 * (1 - ART1731BIS) 
            + min(ARESINEUV_1 , max(ARESINEUV_P+ARESINEUVP2, ARESINEUV1731 + 0)*(1-PREM8_11)) * ART1731BIS ;

ACODIM = min(PLAF_RESINEUV , RESIVIEU) * (1 - V_CNR) ;
ACODIW = min(PLAF_RESINEUV - ACODIM , RESIVIANT) * (1 - V_CNR) ;

ARESIVIEU_1 = arr(ACODIM / 9) + arr(ACODIW / 9) ;
ARESIVIEU = ARESIVIEU_1 * (1-ART1731BIS) 
            + min( ARESIVIEU_1 , max(ARESIVIEU_P+ARESIVIEUP2 , ARESIVIEU1731+0 )*(1-PREM8_11)) * ART1731BIS ;

ARESIMEUB_1 = arr(min(PLAF_RESINEUV , VIEUMEUB) / 9) * (1 - V_CNR) ;
ARESIMEUB = ARESIMEUB_1 * (1-ART1731BIS) 
            + min( ARESIMEUB_1 , max(ARESIMEUB_P+ARESIMEUBP2, ARESIMEUB1731+0 )*(1-PREM8_11)) * ART1731BIS ;


RETCODOU = arr(ACODOU * TX11 / 100) ;


RETCODJT = arr(arr(ACODJT / 9) * TX11 / 100) ;
RETCODJU = arr(arr(ACODJU / 9) * TX11 / 100) ;


RETCODIE = arr(arr(ACODIE / 9) * TX18 / 100) ;

RETCODIF = arr(arr(ACODIF / 9) * TX18 / 100) ;

RETCODID = arr(arr(ACODID / 9) * TX11 / 100) ;

RETCODIG = arr(arr(ACODIG / 9) * TX11 / 100) ;
 

RETLOCIDEFG_1 = arr(arr(ACODIE / 9) * TX18 / 100) + arr(arr(ACODIF / 9) * TX18 / 100) 
                    + arr(arr(ACODID / 9) * TX11 / 100) + arr(arr(ACODIG / 9) * TX11 / 100) ;

RETLOCIDEFG = arr(arr(ACODIE / 9) * TX18 / 100) + arr(arr(ACODIF / 9) * TX18 / 100) 
                  + arr(arr(ACODID / 9) * TX11 / 100) + arr(arr(ACODIG / 9) * TX11 / 100) * (1 - ART1731BIS)
              + min(ALOCIDEFG_1 , ALOCIDEFG1731 + 0) * ART1731BIS ;

RETRESINEUV = arr(arr(ACODIL / 9) * TX20 / 100) + arr(arr(ACODIN / 9) * TX20 / 100) + arr(arr(ACODIJ / 9) * TX18 / 100) + arr(arr(ACODIV / 9) * TX18 / 100) * (1 - ART1731BIS)
              + min(ARESINEUV_1 , ARESINEUV1731 + 0) * ART1731BIS ;

RETRESINEUV_1 = arr(arr(ACODIL / 9) * TX20 / 100) + arr(arr(ACODIN / 9) * TX20 / 100) + arr(arr(ACODIJ / 9) * TX18 / 100) + arr(arr(ACODIV / 9) * TX18 / 100) ;

RETCODIL = arr(arr(ACODIL / 9) * TX20 / 100) ;

RETCODIN = arr(arr(ACODIN / 9) * TX20 / 100) ;

RETCODIJ = arr(arr(ACODIJ / 9) * TX18 / 100) ;

RETCODIV = arr(arr(ACODIV / 9) * TX18 / 100) ;

RETRESIVIEU = arr(arr(ACODIM / 9) * TX25 / 100) + arr(arr(ACODIW / 9) * TX25 / 100) * (1 - ART1731BIS)
              + min( ARESIVIEU_1 , ARESIVIEU1731+0 ) * ART1731BIS ;
RETRESIVIEU_1 = arr(arr(ACODIM / 9) * TX25 / 100) + arr(arr(ACODIW / 9) * TX25 / 100) ;

RETCODIM = arr(arr(ACODIM / 9) * TX25 / 100) ;

RETCODIW = arr(arr(ACODIW / 9) * TX25 / 100) ;

RETRESIMEUB = arr(ARESIMEUB * TX25 / 100) ;

RETRESIMEUB_1 = arr(ARESIMEUB_1 * TX25 / 100) ;

regle 40052:
application : iliad , batch  ;
 

RRESIMEUB_1 = max(min(RETRESIMEUB , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA) , 0) ;


RRESIMEUB = max( 0 , RRESIMEUB_1 * (1-ART1731BIS) 
                 + min( RRESIMEUB_1 , max(RRESIMEUB_P+RRESIMEUBP2 , RRESIMEUB1731+0) * (1-PREM8_11)) * ART1731BIS 
               ) ;

REPLOCIO = (RETRESIMEUB_1 - RRESIMEUB) * positif(VIEUMEUB + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 40054:
application : iliad , batch  ;


RCODIW_1 = max(min(RETCODIW , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB) , 0) ;


RCODIW = max( 0 , RCODIW_1 * (1-ART1731BIS) 
              + min( RCODIW_1 , max(RCODIW_P+ RCODIWP2 , RCODIW1731 + 0) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPLOCIW = (RETCODIW - RCODIW) * positif(RESIVIANT + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCODIM_1 = max(min(RETCODIM , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RCODIW) , 0) ;


RCODIM = max( 0 , RCODIM_1 * (1-ART1731BIS) 
              + min( RCODIM_1 , max(RCODIM_P+RCODIMP2 , RCODIM1731 + 0) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPLOCIM = (RETCODIM - RCODIM) * positif(RESIVIEU + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRESIVIEU = RCODIW + RCODIM ;

regle 40056:
application : iliad , batch  ;


RCODIL_1 = max(min(RETCODIL , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU) , 0) ;

RCODIL = RCODIL_1 * ( 1-ART1731BIS) 
         + min( RCODIL_1 , max(RCODIL_P+RCODILP2 , RCODIL1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCIL = (RETCODIL - RCODIL) * positif(MEUBLENP + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODIN_1 = max(min(RETCODIN , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RCODIL) , 0) ;

RCODIN = RCODIN_1 * ( 1-ART1731BIS) 
         + min( RCODIN_1 , max(RCODIN_P+RCODINP2 , RCODIN1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCIN = (RETCODIN - RCODIN) * positif(INVNPROF1 + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODIV_1 = max(min(RETCODIV , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RCODIL-RCODIN) , 0) ;

RCODIV = RCODIV_1 * ( 1-ART1731BIS) 
         + min( RCODIV_1 , max(RCODIV_P+RCODIVP2 , RCODIV1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCIV = (RETCODIV - RCODIV) * positif(INVNPROF2 + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODIJ_1 = max(min(RETCODIJ , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RCODIL-RCODIN-RCODIV) , 0) ;

RCODIJ = RCODIJ_1 * ( 1-ART1731BIS) 
         + min( RCODIJ_1 , max(RCODIJ_P+RCODIJP2 , RCODIJ1731+0 )* (1-PREM8_11)) * ART1731BIS ;

REPLOCIJ = (RETCODIJ - RCODIJ) * positif(LOCRESINEUV + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RRESINEUV = RCODIL + RCODIN + RCODIV + RCODIJ ;

regle 40058:
application : iliad , batch  ;


RCODIE_1 = max(min(RETCODIE , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV) , 0) ;


RCODIE = RCODIE_1 * ( 1- ART1731BIS ) 
         + min( RCODIE_1 , max( RCODIE_P+RCODIEP2 , RCODIE1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOC7IE = (RETCODIE - RCODIE) * positif(LOCMEUBIE + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODIF_1 = max(min(RETCODIF , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RCODIE) , 0) ;


RCODIF = RCODIF_1 * ( 1- ART1731BIS )
         + min( RCODIF_1 , max( RCODIF_P+RCODIFP2 , RCODIF1731 + 0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCIF = (RETCODIF - RCODIF) * positif(LOCMEUBIF + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODIG_1 = max(min(RETCODIG , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RCODIE-RCODIF) , 0) ;


RCODIG = RCODIG_1 * ( 1- ART1731BIS ) 
         + min( RCODIG_1 , max( RCODIG_P+RCODIGP2 , RCODIG1731 + 0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCIG = (RETCODIG - RCODIG) * positif(LOCMEUBIG + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODID_1 = max(min(RETCODID , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RCODIE-RCODIF-RCODIG) , 0) ;

RCODID = RCODID_1 * ( 1- ART1731BIS )
         + min( RCODID_1 ,max( RCODID_P+RCODIDP2 , RCODID1731 +0 ) * (1-PREM8_11)) * ART1731BIS ;

REPLOCID = (RETCODID - RCODID) * positif(LOCMEUBID + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RLOCIDEFG = RCODIE + RCODIF + RCODIG + RCODID ;

regle 40060:
application : iliad , batch  ;


RCODJU_1 = max(min(RETCODJU , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RLOCIDEFG) , 0) ;

RCODJU = max(0 , RCODJU_1 * ( 1 - ART1731BIS) 
             + min(RCODJU_1 , max(RCODJU_P+RCODJUP2 , RCODJU1731 + 0) * (1-PREM8_11)) * ART1731BIS 
            ) ;

REPLOCJU = (RETCODJU - RCODJU) * positif(LOCMEUBJU + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RCODJT_1 = max(min(RETCODJT , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RLOCIDEFG-RCODJU) , 0) ;

RCODJT = max(0 , RCODJT_1 * ( 1 - ART1731BIS) 
             + min(RCODJT_1 , max(RCODJT_P+RCODJTP2 , RCODJT1731 + 0) * (1-PREM8_11)) * ART1731BIS 
            ) ;

RCODJTJU = RCODJU + RCODJT ;

REPLOCJT = (RETCODJT - RCODJT) * positif(LOCMEUBJT + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;


RCODOU = max(min(RETCODOU , IDOM11-DEC11-REDUCAVTCEL-RCELTOT
                                -RREDMEUB-RREDREP-RILMIX-RILMIY-RILMPA-RINVRED-RILMIH-RILMJC
                                -RILMPB-RILMIZ-RILMJI-RILMPC-RILMJS-RILMPD-RILMPE-RMEUBLE
                                -RPROREP-RREPNPRO-RREPMEU-RILMIC-RILMIB-RILMIA-RILMJY-RILMJX 
                                -RILMJW-RILMJV-RILMOE-RILMOD-RILMOC-RILMOB-RILMOA-RRESIMEUB
                                -RRESIVIEU-RRESINEUV-RLOCIDEFG-RCODJTJU) , 0) ;
REPMEUOU = (RETCODOU - RCODOU) * positif(COD7OU + 0) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

RLOCNPRO = RREDMEUB + RREDREP + RILMIX + RILMIY + RILMPA + RINVRED + RILMIH + RILMJC
           + RILMPB + RILMIZ + RILMJI + RILMPC + RILMJS + RILMPD + RILMPE + RMEUBLE
           + RPROREP + RREPNPRO +RREPMEU + RILMIC + RILMIB + RILMIA + RILMJY + RILMJX 
           + RILMJW + RILMJV + RILMOE + RILMOD + RILMOC + RILMOB + RILMOA + RRESIMEUB
           + RRESIVIEU + RRESINEUV + RLOCIDEFG + RCODJTJU + RCODOU ;

regle 40062:
application : iliad , batch  ;



REPLNPV = REPLOCJT + REPMEUOA ;

REPLOCNT = REPMEUJS ;

REPLNPW = REPMEUJV + REPLOCIG + REPLOCIF + REPLOCID + REPLOCJU + REPMEUOB ;


REPRESINEUV = REPMEUJI ;

REPLNPX = REPMEUIA + REPMEUJW + REPLOCIV + REPLOCIN + REPLOCIJ + REPLOC7IE + REPMEUOC ;

REPINVRED = REPMEUIT ; 

REPLOCN1 = REPMEUJC ;

REPLNPY = REPMEUIP + REPMEUIB + REPMEUJX + REPLOCIM + REPLOCIL + REPMEUOD ; 

MEUBLERED = REPMEUIS ;

REPREDREP = REPMEUIU ;

REPLOCN2 = REPMEUIY ;

REPLNPZ = REPMEUIK + REPMEUIR + REPMEUIQ + REPMEUIC + REPMEUJY + REPLOCIO + REPLOCIW + REPMEUOE ;
 
MEUBLEREP = (RETRESINEUV_1 - RRESINEUV) * positif(MEUBLENP) ;

REPRESIVIEU = (RETRESIVIEU_1 - RRESIVIEU) * positif(RESIVIEU) ;

RESIVIEUREP = (RETRESIVIEU_1 - RRESIVIEU) * positif(RESIVIANT) ;

REPRESIMEUB = RETRESIMEUB_1 - RRESIMEUB ;

regle 40064:
application : iliad , batch  ;

RCODOU1 = arr(ACODOU * TX11/100) ;
RCODOU8 = arr(min(PLAF_RESINEUV , COD7OU) * TX11/100) - 8 * RCODOU1 ;
REPLNOU = (RCODOU8 + RCODOU1 * 7) * (1-null(2-V_REGCO)) * (1-null(4-V_REGCO)) ;
REPLOCOU = REPLNOU ;

RCODJT1 = arr(arr(ACODJT / 9) * TX11/100) ;
RCODJT2 = RCODJT1 ;
RCODJT3 = RCODJT1 ;
RCODJT4 = RCODJT1 ;
RCODJT5 = RCODJT1 ;
RCODJT6 = RCODJT1 ;
RCODJT7 = RCODJT1 ;
RCODJT8 = arr(ACODJT * TX11/100) - 8 * RCODJT1 ; 

REPLNPT = RCODJT1 + RCODJT2 + RCODJT3 + RCODJT4 + RCODJT5 + RCODJT6 + RCODJT7 + RCODJT8 ;

RCODJU1 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU2 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU3 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU4 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU5 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU6 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU7 = arr(arr(ACODJU / 9) * TX11/100) ;
RCODJU8 = arr(ACODJU * TX11/100) - RCODJU1 - RCODJU2 - RCODJU3 - RCODJU4 - RCODJU5 - RCODJU6 - RCODJU7 - RCODJU7 ;

REPLNPU = RCODJU1 + RCODJU2 + RCODJU3 + RCODJU4 + RCODJU5 + RCODJU6 + RCODJU7 + RCODJU8 ;

RLOCIDFG1 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG2 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ; 
RLOCIDFG3 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG4 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG5 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG6 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG7 = arr(arr(ACODID / 9) * TX11/100) + arr(arr(ACODIF / 9) * TX18/100) + arr(arr(ACODIG / 9) * TX11/100) ;
RLOCIDFG8 = arr(ACODID * TX11/100) + arr(ACODIF * TX18/100) + arr(ACODIG * TX11/100)
	     - RLOCIDFG1 - RLOCIDFG2 - RLOCIDFG3 - RLOCIDFG4 - RLOCIDFG5 - RLOCIDFG6 - RLOCIDFG7 - RLOCIDFG7 ;

REPLOCIDFG = RLOCIDFG1 + RLOCIDFG2 + RLOCIDFG3 + RLOCIDFG4 + RLOCIDFG5 + RLOCIDFG6 + RLOCIDFG7 + RLOCIDFG8 ;

REPLOCIE1 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE2 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE3 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE4 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE5 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE6 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE7 = arr(arr(ACODIE / 9) * TX18/100) ; 
REPLOCIE8 = arr(ACODIE * TX18/100) - REPLOCIE1 - REPLOCIE2 - REPLOCIE3 - REPLOCIE4 - REPLOCIE5 - REPLOCIE6 - REPLOCIE7 - REPLOCIE7 ;

REPLOCIE = REPLOCIE1 + REPLOCIE2 + REPLOCIE3 + REPLOCIE4 + REPLOCIE5 + REPLOCIE6 + REPLOCIE7 + REPLOCIE8 ;

RESINEUV1 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV2 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV3 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV4 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV5 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV6 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV7 = arr(arr(ACODIN / 9) * TX20/100) + arr(arr(ACODIJ / 9) * TX18/100) + arr(arr(ACODIV / 9) * TX18/100) ;
RESINEUV8 = arr(ACODIN * TX20/100) + arr(ACODIJ * TX18/100) + arr(ACODIV * TX18/100)
	     - RESINEUV1 - RESINEUV2 - RESINEUV3 - RESINEUV4 - RESINEUV5 - RESINEUV6 - RESINEUV7 - RESINEUV7 ;

REPINVLOCNP = RESINEUV1 + RESINEUV2 + RESINEUV3 + RESINEUV4 + RESINEUV5 + RESINEUV6 + RESINEUV7 + RESINEUV8 ;

RRESINEUV1 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV2 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV3 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV4 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV5 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV6 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV7 = arr(arr(ACODIL / 9) * TX20/100) ;
RRESINEUV8 = arr(ACODIL * TX20/100) - RRESINEUV1 - RRESINEUV2 - RRESINEUV3 - RRESINEUV4 - RRESINEUV5 - RRESINEUV6 - RRESINEUV7 - RRESINEUV7 ;

REPINVMEUBLE = RRESINEUV1 + RRESINEUV2 + RRESINEUV3 + RRESINEUV4 + RRESINEUV5 + RRESINEUV6 + RRESINEUV7 + RRESINEUV8 ;

RESIVIEU1 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU2 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU3 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU4 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU5 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU6 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU7 = arr(arr(ACODIM / 9) * TX25/100) ;
RESIVIEU8 = arr(ACODIM * TX25/100) - RESIVIEU1 - RESIVIEU2 - RESIVIEU3 - RESIVIEU4 - RESIVIEU5 - RESIVIEU6 - RESIVIEU7 - RESIVIEU7 ;

REPINVIEU = RESIVIEU1 + RESIVIEU2 + RESIVIEU3 + RESIVIEU4 + RESIVIEU5 + RESIVIEU6 + RESIVIEU7 + RESIVIEU8 ;

RESIVIAN1 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN2 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN3 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN4 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN5 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN6 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN7 = arr(arr(ACODIW / 9) * TX25/100) ;
RESIVIAN8 = arr(ACODIW * TX25/100) - RESIVIAN1 - RESIVIAN2 - RESIVIAN3 - RESIVIAN4 - RESIVIAN5 - RESIVIAN6 - RESIVIAN7 - RESIVIAN7 ;

REPINVIAN = RESIVIAN1 + RESIVIAN2 + RESIVIAN3 + RESIVIAN4 + RESIVIAN5 + RESIVIAN6 + RESIVIAN7 + RESIVIAN8 ;

RESIMEUB1 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB2 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB3 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB4 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB5 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB6 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB7 = arr(arr(min(DRESIMEUB , PLAF_RESINEUV) / 9) * TX25/100) ;
RESIMEUB8 = arr(min(DRESIMEUB , PLAF_RESINEUV) * TX25/100) - RESIMEUB1 - RESIMEUB2 - RESIMEUB3 - RESIMEUB4 - RESIMEUB5 - RESIMEUB6 - RESIMEUB7 - RESIMEUB7 ;

REPMEUB = (RESIMEUB1 + RESIMEUB2 + RESIMEUB3 + RESIMEUB4 + RESIMEUB5 + RESIMEUB6 + RESIMEUB7 + RESIMEUB8) * (1-positif(null(2-V_REGCO) + null(4-V_REGCO))) ;

REPRETREP = REPRESIVIEU + MEUBLEREP + REPMEUIK ;

regle 407034:
application : iliad , batch  ;

BSOCREP = min(RSOCREPRISE , LIM_SOCREPR * ( 1 + BOOL_0AM)) ;

RSOCREP = arr ( TX_SOCREPR/100 * BSOCREP ) * (1 - V_CNR);

DSOCREPR = RSOCREPRISE;

ASOCREPR = (BSOCREP * (1 - ART1731BIS) 
            + min( BSOCREP , max(ASOCREPR_P + ASOCREPRP2, ASOCREPR1731+0 ) * (1-PREM8_11)) * ART1731BIS 
           ) * (1-V_CNR)  ;

RSOCREPR_1 = max( min( RSOCREP , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPDOM_1-RFIPC_1-RCINE_1-RRESTIMO_1) , 0 );

RSOCREPR = max( 0, RSOCREPR_1 * (1-ART1731BIS) 
                   + min( RSOCREPR_1 , max( RSOCREPR_P+RSOCREPRP2 , RSOCREPR1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;


regle 4070153:
application : iliad , batch  ;

DRESTIMO = RIMOSAUVANT + RIMOPPAUANT + RESTIMOPPAU + RESTIMOSAUV + RIMOPPAURE + RIMOSAUVRF + COD7SY + COD7SX ;

RESTIMOD = min(RIMOSAUVANT , LIM_RESTIMO) ;
RRESTIMOD = max (min (RESTIMOD * TX40/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1
                                                        -RDIFAGRI_1-RFORET_1-RFIPC_1-RCINE_1) , 0) ;

RESTIMOB = min (RESTIMOSAUV , LIM_RESTIMO - RESTIMOD) ;
RRESTIMOB = max (min (RESTIMOB * TX36/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1
                                                        -RDIFAGRI_1-RFORET_1-RFIPC_1-RCINE_1-RRESTIMOD) , 0) ;

RESTIMOC = min(RIMOPPAUANT , LIM_RESTIMO - RESTIMOD - RESTIMOB) ;
RRESTIMOC = max (min (RESTIMOC * TX30/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1
                                                        -RFIPC_1-RCINE_1-RRESTIMOD-RRESTIMOB) , 0) ;

RESTIMOF = min(RIMOSAUVRF , LIM_RESTIMO - RESTIMOD - RESTIMOB - RESTIMOC) ;
RRESTIMOF = max (min (RESTIMOF * TX30/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1
                                                        -RFIPC_1-RCINE_1-RRESTIMOD-RRESTIMOB-RRESTIMOC) , 0) ;

RESTIMOY = min(COD7SY , LIM_RESTIMO - RESTIMOD - RESTIMOB - RESTIMOC - RESTIMOF) ;


RRESTIMOY = max (min (RESTIMOY * TX30/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1
                                                        -RFIPC_1-RCINE_1-RRESTIMOD-RRESTIMOB-RRESTIMOC-RRESTIMOC) , 0) ;

RESTIMOA = min(RESTIMOPPAU , LIM_RESTIMO - RESTIMOD - RESTIMOB - RESTIMOC - RESTIMOF - RESTIMOY) ;
RRESTIMOA = max (min (RESTIMOA * TX_RESTIMO1/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1
                                                        -RFIPC_1-RCINE_1-RRESTIMOD-RRESTIMOB-RRESTIMOC-RRESTIMOC-RRESTIMOY) , 0) ;

RESTIMOE = min(RIMOPPAURE , LIM_RESTIMO - RESTIMOD - RESTIMOB - RESTIMOC - RESTIMOF - RESTIMOY - RESTIMOA) ;
RRESTIMOE = max (min (RESTIMOE * TX22/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPC_1
                                                        -RCINE_1-RRESTIMOD-RRESTIMOB-RRESTIMOC-RRESTIMOC-RRESTIMOY-RRESTIMOA) , 0) ;

RESTIMOX = min(COD7SX , LIM_RESTIMO - RESTIMOD - RESTIMOB - RESTIMOC - RESTIMOF - RESTIMOY - RESTIMOA - RESTIMOE) ;
RRESTIMOX = max (min (RESTIMOX * TX22/100 , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPC_1-RCINE_1
                                                        -RCINE_1-RRESTIMOD-RRESTIMOB-RRESTIMOC-RRESTIMOC-RRESTIMOY-RRESTIMOA
                                                        -RRESTIMOE ) , 0) ;

ARESTIMO_1 = (RESTIMOD + RESTIMOB + RESTIMOC + RESTIMOF + RESTIMOA + RESTIMOE + RESTIMOY + RESTIMOX) * (1 - V_CNR) ;

ARESTIMO = ( ARESTIMO_1 * (1-ART1731BIS)
             + min( ARESTIMO_1, max(ARESTIMO_P+ARESTIMOP2 , ARESTIMO1731+0 ) * (1-PREM8_11)) * ART1731BIS
           ) * (1 - V_CNR) ;

RETRESTIMO = arr((RESTIMOD * TX40/100) + (RESTIMOB * TX36/100)
		 + (RESTIMOC * TX30/100) + (RESTIMOA * TX_RESTIMO1/100)
		 + (RESTIMOE * TX22/100) + (RESTIMOF * TX30/100)
                 + (RESTIMOY * TX30/100) + (RESTIMOX * TX22/100)) * (1 - V_CNR) ;

RRESTIMO_1 = max (min (RETRESTIMO , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPC_1-RCINE_1) , 0) ;

RRESTIMO = max ( 0 , RRESTIMO_1 * (1-ART1731BIS)
                     + min( RRESTIMO_1 , max(RRESTIMO_P+RRESTIMOP2 , RRESTIMO1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

A12RRESTIMO = arr(max (min(RRESTIMO , RRESTIMOD+RRESTIMOB+RRESTIMOC+RRESTIMOF+RRESTIMOA+RRESTIMOE),0)) * (1 - V_CNR) ;
RRESTIMOXY  = max( RRESTIMO - A12RRESTIMO , 0) * (1 - V_CNR) ;



regle 4070161:
application : iliad , batch  ;
REVDON = max(0,RBL+TOTALQUOHT-SDD-SDC1) ;
BDON7UH = min(LIM15000,COD7UH);
BASEDONB = REPDON03 + REPDON04 + REPDON05 + REPDON06 + REPDON07 + RDDOUP + COD7UH + DONAUTRE;
BASEDONP = RDDOUP + BDON7UH + DONAUTRE + EXCEDANTA;
BON = arr (min (REPDON03+REPDON04+REPDON05+REPDON06+REPDON07+RDDOUP+BDON7UH+DONAUTRE+EXCEDANTA,REVDON *(TX_BASEDUP)/100));


regle 407016101:
application : iliad , batch  ;
BASEDONF = min(REPDON03,arr(REVDON * (TX_BASEDUP)/100)) ;
REPDON = max(BASEDONF + REPDON04 + REPDON05 + REPDON06 + REPDON07+BASEDONP - arr(REVDON * (TX_BASEDUP)/100),0)*(1-V_CNR);

REPDONR4 = (positif_ou_nul(BASEDONF - arr(REVDON * (TX_BASEDUP)/100)) * REPDON04
            + (1 - positif_ou_nul(BASEDONF - arr(REVDON * (TX_BASEDUP)/100)))
	      * max(REPDON04 + (BASEDONF - arr(REVDON * (TX_BASEDUP)/100)),0)
	   )
	   * (1 - V_CNR);

REPDONR3 = (positif_ou_nul(BASEDONF + REPDON04 - arr(REVDON * (TX_BASEDUP)/100)) * REPDON05
	    + (1 - positif_ou_nul(BASEDONF + REPDON04 - arr(REVDON * (TX_BASEDUP)/100)))
	      * max(REPDON05 + (BASEDONF + REPDON04 - arr(REVDON * (TX_BASEDUP)/100)),0)
           ) 
	   * (1 - V_CNR);

REPDONR2 = (positif_ou_nul(BASEDONF + REPDON04 + REPDON05 - arr(REVDON * (TX_BASEDUP)/100)) * REPDON06
            + (1 - positif_ou_nul(BASEDONF + REPDON04 + REPDON05 - arr(REVDON * (TX_BASEDUP)/100)))
	      * max(REPDON06 + (BASEDONF + REPDON04 + REPDON05 - arr(REVDON * (TX_BASEDUP)/100)),0)
	   )
	   * (1 - V_CNR);

REPDONR1 = (positif_ou_nul(BASEDONF + REPDON04 + REPDON05 + REPDON06 - arr(REVDON * (TX_BASEDUP)/100)) * REPDON07
	    + (1 - positif_ou_nul(BASEDONF + REPDON04 + REPDON05 + REPDON06 - arr(REVDON * (TX_BASEDUP)/100)))
	      * max(REPDON07 + (BASEDONF + REPDON04 + REPDON05 + REPDON06 - arr(REVDON * (TX_BASEDUP)/100)),0)
           )
	   * (1 - V_CNR) ;

REPDONR = max(REPDON - REPDONR1 - REPDONR2 - REPDONR3 - REPDONR4 - REPDONR5,0)*(1-V_CNR);

regle 407016:
application : iliad , batch  ;
RON = arr( BON *(TX_REDDON)/100 ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

DDONS = RDDOUP + DONAUTRE + REPDON03 + REPDON04 + REPDON05 + REPDON06 + REPDON07 + COD7UH;

ADONS = ( BON * (1-ART1731BIS) 
          + min( BON , max(ADONS_P + ADONSP2 , ADONS1731+0 ) * (1-PREM8_11)) * ART1731BIS 
        ) * (1 - null(2 - V_REGCO)) * (1 - null(4 - V_REGCO)) ;

regle 33407016:
application : iliad , batch  ;

RDONS_1 = max( min( RON , RRI1-RLOGDOM-RCREAT-RCOMP-RRETU) , 0 ) ;

RDONS = max( 0, RDONS_1 * (1-ART1731BIS) 
                + min( RDONS_1 , max(RDONS_P+RDONSP2 , RDONS1731+0 ) * (1-PREM8_11)) * ART1731BIS );

regle 407018:
application : iliad , batch  ;
SEUILRED1=arr((arr(RI1)+REVQUO) / NBPT);
regle 407020:
application:iliad, batch;
RETUD = (1 - V_CNR) * arr((RDENS * MTRC) + (RDENL * MTRL) + (RDENU * MTRS) 
                           + (RDENSQAR * MTRC /2) + (RDENLQAR * MTRL /2) + (RDENUQAR * MTRS /2));
RNBE_1 = (RDENS + RDENL + RDENU + RDENSQAR + RDENLQAR + RDENUQAR) ;

RNBE = RNBE_1 * (1-ART1731BIS)
       + min( RNBE_1 , max( RNBE_P + RNBEP2 , RNBE1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

DNBE = RDENS + RDENL + RDENU + RDENSQAR + RDENLQAR + RDENUQAR ;
regle 100407020:
application:iliad, batch;

RRETU_1 = max(min( RETUD , RRI1-RLOGDOM-RCREAT-RCOMP) , 0) ;

RRETU = max( 0 , RRETU_1 * (1-ART1731BIS)
                 + min( RRETU_1 , max(RRETU_P+RRETUP2 , RRETU1731 + 0) * (1-PREM8_11)) * ART1731BIS ) ;

regle 407022 :
application : iliad , batch  ;

BFCPI_1 = ( positif(BOOL_0AM) * min (FCPI,PLAF_FCPI*2) + positif(1-BOOL_0AM) * min (FCPI,PLAF_FCPI) ) * (1-V_CNR);

BFCPI = BFCPI_1 * (1-ART1731BIS) 
        + min(BFCPI_1 , max(BFCPI_P + BFCPIP2 , BFCPI1731+0) * (1-PREM8_11)) * ART1731BIS ;

RFCPI = arr (BFCPI_1  * TX_FCPI /100) ; 

RINNO_1 = max( min( RFCPI , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1-RFIPC_1
			  -RCINE_1-RRESTIMO_1-RSOCREPR_1-RRPRESCOMP_1-RHEBE-RSURV_1) , 0 );

RINNO = max( 0, RINNO_1 * (1-ART1731BIS)
                + min( RINNO_1 , max(RINNO_P+RINNOP2 , RINNO1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;
regle 407023 :
application : iliad , batch  ;

BPRESCOMP =(RDPRESREPORT 
	   + (1-positif(RDPRESREPORT+0)) * 
	   arr(
	         ((1 - present(SUBSTITRENTE)) * 
                  arr (
                 null(PRESCOMP2000 - PRESCOMPJUGE)
                   * min(PLAFPRESCOMP,PRESCOMP2000)
	         + positif(PRESCOMPJUGE - PRESCOMP2000)
                   * (positif_ou_nul(PLAFPRESCOMP -PRESCOMPJUGE))
                   * PRESCOMP2000
	         + positif(PRESCOMPJUGE - PRESCOMP2000)
                    * (1 - positif_ou_nul(PLAFPRESCOMP -PRESCOMPJUGE))
                    * PLAFPRESCOMP * PRESCOMP2000/PRESCOMPJUGE
                       )
	       +
             present(SUBSTITRENTE) *
                  arr (
                   null(PRESCOMP2000 - SUBSTITRENTE)
		   * 
		   (positif_ou_nul(PLAFPRESCOMP - PRESCOMPJUGE)*SUBSTITRENTE
		   + 
		   positif(PRESCOMPJUGE-PLAFPRESCOMP)*arr(PLAFPRESCOMP*SUBSTITRENTE/PRESCOMPJUGE))
                 + 
		   positif(SUBSTITRENTE - PRESCOMP2000)
		   * (positif_ou_nul(PLAFPRESCOMP - PRESCOMPJUGE)*PRESCOMP2000
		   + 
		   positif(PRESCOMPJUGE-PLAFPRESCOMP)*arr(PLAFPRESCOMP*(SUBSTITRENTE/PRESCOMPJUGE)*(PRESCOMP2000/SUBSTITRENTE)))
                       )
	           )
                )
              )
               *(1 - V_CNR);




RPRESCOMP = arr (BPRESCOMP * TX_PRESCOMP / 100) * (1 -V_CNR);
BPRESCOMP01 = max(0,(1 - present(SUBSTITRENTE)) * 
                   (  positif_ou_nul(PLAFPRESCOMP -PRESCOMPJUGE)
                       * (PRESCOMPJUGE - BPRESCOMP)
                     + positif(PRESCOMPJUGE - PLAFPRESCOMP)
                       * (PLAFPRESCOMP - BPRESCOMP)
                   )
	       +
             present(SUBSTITRENTE) *
                   (  positif_ou_nul(PLAFPRESCOMP -PRESCOMPJUGE)
                       * (SUBSTITRENTE - PRESCOMP2000)
                     + positif(PRESCOMPJUGE - PLAFPRESCOMP)
		     *arr(PLAFPRESCOMP*(SUBSTITRENTE/PRESCOMPJUGE)*((SUBSTITRENTE-PRESCOMP2000)/SUBSTITRENTE))
                   )
		* (1 - V_CNR)
		);
DPRESCOMP = PRESCOMP2000 + RDPRESREPORT ;

APRESCOMP = ( BPRESCOMP * (1-ART1731BIS) 
              + min( BPRESCOMP , max(APRESCOMP_P + APRESCOMPP2 , APRESCOMP1731+0 ) * (1-PREM8_11)) * ART1731BIS 
            ) * (1 - V_CNR) ;

RRPRESCOMP_1 = max( min( RPRESCOMP , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RFIPDOM_1-RAIDE_1-RDIFAGRI_1-RFORET_1
                                                 -RFIPC_1-RCINE_1-RRESTIMO_1-RSOCREPR_1) , 0) ;

RRPRESCOMP = max( 0 , RRPRESCOMP_1 * (1-ART1731BIS) 
                      + min( RRPRESCOMP_1 , max(RRPRESCOMP_P+RRPRESCOMPP2 , RRPRESCOMP1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

RPRESCOMPREP =  max( min( RPRESCOMP , IDOM11-DEC11-RCOTFOR-RREPA-RFIPDOM-RAIDE-RDIFAGRI-RFORET
				      -RFIPC-RCINE-RRESTIMO-RSOCREPR) , 0) * positif(RDPRESREPORT) ;

RPRESCOMPAN =  RRPRESCOMP * (1-positif(RDPRESREPORT)) ;
regle 4081 :
application : iliad , batch  ;

DCOTFOR = COTFORET ;

ACOTFOR_R = min(DCOTFOR , PLAF_FOREST1 * (1 + BOOL_0AM)) * (1 - V_CNR) ;

ACOTFOR = (ACOTFOR_R * (1 - ART1731BIS) 
           + min( ACOTFOR_R , max(ACOTFOR_P+ACOTFORP2 , ACOTFOR1731+0) * (1-PREM8_11)) * ART1731BIS
          ) * (1 - V_CNR);

RCOTFOR_1 = max( min( arr(ACOTFOR_R * TX76/100) , IDOM11-DEC11) , 0) ;

RCOTFOR = max(0, RCOTFOR_1 * (1-ART1731BIS) 
                 + min( RCOTFOR_1 , max(RCOTFOR_P+RCOTFORP2 , RCOTFOR1731+0) * (1-PREM8_11)) * ART1731BIS 
             );

regle 408 :
application : iliad , batch  ;


FORTRA = REPFOR + REPSINFOR + REPFOR1 + REPSINFOR1 + REPFOR2 + REPSINFOR2 + REPFOR3 + REPSINFOR3 + REPSINFOR4 ;

DFOREST = FORTRA + RDFOREST;


AFOREST_1 = min (FORTRA, max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR)) * (1 - V_CNR) 
             + min (RDFOREST, PLAF_FOREST * (1 + BOOL_0AM));

AFOREST = ( AFOREST_1 * (1-ART1731BIS) 
            + min( AFOREST_1 , max(AFOREST_P + AFORESTP2 , AFOREST1731+0 ) * (1-PREM8_11)) * ART1731BIS 
          ) * (1 - V_CNR) ;


RFOREST1 = min( REPFOR + REPSINFOR + REPSINFOR1 , max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR)) ;

RFOREST2 = min( REPFOR1 + REPSINFOR2 , max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR - RFOREST1)) ;

RFOREST3 = min( REPFOR2 + REPSINFOR3 +REPFOR3+REPSINFOR4, max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR - RFOREST1 - RFOREST2)) ;

RFOREST = (arr(RFOREST1 * TX25/100) + arr(RFOREST2 * TX22/100) + arr(RFOREST3 * TX18/100)
	  + arr( max(0 , AFOREST - RFOREST1 - RFOREST2 - RFOREST3) * TX18/100)) * (1 - V_CNR) ;

regle 409 :
application : iliad , batch  ;

RFOR_1 = max(min(RFOREST , IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
			   -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV 
                           -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4) , 0) ;

RFOR = max( 0 , RFOR_1 * (1-ART1731BIS) 
                + min( RFOR_1 , max(RFOR_P+RFORP2 , RFOR1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ; 
regle 4092 :
application : iliad , batch  ;


VARD = max(0,min(REPFOR,max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)-REPSINFOR));

REPSIN = max(0 , REPSINFOR - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * (1 - V_CNR) ; 


REPFORSIN = (positif_ou_nul(REPSINFOR+VARD- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPSINFOR1
            + (1-positif_ou_nul(REPSINFOR+VARD- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R))) *
              max(0,REPSINFOR1 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD))) * (1 - V_CNR); 
REPFOREST2 = (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPFOR1
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPFOR1 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1))) * (1 - V_CNR); 

REPFORSIN2 = (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPSINFOR2 
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPSINFOR2 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1-REPFOR1))) * (1 - V_CNR); 
            

REPFOREST3 =  (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPFOR2 
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPFOR2 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1-REPFOR1-REPSINFOR2))) * (1 - V_CNR); 

REPFORSIN3 = (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPSINFOR3
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPSINFOR3 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1-REPFOR1-REPSINFOR2))) * (1 - V_CNR); 
REPEST =  (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2+REPFOR2+REPSINFOR3- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPFOR3 
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2+REPFOR2+REPSINFOR3- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPFOR3 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1-REPFOR1-REPSINFOR2
                                                                 -REPFOR2-REPSINFOR3))) * (1 - V_CNR); 

REPNIS = (positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2+REPFOR2+REPSINFOR3- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)) * REPSINFOR4
           + (1-positif_ou_nul(REPSINFOR+VARD+REPSINFOR1+REPFOR1+REPSINFOR2+REPFOR2+REPSINFOR3- max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R)))
              * max(0,REPSINFOR4 - max(0 , (PLAF_FOREST1 * (1 + BOOL_0AM)) - ACOTFOR_R - REPSINFOR-VARD-REPSINFOR1-REPFOR1-REPSINFOR2
                                                                 -REPFOR2-REPSINFOR3))) * (1 - V_CNR); 

REPFORTOT = REPFOREST2 + REPFOREST3 + REPEST ;

REPFORESTA = REPSIN + REPFORSIN + REPFORSIN2 + REPFORSIN3 + REPNIS ;

regle 4096:
application : iliad , batch  ;


DCREAT = CONVCREA ;

DCREATHANDI = CONVHAND ;


ACREAT = ( DCREAT * (1-ART1731BIS) 
           + min( DCREAT, max( ACREAT_P + ACREATP2 , ACREAT1731+0 ) * (1-PREM8_11)) * ART1731BIS 
         ) * (1 - V_CNR) ;

ACREATHANDI = ( DCREATHANDI * (1-ART1731BIS) 
                + min( DCREATHANDI , max(ACREATHANDI_P + ACREATHANDIP2 , ACREATHANDI1731 ) * (1-PREM8_11)) * ART1731BIS 
              ) * (1 - V_CNR) ; 


RCREATEUR = CONVCREA/2 * PLAF_CRENTR * (1 - V_CNR) ;

RCREATEURHANDI = CONVHAND/2 * PLAF_CRENTRH * (1 - V_CNR) ;

regle 1004096:
application : iliad , batch  ;

RCREAT_1 = max(min( RCREATEUR + RCREATEURHANDI , RRI1-RLOGDOM) , 0) ;

RCREAT = max( 0, RCREAT_1 * (1-ART1731BIS) 
                 + min( RCREAT_1 , max(RCREAT_P+RCREATP2 , RCREAT1731+0 ) * (1-PREM8_11)) * ART1731BIS ) ;

regle 4095:
application : iliad , batch  ;

BDIFAGRI =   min ( INTDIFAGRI , LIM_DIFAGRI * ( 1 + BOOL_0AM)) * ( 1 - V_CNR) ;

DDIFAGRI = INTDIFAGRI ;

ADIFAGRI = BDIFAGRI * (1-ART1731BIS) 
           + min(BDIFAGRI , max(ADIFAGRI_P + ADIFAGRIP2 , ADIFAGRI1731+0) * (1-PREM8_11)) * ART1731BIS ;

RAGRI = arr (BDIFAGRI  * TX_DIFAGRI / 100 );
RDIFAGRI_1 = max( min(RAGRI , IDOM11-DEC11-RCOTFOR_1-RREPA_1-RAIDE_1),0);

RDIFAGRI = max( 0 , RDIFAGRI_1 * (1-ART1731BIS) 
                    + min( RDIFAGRI_1 , max(RDIFAGRI_P+RDIFAGRIP2 , RDIFAGRI1731+0) * (1-PREM8_11)) * ART1731BIS );

regle 430 :
application : iliad , batch  ;

ITRED = min( RED , IDOM11-DEC11) ;


  ####   #    #    ##    #####           #####    #####   ##   ##    
 #    #  #    #   #  #   #    #          #    #  #     #  # # # #
 #       ######  #    #  #    #    ###   #    #  #     #  #  #  #
 #       #    #  ######  #####           #    #  #     #  #     #
 #    #  #    #  #    #  #               #    #  #     #  #     #
  ####   #    #  #    #  #               #####    #####   #     #

regle 40705 :
application : iliad , batch  ;


NRCREAT = (max(min( RCREATEUR + RCREATEURHANDI , RRI1-NRLOGDOM ) , 0)) ;

NRCOMP = (max(min( RFC , RRI1-NRLOGDOM-NRCREAT) , 0)) ;

NRRETU = (max(min( RETUD , RRI1-NRLOGDOM-NRCREAT-NRCOMP) , 0)) ;

NRDONS = (max(min( RON , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU) , 0)) ;

NRDUFREPFI = (max(min( ADUFREPFI , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS) , 0)) ;

NRDUFLOGIH = (max(min( RDUFLO_GIH , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI) , 0)) ;

NRDUFLOEKL = (max(min( RDUFLO_EKL , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH) , 0)) ;

NRPIQABCD = (max(min( RPI_QABCD , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL) , 0)) ;

NRNOUV = (max(min( RSN , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD) , 0 )) ;

NRPLAFPME = (max(min( COD7CY , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD-NRNOUV) , 0 )) ;

NRFOR = (max(min( RFOREST , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD-NRNOUV-NRPLAFPME) , 0 )) ;

NRTOURREP = (max(min( arr(ATOURREP * TX_REDIL25 / 100) , 
                         RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD-NRNOUV-NRPLAFPME-NRFOR) , 0 )) ;

NRTOUHOTR = (max(min( RIHOTR , RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD-NRNOUV-NRPLAFPME-NRFOR-NRTOURREP) , 0)
	        * (1-positif(null(2-V_REGCO)+null(4-V_REGCO)))) ;

NRTOUREPA = (max(min( arr(ATOUREPA * TX_REDIL20 / 100) ,
			 RRI1-NRLOGDOM-NRCREAT-NRCOMP-NRRETU-NRDONS-NRDUFREPFI-NRDUFLOGIH-NRDUFLOEKL-NRPIQABCD-NRNOUV-NRPLAFPME-NRFOR-NRTOURREP-NRTOUHOTR) , 0)) ;

NRRI2 = NRCREAT + NRCOMP + NRRETU + NRDONS + NRDUFREPFI + NRDUFLOGIH + NRDUFLOEKL + NRPIQABCD + NRNOUV + NRPLAFPME + NRFOR + NRTOURREP + NRTOUHOTR + NRTOUREPA ;


NRCELRREDLA = (max( min(CELRREDLA , RRI1-NRLOGDOM-NRRI2) , 0)) ;

NRCELRREDLB = (max( min(CELRREDLB , RRI1-NRLOGDOM-NRRI2-NRCELRREDLA) , 0)) ;

NRCELRREDLE = (max( min(CELRREDLE , RRI1-NRLOGDOM-NRRI2-NRCELRREDLA-NRCELRREDLB) , 0)) ;

NRCELRREDLM = (max( min(CELRREDLM , RRI1-NRLOGDOM-NRRI2-NRCELRREDLA-NRCELRREDLB-NRCELRREDLE) , 0)) ;

NRCELRREDLN = (max( min(CELRREDLN , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M : NRCELRREDLi)) , 0)) ;

NRCELRREDLC = (max( min(CELRREDLC , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N : NRCELRREDLi)) , 0)) ;

NRCELRREDLD = (max( min(CELRREDLD , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C : NRCELRREDLi)) , 0)) ;

NRCELRREDLS = (max( min(CELRREDLS , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D : NRCELRREDLi)) , 0)) ;

NRCELRREDLT = (max( min(CELRREDLT , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S : NRCELRREDLi)) , 0)) ;

NRCELRREDLF = (max( min(CELRREDLF , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T : NRCELRREDLi)) , 0)) ;

NRCELRREDLZ = (max( min(CELRREDLZ , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T,F : NRCELRREDLi)) , 0)) ;

NRCELRREDLX = (max( min(CELRREDLX , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T,F,Z : NRCELRREDLi)) , 0)) ;

NRCELRREDMG = (max( min(CELRREDMG , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)) , 0)) ;

NRCELRREDMH = (max( min(CELRREDMH , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG) , 0)) ;

NRCELREPHS = (max( min(RCELREP_HS , RRI1-NRLOGDOM-NRRI2 - somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH) , 0)) ;

NRCELREPHR = (max( min(RCELREP_HR , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S : NRCELREPHi )) , 0)) ;

NRCELREPHU = (max( min(RCELREP_HU , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R : NRCELREPHi )) , 0)) ;

NRCELREPHT = (max( min(RCELREP_HT , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U : NRCELREPHi )) , 0)) ;

NRCELREPHZ = (max( min(RCELREP_HZ , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T : NRCELREPHi )) , 0)) ;

NRCELREPHX = (max( min(RCELREP_HX , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z : NRCELREPHi )) , 0)) ;

NRCELREPHW = (max( min(RCELREP_HW , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X : NRCELREPHi )) , 0)) ;

NRCELREPHV = (max( min(RCELREP_HV , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W : NRCELREPHi )) , 0)) ;

NRCELREPHF = (max( min(ACELREPHF , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V : NRCELREPHi )) , 0)) ;

NRCELREPHE = (max( min(ACELREPHE , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F : NRCELREPHi )) , 0)) ;

NRCELREPHD = (max( min(ACELREPHD , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E : NRCELREPHi )) , 0)) ;

NRCELREPHH = (max( min(ACELREPHH , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D : NRCELREPHi )) , 0)) ;

NRCELREPHG = (max( min(ACELREPHG , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H : NRCELREPHi )) , 0)) ;

NRCELREPHB = (max( min(ACELREPHB , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G : NRCELREPHi )) , 0)) ;

NRCELREPHA = (max( min(ACELREPHA , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )) , 0)) ;

NRCELREPGU = (max( min(ACELREPGU , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )) , 0)) ;

NRCELREPGX = (max( min(ACELREPGX , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U : NRCELREPGi )) , 0)) ;

NRCELREPGT = (max( min(ACELREPGT , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X : NRCELREPGi )) , 0)) ;

NRCELREPGS = (max( min(ACELREPGS , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T : NRCELREPGi )) , 0)) ;

NRCELREPGW = (max( min(ACELREPGW , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S : NRCELREPGi )) , 0)) ;

NRCELREPGP = (max( min(ACELREPGP , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W : NRCELREPGi )) , 0)) ;

NRCELREPGL = (max( min(ACELREPGL , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P : NRCELREPGi )) , 0)) ;

NRCELREPGV = (max( min(ACELREPGV , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L : NRCELREPGi )) , 0)) ;

NRCELREPGK = (max( min(ACELREPGK , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V : NRCELREPGi )) , 0)) ;

NRCELREPGJ = (max( min(ACELREPGJ , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K : NRCELREPGi )) , 0)) ;

NRCELREPYH = (max( min(ACELREPYH , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )) , 0)) ;

NRCELREPYL = (max( min(ACELREPYL , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H : NRCELREPYi)) , 0)) ;

NRCELREPYG = (max( min(ACELREPYG , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L : NRCELREPYi)) , 0)) ;

NRCELREPYF = (max( min(ACELREPYF , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G : NRCELREPYi)) , 0)) ;

NRCELREPYK = (max( min(ACELREPYK , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F : NRCELREPYi)) , 0)) ;

NRCELREPYE = (max( min(ACELREPYE , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K : NRCELREPYi)) , 0)) ;

NRCELREPYD = (max( min(ACELREPYD , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E : NRCELREPYi)) , 0)) ;

NRCELREPYJ = (max( min(ACELREPYJ , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D : NRCELREPYi)) , 0)) ;

NRCELREPYC = (max( min(ACELREPYC , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J : NRCELREPYi)) , 0)) ;

NRCELREPYB = (max( min(ACELREPYB , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C : NRCELREPYi)) , 0)) ;

NRCELREPYI = (max( min(ACELREPYI , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B : NRCELREPYi)) , 0)) ;

NRCELREPYA = (max( min(ACELREPYA , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I : NRCELREPYi)) , 0)) ;

NRCELHM = (max( min(RCEL_HM , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi ) 
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)) , 0)) ;

NRCELHL = (max( min(RCEL_HL , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi ) 
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
			                               -NRCELHM) , 0)) ;

NRCELHNO = (max( min(RCEL_HNO , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi ) 
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
			                               -NRCELHM-NRCELHL) , 0)) ;

NRCELHJK = (max( min(RCEL_HJK , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi ) 
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
			                               -NRCELHM-NRCELHL-NRCELHNO ) , 0)) ;

NRCELNQ = (max( min(RCEL_NQ , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                      -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi ) 
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK ) , 0)) ;

NRCELNBGL = (max( min(RCEL_NBGL , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi ) 
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ ) , 0)) ;

NRCELCOM = (max( min(RCEL_COM , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi ) 
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL ) , 0)) ;

NRCEL = (max( min(RCEL_2011 , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi ) 
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL 
                                                       -NRCELCOM) , 0)) ;

NRCELJP = (max( min(RCEL_JP , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL) , 0)) ;

NRCELJBGL = (max( min(RCEL_JBGL , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL-NRCELJP) , 0)) ;

NRCELJOQR = (max( min(RCEL_JOQR , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL-NRCELJP-NRCELJBGL) , 0)) ;

NRCEL2012 = (max( min(RCEL_2012 , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL-NRCELJP-NRCELJBGL-NRCELJOQR) , 0)) ;

NRCELFD = (max( min(RCEL_FD , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL-NRCELJP-NRCELJBGL-NRCELJOQR-NRCEL2012) , 0)) ;

NRCELFABC = (max( min(RCEL_FABC , RRI1-NRLOGDOM-NRRI2-somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi)-NRCELRREDMG-NRCELRREDMH
                                                       -somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                                                       -somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                                                       -somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                                                       -NRCELHM-NRCELHL-NRCELHNO-NRCELHJK-NRCELNQ-NRCELNBGL
                                                       -NRCELCOM-NRCEL-NRCELJP-NRCELJBGL-NRCELJOQR-NRCEL2012-NRCELFD) , 0)) ;

NRCELTOT = (somme(i=A,B,E,M,N,C,D,S,T,F,Z,X : NRCELRREDLi) + NRCELRREDMG + NRCELRREDMH
                  + somme (i=S,R,U,T,Z,X,W,V,F,E,D,H,G,B,A : NRCELREPHi )
                  + somme (i=U,X,T,S,W,P,L,V,K,J : NRCELREPGi )
                  + somme (i=H,L,G,F,K,E,D,J,C,B,I,A : NRCELREPYi)
                  + NRCELHM + NRCELHL + NRCELHNO + NRCELHJK + NRCELNQ + NRCELNBGL
                  + NRCELCOM + NRCEL + NRCELJP + NRCELJBGL + NRCELJOQR + NRCEL2012 + NRCELFD + NRCELFABC) ;


NRREDMEUB = (max(min( AREDMEUB , RRI1-NRLOGDOM-NRRI2-NRCELTOT) , 0)) ;

NRREDREP = (max(min( AREDREP , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB) , 0)) ;

NRILMIX = (max(min( AILMIX , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP) , 0)) ;

NRILMIY = (max(min( AILMIY , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX) , 0)) ;

NRILMPA = (max(min( AILMPA , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY) , 0)) ;

NRINVRED = (max(min( AINVRED , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA) , 0)) ;

NRILMIH = (max(min( AILMIH , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED) , 0)) ;

NRILMJC = (max(min(AILMJC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH) , 0)) ;

NRILMPB = (max(min(AILMPB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC) , 0)) ;

NRILMIZ = (max(min( AILMIZ , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB) , 0)) ;

NRILMJI = (max(min( AILMJI , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ) , 0)) ;

NRILMPC = (max(min( AILMPC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI) , 0)) ;

NRILMJS = (max(min( AILMJS , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC) , 0)) ;

NRILMPD = (max(min( AILMPD , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS) , 0)) ;

NRILMPE = (max(min( AILMPE , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD) , 0)) ;

NRMEUBLE = (max(min( MEUBLERET , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                     -NRILMPC-NRILMJS-NRILMPD-NRILMPE) , 0)) ;

NRPROREP = (max(min( RETPROREP , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                     -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE) , 0)) ;

NRREPNPRO = (max(min( RETREPNPRO , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                       -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP) , 0)) ;

NRREPMEU = (max(min( RETREPMEU , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                     -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO) , 0)) ;

NRILMIC = (max(min( AILMIC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU) , 0)) ;

NRILMIB = (max(min( AILMIB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC) , 0)) ;

NRILMIA = (max(min( AILMIA , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB) , 0)) ;

NRILMJY = (max(min( AILMJY , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA) , 0)) ;

NRILMJX = (max(min( AILMJX , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY) , 0)) ;

NRILMJW = (max(min( AILMJW , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX) , 0)) ;

NRILMJV = (max(min( AILMJV , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW) , 0)) ;

NRILMOE = (max(min( AILMOE , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                 -NRILMJV) , 0)) ;

NRILMOD = (max(min( AILMOD , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                 -NRILMJV-NRILMOE) , 0)) ;

NRILMOC = (max(min( AILMOC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                 -NRILMJV-NRILMOE-NRILMOD) , 0)) ;

NRILMOB = (max(min( AILMOB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                 -NRILMJV-NRILMOE-NRILMOD-NRILMOC) , 0)) ;

NRILMOA = (max(min( AILMOA , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                 -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                 -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB) , 0)) ;

NRRESIMEUB = (max(min( RETRESIMEUB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                         -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                         -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA) , 0)) ;

NRRESIVIEU = (max(min( RETRESIVIEU , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                         -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                         -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB) , 0)) ;

NRRESINEUV = (max(min( RETRESINEUV , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                         -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                         -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB-NRRESIMEUB) , 0)) ;

NRLOCIDEFG = (max(min( RETLOCIDEFG , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                         -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                         -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB-NRRESIMEUB-NRRESINEUV) , 0)) ;

NRCODJU = (max(min( RETCODJU , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                   -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                   -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB-NRRESIMEUB-NRRESINEUV-NRLOCIDEFG) , 0)) ;

NRCODJT = (max(min( RETCODJT , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                   -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                   -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB-NRRESIMEUB-NRRESINEUV-NRLOCIDEFG-NRCODJU) , 0)) ;

NRCODOU = (max(min( ACODOU , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRREDMEUB-NRREDREP-NRILMIX-NRILMIY-NRILMPA-NRINVRED-NRILMIH-NRILMJC-NRILMPB-NRILMIZ-NRILMJI
                                   -NRILMPC-NRILMJS-NRILMPD-NRILMPE-NRMEUBLE-NRPROREP-NRREPNPRO-NRREPMEU-NRILMIC-NRILMIB-NRILMIA-NRILMJY-NRILMJX-NRILMJW
                                   -NRILMJV-NRILMOE-NRILMOD-NRILMOC-NRILMOB-NRILMOA-NRRESIMEUB-NRRESIMEUB-NRRESINEUV-NRLOCIDEFG-NRCODJU-NRCODJT) , 0)) ;

NRLOCNPRO = NRREDMEUB + NRREDREP + NRILMIX + NRILMIY + NRILMPA + NRINVRED + NRILMIH + NRILMJC + NRILMPB + NRILMIZ + NRILMJI + NRILMPC + NRILMJS + NRILMPD + NRILMPE 
            + NRMEUBLE + NRPROREP + NRREPNPRO + NRREPMEU + NRILMIC + NRILMIB + NRILMIA + NRILMJY + NRILMJX + NRILMJW + NRILMJV + NRILMOE + NRILMOD + NRILMOC + NRILMOB
            + NRILMOA + NRRESIMEUB + NRRESIVIEU + NRRESINEUV + NRLOCIDEFG + NRCODJU + NRCODJT + NRCODOU ;


NRPATNAT1 = (max(min(APATNAT1 , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO) , 0 )) ;

NRPATNAT2 = (max(min(APATNAT2 , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT1) , 0 )) ;

NRPATNAT3 = (max(min(APATNAT3 , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT1-NRPATNAT2) , 0 )) ;

NRPATNAT = (max(min(APATNAT , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT1-NRPATNAT2-NRPATNAT3) , 0 )) ;

NRRI3 = NRCELTOT + NRLOCNPRO + NRPATNAT1 + NRPATNAT2 + NRPATNAT3 + NRPATNAT ;

regle 4082 :
application : iliad, batch ;



DLOGDOM = INVLOG2008 + INVLGDEB2009 + INVLGDEB + INVLGAUTRE + INVLGDEB2010 + INVLOG2009 
	  + INVOMLOGOA + INVOMLOGOB + INVOMLOGOC + INVOMLOGOH + INVOMLOGOI + INVOMLOGOJ 
	  + INVOMLOGOK + INVOMLOGOL + INVOMLOGOM + INVOMLOGON + INVOMLOGOO + INVOMLOGOP
	  + INVOMLOGOQ + INVOMLOGOR + INVOMLOGOS + INVOMLOGOT + INVOMLOGOU + INVOMLOGOV + INVOMLOGOW 
          + CODHOD + CODHOE + CODHOF + CODHOG + CODHOX + CODHOY + CODHOZ 
          + CODHUA + CODHUB + CODHUC + CODHUD + CODHUE + CODHUF + CODHUG ;


DDOMSOC1 = INVSOCNRET + INVOMSOCKH + INVOMSOCKI + INVSOC2010 + INVOMSOCQU + INVLOGSOC 
           + INVOMSOCQJ + INVOMSOCQS + INVOMSOCQW + INVOMSOCQX 
           + CODHRA + CODHRB + CODHRC + CODHRD ;

DLOGSOC = CODHXA + CODHXB + CODHXC + CODHXE ;


DCOLENT = INVOMREP + NRETROC50 + NRETROC40 + INVENDI + INVOMENTMN + RETROCOMLH + RETROCOMMB
	  + INVOMENTKT + RETROCOMLI + RETROCOMMC + INVOMENTKU + INVOMQV + INVENDEB2009 + INVRETRO1 
	  + INVRETRO2 + INVIMP + INVDOMRET50 + INVDOMRET60 + INVDIR2009 + INVOMRETPA + INVOMRETPB 
	  + INVOMRETPD + INVOMRETPE + INVOMRETPF + INVOMRETPH + INVOMRETPI + INVOMRETPJ + INVOMRETPL 
          + INVOMRETPM + INVOMRETPN + INVOMRETPO + INVOMRETPP + INVOMRETPR + INVOMRETPS + INVOMRETPT
	  + INVOMRETPU + INVOMRETPW + INVOMRETPX + INVOMRETPY + INVOMENTRG + INVOMENTRI + INVOMENTRJ 
	  + INVOMENTRK + INVOMENTRL + INVOMENTRM + INVOMENTRO + INVOMENTRP + INVOMENTRQ + INVOMENTRR 
	  + INVOMENTRT + INVOMENTRU + INVOMENTRV + INVOMENTRW + INVOMENTRY + INVOMENTNU + INVOMENTNV 
          + INVOMENTNW + INVOMENTNY 
          + CODHSA + CODHSB + CODHSC + CODHSE + CODHSF + CODHSG + CODHSH + CODHSJ
          + CODHSK + CODHSL + CODHSM + CODHSO + CODHSP + CODHSQ + CODHSR + CODHST
          + CODHSU + CODHSV + CODHSW + CODHSY + CODHSZ + CODHTA + CODHTB + CODHTD ;

DLOCENT = CODHAA + CODHAB + CODHAC + CODHAD + CODHAF + CODHAG + CODHAH + CODHAI + CODHAK + CODHAL
          + CODHAM + CODHAN + CODHAP + CODHAQ + CODHAR + CODHAS + CODHAU + CODHAV + CODHAW + CODHAX
          + CODHBA + CODHBB + CODHBE + CODHBF ;

regle 4000 :
application : iliad, batch ;


TOTALPLAF1 = INVRETKG + INVRETKH + INVRETKI + INVRETQN + INVRETQU + INVRETQK + INVRETQJ + INVRETQS + INVRETQW + INVRETQX 
             + INVRETRA + INVRETRB + INVRETRC + INVRETRD
             + INVRETXA + INVRETXB + INVRETXC + INVRETXE 
	     + INVRETMA + INVRETLG + INVRETMB + INVRETLH + INVRETMC + INVRETLI + INVRETQP + INVRETQG + INVRETQO + INVRETQF  
	     + INVRETPO + INVRETPT + INVRETPN + INVRETPS + INVRETPP + INVRETPU + INVRETKS + INVRETKT + INVRETKU + INVRETQR 
	     + INVRETQI + INVRETPR + INVRETPW + INVRETQL + INVRETQM + INVRETQD + INVRETOB + INVRETOC + INVRETOM + INVRETON  
             + INVRETOD + INVRETUA
	     + INVRETKGR + INVRETKHR + INVRETKIR + INVRETQNR + INVRETQUR + INVRETQKR + INVRETQJR + INVRETQSR + INVRETQWR
	     + INVRETQXR + INVRETRAR + INVRETRBR + INVRETRCR + INVRETRDR 
             + INVRETXAR + INVRETXBR + INVRETXCR + INVRETXER 
             + INVRETMAR + INVRETLGR + INVRETMBR + INVRETLHR + INVRETMCR + INVRETLIR + INVRETQPR + INVRETQGR 
	     + INVRETQOR + INVRETQFR + INVRETPOR + INVRETPTR + INVRETPNR + INVRETPSR ;

TOTALPLAF2 = INVRETPB + INVRETPF + INVRETPJ + INVRETPA + INVRETPE + INVRETPI + INVRETPY + INVRETPX + INVRETRG + INVRETPD 
	     + INVRETPH + INVRETPL + INVRETRI + INVRETSB + INVRETSG + INVRETSA + INVRETSF + INVRETSC + INVRETSH + INVRETSE 
             + INVRETSJ 
             + INVRETAB + INVRETAG + INVRETAA + INVRETAF + INVRETAC + INVRETAH + INVRETAE + INVRETAJ
             + INVRETOI + INVRETOJ + INVRETOK + INVRETOP + INVRETOQ + INVRETOR + INVRETOE + INVRETOF + INVRETUB + INVRETUC
	     + INVRETPBR + INVRETPFR + INVRETPJR + INVRETPAR + INVRETPER + INVRETPIR + INVRETPYR + INVRETPXR + INVRETSBR
             + INVRETSGR + INVRETSAR + INVRETSFR + INVRETABR + INVRETAGR + INVRETAAR + INVRETAFR ;

TOTALPLAF3 = INVRETRL + INVRETRQ + INVRETRV + INVRETNV + INVRETRK + INVRETRP + INVRETRU + INVRETNU + INVRETRM + INVRETRR 
	     + INVRETRW + INVRETNW + INVRETRO + INVRETRT + INVRETRY + INVRETNY + INVRETSL + INVRETSQ + INVRETSV + INVRETTA
             + INVRETSK + INVRETSP + INVRETSU + INVRETSZ + INVRETSM + INVRETSR + INVRETSW + INVRETTB + INVRETSO + INVRETST
             + INVRETSY + INVRETTD 
             + INVRETAL + INVRETAQ + INVRETAV + INVRETBB + INVRETAK + INVRETAP + INVRETAU + INVRETBA 
             + INVRETAM + INVRETAR + INVRETAW + INVRETBE + INVRETAO + INVRETAT + INVRETAY + INVRETBG
             + INVRETOT + INVRETOU + INVRETOV + INVRETOW + INVRETOG + INVRETOX + INVRETOY + INVRETOZ
             + INVRETUD + INVRETUE + INVRETUF + INVRETUG
	     + INVRETRLR + INVRETRQR + INVRETRVR + INVRETNVR + INVRETRKR + INVRETRPR + INVRETRUR + INVRETNUR + INVRETSLR
             + INVRETSQR + INVRETSVR + INVRETTAR + INVRETSKR + INVRETSPR + INVRETSUR + INVRETSZR 
             + INVRETALR + INVRETAQR + INVRETAVR + INVRETBBR + INVRETAKR + INVRETAPR + INVRETAUR + INVRETBAR ;

RNIDOM1 = arr((RNG + TTPVQ) * TX15/100) ;

RNIDOM2 = arr((RNG + TTPVQ) * TX13/100) ;

RNIDOM3 = arr((RNG + TTPVQ) * TX11/100) ;

INDPLAF1 = positif(RNIDOM1 - TOTALPLAF1) ;



INVRETKGA = min(arr(NINVRETKG * TX35 / 100) , RNIDOM1) * (1 - V_CNR) ;

INVRETKHA = min(arr(NINVRETKH * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA)) * (1 - V_CNR) ;

INVRETKIA = min(arr(NINVRETKI * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA)) * (1 - V_CNR) ;

INVRETQNA = min(arr(NINVRETQN * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA)) * (1 - V_CNR) ;

INVRETQUA = min(arr(NINVRETQU * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA)) * (1 - V_CNR) ;

INVRETQKA = min(arr(NINVRETQK * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA)) * (1 - V_CNR) ;

INVRETQJA = min(arr(NINVRETQJ * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA)) * (1 - V_CNR) ;

INVRETQSA = min(arr(NINVRETQS * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA)) * (1 - V_CNR) ;

INVRETQWA = min(arr(NINVRETQW * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA)) * (1 - V_CNR) ;

INVRETQXA = min(arr(NINVRETQX * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA
							   )) * (1 - V_CNR) ;

INVRETRAA = min(arr(NINVRETRA * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA)) * (1 - V_CNR) ;

INVRETRBA = min(arr(NINVRETRB * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA)) * (1 - V_CNR) ;

INVRETRCA = min(arr(NINVRETRC * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA)) * (1 - V_CNR) ;

INVRETRDA = min(arr(NINVRETRD * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA)) * (1 - V_CNR) ;

INVRETXAA = min(arr(NINVRETXA * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA)) * (1 - V_CNR) ;

INVRETXBA = min(arr(NINVRETXB * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA)) * (1 - V_CNR) ;

INVRETXCA = min(arr(NINVRETXC * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA)) * (1 - V_CNR) ;

INVRETXEA = min(arr(NINVRETXE * TX35 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA)) * (1 - V_CNR) ;

INVRETMAA = min(arr(NINVRETMA * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA)) * (1 - V_CNR) ;

INVRETLGA = min(arr(NINVRETLG * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA)) * (1 - V_CNR) ;

INVRETKSA = min(NINVRETKS , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA)) * (1 - V_CNR) ;

INVRETMBA = min(arr(NINVRETMB * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA)) * (1 - V_CNR) ;

INVRETMCA = min(arr(NINVRETMC * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA)) * (1 - V_CNR) ;

INVRETLHA = min(arr(NINVRETLH * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETMCA)) * (1 - V_CNR) ;

INVRETLIA = min(arr(NINVRETLI * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA)) * (1 - V_CNR) ;

INVRETKTA = min(NINVRETKT , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA)) * (1 - V_CNR) ;

INVRETKUA = min(NINVRETKU , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA)) * (1 - V_CNR) ;

INVRETQPA = min(arr(NINVRETQP * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA)) * (1 - V_CNR) ;

INVRETQGA = min(arr(NINVRETQG * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA)) * (1 - V_CNR) ;

INVRETQOA = min(arr(NINVRETQO * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA)) * (1 - V_CNR) ;

INVRETQFA = min(arr(NINVRETQF * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA)) * (1 - V_CNR) ;

INVRETQRA = min(NINVRETQR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA)) * (1 - V_CNR) ;

INVRETQIA = min(NINVRETQI , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA)) * (1 - V_CNR) ;

INVRETPOA = min(arr(NINVRETPO * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                                              -INVRETQFA-INVRETQRA-INVRETQIA)) * (1 - V_CNR) ;

INVRETPTA = min(arr(NINVRETPT * TX40 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                                              -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA)) * (1 - V_CNR) ;

INVRETPNA = min(arr(NINVRETPN * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                                              -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA)) * (1 - V_CNR) ;

INVRETPSA = min(arr(NINVRETPS * TX50 / 100) , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
                                                              -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                                              -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                                              -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA)) * (1 - V_CNR) ;

INVRETPPA = min(NINVRETPP , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA)) * (1 - V_CNR) ;

INVRETPUA = min(NINVRETPU , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA)) * (1 - V_CNR) ;

INVRETPRA = min(NINVRETPR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA)) * (1 - V_CNR) ;

INVRETPWA = min(NINVRETPW , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA)) * (1 - V_CNR) ;

INVRETQLA = min(NINVRETQL , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA)) * (1 - V_CNR) ;

INVRETQMA = min(NINVRETQM , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA)) * (1 - V_CNR) ;

INVRETQDA = min(NINVRETQD , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA)) * (1 - V_CNR) ;

INVRETOBA = min(NINVRETOB , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA 
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA)) * (1 - V_CNR) ;

INVRETOCA = min(NINVRETOC , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA-INVRETOBA)) * (1 - V_CNR) ;

INVRETOMA = min(NINVRETOM , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA-INVRETOBA-INVRETOCA)) * (1 - V_CNR) ;

INVRETONA = min(NINVRETON , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA-INVRETOBA-INVRETOCA-INVRETOMA)) * (1 - V_CNR) ;

INVRETODA = min(NINVRETOD , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA-INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA)) * (1 - V_CNR) ;

INVRETUAA = min(NINVRETUA , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA
					    -INVRETRAA-INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA
                                            -INVRETKSA-INVRETMBA-INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA
                                            -INVRETQFA-INVRETQRA-INVRETQIA-INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA
                                            -INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA-INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETODA)) * (1 - V_CNR) ;

INVRETKGRA = min(NINVRETKGR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA)) * (1 - V_CNR) ;

INVRETKHRA = min(NINVRETKHR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA)) * (1 - V_CNR) ;

INVRETKIRA = min(NINVRETKIR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA)) * (1 - V_CNR) ;

INVRETQNRA = min(NINVRETQNR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA)) * (1 - V_CNR) ;

INVRETQURA = min(NINVRETQUR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA)) * (1 - V_CNR) ;

INVRETQKRA = min(NINVRETQKR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA)) * (1 - V_CNR) ;

INVRETQJRA = min(NINVRETQJR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA)) * (1 - V_CNR) ;

INVRETQSRA = min(NINVRETQSR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA)) * (1 - V_CNR) ;

INVRETQWRA = min(NINVRETQWR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA)) * (1 - V_CNR) ;

INVRETQXRA = min(NINVRETQXR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA)) * (1 - V_CNR) ;

INVRETRARA = min(NINVRETRAR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA)) * (1 - V_CNR) ;

INVRETRBRA = min(NINVRETRBR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA)) * (1 - V_CNR) ;

INVRETRCRA = min(NINVRETRCR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA)) * (1 - V_CNR) ;

INVRETRDRA = min(NINVRETRDR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA)) * (1 - V_CNR) ;

INVRETXARA = min(NINVRETXAR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA)) * (1 - V_CNR) ;

INVRETXBRA = min(NINVRETXBR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA)) * (1 - V_CNR) ;

INVRETXCRA = min(NINVRETXCR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA)) * (1 - V_CNR) ;

INVRETXERA = min(NINVRETXER , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA)) * (1 - V_CNR) ;

INVRETMARA = min(NINVRETMAR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA)) * (1 - V_CNR) ;

INVRETLGRA = min(NINVRETLGR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA)) * (1 - V_CNR) ;

INVRETMBRA = min(NINVRETMBR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA)) * (1 - V_CNR) ;

INVRETMCRA = min(NINVRETMCR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA)) * (1 - V_CNR) ;

INVRETLHRA = min(NINVRETLHR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETMCRA)) * (1 - V_CNR) ;

INVRETLIRA = min(NINVRETLIR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETMCRA-INVRETLHRA)) * (1 - V_CNR) ;

INVRETQPRA = min(NINVRETQPR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA)) * (1 - V_CNR) ;

INVRETQGRA = min(NINVRETQGR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA)) * (1 - V_CNR) ;

INVRETQORA = min(NINVRETQOR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA)) * (1 - V_CNR) ;

INVRETQFRA = min(NINVRETQFR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA-INVRETQORA)) * (1 - V_CNR) ;

INVRETPORA = min(NINVRETPOR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA-INVRETQORA-INVRETQFRA)) * (1 - V_CNR) ;

INVRETPTRA = min(NINVRETPTR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA-INVRETQORA-INVRETQFRA-INVRETPORA)) * (1 - V_CNR) ;

INVRETPNRA = min(NINVRETPNR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA-INVRETQORA-INVRETQFRA-INVRETPORA-INVRETPTRA)) * (1 - V_CNR) ;

INVRETPSRA = min(NINVRETPSR , max(0 , RNIDOM1 -INVRETKGA-INVRETKHA-INVRETKIA-INVRETQNA-INVRETQUA-INVRETQKA-INVRETQJA-INVRETQSA-INVRETQWA-INVRETQXA-INVRETRAA
                                              -INVRETRBA-INVRETRCA-INVRETRDA-INVRETXAA-INVRETXBA-INVRETXCA-INVRETXEA-INVRETMAA-INVRETLGA-INVRETKSA-INVRETMBA
                                              -INVRETLHA-INVRETMCA-INVRETLIA-INVRETKTA-INVRETKUA-INVRETQPA-INVRETQGA-INVRETQOA-INVRETQFA-INVRETQRA-INVRETQIA
                                              -INVRETPOA-INVRETPTA-INVRETPNA-INVRETPSA-INVRETPPA-INVRETPUA-INVRETPRA-INVRETPWA-INVRETQLA-INVRETQMA-INVRETQDA
                                              -INVRETOBA-INVRETOCA-INVRETOMA-INVRETONA-INVRETUAA-INVRETODA-INVRETKGRA-INVRETKHRA-INVRETKIRA-INVRETQNRA-INVRETQURA
                                              -INVRETQKRA-INVRETQJRA-INVRETQSRA-INVRETQWRA-INVRETQXRA-INVRETRARA-INVRETRBRA-INVRETRCRA-INVRETRDRA-INVRETXARA
                                              -INVRETXBRA-INVRETXCRA-INVRETXERA-INVRETMARA-INVRETLGRA-INVRETMBRA-INVRETLHRA-INVRETLIRA-INVRETMCRA-INVRETQPRA
                                              -INVRETQGRA-INVRETQORA-INVRETQFRA-INVRETPORA-INVRETPTRA-INVRETPNRA)) * (1 - V_CNR) ;

TOTALPLAFA = INVRETKGA + INVRETKHA + INVRETKIA + INVRETQNA + INVRETQUA + INVRETQKA + INVRETQJA + INVRETQSA + INVRETQWA + INVRETQXA 
             + INVRETRAA + INVRETRBA + INVRETRCA + INVRETRDA + INVRETXAA + INVRETXBA + INVRETXCA + INVRETXEA 
             + INVRETMAA + INVRETLGA + INVRETKSA + INVRETMBA + INVRETLHA + INVRETMCA + INVRETLIA + INVRETKTA + INVRETKUA 
             + INVRETQPA + INVRETQGA + INVRETQOA + INVRETQFA + INVRETQRA + INVRETQIA + INVRETPOA + INVRETPTA + INVRETPNA 
             + INVRETPSA + INVRETPPA + INVRETPUA + INVRETPRA + INVRETPWA + INVRETQLA + INVRETQMA + INVRETQDA
             + INVRETOBA + INVRETOCA + INVRETOMA + INVRETONA + INVRETODA + INVRETUAA
             + INVRETKGRA + INVRETKHRA + INVRETKIRA + INVRETQNRA + INVRETQURA + INVRETQKRA + INVRETQJRA + INVRETQSRA + INVRETQWRA + INVRETQXRA 
             + INVRETRARA + INVRETRBRA + INVRETRCRA + INVRETRDRA + INVRETXARA + INVRETXBRA + INVRETXCRA + INVRETXERA 
             + INVRETMARA + INVRETLGRA + INVRETMBRA + INVRETLHRA + INVRETLIRA + INVRETMCRA + INVRETQPRA + INVRETQGRA + INVRETQORA 
             + INVRETQFRA + INVRETPORA + INVRETPTRA + INVRETPNRA + INVRETPSRA ; 

INDPLAF2 = positif(RNIDOM2 - TOTALPLAF2 - TOTALPLAFA) ;


MAXDOM2 = max(0,RNIDOM2 - TOTALPLAFA) ;

INVRETPBA = min(arr(NINVRETPB*TX375/100) , MAXDOM2) * (1 - V_CNR) ; 

INVRETPFA = min(arr(NINVRETPF*TX375/100) , max(0 , MAXDOM2 -INVRETPBA)) * (1 - V_CNR) ;

INVRETPJA = min(arr(NINVRETPJ*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA)) * (1 - V_CNR) ;

INVRETPAA = min(arr(NINVRETPA*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA)) * (1 - V_CNR) ;

INVRETPEA = min(arr(NINVRETPE*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA- INVRETPAA)) * (1 - V_CNR) ;

INVRETPIA = min(arr(NINVRETPI*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA)) * (1 - V_CNR) ;

INVRETPDA = min(NINVRETPD , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA)) * (1 - V_CNR) ;

INVRETPHA = min(NINVRETPH , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA)) * (1 - V_CNR) ;

INVRETPLA = min(NINVRETPL , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA)) * (1 - V_CNR) ;

INVRETPYA = min(arr(NINVRETPY*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA)) * (1 - V_CNR) ;

INVRETPXA = min(arr(NINVRETPX*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                                -INVRETPYA)) * (1 - V_CNR) ;

INVRETRGA = min(NINVRETRG , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA)) * (1 - V_CNR) ;

INVRETRIA = min(NINVRETRI , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA)) * (1 - V_CNR) ;

INVRETSBA = min(arr(NINVRETSB*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA)) * (1 - V_CNR) ;

INVRETSGA = min(arr(NINVRETSG*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA)) * (1 - V_CNR) ;

INVRETSAA = min(arr(NINVRETSA*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA)) * (1 - V_CNR) ;

INVRETSFA = min(arr(NINVRETSF*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA)) * (1 - V_CNR) ;

INVRETSCA = min(NINVRETSC , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA)) * (1 - V_CNR) ;

INVRETSHA = min(NINVRETSH , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA)) * (1 - V_CNR) ;

INVRETSEA = min(NINVRETSE , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA)) * (1 - V_CNR) ;

INVRETSJA = min(NINVRETSJ , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA)) * (1 - V_CNR) ;

INVRETABA = min(arr(NINVRETAB*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                               -INVRETSHA-INVRETSEA-INVRETSJA)) * (1 - V_CNR) ;

INVRETAGA = min(arr(NINVRETAG*TX375/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                               -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA)) * (1 - V_CNR) ;

INVRETAAA = min(arr(NINVRETAA*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                               -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA)) * (1 - V_CNR) ;

INVRETAFA = min(arr(NINVRETAF*TX4737/100) , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                               -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                               -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA)) * (1 - V_CNR) ;

INVRETACA = min(NINVRETAC , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA)) * (1 - V_CNR) ;

INVRETAHA = min(NINVRETAH , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA)) * (1 - V_CNR) ;

INVRETAEA = min(NINVRETAE , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA)) * (1 - V_CNR) ;

INVRETAJA = min(NINVRETAJ , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA)) * (1 - V_CNR) ;

INVRETOIA = min(NINVRETOI , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA)) * (1 - V_CNR) ;

INVRETOJA = min(NINVRETOJ , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA)) * (1 - V_CNR) ;

INVRETOKA = min(NINVRETOK , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA)) * (1 - V_CNR) ;

INVRETOPA = min(NINVRETOP , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA)) * (1 - V_CNR) ;

INVRETOQA = min(NINVRETOQ , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA)) * (1 - V_CNR) ;

INVRETORA = min(NINVRETOR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA)) * (1 - V_CNR) ;

INVRETOEA = min(NINVRETOE , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA)) * (1 - V_CNR) ;

INVRETOFA = min(NINVRETOF , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA)) * (1 - V_CNR) ;

INVRETUBA = min(NINVRETUB , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                -INVRETOFA)) * (1 - V_CNR) ;

INVRETUCA = min(NINVRETUC , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                -INVRETOFA-INVRETUBA)) * (1 - V_CNR) ;

INVRETPBRA = min(NINVRETPBR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA)) * (1 - V_CNR) ;

INVRETPFRA = min(NINVRETPFR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA)) * (1 - V_CNR) ;

INVRETPJRA = min(NINVRETPJR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA)) * (1 - V_CNR) ;

INVRETPARA = min(NINVRETPAR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA)) * (1 - V_CNR) ;

INVRETPERA = min(NINVRETPER , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA)) * (1 - V_CNR) ;

INVRETPIRA = min(NINVRETPIR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA)) * (1 - V_CNR) ;

INVRETPYRA = min(NINVRETPYR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA)) * (1 - V_CNR) ;

INVRETPXRA = min(NINVRETPXR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA)) * (1 - V_CNR) ;

INVRETSBRA = min(NINVRETSBR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA)) * (1 - V_CNR) ;

INVRETSGRA = min(NINVRETSGR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA)) * (1 - V_CNR) ;

INVRETSARA = min(NINVRETSAR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA)) * (1 - V_CNR) ;

INVRETSFRA = min(NINVRETSFR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA-INVRETSARA)) * (1 - V_CNR) ;

INVRETABRA = min(NINVRETABR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA-INVRETSARA-INVRETSFRA)) * (1 - V_CNR) ;

INVRETAGRA = min(NINVRETAGR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA-INVRETSARA-INVRETSFRA-INVRETABRA)) * (1 - V_CNR) ;

INVRETAARA = min(NINVRETAAR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA-INVRETSARA-INVRETSFRA-INVRETABRA-INVRETAGRA)) * (1 - V_CNR) ;

INVRETAFRA = min(NINVRETAFR , max(0 , MAXDOM2 -INVRETPBA-INVRETPFA-INVRETPJA-INVRETPAA-INVRETPEA-INVRETPIA-INVRETPDA-INVRETPHA-INVRETPLA
                                                                  -INVRETPYA-INVRETPXA-INVRETRGA-INVRETRIA-INVRETSBA-INVRETSGA-INVRETSAA-INVRETSFA-INVRETSCA
                                                                  -INVRETSHA-INVRETSEA-INVRETSJA-INVRETABA-INVRETAGA-INVRETAAA-INVRETAFA-INVRETACA-INVRETAHA
                                                                  -INVRETAEA-INVRETAJA-INVRETOIA-INVRETOJA-INVRETOKA-INVRETOPA-INVRETOQA-INVRETORA-INVRETOEA
                                                                  -INVRETOFA-INVRETUBA-INVRETUCA-INVRETPBRA-INVRETPFRA-INVRETPJRA-INVRETPARA-INVRETPERA-INVRETPIRA
                                                                  -INVRETPYRA-INVRETPXRA-INVRETSBRA-INVRETSGRA-INVRETSARA-INVRETSFRA-INVRETABRA-INVRETAGRA
                                                                  -INVRETAARA)) * (1 - V_CNR) ;

TOTALPLAFB = INVRETPBA + INVRETPFA + INVRETPJA + INVRETPAA + INVRETPEA + INVRETPIA + INVRETPDA + INVRETPHA + INVRETPLA + INVRETPYA + INVRETPXA + INVRETRGA 
             + INVRETRIA + INVRETSBA + INVRETSGA + INVRETSAA + INVRETSFA + INVRETABA + INVRETAGA + INVRETAAA + INVRETAFA + INVRETACA + INVRETAHA + INVRETAEA + INVRETAJA
             + INVRETSCA + INVRETSHA + INVRETSEA + INVRETSJA + INVRETOIA + INVRETOJA + INVRETOKA 
             + INVRETOPA + INVRETOQA + INVRETORA + INVRETOEA + INVRETOFA + INVRETUBA + INVRETUCA 
             + INVRETPBRA + INVRETPFRA + INVRETPJRA + INVRETPARA + INVRETPERA + INVRETPIRA + INVRETPYRA + INVRETPXRA + INVRETSBRA + INVRETSGRA + INVRETSARA 
             + INVRETSFRA + INVRETABRA + INVRETAGRA + INVRETAARA + INVRETAFRA ;
 
INDPLAF3 = positif(RNIDOM3 - TOTALPLAF3 - TOTALPLAFA - TOTALPLAFB) ;


MAXDOM3 = max(0,RNIDOM3 -TOTALPLAFA-TOTALPLAFB) ;

INVRETRLA = min(arr(NINVRETRL*TX375/100) , MAXDOM3) * (1 - V_CNR) ; 

INVRETRQA = min(arr(NINVRETRQ*TX375/100) , max(0 , MAXDOM3 -INVRETRLA)) * (1 - V_CNR) ;

INVRETRVA = min(arr(NINVRETRV*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA)) * (1 - V_CNR) ;

INVRETNVA = min(arr(NINVRETNV*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA)) * (1 - V_CNR) ;

INVRETRKA = min(arr(NINVRETRK*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA)) * (1 - V_CNR) ;

INVRETRPA = min(arr(NINVRETRP*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA)) * (1 - V_CNR) ;

INVRETRUA = min(arr(NINVRETRU*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA)) * (1 - V_CNR) ;

INVRETNUA = min(arr(NINVRETNU*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA)) * (1 - V_CNR) ;

INVRETRMA = min(NINVRETRM , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA)) * (1 - V_CNR) ;

INVRETRRA = min(NINVRETRR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA)) * (1 - V_CNR) ;

INVRETRWA = min(NINVRETRW , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA)) * (1 - V_CNR) ;

INVRETNWA = min(NINVRETNW , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                            -INVRETRWA)) * (1 - V_CNR) ;

INVRETROA = min(NINVRETRO , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                            -INVRETRWA-INVRETNWA)) * (1 - V_CNR) ;

INVRETRTA = min(NINVRETRT , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                            -INVRETRWA-INVRETNWA-INVRETROA)) * (1 - V_CNR) ;

INVRETRYA = min(NINVRETRY , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA)) * (1 - V_CNR) ;

INVRETNYA = min(NINVRETNY , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA)) * (1 - V_CNR) ;

INVRETSLA = min(arr(NINVRETSL*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                           -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA)) * (1 - V_CNR) ;

INVRETSQA = min(arr(NINVRETSQ*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                           -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA)) * (1 - V_CNR) ;

INVRETSVA = min(arr(NINVRETSV*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                           -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA)) * (1 - V_CNR) ;

INVRETTAA = min(arr(NINVRETTA*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                           -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA-INVRETSVA)) * (1 - V_CNR) ;

INVRETSKA = min(arr(NINVRETSK*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA)) * (1 - V_CNR) ;

INVRETSPA = min(arr(NINVRETSP*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA
                                                            -INVRETSKA)) * (1 - V_CNR) ;

INVRETSUA = min(arr(NINVRETSU*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA
                                                            -INVRETSKA-INVRETSPA)) * (1 - V_CNR) ;

INVRETSZA = min(arr(NINVRETSZ*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA-INVRETRMA-INVRETRRA
                                                            -INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA-INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA
                                                            -INVRETSKA-INVRETSPA-INVRETSUA)) * (1 - V_CNR) ;

INVRETSMA = min(NINVRETSM , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA)) * (1 - V_CNR) ;

INVRETSRA = min(NINVRETSR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA)) * (1 - V_CNR) ;

INVRETSWA = min(NINVRETSW , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA)) * (1 - V_CNR) ;

INVRETTBA = min(NINVRETTB , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA)) * (1 - V_CNR) ;

INVRETSOA = min(NINVRETSO , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA)) * (1 - V_CNR) ;

INVRETSTA = min(NINVRETST , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA)) * (1 - V_CNR) ;

INVRETSYA = min(NINVRETSY , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA)) * (1 - V_CNR) ;

INVRETTDA = min(NINVRETTD , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA)) * (1 - V_CNR) ;

INVRETALA = min(arr(NINVRETAL*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									                 -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                         -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                         -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA)) * (1 - V_CNR) ;

INVRETAQA = min(arr(NINVRETAQ*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									                 -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                         -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                         -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                         -INVRETALA)) * (1 - V_CNR) ;

INVRETAVA = min(arr(NINVRETAV*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									                 -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                         -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                         -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                         -INVRETALA-INVRETAQA)) * (1 - V_CNR) ;

INVRETBBA = min(arr(NINVRETBB*TX375/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									                 -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                         -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                         -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                         -INVRETALA-INVRETAQA-INVRETAVA)) * (1 - V_CNR) ;

INVRETAKA = min(arr(NINVRETAK*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
								                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA)) * (1 - V_CNR) ;

INVRETAPA = min(arr(NINVRETAP*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
								                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA)) * (1 - V_CNR) ;

INVRETAUA = min(arr(NINVRETAU*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
								                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA)) * (1 - V_CNR) ;

INVRETBAA = min(arr(NINVRETBA*TX4737/100) , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
								                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA)) * (1 - V_CNR) ;

INVRETAMA = min(NINVRETAM , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA)) * (1 - V_CNR) ;

INVRETARA = min(NINVRETAR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA)) * (1 - V_CNR) ;

INVRETAWA = min(NINVRETAW , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA)) * (1 - V_CNR) ;

INVRETBEA = min(NINVRETBE , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA)) * (1 - V_CNR) ;

INVRETAOA = min(NINVRETAO , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA)) * (1 - V_CNR) ;

INVRETATA = min(NINVRETAT , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA)) * (1 - V_CNR) ;

INVRETAYA = min(NINVRETAY , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA)) * (1 - V_CNR) ;

INVRETBGA = min(NINVRETBG , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
						                          -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA)) * (1 - V_CNR) ;

INVRETOTA = min(NINVRETOT , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA)) * (1 - V_CNR) ;

INVRETOUA = min(NINVRETOU , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
                                                                          -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA)) * (1 - V_CNR) ;

INVRETOVA = min(NINVRETOV , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA)) * (1 - V_CNR) ;

INVRETOWA = min(NINVRETOW , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA)) * (1 - V_CNR) ;

INVRETOGA = min(NINVRETOG , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA)) * (1 - V_CNR) ;

INVRETOXA = min(NINVRETOX , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA)) * (1 - V_CNR) ;

INVRETOYA = min(NINVRETOY , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA)) * (1 - V_CNR) ;

INVRETOZA = min(NINVRETOZ , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA)) * (1 - V_CNR) ;

INVRETUDA = min(NINVRETUD , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA)) * (1 - V_CNR) ;

INVRETUEA = min(NINVRETUE , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                          -INVRETUDA)) * (1 - V_CNR) ;

INVRETUFA = min(NINVRETUF , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                          -INVRETUDA-INVRETUEA)) * (1 - V_CNR) ;

INVRETUGA = min(NINVRETUG , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									  -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									  -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                          -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                          -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                          -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                          -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                          -INVRETUDA-INVRETUEA-INVRETUFA)) * (1 - V_CNR) ;

INVRETRLRA = min(NINVRETRLR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA)) * (1 - V_CNR) ;

INVRETRQRA = min(NINVRETRQR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA)) * (1 - V_CNR) ;

INVRETRVRA = min(NINVRETRVR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA)) * (1 - V_CNR) ;

INVRETNVRA = min(NINVRETNVR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA)) * (1 - V_CNR) ;

INVRETRKRA = min(NINVRETRKR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA)) * (1 - V_CNR) ;

INVRETRPRA = min(NINVRETRPR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA)) * (1 - V_CNR) ;

INVRETRURA = min(NINVRETRUR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA)) * (1 - V_CNR) ;

INVRETNURA = min(NINVRETNUR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA)) * (1 - V_CNR) ;

INVRETSLRA = min(NINVRETSLR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA)) * (1 - V_CNR) ;

INVRETSQRA = min(NINVRETSQR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA)) * (1 - V_CNR) ;

INVRETSVRA = min(NINVRETSVR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA)) * (1 - V_CNR) ;

INVRETTARA = min(NINVRETTAR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA)) * (1 - V_CNR) ;

INVRETSKRA = min(NINVRETSKR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA)) * (1 - V_CNR) ;

INVRETSPRA = min(NINVRETSPR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA)) * (1 - V_CNR) ;

INVRETSURA = min(NINVRETSUR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA)) * (1 - V_CNR) ;
                                                                            
INVRETSZRA = min(NINVRETSZR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA)) * (1 - V_CNR) ;

INVRETALRA = min(NINVRETALR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA)) * (1 - V_CNR) ;

INVRETAQRA = min(NINVRETAQR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA)) * (1 - V_CNR) ;

INVRETAVRA = min(NINVRETAVR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA)) * (1 - V_CNR) ;

INVRETBBRA = min(NINVRETBBR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA
                                                                            -INVRETAVRA)) * (1 - V_CNR) ;

INVRETAKRA = min(NINVRETAKR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA
                                                                            -INVRETAVRA-INVRETBBRA)) * (1 - V_CNR) ;

INVRETAPRA = min(NINVRETAPR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA
                                                                            -INVRETAVRA-INVRETBBRA-INVRETAKRA)) * (1 - V_CNR) ;

INVRETAURA = min(NINVRETAUR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA
                                                                            -INVRETAVRA-INVRETBBRA-INVRETAKRA-INVRETAPRA)) * (1 - V_CNR) ;

INVRETBARA = min(NINVRETBAR , max(0 , MAXDOM3 -INVRETRLA-INVRETRQA-INVRETRVA-INVRETNVA-INVRETRKA-INVRETRPA-INVRETRUA-INVRETNUA
									    -INVRETRMA-INVRETRRA-INVRETRWA-INVRETNWA-INVRETROA-INVRETRTA-INVRETRYA-INVRETNYA
									    -INVRETSLA-INVRETSQA-INVRETSVA-INVRETTAA-INVRETSKA-INVRETSPA-INVRETSUA-INVRETSZA
                                                                            -INVRETSMA-INVRETSRA-INVRETSWA-INVRETTBA-INVRETSOA-INVRETSTA-INVRETSYA-INVRETTDA
                                                                            -INVRETALA-INVRETAQA-INVRETAVA-INVRETBBA-INVRETAKA-INVRETAPA-INVRETAUA-INVRETBAA
                                                                            -INVRETAMA-INVRETARA-INVRETAWA-INVRETBEA-INVRETAOA-INVRETATA-INVRETAYA-INVRETBGA
                                                                            -INVRETOTA-INVRETOUA-INVRETOVA-INVRETOWA-INVRETOGA-INVRETOXA-INVRETOYA-INVRETOZA
                                                                            -INVRETUDA-INVRETUEA-INVRETUFA-INVRETUGA-INVRETRLRA-INVRETRQRA-INVRETRVRA-INVRETNVRA
                                                                            -INVRETRKRA-INVRETRPRA-INVRETRURA-INVRETNURA-INVRETSLRA-INVRETSQRA-INVRETSVRA
                                                                            -INVRETTARA-INVRETSKRA-INVRETSPRA-INVRETSURA-INVRETSZRA-INVRETALRA-INVRETAQRA
                                                                            -INVRETAVRA-INVRETBBRA-INVRETAKRA-INVRETAPRA-INVRETAURA)) * (1 - V_CNR) ;

TOTALPLAFC = INVRETRLA + INVRETRQA + INVRETRVA + INVRETNVA + INVRETRKA + INVRETRPA + INVRETRUA + INVRETNUA + INVRETRMA + INVRETRRA + INVRETRWA + INVRETNWA 
             + INVRETROA + INVRETRTA + INVRETRYA + INVRETNYA + INVRETSLA + INVRETSQA + INVRETSVA + INVRETTAA + INVRETSKA + INVRETSPA + INVRETSUA + INVRETSZA
             + INVRETSMA + INVRETSRA + INVRETSWA + INVRETTBA + INVRETSOA + INVRETSTA + INVRETSYA + INVRETTDA 
             + INVRETALA + INVRETAQA + INVRETAVA + INVRETBBA + INVRETAKA + INVRETAPA + INVRETAUA + INVRETBAA 
             + INVRETAMA + INVRETARA + INVRETAWA + INVRETBEA + INVRETAOA + INVRETATA + INVRETAYA + INVRETBGA
             + INVRETOTA + INVRETOUA + INVRETOVA + INVRETOWA + INVRETOGA + INVRETOXA + INVRETOYA + INVRETOZA
             + INVRETUDA + INVRETUEA + INVRETUFA + INVRETUGA
             + INVRETRLRA + INVRETRQRA + INVRETRVRA + INVRETNVRA + INVRETRKRA + INVRETRPRA + INVRETRURA + INVRETNURA + INVRETSLRA + INVRETSQRA + INVRETSVRA 
             + INVRETTARA + INVRETSKRA + INVRETSPRA + INVRETSURA + INVRETSZRA 
             + INVRETALRA + INVRETAQRA + INVRETAVRA + INVRETBBRA + INVRETAKRA + INVRETAPRA + INVRETAURA + INVRETBARA ;

INDPLAF = positif(TOTALPLAFA + TOTALPLAFB + TOTALPLAFC - TOTALPLAF1 - TOTALPLAF2 - TOTALPLAF3) * positif(INDPLAF1 + INDPLAF2 + INDPLAF3) * positif(OPTPLAF15) ;


ALOGDOM_1 = (INVLOG2008 + INVLGDEB2009 + INVLGDEB + INVOMLOGOA + INVOMLOGOH + INVOMLOGOL + INVOMLOGOO + INVOMLOGOS
                      + (INVRETQL + INVRETQM + INVRETQD + INVRETOB + INVRETOC + INVRETOM + INVRETON + INVRETOI + INVRETOJ + INVRETOK + INVRETOP 
			 + INVRETOQ + INVRETOR + INVRETOT + INVRETOU + INVRETOV + INVRETOW + INVRETOD + INVRETOE + INVRETOF + INVRETOG
                         + INVRETOX + INVRETOY + INVRETOZ + INVRETUA + INVRETUB + INVRETUC + INVRETUD + INVRETUE + INVRETUF + INVRETUG) * (1 - INDPLAF)
		      + (INVRETQLA + INVRETQMA + INVRETQDA + INVRETOBA + INVRETOCA + INVRETOMA + INVRETONA + INVRETOIA + INVRETOJA + INVRETOKA 
			 + INVRETOPA + INVRETOQA + INVRETORA + INVRETOTA + INVRETOUA + INVRETOVA + INVRETOWA + INVRETODA + INVRETOEA + INVRETOFA + INVRETOGA
                         + INVRETOXA + INVRETOYA + INVRETOZA + INVRETUAA + INVRETUBA + INVRETUCA + INVRETUDA + INVRETUEA + INVRETUFA + INVRETUGA) * INDPLAF)
	     * (1 - V_CNR) ;

ALOGDOM = ALOGDOM_1 * (1 - ART1731BIS) 
          + min(ALOGDOM_1 , max( ALOGDOM_P + ALOGDOMP2 , ALOGDOM1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

ALOGSOC_1 = ((INVRETXA + INVRETXB + INVRETXC + INVRETXE + INVRETXAR + INVRETXBR + INVRETXCR + INVRETXER) * (1 - INDPLAF) 
	    + (INVRETXAA + INVRETXBA + INVRETXCA + INVRETXEA + INVRETXARA + INVRETXBRA + INVRETXCRA + INVRETXERA) * INDPLAF) 
             * (1 - V_CNR) ;

ALOGSOC = ALOGSOC_1 * (1 - ART1731BIS) 
          + min(ALOGSOC_1 , max(ALOGSOC_P + ALOGSOCP2, ALOGSOC1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

ADOMSOC1_1 = ((INVRETKG + INVRETKH + INVRETKI + INVRETQN + INVRETQU + INVRETQK + INVRETQJ + INVRETQS + INVRETQW + INVRETQX 
               + INVRETRA + INVRETRB + INVRETRC + INVRETRD
               + INVRETKGR + INVRETKHR + INVRETKIR + INVRETQNR + INVRETQUR + INVRETQKR + INVRETQJR + INVRETQSR + INVRETQWR + INVRETQXR
               + INVRETRAR + INVRETRBR + INVRETRCR + INVRETRDR) * (1 - INDPLAF) 
	     + (INVRETKGA + INVRETKHA + INVRETKIA + INVRETQNA + INVRETQUA + INVRETQKA + INVRETQJA + INVRETQSA + INVRETQWA + INVRETQXA
                + INVRETRAA + INVRETRBA + INVRETRCA + INVRETRDA
                + INVRETKGRA + INVRETKHRA + INVRETKIRA + INVRETQNRA + INVRETQURA + INVRETQKRA + INVRETQJRA + INVRETQSRA + INVRETQWRA + INVRETQXRA
                + INVRETRARA + INVRETRBRA + INVRETRCRA + INVRETRDRA) * INDPLAF) 
              * (1 - V_CNR) ;

ADOMSOC1 = ADOMSOC1_1 * (1 - ART1731BIS) 
           + min(ADOMSOC1_1 , max(ADOMSOC1_P + ADOMSOC1P2 , ADOMSOC11731 + 0) * (1-PREM8_11)) * ART1731BIS ;

ALOCENT_1 = ((INVRETAB + INVRETAG + INVRETAA + INVRETAF + INVRETAC + INVRETAH + INVRETAE + INVRETAJ + INVRETAL + INVRETAQ + INVRETAV + INVRETBB 
              + INVRETAK + INVRETAP + INVRETAU + INVRETBA + INVRETAM + INVRETAR + INVRETAW + INVRETBE + INVRETAO + INVRETAT + INVRETAY + INVRETBG
              + INVRETABR + INVRETAGR + INVRETAAR + INVRETAFR + INVRETALR + INVRETAQR + INVRETAVR + INVRETBBR 
              + INVRETAKR + INVRETAPR + INVRETAUR + INVRETBAR) * (1 - INDPLAF)
            + (INVRETABA + INVRETAGA + INVRETAAA + INVRETAFA + INVRETACA + INVRETAHA + INVRETAEA + INVRETAJA + INVRETALA + INVRETAQA + INVRETAVA + INVRETBBA 
               + INVRETAKA + INVRETAPA + INVRETAUA + INVRETBAA + INVRETAMA + INVRETARA + INVRETAWA + INVRETBEA + INVRETAOA + INVRETATA + INVRETAYA + INVRETBGA
               + INVRETABRA + INVRETAGRA + INVRETAARA + INVRETAFRA + INVRETALRA + INVRETAQRA + INVRETAVRA + INVRETBBRA 
               + INVRETAKRA + INVRETAPRA + INVRETAURA + INVRETBARA) * INDPLAF)
            * (1 - V_CNR) ;

ALOCENT = ALOCENT_1 * (1 - ART1731BIS) 
          + min(ALOCENT_1 , max(ALOCENT_P + ALOCENTP2 , ALOCENT1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

ACOLENT_1 = (INVOMREP + INVOMENTMN + INVENDEB2009 + INVOMQV + INVOMRETPM + INVOMENTRJ
		 + (INVRETMA + INVRETLG + INVRETMB + INVRETLH + INVRETMC + INVRETLI + INVRETQP + INVRETQG + INVRETPB + INVRETPF + INVRETPJ + INVRETQO + INVRETQF 
                    + INVRETPA + INVRETPE + INVRETPI + INVRETKS + INVRETKT + INVRETKU + INVRETQR + INVRETQI + INVRETPD + INVRETPH + INVRETPL + INVRETPO + INVRETPT 
                    + INVRETPY + INVRETRL + INVRETRQ + INVRETRV + INVRETNV + INVRETPN + INVRETPS + INVRETPX + INVRETRK + INVRETRP + INVRETRU + INVRETNU + INVRETPP 
                    + INVRETPU + INVRETRG + INVRETRM + INVRETRR + INVRETRW + INVRETNW + INVRETPR + INVRETPW + INVRETRI + INVRETRO + INVRETRT + INVRETRY + INVRETNY
                    + INVRETSB + INVRETSG + INVRETSA + INVRETSF + INVRETSC + INVRETSH + INVRETSE + INVRETSJ + INVRETSL + INVRETSQ + INVRETSV + INVRETTA + INVRETSK
                    + INVRETSP + INVRETSU + INVRETSZ + INVRETSM + INVRETSR + INVRETSW + INVRETTB + INVRETSO + INVRETST + INVRETSY + INVRETTD
                    + INVRETMAR + INVRETLGR + INVRETMBR + INVRETLHR + INVRETMCR + INVRETLIR + INVRETQPR + INVRETQGR + INVRETPBR + INVRETPFR + INVRETPJR + INVRETQOR 
                    + INVRETQFR + INVRETPAR + INVRETPER + INVRETPIR + INVRETPOR + INVRETPTR + INVRETPYR + INVRETRLR + INVRETRQR + INVRETRVR + INVRETNVR + INVRETPNR 
                    + INVRETPSR + INVRETPXR + INVRETRKR + INVRETRPR + INVRETRUR + INVRETNUR + INVRETSBR + INVRETSGR + INVRETSAR + INVRETSFR + INVRETSLR + INVRETSQR 
                    + INVRETSVR + INVRETTAR + INVRETSKR + INVRETSPR + INVRETSUR + INVRETSZR) * (1 - INDPLAF) 
		 + (INVRETMAA + INVRETLGA + INVRETMBA + INVRETLHA + INVRETMCA + INVRETLIA + INVRETQPA + INVRETQGA + INVRETPBA + INVRETPFA + INVRETPJA + INVRETQOA + INVRETQFA
                    + INVRETPAA + INVRETPEA + INVRETPIA + INVRETKSA + INVRETKTA + INVRETKUA + INVRETQRA + INVRETQIA + INVRETPDA + INVRETPHA + INVRETPLA + INVRETPOA + INVRETPTA
                    + INVRETPYA + INVRETRLA + INVRETRQA + INVRETRVA + INVRETNVA + INVRETPNA + INVRETPSA + INVRETPXA + INVRETRKA + INVRETRPA + INVRETRUA + INVRETNUA + INVRETPPA
                    + INVRETPUA + INVRETRGA + INVRETRMA + INVRETRRA + INVRETRWA + INVRETNWA + INVRETPRA + INVRETPWA + INVRETRIA + INVRETROA + INVRETRTA + INVRETRYA + INVRETNYA
                    + INVRETSBA + INVRETSGA + INVRETSAA + INVRETSFA + INVRETSCA + INVRETSHA + INVRETSEA + INVRETSJA + INVRETSLA + INVRETSQA + INVRETSVA + INVRETTAA + INVRETSKA
                    + INVRETSPA + INVRETSUA + INVRETSZA + INVRETSMA + INVRETSRA + INVRETSWA + INVRETTBA + INVRETSOA + INVRETSTA + INVRETSYA + INVRETTDA
                    + INVRETMARA + INVRETLGRA + INVRETMBRA + INVRETLHRA + INVRETMCRA + INVRETLIRA + INVRETQPRA + INVRETQGRA + INVRETPBRA + INVRETPFRA + INVRETPJRA + INVRETQORA
                    + INVRETQFRA + INVRETPARA + INVRETPERA + INVRETPIRA + INVRETPORA + INVRETPTRA + INVRETPYRA + INVRETRLRA + INVRETRQRA + INVRETRVRA + INVRETNVRA + INVRETPNRA
                    + INVRETPSRA + INVRETPXRA + INVRETRKRA + INVRETRPRA + INVRETRURA + INVRETNURA + INVRETSBRA + INVRETSGRA + INVRETSARA + INVRETSFRA + INVRETSLRA + INVRETSQRA 
                    + INVRETSVRA + INVRETTARA + INVRETSKRA + INVRETSPRA + INVRETSURA + INVRETSZRA) * INDPLAF) 
	   * (1 - V_CNR) ;

ACOLENT = ACOLENT_1 * (1 - ART1731BIS) 
          + min(ACOLENT_1 , max(ACOLENT_P + ACOLENTP2 ,ACOLENT1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

regle 4083:
application : iliad, batch ;

NINVRETQB = (max(min(INVLOG2008 , RRI1) , 0) * (1 - V_CNR)) ;

NINVRETQC = (max(min(INVLGDEB2009 , RRI1-INVLOG2008) , 0) * (1 - V_CNR)) ;

NINVRETQT = (max(min(INVLGDEB , RRI1-INVLOG2008-INVLGDEB2009) , 0) * (1 - V_CNR)) ;

NINVRETOA = (max(min(INVOMLOGOA , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB) , 0) * (1 - V_CNR)) ;

NINVRETOH = (max(min(INVOMLOGOH , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA) , 0) * (1 - V_CNR)) ;

NINVRETOL = (max(min(INVOMLOGOL , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH) , 0) * (1 - V_CNR)) ;

NINVRETOO = (max(min(INVOMLOGOO , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL) , 0) * (1 - V_CNR)) ;

NINVRETOS = max(min(INVOMLOGOS , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO) , 0) * (1 - V_CNR) ;

NINVRETQL = max(min(INVLGAUTRE , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS) , 0) * (1 - V_CNR) ;

NINVRETQM = max(min(INVLGDEB2010 , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL) , 0) * (1 - V_CNR) ;

NINVRETQD = max(min(INVLOG2009 , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM) , 0) * (1 - V_CNR) ;

NINVRETOB = max(min(INVOMLOGOB , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD) , 0) * (1 - V_CNR) ;

NINVRETOC = max(min(INVOMLOGOC , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB) , 0) * (1 - V_CNR) ;

NINVRETOI = max(min(INVOMLOGOI , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC) , 0) * (1 - V_CNR) ;

NINVRETOJ = max(min(INVOMLOGOJ , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI) , 0) * (1 - V_CNR) ;

NINVRETOK = max(min(INVOMLOGOK , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ) , 0) * (1 - V_CNR) ;

NINVRETOM = max(min(INVOMLOGOM , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK) , 0) * (1 - V_CNR) ;

NINVRETON = max(min(INVOMLOGON , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM) , 0) * (1 - V_CNR) ;

NINVRETOP = max(min(INVOMLOGOP , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON) , 0) * (1 - V_CNR) ;

NINVRETOQ = max(min(INVOMLOGOQ , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP) , 0) * (1 - V_CNR) ;

NINVRETOR = max(min(INVOMLOGOR , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ) , 0) * (1 - V_CNR) ;

NINVRETOT = max(min(INVOMLOGOT , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR) , 0) * (1 - V_CNR) ;

NINVRETOU = max(min(INVOMLOGOU , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				     -NINVRETOT) , 0) * (1 - V_CNR) ;

NINVRETOV = max(min(INVOMLOGOV , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				     -NINVRETOT-NINVRETOU) , 0) * (1 - V_CNR) ;

NINVRETOW = max(min(INVOMLOGOW , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				     -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				     -NINVRETOT-NINVRETOU-NINVRETOV) , 0) * (1 - V_CNR) ;

NINVRETOD = max(min(CODHOD , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW) , 0) * (1 - V_CNR) ;

NINVRETOE = max(min(CODHOE , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD) , 0) * (1 - V_CNR) ;

NINVRETOF = max(min(CODHOF , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE) , 0) * (1 - V_CNR) ;

NINVRETOG = max(min(CODHOG , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF) , 0) * (1 - V_CNR) ;

NINVRETOX = max(min(CODHOX , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG) , 0) * (1 - V_CNR) ;

NINVRETOY = max(min(CODHOY , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX) , 0) * (1 - V_CNR) ;

NINVRETOZ = max(min(CODHOZ , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY) , 0) * (1 - V_CNR) ;

NINVRETUA = max(min(CODHUA , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ) , 0) * (1 - V_CNR) ;

NINVRETUB = max(min(CODHUB , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA) , 0) * (1 - V_CNR) ;

NINVRETUC = max(min(CODHUC , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA-NINVRETUB) , 0) * (1 - V_CNR) ;

NINVRETUD = max(min(CODHUD , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA-NINVRETUB-NINVRETUC) , 0) * (1 - V_CNR) ;

NINVRETUE = max(min(CODHUE , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA-NINVRETUB-NINVRETUC-NINVRETUD) , 0) * (1 - V_CNR) ;

NINVRETUF = max(min(CODHUF , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA-NINVRETUB-NINVRETUC-NINVRETUD-NINVRETUE) , 0) * (1 - V_CNR) ;

NINVRETUG = max(min(CODHUG , RRI1-INVLOG2008-INVLGDEB2009-INVLGDEB-INVOMLOGOA-INVOMLOGOH-INVOMLOGOL-INVOMLOGOO-INVOMLOGOS-NINVRETQL-NINVRETQM
				 -NINVRETQD-NINVRETOB-NINVRETOC-NINVRETOI-NINVRETOJ-NINVRETOK-NINVRETOM-NINVRETON-NINVRETOP-NINVRETOQ-NINVRETOR
				 -NINVRETOT-NINVRETOU-NINVRETOV-NINVRETOW-NINVRETOD-NINVRETOE-NINVRETOF-NINVRETOG-NINVRETOX-NINVRETOY-NINVRETOZ
                                 -NINVRETUA-NINVRETUB-NINVRETUC-NINVRETUD-NINVRETUE-NINVRETUF) , 0) * (1 - V_CNR) ;

NRLOGDOM = (INVLOG2008 + INVLGDEB2009 + INVLGDEB + INVOMLOGOA + INVOMLOGOH + INVOMLOGOL + INVOMLOGOO + INVOMLOGOS
	    + NINVRETQL + NINVRETQM + NINVRETQD + NINVRETOB + NINVRETOC + NINVRETOI + NINVRETOJ + NINVRETOK
	    + NINVRETOM + NINVRETON + NINVRETOP + NINVRETOQ + NINVRETOR + NINVRETOT + NINVRETOU + NINVRETOV 
            + NINVRETOW + NINVRETOD + NINVRETOE + NINVRETOF + NINVRETOG + NINVRETOX + NINVRETOY + NINVRETOZ
            + NINVRETUA + NINVRETUB + NINVRETUC + NINVRETUD + NINVRETUE + NINVRETUF + NINVRETUG) 
	    * (1 - V_CNR) ;

regle 14084:
application : iliad, batch ;

NINVRETKG = max(min(INVSOCNRET , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT) , 0) * (1 - V_CNR) ;

NINVRETKH = max(min(INVOMSOCKH , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG) , 0) * (1 - V_CNR) ;

NINVRETKI = max(min(INVOMSOCKI , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH) , 0) * (1 - V_CNR) ;

NINVRETQN = max(min(INVSOC2010 , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI) , 0) * (1 - V_CNR) ;

NINVRETQU = max(min(INVOMSOCQU , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN) , 0) * (1 - V_CNR) ;

NINVRETQK = max(min(INVLOGSOC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU) , 0) * (1 - V_CNR) ;

NINVRETQJ = max(min(INVOMSOCQJ , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				     -NINVRETQK) , 0) * (1 - V_CNR) ;

NINVRETQS = max(min(INVOMSOCQS , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				     -NINVRETQK-NINVRETQJ) , 0) * (1 - V_CNR) ;

NINVRETQW = max(min(INVOMSOCQW , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				     -NINVRETQK-NINVRETQJ-NINVRETQS) , 0) * (1 - V_CNR) ;

NINVRETQX = max(min(INVOMSOCQX , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				     -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW) , 0) * (1 - V_CNR) ;

NINVRETRA = max(min(CODHRA , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX) , 0) * (1 - V_CNR) ;

NINVRETRB = max(min(CODHRB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA) , 0) * (1 - V_CNR) ;

NINVRETRC = max(min(CODHRC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB) , 0) * (1 - V_CNR) ;

NINVRETRD = max(min(CODHRD , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB-NINVRETRC) , 0) * (1 - V_CNR) ;

NINVRETXA = max(min(CODHXA , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB-NINVRETRC-NINVRETRD) , 0) * (1 - V_CNR) ;

NINVRETXB = max(min(CODHXB , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB-NINVRETRC-NINVRETRD-NINVRETXA) , 0) * (1 - V_CNR) ;

NINVRETXC = max(min(CODHXC , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB-NINVRETRC-NINVRETRD-NINVRETXA-NINVRETXB) , 0) * (1 - V_CNR) ;

NINVRETXE = max(min(CODHXE , RRI1-NRLOGDOM-NRRI2-NRCELTOT-NRLOCNPRO-NRPATNAT3-NRPATNAT2-NRPATNAT1-NRPATNAT-NINVRETKG-NINVRETKH-NINVRETKI-NINVRETQN-NINVRETQU
				 -NINVRETQK-NINVRETQJ-NINVRETQS-NINVRETQW-NINVRETQX-NINVRETRA-NINVRETRB-NINVRETRC-NINVRETRD-NINVRETXA-NINVRETXB-NINVRETXC) , 0) * (1 - V_CNR) ;

NINVRETKGR = (NINVRETKG - arr(NINVRETKG * TX35 / 100)) * (1 - V_CNR) ;

NINVRETKHR = (NINVRETKH - arr(NINVRETKH * TX35 / 100)) * (1 - V_CNR) ;

NINVRETKIR = (NINVRETKI - arr(NINVRETKI * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQNR = (NINVRETQN - arr(NINVRETQN * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQUR = (NINVRETQU - arr(NINVRETQU * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQKR = (NINVRETQK - arr(NINVRETQK * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQJR = (NINVRETQJ - arr(NINVRETQJ * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQSR = (NINVRETQS - arr(NINVRETQS * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQWR = (NINVRETQW - arr(NINVRETQW * TX35 / 100)) * (1 - V_CNR) ;

NINVRETQXR = (NINVRETQX - arr(NINVRETQX * TX35 / 100)) * (1 - V_CNR) ;

NINVRETRAR = (NINVRETRA - arr(NINVRETRA * TX35 / 100)) * (1 - V_CNR) ;

NINVRETRBR = (NINVRETRB - arr(NINVRETRB * TX35 / 100)) * (1 - V_CNR) ;

NINVRETRCR = (NINVRETRC - arr(NINVRETRC * TX35 / 100)) * (1 - V_CNR) ;

NINVRETRDR = (NINVRETRD - arr(NINVRETRD * TX35 / 100)) * (1 - V_CNR) ;

NINVRETXAR = (NINVRETXA - arr(NINVRETXA * TX35 / 100)) * (1 - V_CNR) ;

NINVRETXBR = (NINVRETXB - arr(NINVRETXB * TX35 / 100)) * (1 - V_CNR) ;

NINVRETXCR = (NINVRETXC - arr(NINVRETXC * TX35 / 100)) * (1 - V_CNR) ;

NINVRETXER = (NINVRETXE - arr(NINVRETXE * TX35 / 100)) * (1 - V_CNR) ;

NRDOMSOC1 = NINVRETKG + NINVRETKH + NINVRETKI + NINVRETQN + NINVRETQU + NINVRETQK + NINVRETQJ + NINVRETQS + NINVRETQW + NINVRETQX + NINVRETRA + NINVRETRB + NINVRETRC + NINVRETRD ;

NRLOGSOC = NINVRETXA + NINVRETXB + NINVRETXC + NINVRETXE ;

regle 4084:
application : iliad, batch ;

INVRETKG = min(arr(NINVRETKG * TX35 / 100) , PLAF_INVDOM) * (1 - V_CNR) ;

INVRETKH = min(arr(NINVRETKH * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG)) * (1 - V_CNR) ; 

INVRETKI = min(arr(NINVRETKI * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH)) * (1 - V_CNR) ; 

INVRETQN = min(arr(NINVRETQN * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI)) * (1 - V_CNR) ; 

INVRETQU = min(arr(NINVRETQU * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN)) * (1 - V_CNR) ; 

INVRETQK = min(arr(NINVRETQK * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU)) * (1 - V_CNR) ;

INVRETQJ = min(arr(NINVRETQJ * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK)) * (1 - V_CNR) ;

INVRETQS = min(arr(NINVRETQS * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ)) * (1 - V_CNR) ;

INVRETQW = min(arr(NINVRETQW * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS)) * (1 - V_CNR) ;

INVRETQX = min(arr(NINVRETQX * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW)) * (1 - V_CNR) ;

INVRETRA = min(arr(NINVRETRA * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX)) * (1 - V_CNR) ;

INVRETRB = min(arr(NINVRETRB * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA)) * (1 - V_CNR) ;

INVRETRC = min(arr(NINVRETRC * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB)) * (1 - V_CNR) ;

INVRETRD = min(arr(NINVRETRD * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB-INVRETRC)) * (1 - V_CNR) ;

INVRETXA = min(arr(NINVRETXA * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB-INVRETRC-INVRETRD)) * (1 - V_CNR) ;

INVRETXB = min(arr(NINVRETXB * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB-INVRETRC-INVRETRD-INVRETXA)) * (1 - V_CNR) ;

INVRETXC = min(arr(NINVRETXC * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB-INVRETRC-INVRETRD-INVRETXA-INVRETXB)) * (1 - V_CNR) ;

INVRETXE = min(arr(NINVRETXE * TX35 / 100) , max(0 , PLAF_INVDOM -INVRETKG-INVRETKH-INVRETKI-INVRETQN-INVRETQU-INVRETQK-INVRETQJ-INVRETQS-INVRETQW
                                                                 -INVRETQX-INVRETRA-INVRETRB-INVRETRC-INVRETRD-INVRETXA-INVRETXB-INVRETXC)) * (1 - V_CNR) ;

INVRETSOC = INVRETKG + INVRETKH + INVRETKI + INVRETQN + INVRETQU + INVRETQK + INVRETQJ + INVRETQS + INVRETQW + INVRETQX 
            + INVRETRA + INVRETRB + INVRETRC + INVRETRD + INVRETXA + INVRETXB + INVRETXC + INVRETXE ;


INVRETKGR = min(max(min(arr(INVRETKG * 13 / 7) , NINVRETKG - INVRETKG) , NINVRETKG - INVRETKG) , PLAF_INVDOM1)
                * (1 - V_CNR) ;

INVRETKHR = min(max(min(arr(INVRETKH * 13 / 7) , NINVRETKH - INVRETKH) , NINVRETKH - INVRETKH) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR)) * (1 - V_CNR) ;

INVRETKIR = min(max(min(arr(INVRETKI * 13 / 7) , NINVRETKI - INVRETKI) , NINVRETKI - INVRETKI) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR)) * (1 - V_CNR) ;

INVRETQNR = min(max(min(arr(INVRETQN * 13 / 7) , NINVRETQN - INVRETQN) , NINVRETQN - INVRETQN) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR)) * (1 - V_CNR) ;

INVRETQUR = min(max(min(arr(INVRETQU * 13 / 7) , NINVRETQU - INVRETQU) , NINVRETQU - INVRETQU) , 
                max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR)) * (1 - V_CNR) ;

INVRETQKR = min(max(min(arr(INVRETQK * 13 / 7) , NINVRETQK - INVRETQK) , NINVRETQK - INVRETQK) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR)) * (1 - V_CNR) ;

INVRETQJR = min(max(min(arr(INVRETQJ * 13 / 7) , NINVRETQJ - INVRETQJ) , NINVRETQJ - INVRETQJ) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR)) * (1 - V_CNR) ;

INVRETQSR = min(max(min(arr(INVRETQS * 13 / 7) , NINVRETQS - INVRETQS) , NINVRETQS - INVRETQS) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR)) * (1 - V_CNR) ;

INVRETQWR = min(max(min(arr(INVRETQW * 13 / 7) , NINVRETQW - INVRETQW) , NINVRETQW - INVRETQW) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR)) * (1 - V_CNR) ;

INVRETQXR = min(max(min(arr(INVRETQX * 13 / 7) , NINVRETQX - INVRETQX) , NINVRETQX - INVRETQX) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR)) * (1 - V_CNR) ;

INVRETRAR = min(max(min(arr(INVRETRA * 13 / 7) , NINVRETRA - INVRETRA) , NINVRETRA - INVRETRA) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR)) * (1 - V_CNR) ;

INVRETRBR = min(max(min(arr(INVRETRB * 13 / 7) , NINVRETRB - INVRETRB) , NINVRETRB - INVRETRB) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR)) * (1 - V_CNR) ;

INVRETRCR = min(max(min(arr(INVRETRC * 13 / 7) , NINVRETRC - INVRETRC) , NINVRETRC - INVRETRC) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR)) * (1 - V_CNR) ;

INVRETRDR = min(max(min(arr(INVRETRD * 13 / 7) , NINVRETRD - INVRETRD) , NINVRETRD - INVRETRD) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR-INVRETRCR)) * (1 - V_CNR) ;

INVRETXAR = min(max(min(arr(INVRETXA * 13 / 7) , NINVRETXA - INVRETXA) , NINVRETXA - INVRETXA) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR-INVRETRCR-INVRETRDR)) * (1 - V_CNR) ;

INVRETXBR = min(max(min(arr(INVRETXB * 13 / 7) , NINVRETXB - INVRETXB) , NINVRETXB - INVRETXB) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR-INVRETRCR-INVRETRDR-INVRETXAR)) * (1 - V_CNR) ;

INVRETXCR = min(max(min(arr(INVRETXC * 13 / 7) , NINVRETXC - INVRETXC) , NINVRETXC - INVRETXC) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR-INVRETRCR-INVRETRDR-INVRETXAR-INVRETXBR)) * (1 - V_CNR) ;

INVRETXER = min(max(min(arr(INVRETXE * 13 / 7) , NINVRETXE - INVRETXE) , NINVRETXE - INVRETXE) , 
		max(0 , PLAF_INVDOM1 -INVRETKGR-INVRETKHR-INVRETKIR-INVRETQNR-INVRETQUR-INVRETQKR-INVRETQJR-INVRETQSR-INVRETQWR-INVRETQXR
                                     -INVRETRAR-INVRETRBR-INVRETRCR-INVRETRDR-INVRETXAR-INVRETXBR-INVRETXCR)) * (1 - V_CNR) ;

regle 4084111:
application : iliad, batch ;

RRISUP = RRI1 - RLOGDOM - RTOURREP - RTOUHOTR - RTOUREPA - RCOMP - RCREAT - RRETU 
              - RDONS - RCELTOT - RLOCNPRO - RDUFLOTOT - RPINELTOT - RNOUV - RPLAFREPME4 - RFOR - RPATNATOT ; 

RSOC11 = arr(max(min((INVRETKG * (1 - INDPLAF) + INVRETKGA * INDPLAF) , RRISUP) , 0)) * (1 - V_CNR) ;

RSOC12 = arr(max(min((INVRETKGR * (1 - INDPLAF) + INVRETKGRA * INDPLAF) , RRISUP -RSOC11) , 0)) * (1 - V_CNR) ;

RSOC13 = arr(max(min((INVRETKH * (1 - INDPLAF) + INVRETKHA * INDPLAF) , RRISUP -RSOC11-RSOC12) , 0)) * (1 - V_CNR) ;

RSOC14 = arr(max(min((INVRETKI * (1 - INDPLAF) + INVRETKIA * INDPLAF) , RRISUP -somme(i=11..13 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC15 = arr(max(min((INVRETKHR * (1 - INDPLAF) + INVRETKHRA * INDPLAF) , RRISUP -somme(i=11..14 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC16 = arr(max(min((INVRETKIR * (1 - INDPLAF) + INVRETKIRA * INDPLAF) , RRISUP -somme(i=11..15 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC17 = arr(max(min((INVRETQN * (1 - INDPLAF) + INVRETQNA * INDPLAF) , RRISUP -somme(i=11..16 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC18 = arr(max(min((INVRETQU * (1 - INDPLAF) + INVRETQUA * INDPLAF) , RRISUP -somme(i=11..17 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC19 = arr(max(min((INVRETQK * (1 - INDPLAF) + INVRETQKA * INDPLAF) , RRISUP -somme(i=11..18 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC20 = arr(max(min((INVRETQNR * (1 - INDPLAF) + INVRETQNRA * INDPLAF) , RRISUP -somme(i=11..19 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC21 = arr(max(min((INVRETQUR * (1 - INDPLAF) + INVRETQURA * INDPLAF) , RRISUP -somme(i=11..20 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC22 = arr(max(min((INVRETQKR * (1 - INDPLAF) + INVRETQKRA * INDPLAF) , RRISUP -somme(i=11..21 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC23 = arr(max(min((INVRETQJ * (1 - INDPLAF) + INVRETQJA * INDPLAF) , RRISUP -somme(i=11..22 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC24 = arr(max(min((INVRETQS * (1 - INDPLAF) + INVRETQSA * INDPLAF) , RRISUP -somme(i=11..23 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC25 = arr(max(min((INVRETQW * (1 - INDPLAF) + INVRETQWA * INDPLAF) , RRISUP -somme(i=11..24 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC26 = arr(max(min((INVRETQX * (1 - INDPLAF) + INVRETQXA * INDPLAF) , RRISUP -somme(i=11..25 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC27 = arr(max(min((INVRETQJR * (1 - INDPLAF) + INVRETQJRA * INDPLAF) , RRISUP -somme(i=11..26 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC28 = arr(max(min((INVRETQSR * (1 - INDPLAF) + INVRETQSRA * INDPLAF) , RRISUP -somme(i=11..27 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC29 = arr(max(min((INVRETQWR * (1 - INDPLAF) + INVRETQWRA * INDPLAF) , RRISUP -somme(i=11..28 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC30 = arr(max(min((INVRETQXR * (1 - INDPLAF) + INVRETQXRA * INDPLAF) , RRISUP -somme(i=11..29 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC31 = arr(max(min((INVRETRA * (1 - INDPLAF) + INVRETRAA * INDPLAF) , RRISUP -somme(i=11..30 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC32 = arr(max(min((INVRETRB * (1 - INDPLAF) + INVRETRBA * INDPLAF) , RRISUP -somme(i=11..31 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC33 = arr(max(min((INVRETRC * (1 - INDPLAF) + INVRETRCA * INDPLAF) , RRISUP -somme(i=11..32 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC34 = arr(max(min((INVRETRD * (1 - INDPLAF) + INVRETRDA * INDPLAF) , RRISUP -somme(i=11..33 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC35 = arr(max(min((INVRETRAR * (1 - INDPLAF) + INVRETRARA * INDPLAF) , RRISUP -somme(i=11..34 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC36 = arr(max(min((INVRETRBR * (1 - INDPLAF) + INVRETRBRA * INDPLAF) , RRISUP -somme(i=11..35 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC37 = arr(max(min((INVRETRCR * (1 - INDPLAF) + INVRETRCRA * INDPLAF) , RRISUP -somme(i=11..36 : RSOCi)) , 0)) * (1 - V_CNR) ;

RSOC38 = arr(max(min((INVRETRDR * (1 - INDPLAF) + INVRETRDRA * INDPLAF) , RRISUP -somme(i=11..37 : RSOCi)) , 0)) * (1 - V_CNR) ;

RDOMSOC1_1 =  (1 - V_CNR) * ((1 - V_INDTEO) * (somme(i=11..38 : RSOCi))

              + V_INDTEO * (arr((V_RSOC11+V_RSOC12 + V_RSOC13+V_RSOC15 + V_RSOC17+V_RSOC20 + V_RSOC23+V_RSOC27
                                + V_RSOC14+V_RSOC16 + V_RSOC18+V_RSOC21 + V_RSOC24+V_RSOC28 + V_RSOC31+V_RSOC35
                                + V_RSOC19+V_RSOC22 + V_RSOC25+V_RSOC29 + V_RSOC32+V_RSOC36
                                + V_RSOC26+V_RSOC30 + V_RSOC33+V_RSOC37 
                                + V_RSOC34+V_RSOC38 
                                ) * (TX65/100)
                               )
                           )
                            ) ;

RDOMSOC1 = RDOMSOC1_1 * (1 - ART1731BIS) 
           + min(RDOMSOC1_1 , max(RDOMSOC1_P+RDOMSOC1P2 , RDOMSOC11731 + 0) * (1-PREM8_11)) * ART1731BIS ;

RSOC1 = arr(max(min((INVRETXA * (1 - INDPLAF) + INVRETXAA * INDPLAF) , RRISUP -RDOMSOC1) , 0)) * (1 - V_CNR) ;

RSOC2 = arr(max(min((INVRETXB * (1 - INDPLAF) + INVRETXBA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1) , 0)) * (1 - V_CNR) ;

RSOC3 = arr(max(min((INVRETXC * (1 - INDPLAF) + INVRETXCA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2) , 0)) * (1 - V_CNR) ;

RSOC4 = arr(max(min((INVRETXE * (1 - INDPLAF) + INVRETXEA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2-RSOC3) , 0)) * (1 - V_CNR) ;

RSOC5 = arr(max(min((INVRETXAR * (1 - INDPLAF) + INVRETXARA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2-RSOC3-RSOC4) , 0)) * (1 - V_CNR) ;

RSOC6 = arr(max(min((INVRETXBR * (1 - INDPLAF) + INVRETXBRA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2-RSOC3-RSOC4-RSOC5) , 0)) * (1 - V_CNR) ;

RSOC7 = arr(max(min((INVRETXCR * (1 - INDPLAF) + INVRETXCRA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2-RSOC3-RSOC4-RSOC5-RSOC6) , 0)) * (1 - V_CNR) ;

RSOC8 = arr(max(min((INVRETXER * (1 - INDPLAF) + INVRETXERA * INDPLAF) , RRISUP -RDOMSOC1-RSOC1-RSOC2-RSOC3-RSOC4-RSOC5-RSOC6-RSOC7) , 0)) * (1 - V_CNR) ;


RLOGSOC_1 = ((1 - V_INDTEO) * (RSOC1 + RSOC2 + RSOC3 + RSOC4 + RSOC5 + RSOC6 + RSOC7 + RSOC8) 


             + V_INDTEO * ( arr(( V_RSOC1+V_RSOC5 + V_RSOC2+V_RSOC6 + V_RSOC3+V_RSOC7 + V_RSOC4+V_RSOC8 ) * (TX65/100)))
            )  * (1 - V_CNR);

RLOGSOC = RLOGSOC_1 * (1 - ART1731BIS)
          + min(RLOGSOC_1 , max(RLOGSOC_P+RLOGSOCP2 , RLOGSOC1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

regle 4085:
application : iliad, batch ;

NINVRETMM = max(min(INVOMREP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3) , 0) 
	     * (1 - V_CNR) ;

NINVRETMN = max(min(INVOMENTMN , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP) , 0) 
	     * (1 - V_CNR) ;

NINVRETQE = max(min(INVENDEB2009 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN) , 0) 
	     * (1 - V_CNR) ;

NINVRETQV = max(min(INVOMQV , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVENDEB2009) , 0) 
	     * (1 - V_CNR) ;

NINVRETPM = max(min(INVOMRETPM , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009) , 0) * (1 - V_CNR) ;

NINVRETRJ = max(min(INVOMENTRJ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM) , 0) * (1 - V_CNR) ;

NINVRETMA = max(min(NRETROC40 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ) , 0) * (1 - V_CNR) ;

NINVRETLG = max(min(NRETROC50 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA) , 0) 
             * (1 - V_CNR) ;

NINVRETKS = max(min(INVENDI , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG) , 0) 
             * (1 - V_CNR) ;

NINVRETMB = max(min(RETROCOMMB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS) , 0) * (1 - V_CNR) ;

NINVRETMC = max(min(RETROCOMMC , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB) , 0) * (1 - V_CNR) ;

NINVRETLH = max(min(RETROCOMLH , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC) , 0) * (1 - V_CNR) ;

NINVRETLI = max(min(RETROCOMLI , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH) , 0) * (1 - V_CNR) ;

NINVRETKT = max(min(INVOMENTKT , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI) , 0) * (1 - V_CNR) ;

NINVRETKU = max(min(INVOMENTKU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT) , 0) * (1 - V_CNR) ;

NINVRETQP = max(min(INVRETRO2 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                    -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU) , 0) * (1 - V_CNR) ;

NINVRETQG = max(min(INVDOMRET60 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                      -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP) , 0) * (1 - V_CNR) ;

NINVRETPB = max(min(INVOMRETPB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG) , 0) * (1 - V_CNR) ;

NINVRETPF = max(min(INVOMRETPF , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB) , 0) * (1 - V_CNR) ;

NINVRETPJ = max(min(INVOMRETPJ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF) , 0) * (1 - V_CNR) ;

NINVRETQO = max(min(INVRETRO1 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                    -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ) , 0) * (1 - V_CNR) ;

NINVRETQF = max(min(INVDOMRET50 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                      -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                      -NINVRETQO) , 0) * (1 - V_CNR) ;

NINVRETPA = max(min(INVOMRETPA , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                     -NINVRETQO-NINVRETQF) , 0) * (1 - V_CNR) ;

NINVRETPE = max(min(INVOMRETPE , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                     -NINVRETQO-NINVRETQF-NINVRETPA) , 0) * (1 - V_CNR) ;

NINVRETPI = max(min(INVOMRETPI , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                     -NINVRETQO-NINVRETQF-NINVRETPA-NINVRETPE) , 0) * (1 - V_CNR) ;

NINVRETQR = max(min(INVIMP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                 -NINVRETQO-NINVRETQF-NINVRETPA-NINVRETPE-NINVRETPI) , 0) * (1 - V_CNR) ;

NINVRETQI = max(min(INVDIR2009 , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETPB-NINVRETPF-NINVRETPJ
                                     -NINVRETQO-NINVRETQF-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETQR) , 0) * (1 - V_CNR) ;

NINVRETPD = max(min(INVOMRETPD , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI) , 0) * (1 - V_CNR) ;

NINVRETPH = max(min(INVOMRETPH , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD) , 0) * (1 - V_CNR) ;

NINVRETPL = max(min(INVOMRETPL , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH) , 0) * (1 - V_CNR) ;

NINVRETPO = max(min(INVOMRETPO , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL) , 0) * (1 - V_CNR) ;

NINVRETPT = max(min(INVOMRETPT , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO) , 0) * (1 - V_CNR) ;

NINVRETPY = max(min(INVOMRETPY , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT) , 0) 
				     * (1 - V_CNR) ;

NINVRETRL = max(min(INVOMENTRL , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY) , 0) * (1 - V_CNR) ;

NINVRETRQ = max(min(INVOMENTRQ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL) , 0) * (1 - V_CNR) ;

NINVRETRV = max(min(INVOMENTRV , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ) , 0) * (1 - V_CNR) ;

NINVRETNV = max(min(INVOMENTNV , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV) , 0) * (1 - V_CNR) ;

NINVRETPN = max(min(INVOMRETPN , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV) , 0) * (1 - V_CNR) ;

NINVRETPS = max(min(INVOMRETPS , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN) , 0) * (1 - V_CNR) ;

NINVRETPX = max(min(INVOMRETPX , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS) , 0) * (1 - V_CNR) ;

NINVRETRK = max(min(INVOMENTRK , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX) , 0) * (1 - V_CNR) ;

NINVRETRP = max(min(INVOMENTRP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK) , 0) * (1 - V_CNR) ;

NINVRETRU = max(min(INVOMENTRU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP) , 0) * (1 - V_CNR) ;

NINVRETNU = max(min(INVOMENTNU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU) , 0) * (1 - V_CNR) ;

NINVRETPP = max(min(INVOMRETPP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU) , 0) 
				     * (1 - V_CNR) ;

NINVRETPU = max(min(INVOMRETPU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP) , 0) * (1 - V_CNR) ;

NINVRETRG = max(min(INVOMENTRG , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU) , 0) * (1 - V_CNR) ;

NINVRETRM = max(min(INVOMENTRM , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG) , 0) * (1 - V_CNR) ;

NINVRETRR = max(min(INVOMENTRR , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM) , 0) * (1 - V_CNR) ;

NINVRETRW = max(min(INVOMENTRW , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR) , 0) * (1 - V_CNR) ;

NINVRETNW = max(min(INVOMENTNW , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW) , 0) * (1 - V_CNR) ;

NINVRETPR = max(min(INVOMRETPR , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW) , 0) * (1 - V_CNR) ;

NINVRETPW = max(min(INVOMRETPW , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR) , 0) * (1 - V_CNR) ;

NINVRETRI = max(min(INVOMENTRI , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW) , 0) * (1 - V_CNR) ;

NINVRETRO = max(min(INVOMENTRO , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI) , 0) * (1 - V_CNR) ;

NINVRETRT = max(min(INVOMENTRT , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO) , 0) * (1 - V_CNR) ;

NINVRETRY = max(min(INVOMENTRY , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT) , 0) 
				     * (1 - V_CNR) ;

NINVRETNY = max(min(INVOMENTNY , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                     -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                     -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
				     -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				     -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				     -NINVRETRY) , 0) * (1 - V_CNR) ;

NINVRETSB = max(min(CODHSB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY) , 0) * (1 - V_CNR) ;

NINVRETSG = max(min(CODHSG , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB) , 0) * (1 - V_CNR) ;

NINVRETSL = max(min(CODHSL , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG) , 0) * (1 - V_CNR) ;

NINVRETSQ = max(min(CODHSQ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL) , 0) * (1 - V_CNR) ;

NINVRETSV = max(min(CODHSV , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ) , 0) * (1 - V_CNR) ;

NINVRETTA = max(min(CODHTA , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV) , 0) * (1 - V_CNR) ;

NINVRETSA = max(min(CODHSA , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA) , 0) * (1 - V_CNR) ;

NINVRETSF = max(min(CODHSF , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA) , 0) * (1 - V_CNR) ;

NINVRETSK = max(min(CODHSK , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF) , 0) * (1 - V_CNR) ;

NINVRETSP = max(min(CODHSP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK) , 0) * (1 - V_CNR) ;

NINVRETSU = max(min(CODHSU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP) , 0) * (1 - V_CNR) ;

NINVRETSZ = max(min(CODHSZ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU) , 0) * (1 - V_CNR) ;

NINVRETSC = max(min(CODHSC , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ) , 0) * (1 - V_CNR) ;

NINVRETSH = max(min(CODHSH , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC) , 0) * (1 - V_CNR) ;

NINVRETSM = max(min(CODHSM , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH) , 0) * (1 - V_CNR) ;

NINVRETSR = max(min(CODHSR , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM) , 0) * (1 - V_CNR) ;

NINVRETSW = max(min(CODHSW , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR) , 0) * (1 - V_CNR) ;

NINVRETTB = max(min(CODHTB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW) , 0) * (1 - V_CNR) ;

NINVRETSE = max(min(CODHSE , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB) , 0) * (1 - V_CNR) ;

NINVRETSJ = max(min(CODHSJ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE) , 0) * (1 - V_CNR) ;

NINVRETSO = max(min(CODHSO , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ) , 0) * (1 - V_CNR) ;

NINVRETST = max(min(CODHST , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO) , 0) * (1 - V_CNR) ;

NINVRETSY = max(min(CODHSY , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST) , 0) * (1 - V_CNR) ;

NINVRETTD = max(min(CODHTD , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY) , 0) * (1 - V_CNR) ;

NINVRETAB = max(min(CODHAB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD) , 0) * (1 - V_CNR) ;

NINVRETAG = max(min(CODHAG , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB) , 0) * (1 - V_CNR) ;

NINVRETAL = max(min(CODHAL , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG) , 0) * (1 - V_CNR) ;

NINVRETAQ = max(min(CODHAQ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL) , 0) * (1 - V_CNR) ;

NINVRETAV = max(min(CODHAV , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ) , 0) * (1 - V_CNR) ;

NINVRETBB = max(min(CODHBB , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV) , 0) * (1 - V_CNR) ;

NINVRETAA = max(min(CODHAA , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB) , 0) * (1 - V_CNR) ;

NINVRETAF = max(min(CODHAF , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA) , 0) * (1 - V_CNR) ;

NINVRETAK = max(min(CODHAK , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF) , 0) * (1 - V_CNR) ;

NINVRETAP = max(min(CODHAP , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK) , 0) * (1 - V_CNR) ;

NINVRETAU = max(min(CODHAU , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP) , 0) * (1 - V_CNR) ;

NINVRETBA = max(min(CODHBA , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU) , 0) * (1 - V_CNR) ;

NINVRETAC = max(min(CODHAC , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA) , 0) * (1 - V_CNR) ;

NINVRETAH = max(min(CODHAH , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC) , 0) * (1 - V_CNR) ;

NINVRETAM = max(min(CODHAM , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH) , 0) * (1 - V_CNR) ;

NINVRETAR = max(min(CODHAR , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM) , 0) * (1 - V_CNR) ;

NINVRETAW = max(min(CODHAW , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR) , 0) * (1 - V_CNR) ;

NINVRETBE = max(min(CODHBE , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW) , 0) * (1 - V_CNR) ;

NINVRETAE = max(min(CODHAE , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE) , 0) * (1 - V_CNR) ;

NINVRETAJ = max(min(CODHAJ , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE-NINVRETAE) , 0) * (1 - V_CNR) ;

NINVRETAO = max(min(CODHAO , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE-NINVRETAE-NINVRETAJ) , 0) * (1 - V_CNR) ;

NINVRETAT = max(min(CODHAT , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE-NINVRETAE-NINVRETAJ-NINVRETAO) , 0) * (1 - V_CNR) ;

NINVRETAY = max(min(CODHAY , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE-NINVRETAE-NINVRETAJ-NINVRETAO-NINVRETAT) , 0) * (1 - V_CNR) ;

NINVRETBG = max(min(CODHBG , RRI1-NRLOGDOM-NRRI2-NRLOGSOC-NRDOMSOC1-NRRI3-INVOMREP-INVOMENTMN-INVOMQV-INVENDEB2009-NINVRETPM-NINVRETRJ-NINVRETMA-NINVRETLG
                                 -NINVRETKS-NINVRETMB-NINVRETMC-NINVRETLH-NINVRETLI-NINVRETKT-NINVRETKU-NINVRETQP-NINVRETQG-NINVRETQO-NINVRETQF-NINVRETQR
                                 -NINVRETQI-NINVRETPB-NINVRETPF-NINVRETPJ-NINVRETPA-NINVRETPE-NINVRETPI-NINVRETPD-NINVRETPH-NINVRETPL-NINVRETPO-NINVRETPT
			         -NINVRETPY-NINVRETRL-NINVRETRQ-NINVRETRV-NINVRETNV-NINVRETPN-NINVRETPS-NINVRETPX-NINVRETRK-NINVRETRP-NINVRETRU-NINVRETNU
				 -NINVRETPP-NINVRETPU-NINVRETRG-NINVRETRM-NINVRETRR-NINVRETRW-NINVRETNW-NINVRETPR-NINVRETPW-NINVRETRI-NINVRETRO-NINVRETRT
				 -NINVRETRY-NINVRETNY-NINVRETSB-NINVRETSG-NINVRETSL-NINVRETSQ-NINVRETSV-NINVRETTA-NINVRETSA-NINVRETSF-NINVRETSK-NINVRETSP
                                 -NINVRETSU-NINVRETSZ-NINVRETSC-NINVRETSH-NINVRETSM-NINVRETSR-NINVRETSW-NINVRETTB-NINVRETSE-NINVRETSJ-NINVRETSO-NINVRETST
                                 -NINVRETSY-NINVRETTD-NINVRETAB-NINVRETAG-NINVRETAL-NINVRETAQ-NINVRETAV-NINVRETBB-NINVRETAA-NINVRETAF-NINVRETAK-NINVRETAP
                                 -NINVRETAU-NINVRETBA-NINVRETAC-NINVRETAH-NINVRETAM-NINVRETAR-NINVRETAW-NINVRETBE-NINVRETAE-NINVRETAJ-NINVRETAO-NINVRETAT
                                 -NINVRETAY) , 0) * (1 - V_CNR) ;

NINVRETMAR = (NINVRETMA - arr(NINVRETMA * TX40 / 100)) * (1 - V_CNR) ;

NINVRETLGR = (NINVRETLG - arr(NINVRETLG * TX50 / 100)) * (1 - V_CNR) ;

NINVRETMBR = (NINVRETMB - arr(NINVRETMB * TX40 / 100)) * (1 - V_CNR) ;

NINVRETMCR = (NINVRETMC - arr(NINVRETMC * TX40 / 100)) * (1 - V_CNR) ;

NINVRETLHR = (NINVRETLH - arr(NINVRETLH * TX50 / 100)) * (1 - V_CNR) ;

NINVRETLIR = (NINVRETLI - arr(NINVRETLI * TX50 / 100)) * (1 - V_CNR) ;

NINVRETQPR = (NINVRETQP - arr(NINVRETQP * TX40 / 100)) * (1 - V_CNR) ;

NINVRETQGR = (NINVRETQG - arr(NINVRETQG * TX40 / 100)) * (1 - V_CNR) ;

NINVRETQOR = (NINVRETQO - arr(NINVRETQO * TX50 / 100)) * (1 - V_CNR) ;

NINVRETQFR = (NINVRETQF - arr(NINVRETQF * TX50 / 100)) * (1 - V_CNR) ;

NINVRETPOR = (NINVRETPO - arr(NINVRETPO * TX40 / 100)) * (1 - V_CNR) ;

NINVRETPTR = (NINVRETPT - arr(NINVRETPT * TX40 / 100)) * (1 - V_CNR) ;

NINVRETPNR = (NINVRETPN - arr(NINVRETPN * TX50 / 100)) * (1 - V_CNR) ;

NINVRETPSR = (NINVRETPS - arr(NINVRETPS * TX50 / 100)) * (1 - V_CNR) ;

NINVRETPBR = (NINVRETPB - arr(NINVRETPB * TX375/ 100)) * (1 - V_CNR) ;

NINVRETPFR = (NINVRETPF - arr(NINVRETPF * TX375/ 100)) * (1 - V_CNR) ;

NINVRETPJR = (NINVRETPJ - arr(NINVRETPJ * TX375/ 100)) * (1 - V_CNR) ;

NINVRETPAR = (NINVRETPA - arr(NINVRETPA * TX4737/100)) * (1 - V_CNR) ;

NINVRETPER = (NINVRETPE - arr(NINVRETPE * TX4737/100)) * (1 - V_CNR) ;

NINVRETPIR = (NINVRETPI - arr(NINVRETPI * TX4737/100)) * (1 - V_CNR) ;

NINVRETPYR = (NINVRETPY - arr(NINVRETPY * TX375/100)) * (1 - V_CNR) ;

NINVRETPXR = (NINVRETPX - arr(NINVRETPX * TX4737/100)) * (1 - V_CNR) ;

NINVRETSBR = (NINVRETSB - arr(NINVRETSB * TX375/100)) * (1 - V_CNR) ;

NINVRETSGR = (NINVRETSG - arr(NINVRETSG * TX375/100)) * (1 - V_CNR) ;

NINVRETSAR = (NINVRETSA - arr(NINVRETSA * TX4737/100)) * (1 - V_CNR) ;

NINVRETSFR = (NINVRETSF - arr(NINVRETSF * TX4737/100)) * (1 - V_CNR) ;

NINVRETABR = (NINVRETAB - arr(NINVRETAB * TX375/100)) * (1 - V_CNR) ;

NINVRETAGR = (NINVRETAG - arr(NINVRETAG * TX375/100)) * (1 - V_CNR) ;

NINVRETAAR = (NINVRETAA - arr(NINVRETAA * TX4737/100)) * (1 - V_CNR) ;

NINVRETAFR = (NINVRETAF - arr(NINVRETAF * TX4737/100)) * (1 - V_CNR) ;

NINVRETRLR = (NINVRETRL - arr(NINVRETRL * TX375/100)) * (1 - V_CNR) ;

NINVRETRQR = (NINVRETRQ - arr(NINVRETRQ * TX375/100)) * (1 - V_CNR) ;

NINVRETRVR = (NINVRETRV - arr(NINVRETRV * TX375/100)) * (1 - V_CNR) ;

NINVRETNVR = (NINVRETNV - arr(NINVRETNV * TX375/100)) * (1 - V_CNR) ;

NINVRETRKR = (NINVRETRK - arr(NINVRETRK * TX4737/100)) * (1 - V_CNR) ;

NINVRETRPR = (NINVRETRP - arr(NINVRETRP * TX4737/100)) * (1 - V_CNR) ;

NINVRETRUR = (NINVRETRU - arr(NINVRETRU * TX4737/100)) * (1 - V_CNR) ;

NINVRETNUR = (NINVRETNU - arr(NINVRETNU * TX4737/100)) * (1 - V_CNR) ;

NINVRETSLR = (NINVRETSL - arr(NINVRETSL * TX375/100)) * (1 - V_CNR) ;

NINVRETSQR = (NINVRETSQ - arr(NINVRETSQ * TX375/100)) * (1 - V_CNR) ;

NINVRETSVR = (NINVRETSV - arr(NINVRETSV * TX375/100)) * (1 - V_CNR) ;

NINVRETTAR = (NINVRETTA - arr(NINVRETTA * TX375/100)) * (1 - V_CNR) ;

NINVRETSKR = (NINVRETSK - arr(NINVRETSK * TX4737/100)) * (1 - V_CNR) ;

NINVRETSPR = (NINVRETSP - arr(NINVRETSP * TX4737/100)) * (1 - V_CNR) ;

NINVRETSUR = (NINVRETSU - arr(NINVRETSU * TX4737/100)) * (1 - V_CNR) ;

NINVRETSZR = (NINVRETSZ - arr(NINVRETSZ * TX4737/100)) * (1 - V_CNR) ;

NINVRETALR = (NINVRETAL - arr(NINVRETAL * TX375/100)) * (1 - V_CNR) ;

NINVRETAQR = (NINVRETAQ - arr(NINVRETAQ * TX375/100)) * (1 - V_CNR) ;

NINVRETAVR = (NINVRETAV - arr(NINVRETAV * TX375/100)) * (1 - V_CNR) ;

NINVRETBBR = (NINVRETBB - arr(NINVRETBB * TX375/100)) * (1 - V_CNR) ;

NINVRETAKR = (NINVRETAK - arr(NINVRETAK * TX4737/100)) * (1 - V_CNR) ;

NINVRETAPR = (NINVRETAP - arr(NINVRETAP * TX4737/100)) * (1 - V_CNR) ;

NINVRETAUR = (NINVRETAU - arr(NINVRETAU * TX4737/100)) * (1 - V_CNR) ;

NINVRETBAR = (NINVRETBA - arr(NINVRETBA * TX4737/100)) * (1 - V_CNR) ;

regle 14083:
application : iliad, batch ;

INVRETMM = NINVRETMM * (1 - V_CNR) ;

INVRETMN = NINVRETMN * (1 - V_CNR) ;

INVRETQE = NINVRETQE * (1 - V_CNR) ;

INVRETQV = NINVRETQV * (1 - V_CNR) ;

INVRETMA = min(arr(NINVRETMA * TX40 / 100) , max(0 , PLAF_INVDOM -INVRETSOC)) * (1 - V_CNR) ;

INVRETLG = min(arr(NINVRETLG * TX50 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA)) * (1 - V_CNR) ;

INVRETMB = min(arr(NINVRETMB * TX40 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG)) * (1 - V_CNR) ;

INVRETMC = min(arr(NINVRETMC * TX40 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB)) * (1 - V_CNR) ;

INVRETLH = min(arr(NINVRETLH * TX50 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC)) * (1 - V_CNR) ;

INVRETLI = min(arr(NINVRETLI * TX50 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH)) * (1 - V_CNR) ;

INVRETQP = min(arr(NINVRETQP * TX40 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI)) * (1 - V_CNR) ;

INVRETQG = min(arr(NINVRETQG * TX40 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP)) * (1 - V_CNR) ;

INVRETQO = min(arr(NINVRETQO * TX50 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG)) * (1 - V_CNR) ;

INVRETQF = min(arr(NINVRETQF * TX50 / 100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO)) * (1 - V_CNR) ;

INVRETPB = min(arr(NINVRETPB * TX375/ 100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF)) * (1 - V_CNR) ;

INVRETPF = min(arr(NINVRETPF * TX375/ 100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB)) * (1 - V_CNR) ;

INVRETPJ = min(arr(NINVRETPJ * TX375/ 100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF)) * (1 - V_CNR) ;

INVRETPA = min(arr(NINVRETPA * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ)) * (1 - V_CNR) ;

INVRETPE = min(arr(NINVRETPE * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA)) * (1 - V_CNR) ;

INVRETPI = min(arr(NINVRETPI * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE)) * (1 - V_CNR) ;

INVRETPO = min(arr(NINVRETPO * TX40/100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI)) * (1 - V_CNR) ;

INVRETPT = min(arr(NINVRETPT * TX40/100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO)) * (1 - V_CNR) ;

INVRETPY = min(arr(NINVRETPY * TX375/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT)) * (1 - V_CNR) ;

INVRETRL = min(arr(NINVRETRL * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY)) * (1 - V_CNR) ;

INVRETRQ = min(arr(NINVRETRQ * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL)) * (1 - V_CNR) ;

INVRETRV = min(arr(NINVRETRV * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ)) * (1 - V_CNR) ;

INVRETNV = min(arr(NINVRETNV * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV)) * (1 - V_CNR) ;

INVRETPN = min(arr(NINVRETPN * TX50/100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                               -INVRETRL-INVRETRQ-INVRETRV-INVRETNV)) * (1 - V_CNR) ;

INVRETPS = min(arr(NINVRETPS * TX50/100) , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                               -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN)) * (1 - V_CNR) ;

INVRETPX = min(arr(NINVRETPX * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS)) * (1 - V_CNR) ;

INVRETRK = min(arr(NINVRETRK * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX)) * (1 - V_CNR) ;

INVRETRP = min(arr(NINVRETRP * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK)) * (1 - V_CNR) ;

INVRETRU = min(arr(NINVRETRU * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP)) * (1 - V_CNR) ;

INVRETNU = min(arr(NINVRETNU * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU)) * (1 - V_CNR) ;

INVRETSB = min(arr(NINVRETSB * TX375/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU)) * (1 - V_CNR) ;

INVRETSG = min(arr(NINVRETSG * TX375/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB)) * (1 - V_CNR) ;

INVRETSL = min(arr(NINVRETSL * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG)) * (1 - V_CNR) ;

INVRETSQ = min(arr(NINVRETSQ * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL)) * (1 - V_CNR) ;

INVRETSV = min(arr(NINVRETSV * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ)) * (1 - V_CNR) ;

INVRETTA = min(arr(NINVRETTA * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV)) * (1 - V_CNR) ;

INVRETSA = min(arr(NINVRETSA * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA)) * (1 - V_CNR) ;

INVRETSF = min(arr(NINVRETSF * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA)) * (1 - V_CNR) ;

INVRETSK = min(arr(NINVRETSK * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF)) * (1 - V_CNR) ;

INVRETSP = min(arr(NINVRETSP * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK)) * (1 - V_CNR) ;

INVRETSU = min(arr(NINVRETSU * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP)) * (1 - V_CNR) ;

INVRETSZ = min(arr(NINVRETSZ * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU)) * (1 - V_CNR) ;

INVRETAB = min(arr(NINVRETAB * TX375/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ)) * (1 - V_CNR) ;

INVRETAG = min(arr(NINVRETAG * TX375/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ-INVRETAB)) * (1 - V_CNR) ;

INVRETAL = min(arr(NINVRETAL * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG)) * (1 - V_CNR) ;

INVRETAQ = min(arr(NINVRETAQ * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL)) * (1 - V_CNR) ;

INVRETAV = min(arr(NINVRETAV * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ)) * (1 - V_CNR) ;

INVRETBB = min(arr(NINVRETBB * TX375/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                 -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                 -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                 -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                 -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV)) * (1 - V_CNR) ;

INVRETAA = min(arr(NINVRETAA * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB)) * (1 - V_CNR) ;

INVRETAF = min(arr(NINVRETAF * TX4737/100) , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA)) * (1 - V_CNR) ;

INVRETAK = min(arr(NINVRETAK * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                                  -INVRETAF)) * (1 - V_CNR) ;

INVRETAP = min(arr(NINVRETAP * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                                  -INVRETAF-INVRETAK)) * (1 - V_CNR) ;

INVRETAU = min(arr(NINVRETAU * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                                  -INVRETAF-INVRETAK-INVRETAP)) * (1 - V_CNR) ;

INVRETBA = min(arr(NINVRETBA * TX4737/100) , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                                  -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                                  -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                                  -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                                  -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                                  -INVRETAF-INVRETAK-INVRETAP-INVRETAU)) * (1 - V_CNR) ;

INVRETPP = min(NINVRETPP , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                               -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                               -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                               -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                               -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA)) * (1 - V_CNR) ;

INVRETPU = min(NINVRETPU , max(0 , PLAF_INVDOM -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                               -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                               -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                               -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                               -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                               -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP)) * (1 - V_CNR) ;

INVRETRG = min(NINVRETRG , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU)) * (1 - V_CNR) ;

INVRETRM = min(NINVRETRM , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG)) * (1 - V_CNR) ;

INVRETRR = min(NINVRETRR , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM)) * (1 - V_CNR) ;

INVRETRW = min(NINVRETRW , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR)) * (1 - V_CNR) ;

INVRETNW = min(NINVRETNW , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW)) * (1 - V_CNR) ;

INVRETSC = min(NINVRETSC , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW)) * (1 - V_CNR) ;

INVRETSH = min(NINVRETSH , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC)) * (1 - V_CNR) ;

INVRETSM = min(NINVRETSM , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH)) * (1 - V_CNR) ;

INVRETSR = min(NINVRETSR , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM)) * (1 - V_CNR) ;

INVRETSW = min(NINVRETSW , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR)) * (1 - V_CNR) ;

INVRETTB = min(NINVRETTB , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW)) * (1 - V_CNR) ;

INVRETAC = min(NINVRETAC , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB)) * (1 - V_CNR) ;

INVRETAH = min(NINVRETAH , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB-INVRETAC)) * (1 - V_CNR) ;

INVRETAM = min(NINVRETAM , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB-INVRETAC-INVRETAH)) * (1 - V_CNR) ;

INVRETAR = min(NINVRETAR , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB-INVRETAC-INVRETAH
                                                -INVRETAM)) * (1 - V_CNR) ;

INVRETAW = min(NINVRETAW , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB-INVRETAC-INVRETAH
                                                -INVRETAM-INVRETAR)) * (1 - V_CNR) ;

INVRETBE = min(NINVRETBE , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETMA-INVRETLG-INVRETMB-INVRETMC-INVRETLH-INVRETLI-INVRETQP-INVRETQG-INVRETQO
                                                -INVRETQF-INVRETPB-INVRETPF-INVRETPJ-INVRETPA-INVRETPE-INVRETPI-INVRETPO-INVRETPT-INVRETPY
                                                -INVRETRL-INVRETRQ-INVRETRV-INVRETNV-INVRETPN-INVRETPS-INVRETPX-INVRETRK-INVRETRP-INVRETRU
                                                -INVRETNU-INVRETSB-INVRETSG-INVRETSL-INVRETSQ-INVRETSV-INVRETTA-INVRETSA-INVRETSF-INVRETSK
                                                -INVRETSP-INVRETSU-INVRETSZ-INVRETAB-INVRETAG-INVRETAL-INVRETAQ-INVRETAV-INVRETBB-INVRETAA
                                                -INVRETAF-INVRETAK-INVRETAP-INVRETAU-INVRETBA-INVRETPP-INVRETPU-INVRETRG-INVRETRM-INVRETRR
                                                -INVRETRW-INVRETNW-INVRETSC-INVRETSH-INVRETSM-INVRETSR-INVRETSW-INVRETTB-INVRETAC-INVRETAH
                                                -INVRETAM-INVRETAR-INVRETAW)) * (1 - V_CNR) ;

INVRETENT = INVRETMA + INVRETLG + INVRETMB + INVRETMC + INVRETLH + INVRETLI + INVRETQP + INVRETQG + INVRETQO + INVRETQF + INVRETPB + INVRETPF + INVRETPJ 
            + INVRETPA + INVRETPE + INVRETPI + INVRETPO + INVRETPT + INVRETPY + INVRETRL + INVRETRQ + INVRETRV + INVRETNV + INVRETPN + INVRETPS + INVRETPX 
            + INVRETRK + INVRETRP + INVRETRU + INVRETNU + INVRETSB + INVRETSG + INVRETSL + INVRETSQ + INVRETSV + INVRETTA + INVRETSA + INVRETSF + INVRETSK 
            + INVRETSP + INVRETSU + INVRETSZ + INVRETAB + INVRETAG + INVRETAL + INVRETAQ + INVRETAV + INVRETBB + INVRETAA + INVRETAF + INVRETAK 
            + INVRETAP + INVRETAU + INVRETBA + INVRETPP + INVRETPU + INVRETRG + INVRETRM + INVRETRR + INVRETRW + INVRETNW + INVRETSC + INVRETSH 
            + INVRETSM + INVRETSR + INVRETSW + INVRETTB + INVRETAC + INVRETAH + INVRETAM + INVRETAR + INVRETAW + INVRETBE ;

INVRETKS = NINVRETKS * (1 - V_CNR) ; 

INVRETKT = NINVRETKT * (1 - V_CNR) ; 

INVRETKU = NINVRETKU * (1 - V_CNR) ; 

INVRETQR = NINVRETQR * (1 - V_CNR) ;

INVRETQI = NINVRETQI * (1 - V_CNR) ;

INVRETPD = NINVRETPD * (1 - V_CNR) ;

INVRETPH = NINVRETPH * (1 - V_CNR) ;

INVRETPL = NINVRETPL * (1 - V_CNR) ;

INVRETPR = NINVRETPR * (1 - V_CNR) ;

INVRETPW = NINVRETPW * (1 - V_CNR) ;

INVRETRI = NINVRETRI * (1 - V_CNR) ;

INVRETRO = NINVRETRO * (1 - V_CNR) ;

INVRETRT = NINVRETRT * (1 - V_CNR) ;

INVRETRY = NINVRETRY * (1 - V_CNR) ;

INVRETNY = NINVRETNY * (1 - V_CNR) ;

INVRETSE = NINVRETSE * (1 - V_CNR) ;

INVRETSJ = NINVRETSJ * (1 - V_CNR) ;

INVRETSO = NINVRETSO * (1 - V_CNR) ;

INVRETST = NINVRETST * (1 - V_CNR) ;

INVRETSY = NINVRETSY * (1 - V_CNR) ;

INVRETTD = NINVRETTD * (1 - V_CNR) ;

INVRETAE = NINVRETAE * (1 - V_CNR) ;

INVRETAJ = NINVRETAJ * (1 - V_CNR) ;

INVRETAO = NINVRETAO * (1 - V_CNR) ;

INVRETAT = NINVRETAT * (1 - V_CNR) ;

INVRETAY = NINVRETAY * (1 - V_CNR) ;

INVRETBG = NINVRETBG * (1 - V_CNR) ;


INVRETMAR = min(arr(INVRETMA * 3/2) , NINVRETMA - INVRETMA) * (1 - V_CNR) ;

INVRETLGR = min(INVRETLG , max(0 , NINVRETLG - INVRETLG)) * (1 - V_CNR) ;

INVRETMBR = min(arr(INVRETMB * 3/2) , NINVRETMB - INVRETMB) * (1 - V_CNR) ;

INVRETMCR = min(arr(INVRETMC * 3/2) , NINVRETMC - INVRETMC) * (1 - V_CNR) ;

INVRETLHR = min(INVRETLH , max(0 , NINVRETLH - INVRETLH)) * (1 - V_CNR) ;

INVRETLIR = min(INVRETLI , max(0 , NINVRETLI - INVRETLI)) * (1 - V_CNR) ;

INVRETQPR = min(arr(INVRETQP * 3/2) , NINVRETQP - INVRETQP) * (1 - V_CNR) ;

INVRETQGR = min(arr(INVRETQG * 3/2) , NINVRETQG - INVRETQG) * (1 - V_CNR) ;

INVRETQOR = min(INVRETQO , max(0 , NINVRETQO - INVRETQO)) * (1 - V_CNR) ;

INVRETQFR = min(INVRETQF , max(0 , NINVRETQF - INVRETQF)) * (1 - V_CNR) ;

INVRETPBR = (min(arr(INVRETPB * 5/3) , NINVRETPB - INVRETPB) * (1 - null(1 - abs(arr(INVRETPB * 5/3) - (NINVRETPB - INVRETPB))))
             + (NINVRETPB - INVRETPB) * null(1 - abs(arr(INVRETPB * 5/3) - (NINVRETPB - INVRETPB))))
            * (1 - V_CNR) ;

INVRETPFR = (min(arr(INVRETPF * 5/3) , NINVRETPF - INVRETPF) * (1 - null(1 - abs(arr(INVRETPF * 5/3) - (NINVRETPF - INVRETPF))))
             + (NINVRETPF - INVRETPF) * null(1 - abs(arr(INVRETPF * 5/3) - (NINVRETPF - INVRETPF))))
            * (1 - V_CNR) ;

INVRETPJR = (min(arr(INVRETPJ * 5/3) , NINVRETPJ - INVRETPJ) * (1 - null(1 - abs(arr(INVRETPJ * 5/3) - (NINVRETPJ - INVRETPJ))))
             + (NINVRETPJ - INVRETPJ) * null(1 - abs(arr(INVRETPJ * 5/3) - (NINVRETPJ - INVRETPJ))))
            * (1 - V_CNR) ;

INVRETPAR = (min(arr(INVRETPA * 10/9) , NINVRETPA - INVRETPA) * (1 - null(1 - abs(arr(INVRETPA * 10/9) - (NINVRETPA - INVRETPA))))
             + (NINVRETPA - INVRETPA) * null(1 - abs(arr(INVRETPA * 10/9) - (NINVRETPA - INVRETPA))))
            * (1 - V_CNR) ;

INVRETPER = (min(arr(INVRETPE * 10/9) , NINVRETPE - INVRETPE) * (1 - null(1 - abs(arr(INVRETPE * 10/9) - (NINVRETPE - INVRETPE))))
             + (NINVRETPE - INVRETPE) * null(1 - abs(arr(INVRETPE * 10/9) - (NINVRETPE - INVRETPE))))
            * (1 - V_CNR) ;

INVRETPIR = (min(arr(INVRETPI * 10/9) , NINVRETPI - INVRETPI) * (1 - null(1 - abs(arr(INVRETPI * 10/9) - (NINVRETPI - INVRETPI))))
             + (NINVRETPI - INVRETPI) * null(1 - abs(arr(INVRETPI * 10/9) - (NINVRETPI - INVRETPI))))
            * (1 - V_CNR) ;

INVRETPOR = min(arr(INVRETPO * 3/2) , NINVRETPO - INVRETPO) * (1 - V_CNR) ;

INVRETPTR = min(arr(INVRETPT * 3/2) , NINVRETPT - INVRETPT) * (1 - V_CNR) ;

INVRETPYR = (min(arr(INVRETPY * 5/3) , NINVRETPY - INVRETPY) * (1 - null(1 - abs(arr(INVRETPY * 5/3) - (NINVRETPY - INVRETPY))))
             + (NINVRETPY - INVRETPY) * null(1 - abs(arr(INVRETPY * 5/3) - (NINVRETPY - INVRETPY))))
            * (1 - V_CNR) ; 

INVRETRLR = (min(arr(INVRETRL * 5/3) , NINVRETRL - INVRETRL) * (1 - null(1 - abs(arr(INVRETRL * 5/3) - (NINVRETRL - INVRETRL))))
             + (NINVRETRL - INVRETRL) * null(1 - abs(arr(INVRETRL * 5/3) - (NINVRETRL - INVRETRL))))
            * (1 - V_CNR) ; 

INVRETRQR = (min(arr(INVRETRQ * 5/3) , NINVRETRQ - INVRETRQ) * (1 - null(1 - abs(arr(INVRETRQ * 5/3) - (NINVRETRQ - INVRETRQ))))
             + (NINVRETRQ - INVRETRQ) * null(1 - abs(arr(INVRETRQ * 5/3) - (NINVRETRQ - INVRETRQ)))) 
            * (1 - V_CNR) ; 

INVRETRVR = (min(arr(INVRETRV * 5/3) , NINVRETRV - INVRETRV) * (1 - null(1 - abs(arr(INVRETRV * 5/3) - (NINVRETRV - INVRETRV))))
             + (NINVRETRV - INVRETRV) * null(1 - abs(arr(INVRETRV * 5/3) - (NINVRETRV - INVRETRV))))
            * (1 - V_CNR) ;

INVRETNVR = (min(arr(INVRETNV * 5/3) , NINVRETNV - INVRETNV) * (1 - null(1 - abs(arr(INVRETNV * 5/3) - (NINVRETNV - INVRETNV))))
             + (NINVRETNV - INVRETNV) * null(1 - abs(arr(INVRETNV * 5/3) - (NINVRETNV - INVRETNV))))
            * (1 - V_CNR) ;

INVRETPNR = min(INVRETPN , max(0 , NINVRETPN - INVRETPN)) * (1 - V_CNR) ;

INVRETPSR = min(INVRETPS , max(0 , NINVRETPS - INVRETPS)) * (1 - V_CNR) ;

INVRETPXR = (min(arr(INVRETPX * 10/9) , NINVRETPX - INVRETPX) * (1 - null(1 - abs(arr(INVRETPX * 10/9) - (NINVRETPX - INVRETPX))))
             + (NINVRETPX - INVRETPX) * null(1 - abs(arr(INVRETPX * 10/9) - (NINVRETPX - INVRETPX))))
            * (1 - V_CNR) ;

INVRETRKR = (min(arr(INVRETRK * 10/9) , NINVRETRK - INVRETRK) * (1 - null(1 - abs(arr(INVRETRK * 10/9) - (NINVRETRK - INVRETRK))))
             + (NINVRETRK - INVRETRK) * null(1 - abs(arr(INVRETRK * 10/9) - (NINVRETRK - INVRETRK)))) 
            * (1 - V_CNR) ;

INVRETRPR = (min(arr(INVRETRP * 10/9) , NINVRETRP - INVRETRP) * (1 - null(1 - abs(arr(INVRETRP * 10/9) - (NINVRETRP - INVRETRP))))
             + (NINVRETRP - INVRETRP) * null(1 - abs(arr(INVRETRP * 10/9) - (NINVRETRP - INVRETRP))))
            * (1 - V_CNR) ;

INVRETRUR = (min(arr(INVRETRU * 10/9) , NINVRETRU - INVRETRU) * (1 - null(1 - abs(arr(INVRETRU * 10/9) - (NINVRETRU - INVRETRU))))
             + (NINVRETRU - INVRETRU) * null(1 - abs(arr(INVRETRU * 10/9) - (NINVRETRU - INVRETRU))))
            * (1 - V_CNR) ; 

INVRETNUR = (min(arr(INVRETNU * 10/9) , NINVRETNU - INVRETNU) * (1 - null(1 - abs(arr(INVRETNU * 10/9) - (NINVRETNU - INVRETNU))))
             + (NINVRETNU - INVRETNU) * null(1 - abs(arr(INVRETNU * 10/9) - (NINVRETNU - INVRETNU))))
            * (1 - V_CNR) ; 

INVRETSBR = (min(arr(INVRETSB * 5/3) , NINVRETSB - INVRETSB) * (1 - null(1 - abs(arr(INVRETSB * 5/3) - (NINVRETSB - INVRETSB))))  
             + (NINVRETSB - INVRETSB) * null(1 - abs(arr(INVRETSB * 5/3) - (NINVRETSB - INVRETSB))))
            * (1 - V_CNR) ; 

INVRETSGR = (min(arr(INVRETSG * 5/3) , NINVRETSG - INVRETSG) * (1 - null(1 - abs(arr(INVRETSG * 5/3) - (NINVRETSG - INVRETSG))))
             + (NINVRETSG - INVRETSG) * null(1 - abs(arr(INVRETSG * 5/3) - (NINVRETSG - INVRETSG))))
            * (1 - V_CNR) ;

INVRETSLR = (min(arr(INVRETSL * 5/3) , NINVRETSL - INVRETSL) * (1 - null(1 - abs(arr(INVRETSL * 5/3) - (NINVRETSL - INVRETSL))))
             + (NINVRETSL - INVRETSL) * null(1 - abs(arr(INVRETSL * 5/3) - (NINVRETSL - INVRETSL))))
            * (1 - V_CNR) ; 

INVRETSQR = (min(arr(INVRETSQ * 5/3) , NINVRETSQ - INVRETSQ) * (1 - null(1 - abs(arr(INVRETSQ * 5/3) - (NINVRETSQ - INVRETSQ))))
             + (NINVRETSQ - INVRETSQ) * null(1 - abs(arr(INVRETSQ * 5/3) - (NINVRETSQ - INVRETSQ))))
            * (1 - V_CNR) ; 

INVRETSVR = (min(arr(INVRETSV * 5/3) , NINVRETSV - INVRETSV) * (1 - null(1 - abs(arr(INVRETSV * 5/3) - (NINVRETSV - INVRETSV))))
             + (NINVRETSV - INVRETSV) * null(1 - abs(arr(INVRETSV * 5/3) - (NINVRETSV - INVRETSV))))
            * (1 - V_CNR) ; 

INVRETTAR = (min(arr(INVRETTA * 5/3) , NINVRETTA - INVRETTA) * (1 - null(1 - abs(arr(INVRETTA * 5/3) - (NINVRETTA - INVRETTA))))
             + (NINVRETTA - INVRETTA) * null(1 - abs(arr(INVRETTA * 5/3) - (NINVRETTA - INVRETTA))))
            * (1 - V_CNR) ; 

INVRETSAR = (min(arr(INVRETSA * 10/9) , NINVRETSA - INVRETSA) * (1 - null(1 - abs(arr(INVRETSA * 10/9) - (NINVRETSA - INVRETSA))))
             + (NINVRETSA - INVRETSA) * null(1 - abs(arr(INVRETSA * 10/9) - (NINVRETSA - INVRETSA)))) 
            * (1 - V_CNR) ; 

INVRETSFR = (min(arr(INVRETSF * 10/9) , NINVRETSF - INVRETSF) * (1 - null(1 - abs(arr(INVRETSF * 10/9) - (NINVRETSF - INVRETSF))))
             + (NINVRETSF - INVRETSF) * null(1 - abs(arr(INVRETSF * 10/9) - (NINVRETSF - INVRETSF)))) 
            * (1 - V_CNR) ;

INVRETSKR = (min(arr(INVRETSK * 10/9) , NINVRETSK - INVRETSK) * (1 - null(1 - abs(arr(INVRETSK * 10/9) - (NINVRETSK - INVRETSK))))
             + (NINVRETSK - INVRETSK) * null(1 - abs(arr(INVRETSK * 10/9) - (NINVRETSK - INVRETSK)))) 
            * (1 - V_CNR) ; 

INVRETSPR = (min(arr(INVRETSP * 10/9) , NINVRETSP - INVRETSP) * (1 - null(1 - abs(arr(INVRETSP * 10/9) - (NINVRETSP - INVRETSP))))
             + (NINVRETSP - INVRETSP) * null(1 - abs(arr(INVRETSP * 10/9) - (NINVRETSP - INVRETSP))))
            * (1 - V_CNR) ;

INVRETSUR = (min(arr(INVRETSU * 10/9) , NINVRETSU - INVRETSU) * (1 - null(1 - abs(arr(INVRETSU * 10/9) - (NINVRETSU - INVRETSU))))
             + (NINVRETSU - INVRETSU) * null(1 - abs(arr(INVRETSU * 10/9) - (NINVRETSU - INVRETSU)))) 
            * (1 - V_CNR) ; 

INVRETSZR = (min(arr(INVRETSZ * 10/9) , NINVRETSZ - INVRETSZ) * (1 - null(1 - abs(arr(INVRETSZ * 10/9) - (NINVRETSZ - INVRETSZ))))
             + (NINVRETSZ - INVRETSZ) * null(1 - abs(arr(INVRETSZ * 10/9) - (NINVRETSZ - INVRETSZ))))
            * (1 - V_CNR) ; 

INVRETABR = (min(arr(INVRETAB * 5/3) , NINVRETAB - INVRETAB) * (1 - null(1 - abs(arr(INVRETAB * 5/3) - (NINVRETAB - INVRETAB))))
             + (NINVRETAB - INVRETAB) * null(1 - abs(arr(INVRETAB * 5/3) - (NINVRETAB - INVRETAB))))
            * (1 - V_CNR) ; 

INVRETAGR = (min(arr(INVRETAG * 5/3) , NINVRETAG - INVRETAG) * (1 - null(1 - abs(arr(INVRETAG * 5/3) - (NINVRETAG - INVRETAG))))
             + (NINVRETAG - INVRETAG) * null(1 - abs(arr(INVRETAG * 5/3) - (NINVRETAG - INVRETAG))))
            * (1 - V_CNR) ; 

INVRETALR = (min(arr(INVRETAL * 5/3) , NINVRETAL - INVRETAL) * (1 - null(1 - abs(arr(INVRETAL * 5/3) - (NINVRETAL - INVRETAL))))
             + (NINVRETAL - INVRETAL) * null(1 - abs(arr(INVRETAL * 5/3) - (NINVRETAL - INVRETAL))))
            * (1 - V_CNR) ; 

INVRETAQR = (min(arr(INVRETAQ * 5/3) , NINVRETAQ - INVRETAQ) * (1 - null(1 - abs(arr(INVRETAQ * 5/3) - (NINVRETAQ - INVRETAQ))))
             + (NINVRETAQ - INVRETAQ) * null(1 - abs(arr(INVRETAQ * 5/3) - (NINVRETAQ - INVRETAQ))))
            * (1 - V_CNR) ; 

INVRETAVR = (min(arr(INVRETAV * 5/3) , NINVRETAV - INVRETAV) * (1 - null(1 - abs(arr(INVRETAV * 5/3) - (NINVRETAV - INVRETAV))))
             + (NINVRETAV - INVRETAV) * null(1 - abs(arr(INVRETAV * 5/3) - (NINVRETAV - INVRETAV))))
            * (1 - V_CNR) ; 

INVRETBBR = (min(arr(INVRETBB * 5/3) , NINVRETBB - INVRETBB) * (1 - null(1 - abs(arr(INVRETBB * 5/3) - (NINVRETBB - INVRETBB))))
             + (NINVRETBB - INVRETBB) * null(1 - abs(arr(INVRETBB * 5/3) - (NINVRETBB - INVRETBB))))
            * (1 - V_CNR) ; 

INVRETAAR = (min(arr(INVRETAA * 10/9) , NINVRETAA - INVRETAA) * (1 - null(1 - abs(arr(INVRETAA * 10/9) - (NINVRETAA - INVRETAA))))
             + (NINVRETAA - INVRETAA) * null(1 - abs(arr(INVRETAA * 10/9) - (NINVRETAA - INVRETAA))))
            * (1 - V_CNR) ; 

INVRETAFR = (min(arr(INVRETAF * 10/9) , NINVRETAF - INVRETAF) * (1 - null(1 - abs(arr(INVRETAF * 10/9) - (NINVRETAF - INVRETAF))))
             + (NINVRETAF - INVRETAF) * null(1 - abs(arr(INVRETAF * 10/9) - (NINVRETAF - INVRETAF))))
            * (1 - V_CNR) ; 

INVRETAKR = (min(arr(INVRETAK * 10/9) , NINVRETAK - INVRETAK) * (1 - null(1 - abs(arr(INVRETAK * 10/9) - (NINVRETAK - INVRETAK))))
             + (NINVRETAK - INVRETAK) * null(1 - abs(arr(INVRETAK * 10/9) - (NINVRETAK - INVRETAK))))
            * (1 - V_CNR) ; 

INVRETAPR = (min(arr(INVRETAP * 10/9) , NINVRETAP - INVRETAP) * (1 - null(1 - abs(arr(INVRETAP * 10/9) - (NINVRETAP - INVRETAP))))
             + (NINVRETAP - INVRETAP) * null(1 - abs(arr(INVRETAP * 10/9) - (NINVRETAP - INVRETAP))))
            * (1 - V_CNR) ; 

INVRETAUR = (min(arr(INVRETAU * 10/9) , NINVRETAU - INVRETAU) * (1 - null(1 - abs(arr(INVRETAU * 10/9) - (NINVRETAU - INVRETAU))))
             + (NINVRETAU - INVRETAU) * null(1 - abs(arr(INVRETAU * 10/9) - (NINVRETAU - INVRETAU))))
            * (1 - V_CNR) ; 

INVRETBAR = (min(arr(INVRETBA * 10/9) , NINVRETBA - INVRETBA) * (1 - null(1 - abs(arr(INVRETBA * 10/9) - (NINVRETBA - INVRETBA))))
             + (NINVRETBA - INVRETBA) * null(1 - abs(arr(INVRETBA * 10/9) - (NINVRETBA - INVRETBA))))
            * (1 - V_CNR) ; 

regle 7714083:
application : iliad, batch ;

RRIRENT = RRISUP - RLOGSOC - RDOMSOC1 - RIDOMPROTOT - RCOLENT ;

RENT01 = max(min((INVRETAB * (1 - INDPLAF) + INVRETABA * INDPLAF) , RRIRENT) , 0) * (1 - V_CNR) ;

RENT02 = max(min((INVRETAG * (1 - INDPLAF) + INVRETAGA * INDPLAF) , RRIRENT - RENT01) , 0) * (1 - V_CNR) ;

RENT03 = max(min((INVRETAL * (1 - INDPLAF) + INVRETALA * INDPLAF) , RRIRENT - RENT01 - RENT02) , 0) * (1 - V_CNR) ;

RENT04 = max(min((INVRETAQ * (1 - INDPLAF) + INVRETAQA * INDPLAF) , RRIRENT - RENT01 - RENT02 - RENT03) , 0) * (1 - V_CNR) ;

RENT05 = max(min((INVRETAV * (1 - INDPLAF) + INVRETAVA * INDPLAF) , RRIRENT - RENT01 - RENT02 - RENT03 - RENT04) , 0) * (1 - V_CNR) ;

RENT06 = max(min((INVRETBB * (1 - INDPLAF) + INVRETBBA * INDPLAF) , RRIRENT - somme(i=1..5 : RENT0i)) , 0) * (1 - V_CNR) ;

RENT07 = max(min((INVRETAA * (1 - INDPLAF) + INVRETAAA * INDPLAF) , RRIRENT - somme(i=1..6 : RENT0i)) , 0) * (1 - V_CNR) ;

RENT08 = max(min((INVRETAF * (1 - INDPLAF) + INVRETAFA * INDPLAF) , RRIRENT - somme(i=1..7 : RENT0i)) , 0) * (1 - V_CNR) ;

RENT09 = max(min((INVRETAK * (1 - INDPLAF) + INVRETAKA * INDPLAF) , RRIRENT - somme(i=1..8 : RENT0i)) , 0) * (1 - V_CNR) ;

RENT10 = max(min((INVRETAP * (1 - INDPLAF) + INVRETAPA * INDPLAF) , RRIRENT - somme(i=1..9 : RENT0i)) , 0) * (1 - V_CNR) ;

RENT11 = max(min((INVRETAU * (1 - INDPLAF) + INVRETAUA * INDPLAF) , RRIRENT - somme(i=1..10 : RENTi)) , 0) * (1 - V_CNR) ;

RENT12 = max(min((INVRETBA * (1 - INDPLAF) + INVRETBAA * INDPLAF) , RRIRENT - somme(i=1..11 : RENTi)) , 0) * (1 - V_CNR) ;

RENT13 = max(min((INVRETAC * (1 - INDPLAF) + INVRETACA * INDPLAF) , RRIRENT - somme(i=1..12 : RENTi)) , 0) * (1 - V_CNR) ;

RENT14 = max(min((INVRETAH * (1 - INDPLAF) + INVRETAHA * INDPLAF) , RRIRENT - somme(i=1..13 : RENTi)) , 0) * (1 - V_CNR) ;

RENT15 = max(min((INVRETAM * (1 - INDPLAF) + INVRETAMA * INDPLAF) , RRIRENT - somme(i=1..14 : RENTi)) , 0) * (1 - V_CNR) ;

RENT16 = max(min((INVRETAR * (1 - INDPLAF) + INVRETARA * INDPLAF) , RRIRENT - somme(i=1..15 : RENTi)) , 0) * (1 - V_CNR) ;

RENT17 = max(min((INVRETAW * (1 - INDPLAF) + INVRETAWA * INDPLAF) , RRIRENT - somme(i=1..16 : RENTi)) , 0) * (1 - V_CNR) ;

RENT18 = max(min((INVRETBE * (1 - INDPLAF) + INVRETBEA * INDPLAF) , RRIRENT - somme(i=1..17 : RENTi)) , 0) * (1 - V_CNR) ;

RENT19 = max(min((INVRETAE * (1 - INDPLAF) + INVRETAEA * INDPLAF) , RRIRENT - somme(i=1..18 : RENTi)) , 0) * (1 - V_CNR) ;

RENT20 = max(min((INVRETAJ * (1 - INDPLAF) + INVRETAJA * INDPLAF) , RRIRENT - somme(i=1..19 : RENTi)) , 0) * (1 - V_CNR) ;

RENT21 = max(min((INVRETAO * (1 - INDPLAF) + INVRETAOA * INDPLAF) , RRIRENT - somme(i=1..20 : RENTi)) , 0) * (1 - V_CNR) ;

RENT22 = max(min((INVRETAT * (1 - INDPLAF) + INVRETATA * INDPLAF) , RRIRENT - somme(i=1..21 : RENTi)) , 0) * (1 - V_CNR) ;

RENT23 = max(min((INVRETAY * (1 - INDPLAF) + INVRETAYA * INDPLAF) , RRIRENT - somme(i=1..22 : RENTi)) , 0) * (1 - V_CNR) ;

RENT24 = max(min((INVRETBG * (1 - INDPLAF) + INVRETBGA * INDPLAF) , RRIRENT - somme(i=1..23 : RENTi)) , 0) * (1 - V_CNR) ;

RENT25 = max(min((INVRETABR * (1 - INDPLAF) + INVRETABRA * INDPLAF) , RRIRENT - somme(i=1..24 : RENTi)) , 0) * (1 - V_CNR) ;

RENT26 = max(min((INVRETAGR * (1 - INDPLAF) + INVRETAGRA * INDPLAF) , RRIRENT - somme(i=1..25 : RENTi)) , 0) * (1 - V_CNR) ;

RENT27 = max(min((INVRETALR * (1 - INDPLAF) + INVRETALRA * INDPLAF) , RRIRENT - somme(i=1..26 : RENTi)) , 0) * (1 - V_CNR) ;

RENT28 = max(min((INVRETAQR * (1 - INDPLAF) + INVRETAQRA * INDPLAF) , RRIRENT - somme(i=1..27 : RENTi)) , 0) * (1 - V_CNR) ;

RENT29 = max(min((INVRETAVR * (1 - INDPLAF) + INVRETAVRA * INDPLAF) , RRIRENT - somme(i=1..28 : RENTi)) , 0) * (1 - V_CNR) ;

RENT30 = max(min((INVRETBBR * (1 - INDPLAF) + INVRETBBRA * INDPLAF) , RRIRENT - somme(i=1..29 : RENTi)) , 0) * (1 - V_CNR) ;

RENT31 = max(min((INVRETAAR * (1 - INDPLAF) + INVRETAARA * INDPLAF) , RRIRENT - somme(i=1..30 : RENTi)) , 0) * (1 - V_CNR) ;

RENT32 = max(min((INVRETAFR * (1 - INDPLAF) + INVRETAFRA * INDPLAF) , RRIRENT - somme(i=1..31 : RENTi)) , 0) * (1 - V_CNR) ;

RENT33 = max(min((INVRETAKR * (1 - INDPLAF) + INVRETAKRA * INDPLAF) , RRIRENT - somme(i=1..32 : RENTi)) , 0) * (1 - V_CNR) ;

RENT34 = max(min((INVRETAPR * (1 - INDPLAF) + INVRETAPRA * INDPLAF) , RRIRENT - somme(i=1..33 : RENTi)) , 0) * (1 - V_CNR) ;

RENT35 = max(min((INVRETAUR * (1 - INDPLAF) + INVRETAURA * INDPLAF) , RRIRENT - somme(i=1..34 : RENTi)) , 0) * (1 - V_CNR) ;

RENT36 = max(min((INVRETBAR * (1 - INDPLAF) + INVRETBARA * INDPLAF) , RRIRENT - somme(i=1..35 : RENTi)) , 0) * (1 - V_CNR) ;

RLOCENT_1 = ((1 - V_INDTEO) * somme(i=1..36 : RENTi)
           + V_INDTEO * (
            arr((V_RENT07+V_RENT31)*(5263/10000))
           + arr((V_RENT01+V_RENT25)*(625/1000))
           + arr((V_RENT09+V_RENT33)*(5263/10000))
           + arr((V_RENT03+V_RENT27)*(625/1000))

           + arr((V_RENT08+V_RENT32)*(5263/10000))
           + arr((V_RENT02+V_RENT26)*(625/1000))
           + arr((V_RENT10+V_RENT34)*(5263/10000))
           + arr((V_RENT04+V_RENT28)*(625/1000))

           + arr((V_RENT11+V_RENT35)*(5263/10000))
           + arr((V_RENT05+V_RENT29)*(625/1000))

          + arr((V_RENT12+V_RENT36)*(5263/10000))
          + arr((V_RENT06+V_RENT30)*(625/1000))

                          )) * (1 - V_CNR) ;

RLOCENT = RLOCENT_1 * (1 - ART1731BIS) 
          + min(RLOCENT_1 , max(RLOCENT_P+RLOCENTP2 , RLOCENT1731 + 0) * (1-PREM8_11)) * ART1731BIS ;

RIDOMENT = RLOCENT ;

regle 14085:
application : iliad, batch ;

INVRETQB = NINVRETQB * (1 - V_CNR) ; 

INVRETQC = NINVRETQC * (1 - V_CNR) ; 

INVRETQT = NINVRETQT * (1 - V_CNR) ; 

INVRETQL = min(NINVRETQL , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT)) * (1 - V_CNR) ;

INVRETQM = min(NINVRETQM , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL)) * (1 - V_CNR) ;

INVRETQD = min(NINVRETQD , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM)) * (1 - V_CNR) ;

INVRETOB = min(NINVRETOB , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD)) * (1 - V_CNR) ;

INVRETOC = min(NINVRETOC , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB)) * (1 - V_CNR) ;

INVRETOI = min(NINVRETOI , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC)) * (1 - V_CNR) ;

INVRETOJ = min(NINVRETOJ , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI)) * (1 - V_CNR) ;

INVRETOK = min(NINVRETOK , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ)) * (1 - V_CNR) ;

INVRETOM = min(NINVRETOM , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK)) * (1 - V_CNR) ;

INVRETON = min(NINVRETON , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM)) * (1 - V_CNR) ;

INVRETOP = min(NINVRETOP , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON)) * (1 - V_CNR) ;

INVRETOQ = min(NINVRETOQ , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP)) * (1 - V_CNR) ;

INVRETOR = min(NINVRETOR , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ)) * (1 - V_CNR) ;

INVRETOT = min(NINVRETOT , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR)) * (1 - V_CNR) ;

INVRETOU = min(NINVRETOU , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT)) * (1 - V_CNR) ;

INVRETOV = min(NINVRETOV , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU)) * (1 - V_CNR) ;

INVRETOW = min(NINVRETOW , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV)) * (1 - V_CNR) ;

INVRETOD = min(NINVRETOD , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                               -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW)) * (1 - V_CNR) ;

INVRETOE = min(NINVRETOE , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD)) * (1 - V_CNR) ;

INVRETOF = min(NINVRETOF , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE)) * (1 - V_CNR) ;

INVRETOG = min(NINVRETOG , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF)) * (1 - V_CNR) ;

INVRETOX = min(NINVRETOX , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG)) * (1 - V_CNR) ;

INVRETOY = min(NINVRETOY , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX)) * (1 - V_CNR) ;

INVRETOZ = min(NINVRETOZ , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY)) * (1 - V_CNR) ;

INVRETUA = min(NINVRETUA , max(0 , PLAF_INVDOM -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                               -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                               -INVRETOG-INVRETOX-INVRETOY-INVRETOZ)) * (1 - V_CNR) ;

INVRETUB = min(NINVRETUB , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA)) * (1 - V_CNR) ;

INVRETUC = min(NINVRETUC , max(0 , PLAF_INVDOM3 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA-INVRETUB)) * (1 - V_CNR) ;

INVRETUD = min(NINVRETUD , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA-INVRETUB-INVRETUC)) * (1 - V_CNR) ;

INVRETUE = min(NINVRETUE , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA-INVRETUB-INVRETUC-INVRETUD)) * (1 - V_CNR) ;

INVRETUF = min(NINVRETUF , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA-INVRETUB-INVRETUC-INVRETUD-INVRETUE)) * (1 - V_CNR) ;

INVRETUG = min(NINVRETUG , max(0 , PLAF_INVDOM4 -INVRETSOC-INVRETENT-INVRETQL-INVRETQM-INVRETQD-INVRETOB-INVRETOC-INVRETOI-INVRETOJ-INVRETOK-INVRETOM
                                                -INVRETON-INVRETOP-INVRETOQ-INVRETOR-INVRETOT-INVRETOU-INVRETOV-INVRETOW-INVRETOD-INVRETOE-INVRETOF
                                                -INVRETOG-INVRETOX-INVRETOY-INVRETOZ-INVRETUA-INVRETUB-INVRETUC-INVRETUD-INVRETUE-INVRETUF)) * (1 - V_CNR) ;

INVRETLOG = INVRETQL + INVRETQM + INVRETQD + INVRETOB + INVRETOC + INVRETOI + INVRETOJ + INVRETOK + INVRETOM + INVRETON 
            + INVRETOP + INVRETOQ + INVRETOR + INVRETOT + INVRETOU + INVRETOV + INVRETOW + INVRETOD + INVRETOE + INVRETOF 
            + INVRETOG + INVRETOX + INVRETOY + INVRETOZ + INVRETUA + INVRETUB + INVRETUC + INVRETUD + INVRETUE + INVRETUF + INVRETUG ;

regle 14086:
application : iliad, batch ;

RLOG01 = max(min(INVLOG2008 , RRI1) , 0) * (1 - V_CNR) ;

RLOG02 = max(min(INVLGDEB2009 , RRI1-RLOG01) , 0) * (1 - V_CNR) ;

RLOG03 = max(min(INVLGDEB , RRI1-RLOG01-RLOG02) , 0) * (1 - V_CNR) ;

RLOG04 = max(min(INVOMLOGOA , RRI1-RLOG01-RLOG02-RLOG03) , 0) * (1 - V_CNR) ;

RLOG05 = max(min(INVOMLOGOH , RRI1-RLOG01-RLOG02-RLOG03-RLOG04) , 0) * (1 - V_CNR) ;

RLOG06 = max(min(INVOMLOGOL , RRI1-RLOG01-RLOG02-RLOG03-RLOG04-RLOG05) , 0) * (1 - V_CNR) ;

RLOG07 = max(min(INVOMLOGOO , RRI1-RLOG01-RLOG02-RLOG03-RLOG04-RLOG05-RLOG06) , 0) * (1 - V_CNR) ;

RLOG08 = max(min(INVOMLOGOS , RRI1-RLOG01-RLOG02-RLOG03-RLOG04-RLOG05-RLOG06-RLOG07) , 0) * (1 - V_CNR) ;

RLOG09 = max(min((INVRETQL * (1 - INDPLAF) + INVRETQLA * INDPLAF) , RRI1-RLOG01-RLOG02-RLOG03-RLOG04-RLOG05-RLOG06-RLOG07-RLOG08) , 0) * (1 - V_CNR) ;

RLOG10 = max(min((INVRETQM * (1 - INDPLAF) + INVRETQMA * INDPLAF) , RRI1-RLOG01-RLOG02-RLOG03-RLOG04-RLOG05-RLOG06-RLOG07-RLOG08-RLOG09) , 0) * (1 - V_CNR) ;

RLOG11 = max(min((INVRETQD * (1 - INDPLAF) + INVRETQDA * INDPLAF) , RRI1 - somme(i=1..10 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG12 = max(min((INVRETOB * (1 - INDPLAF) + INVRETOBA * INDPLAF) , RRI1 - somme(i=1..11 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG13 = max(min((INVRETOC * (1 - INDPLAF) + INVRETOCA * INDPLAF) , RRI1 - somme(i=1..12 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG14 = max(min((INVRETOI * (1 - INDPLAF) + INVRETOIA * INDPLAF) , RRI1 - somme(i=1..13 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG15 = max(min((INVRETOJ * (1 - INDPLAF) + INVRETOJA * INDPLAF) , RRI1 - somme(i=1..14 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG16 = max(min((INVRETOK * (1 - INDPLAF) + INVRETOKA * INDPLAF) , RRI1 - somme(i=1..15 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG17 = max(min((INVRETOM * (1 - INDPLAF) + INVRETOMA * INDPLAF) , RRI1 - somme(i=1..16 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG18 = max(min((INVRETON * (1 - INDPLAF) + INVRETONA * INDPLAF) , RRI1 - somme(i=1..17 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG19 = max(min((INVRETOP * (1 - INDPLAF) + INVRETOPA * INDPLAF) , RRI1 - somme(i=1..18 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG20 = max(min((INVRETOQ * (1 - INDPLAF) + INVRETOQA * INDPLAF) , RRI1 - somme(i=1..19 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG21 = max(min((INVRETOR * (1 - INDPLAF) + INVRETORA * INDPLAF) , RRI1 - somme(i=1..20 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG22 = max(min((INVRETOT * (1 - INDPLAF) + INVRETOTA * INDPLAF) , RRI1 - somme(i=1..21 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG23 = max(min((INVRETOU * (1 - INDPLAF) + INVRETOUA * INDPLAF) , RRI1 - somme(i=1..22 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG24 = max(min((INVRETOV * (1 - INDPLAF) + INVRETOVA * INDPLAF) , RRI1 - somme(i=1..23 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG25 = max(min((INVRETOW * (1 - INDPLAF) + INVRETOWA * INDPLAF) , RRI1 - somme(i=1..24 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG26 = max(min((INVRETOD * (1 - INDPLAF) + INVRETODA * INDPLAF) , RRI1 - somme(i=1..25 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG27 = max(min((INVRETOE * (1 - INDPLAF) + INVRETOEA * INDPLAF) , RRI1 - somme(i=1..26 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG28 = max(min((INVRETOF * (1 - INDPLAF) + INVRETOFA * INDPLAF) , RRI1 - somme(i=1..27 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG29 = max(min((INVRETOG * (1 - INDPLAF) + INVRETOGA * INDPLAF) , RRI1 - somme(i=1..28 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG30 = max(min((INVRETOX * (1 - INDPLAF) + INVRETOXA * INDPLAF) , RRI1 - somme(i=1..29 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG31 = max(min((INVRETOY * (1 - INDPLAF) + INVRETOYA * INDPLAF) , RRI1 - somme(i=1..30 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG32 = max(min((INVRETOZ * (1 - INDPLAF) + INVRETOZA * INDPLAF) , RRI1 - somme(i=1..31 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG33 = max(min((INVRETUA * (1 - INDPLAF) + INVRETUAA * INDPLAF) , RRI1 - somme(i=1..32 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG34 = max(min((INVRETUB * (1 - INDPLAF) + INVRETUBA * INDPLAF) , RRI1 - somme(i=1..33 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG35 = max(min((INVRETUC * (1 - INDPLAF) + INVRETUCA * INDPLAF) , RRI1 - somme(i=1..34 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG36 = max(min((INVRETUD * (1 - INDPLAF) + INVRETUDA * INDPLAF) , RRI1 - somme(i=1..35 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG37 = max(min((INVRETUE * (1 - INDPLAF) + INVRETUEA * INDPLAF) , RRI1 - somme(i=1..36 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG38 = max(min((INVRETUF * (1 - INDPLAF) + INVRETUFA * INDPLAF) , RRI1 - somme(i=1..37 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOG39 = max(min((INVRETUG * (1 - INDPLAF) + INVRETUGA * INDPLAF) , RRI1 - somme(i=1..38 : RLOGi)) , 0) * (1 - V_CNR) ;

RLOGDOM_1 = (1 - V_INDTEO) * somme(i=1..39: RLOGi)

         + V_INDTEO * (RLOG01 + RLOG02 + RLOG03 + RLOG04 + RLOG05 + RLOG06 + RLOG07 + RLOG08) ;

RLOGDOM = RLOGDOM_1 * (1-ART1731BIS) 
          + min( RLOGDOM_1 , max(RLOGDOM_P+RLOGDOMP2, RLOGDOM1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

RINVDOMTOMLG = RLOGDOM ;

regle 4087:
application : iliad , batch ;

RRILOC = RRISUP - RLOGSOC - RDOMSOC1 - RIDOMPROTOT ;

RLOC01 = max(min(INVOMREP , RRILOC) , 0) * (1 - V_CNR) ;

RLOC02 = max(min((INVRETMA * (1 - INDPLAF) + INVRETMAA * INDPLAF) , RRILOC - RLOC01) , 0) * (1 - V_CNR) ;

RLOC03 = max(min((INVRETLG * (1 - INDPLAF) + INVRETLGA * INDPLAF) , RRILOC - RLOC01 - RLOC02) , 0) * (1 - V_CNR) ;

RLOC04 = max(min((INVRETKS * (1 - INDPLAF) + INVRETKSA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03) , 0) * (1 - V_CNR) ;

RLOC05 = max(min((INVRETMAR * (1 - INDPLAF) + INVRETMARA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04) , 0) * (1 - V_CNR) ;

RLOC06 = max(min((INVRETLGR * (1 - INDPLAF) + INVRETLGRA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04 - RLOC05) , 0) * (1 - V_CNR) ;

RLOC07 = max(min(INVOMENTMN , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04 - RLOC05 - RLOC06) , 0) * (1 - V_CNR) ;

RLOC08 = max(min((INVRETMB * (1 - INDPLAF) + INVRETMBA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04 - RLOC05 - RLOC06 - RLOC07) , 0) * (1 - V_CNR) ;

RLOC09 = max(min((INVRETMC * (1 - INDPLAF) + INVRETMCA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04 - RLOC05 - RLOC06 - RLOC07 - RLOC08) , 0) * (1 - V_CNR) ;

RLOC10 = max(min((INVRETLH * (1 - INDPLAF) + INVRETLHA * INDPLAF) , RRILOC - RLOC01 - RLOC02 - RLOC03 - RLOC04 - RLOC05 - RLOC06 - RLOC07 - RLOC08 - RLOC09) , 0) * (1 - V_CNR) ;

RLOC11 = max(min((INVRETLI * (1 - INDPLAF) + INVRETLIA * INDPLAF) , RRILOC - somme(i=1..10 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC12 = max(min((INVRETKT * (1 - INDPLAF) + INVRETKTA * INDPLAF) , RRILOC - somme(i=1..11 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC13 = max(min((INVRETKU * (1 - INDPLAF) + INVRETKUA * INDPLAF) , RRILOC - somme(i=1..12 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC14 = max(min((INVRETMBR * (1 - INDPLAF) + INVRETMBRA * INDPLAF) , RRILOC - somme(i=1..13 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC15 = max(min((INVRETMCR * (1 - INDPLAF) + INVRETMCRA * INDPLAF) , RRILOC - somme(i=1..14 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC16 = max(min((INVRETLHR * (1 - INDPLAF) + INVRETLHRA * INDPLAF) , RRILOC - somme(i=1..15 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC17 = max(min((INVRETLIR * (1 - INDPLAF) + INVRETLIRA * INDPLAF) , RRILOC - somme(i=1..16 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC18 = max(min(INVOMQV , RRILOC - somme(i=1..17 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC19 = max(min(INVENDEB2009 , RRILOC - somme(i=1..18 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC20 = max(min((INVRETQP * (1 - INDPLAF) + INVRETQPA * INDPLAF) , RRILOC - somme(i=1..19 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC21 = max(min((INVRETQG * (1 - INDPLAF) + INVRETQGA * INDPLAF) , RRILOC - somme(i=1..20 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC22 = max(min((INVRETPB * (1 - INDPLAF) + INVRETPBA * INDPLAF) , RRILOC - somme(i=1..21 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC23 = max(min((INVRETPF * (1 - INDPLAF) + INVRETPFA * INDPLAF) , RRILOC - somme(i=1..22 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC24 = max(min((INVRETPJ * (1 - INDPLAF) + INVRETPJA * INDPLAF) , RRILOC - somme(i=1..23 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC25 = max(min((INVRETQO * (1 - INDPLAF) + INVRETQOA * INDPLAF) , RRILOC - somme(i=1..24 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC26 = max(min((INVRETQF * (1 - INDPLAF) + INVRETQFA * INDPLAF) , RRILOC - somme(i=1..25 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC27 = max(min((INVRETPA * (1 - INDPLAF) + INVRETPAA * INDPLAF) , RRILOC - somme(i=1..26 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC28 = max(min((INVRETPE * (1 - INDPLAF) + INVRETPEA * INDPLAF) , RRILOC - somme(i=1..27 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC29 = max(min((INVRETPI * (1 - INDPLAF) + INVRETPIA * INDPLAF) , RRILOC - somme(i=1..28 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC30 = max(min((INVRETQR * (1 - INDPLAF) + INVRETQRA * INDPLAF) , RRILOC - somme(i=1..29 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC31 = max(min((INVRETQI * (1 - INDPLAF) + INVRETQIA * INDPLAF) , RRILOC - somme(i=1..30 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC32 = max(min((INVRETPD * (1 - INDPLAF) + INVRETPDA * INDPLAF) , RRILOC - somme(i=1..31 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC33 = max(min((INVRETPH * (1 - INDPLAF) + INVRETPHA * INDPLAF) , RRILOC - somme(i=1..32 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC34 = max(min((INVRETPL * (1 - INDPLAF) + INVRETPLA * INDPLAF) , RRILOC - somme(i=1..33 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC35 = max(min((INVRETQPR * (1 - INDPLAF) + INVRETQPRA * INDPLAF) , RRILOC - somme(i=1..34 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC36 = max(min((INVRETQGR * (1 - INDPLAF) + INVRETQGRA * INDPLAF) , RRILOC - somme(i=1..35 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC37 = max(min((INVRETPBR * (1 - INDPLAF) + INVRETPBRA * INDPLAF) , RRILOC - somme(i=1..36 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC38 = max(min((INVRETPFR * (1 - INDPLAF) + INVRETPFRA * INDPLAF) , RRILOC - somme(i=1..37 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC39 = max(min((INVRETPJR * (1 - INDPLAF) + INVRETPJRA * INDPLAF) , RRILOC - somme(i=1..38 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC40 = max(min((INVRETQOR * (1 - INDPLAF) + INVRETQORA * INDPLAF) , RRILOC - somme(i=1..39 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC41 = max(min((INVRETQFR * (1 - INDPLAF) + INVRETQFRA * INDPLAF) , RRILOC - somme(i=1..40 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC42 = max(min((INVRETPAR * (1 - INDPLAF) + INVRETPARA * INDPLAF) , RRILOC - somme(i=1..41 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC43 = max(min((INVRETPER * (1 - INDPLAF) + INVRETPERA * INDPLAF) , RRILOC - somme(i=1..42 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC44 = max(min((INVRETPIR * (1 - INDPLAF) + INVRETPIRA * INDPLAF) , RRILOC - somme(i=1..43 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC45 = max(min(INVOMRETPM , RRILOC - somme(i=1..44 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC46 = max(min(INVOMENTRJ , RRILOC - somme(i=1..45 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC47 = max(min((INVRETPO * (1 - INDPLAF) + INVRETPOA * INDPLAF) , RRILOC - somme(i=1..46 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC48 = max(min((INVRETPT * (1 - INDPLAF) + INVRETPTA * INDPLAF) , RRILOC - somme(i=1..47 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC49 = max(min((INVRETPY * (1 - INDPLAF) + INVRETPYA * INDPLAF) , RRILOC - somme(i=1..48 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC50 = max(min((INVRETRL * (1 - INDPLAF) + INVRETRLA * INDPLAF) , RRILOC - somme(i=1..49 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC51 = max(min((INVRETRQ * (1 - INDPLAF) + INVRETRQA * INDPLAF) , RRILOC - somme(i=1..50 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC52 = max(min((INVRETRV * (1 - INDPLAF) + INVRETRVA * INDPLAF) , RRILOC - somme(i=1..51 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC53 = max(min((INVRETNV * (1 - INDPLAF) + INVRETNVA * INDPLAF) , RRILOC - somme(i=1..52 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC54 = max(min((INVRETPN * (1 - INDPLAF) + INVRETPNA * INDPLAF) , RRILOC - somme(i=1..53 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC55 = max(min((INVRETPS * (1 - INDPLAF) + INVRETPSA * INDPLAF) , RRILOC - somme(i=1..54 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC56 = max(min((INVRETPX * (1 - INDPLAF) + INVRETPXA * INDPLAF) , RRILOC - somme(i=1..55 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC57 = max(min((INVRETRK * (1 - INDPLAF) + INVRETRKA * INDPLAF) , RRILOC - somme(i=1..56 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC58 = max(min((INVRETRP * (1 - INDPLAF) + INVRETRPA * INDPLAF) , RRILOC - somme(i=1..57 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC59 = max(min((INVRETRU * (1 - INDPLAF) + INVRETRUA * INDPLAF) , RRILOC - somme(i=1..58 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC60 = max(min((INVRETNU * (1 - INDPLAF) + INVRETNUA * INDPLAF) , RRILOC - somme(i=1..59 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC61 = max(min((INVRETPP * (1 - INDPLAF) + INVRETPPA * INDPLAF) , RRILOC - somme(i=1..60 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC62 = max(min((INVRETPU * (1 - INDPLAF) + INVRETPUA * INDPLAF) , RRILOC - somme(i=1..61 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC63 = max(min((INVRETRG * (1 - INDPLAF) + INVRETRGA * INDPLAF) , RRILOC - somme(i=1..62 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC64 = max(min((INVRETRM * (1 - INDPLAF) + INVRETRMA * INDPLAF) , RRILOC - somme(i=1..63 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC65 = max(min((INVRETRR * (1 - INDPLAF) + INVRETRRA * INDPLAF) , RRILOC - somme(i=1..64 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC66 = max(min((INVRETRW * (1 - INDPLAF) + INVRETRWA * INDPLAF) , RRILOC - somme(i=1..65 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC67 = max(min((INVRETNW * (1 - INDPLAF) + INVRETNWA * INDPLAF) , RRILOC - somme(i=1..66 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC68 = max(min((INVRETPR * (1 - INDPLAF) + INVRETPRA * INDPLAF) , RRILOC - somme(i=1..67 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC69 = max(min((INVRETPW * (1 - INDPLAF) + INVRETPWA * INDPLAF) , RRILOC - somme(i=1..68 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC70 = max(min((INVRETRI * (1 - INDPLAF) + INVRETRIA * INDPLAF) , RRILOC - somme(i=1..69 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC71 = max(min((INVRETRO * (1 - INDPLAF) + INVRETROA * INDPLAF) , RRILOC - somme(i=1..70 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC72 = max(min((INVRETRT * (1 - INDPLAF) + INVRETRTA * INDPLAF) , RRILOC - somme(i=1..71 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC73 = max(min((INVRETRY * (1 - INDPLAF) + INVRETRYA * INDPLAF) , RRILOC - somme(i=1..72 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC74 = max(min((INVRETNY * (1 - INDPLAF) + INVRETNYA * INDPLAF) , RRILOC - somme(i=1..73 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC75 = max(min((INVRETPOR * (1 - INDPLAF) + INVRETPORA * INDPLAF) , RRILOC - somme(i=1..74 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC76 = max(min((INVRETPTR * (1 - INDPLAF) + INVRETPTRA * INDPLAF) , RRILOC - somme(i=1..75 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC77 = max(min((INVRETPYR * (1 - INDPLAF) + INVRETPYRA * INDPLAF) , RRILOC - somme(i=1..76 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC78 = max(min((INVRETRLR * (1 - INDPLAF) + INVRETRLRA * INDPLAF) , RRILOC - somme(i=1..77 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC79 = max(min((INVRETRQR * (1 - INDPLAF) + INVRETRQRA * INDPLAF) , RRILOC - somme(i=1..78 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC80 = max(min((INVRETRVR * (1 - INDPLAF) + INVRETRVRA * INDPLAF) , RRILOC - somme(i=1..79 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC81 = max(min((INVRETNVR * (1 - INDPLAF) + INVRETNVRA * INDPLAF) , RRILOC - somme(i=1..80 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC82 = max(min((INVRETPNR * (1 - INDPLAF) + INVRETPNRA * INDPLAF) , RRILOC - somme(i=1..81 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC83 = max(min((INVRETPSR * (1 - INDPLAF) + INVRETPSRA * INDPLAF) , RRILOC - somme(i=1..82 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC84 = max(min((INVRETPXR * (1 - INDPLAF) + INVRETPXRA * INDPLAF) , RRILOC - somme(i=1..83 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC85 = max(min((INVRETRKR * (1 - INDPLAF) + INVRETRKRA * INDPLAF) , RRILOC - somme(i=1..84 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC86 = max(min((INVRETRPR * (1 - INDPLAF) + INVRETRPRA * INDPLAF) , RRILOC - somme(i=1..85 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC87 = max(min((INVRETRUR * (1 - INDPLAF) + INVRETRURA * INDPLAF) , RRILOC - somme(i=1..86 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC88 = max(min((INVRETNUR * (1 - INDPLAF) + INVRETNURA * INDPLAF) , RRILOC - somme(i=1..87 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC89 = max(min((INVRETSB * (1 - INDPLAF) + INVRETSBA * INDPLAF) , RRILOC - somme(i=1..88 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC90 = max(min((INVRETSG * (1 - INDPLAF) + INVRETSGA * INDPLAF) , RRILOC - somme(i=1..89 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC91 = max(min((INVRETSL * (1 - INDPLAF) + INVRETSLA * INDPLAF) , RRILOC - somme(i=1..90 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC92 = max(min((INVRETSQ * (1 - INDPLAF) + INVRETSQA * INDPLAF) , RRILOC - somme(i=1..91 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC93 = max(min((INVRETSV * (1 - INDPLAF) + INVRETSVA * INDPLAF) , RRILOC - somme(i=1..92 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC94 = max(min((INVRETTA * (1 - INDPLAF) + INVRETTAA * INDPLAF) , RRILOC - somme(i=1..93 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC95 = max(min((INVRETSA * (1 - INDPLAF) + INVRETSAA * INDPLAF) , RRILOC - somme(i=1..94 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC96 = max(min((INVRETSF * (1 - INDPLAF) + INVRETSFA * INDPLAF) , RRILOC - somme(i=1..95 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC97 = max(min((INVRETSK * (1 - INDPLAF) + INVRETSKA * INDPLAF) , RRILOC - somme(i=1..96 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC98 = max(min((INVRETSP * (1 - INDPLAF) + INVRETSPA * INDPLAF) , RRILOC - somme(i=1..97 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC99 = max(min((INVRETSU * (1 - INDPLAF) + INVRETSUA * INDPLAF) , RRILOC - somme(i=1..98 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC100 = max(min((INVRETSZ * (1 - INDPLAF) + INVRETSZA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi)) , 0) * (1 - V_CNR) ;

RLOC101 = max(min((INVRETSC * (1 - INDPLAF) + INVRETSCA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) -RLOC100) , 0) * (1 - V_CNR) ;

RLOC102 = max(min((INVRETSH * (1 - INDPLAF) + INVRETSHA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) -RLOC100-RLOC101) , 0) * (1 - V_CNR) ;

RLOC103 = max(min((INVRETSM * (1 - INDPLAF) + INVRETSMA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..2 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC104 = max(min((INVRETSR * (1 - INDPLAF) + INVRETSRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..3 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC105 = max(min((INVRETSW * (1 - INDPLAF) + INVRETSWA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..4 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC106 = max(min((INVRETTB * (1 - INDPLAF) + INVRETTBA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..5 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC107 = max(min((INVRETSE * (1 - INDPLAF) + INVRETSEA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..6 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC108 = max(min((INVRETSJ * (1 - INDPLAF) + INVRETSJA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..7 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC109 = max(min((INVRETSO * (1 - INDPLAF) + INVRETSOA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..8 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC110 = max(min((INVRETST * (1 - INDPLAF) + INVRETSTA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..9 : RLOC10i)) , 0) * (1 - V_CNR) ;

RLOC111 = max(min((INVRETSY * (1 - INDPLAF) + INVRETSYA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..10 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC112 = max(min((INVRETTD * (1 - INDPLAF) + INVRETTDA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..11 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC113 = max(min((INVRETSBR * (1 - INDPLAF) + INVRETSBRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..12 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC114 = max(min((INVRETSGR * (1 - INDPLAF) + INVRETSGRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..13 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC115 = max(min((INVRETSAR * (1 - INDPLAF) + INVRETSARA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..14 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC116 = max(min((INVRETSFR * (1 - INDPLAF) + INVRETSFRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..15 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC117 = max(min((INVRETSLR * (1 - INDPLAF) + INVRETSLRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..16 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC118 = max(min((INVRETSQR * (1 - INDPLAF) + INVRETSQRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..17 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC119 = max(min((INVRETSVR * (1 - INDPLAF) + INVRETSVRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..18 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC120 = max(min((INVRETTAR * (1 - INDPLAF) + INVRETTARA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..19 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC121 = max(min((INVRETSKR * (1 - INDPLAF) + INVRETSKRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..20 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC122 = max(min((INVRETSPR * (1 - INDPLAF) + INVRETSPRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..21 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC123 = max(min((INVRETSUR * (1 - INDPLAF) + INVRETSURA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..22 : RLOC1i)) , 0) * (1 - V_CNR) ;

RLOC124 = max(min((INVRETSZR * (1 - INDPLAF) + INVRETSZRA * INDPLAF) , RRILOC - somme(i=1..99 : RLOCi) - somme(i=0..23 : RLOC1i)) , 0) * (1 - V_CNR) ;


RCOLENT_1 = ((1-V_INDTEO) * (somme(i=1..99 : RLOCi) + somme(i=0..24 : RLOC1i))
          + (V_INDTEO) * (RLOC01 + RLOC07 + RLOC18 + RLOC19 +RLOC45 + RLOC46
                        + arr((V_RLOC03+V_RLOC06)*(TX50/100)) 
	                + arr((V_RLOC02+V_RLOC05)*(TX60/100)) 
                        + arr((V_RLOC10+V_RLOC16)*(TX50/100))
			+ arr((V_RLOC08+V_RLOC14)*(TX60/100))
			+ arr((V_RLOC25+V_RLOC40)*(TX50/100))
			+ arr((V_RLOC20+V_RLOC35)*(TX60/100))
			+ arr((V_RLOC54+V_RLOC82)*(TX50/100))
			+ arr((V_RLOC47+V_RLOC75)*(TX60/100))
			+ arr((V_RLOC27+V_RLOC42)*(5263/10000))
			+ arr((V_RLOC22+V_RLOC37)*(625/1000))
			+ arr((V_RLOC57+V_RLOC85)*(5263/10000))
			+ arr((V_RLOC50+V_RLOC78)*(625/1000))

			+ arr((V_RLOC11+V_RLOC17)*(TX50/100))
			+ arr((V_RLOC09+V_RLOC15)*(60/100))
			+ arr((V_RLOC26+V_RLOC41)*(50/100))
			+ arr((V_RLOC21+V_RLOC36)*(60/100))
			+ arr((V_RLOC55+V_RLOC83)*(50/100))
			+ arr((V_RLOC48+V_RLOC76)*(60/100))
			+ arr((V_RLOC28+V_RLOC43)*(5263/10000))
			+ arr((V_RLOC23+V_RLOC38)*(625/1000))
			+ arr((V_RLOC58+V_RLOC86)*(5263/10000))
			+ arr((V_RLOC51+V_RLOC79)*(625/1000))
                        + arr((V_RLOC95+V_RLOC115)*(5263/10000)) 
                        + arr((V_RLOC89+V_RLOC113)*(625/1000))
                        + arr((V_RLOC97+V_RLOC121)*(5263/10000))
                        + arr((V_RLOC91+V_RLOC117)*(625/1000))

			+ arr((V_RLOC29+V_RLOC44)*(5263/10000))
			+ arr((V_RLOC24+V_RLOC39)*(625/1000))
                        + arr((V_RLOC56+V_RLOC84)*(5263/10000))
                        + arr((V_RLOC49+V_RLOC77)*(625/1000))
                        + arr((V_RLOC59+V_RLOC87)*(5263/10000))
                        + arr((V_RLOC52+V_RLOC80)*(625/1000))
                        + arr((V_RLOC96+V_RLOC116)*(5263/10000))
                        + arr((V_RLOC90+V_RLOC114)*(625/1000))
                        + arr((V_RLOC98+V_RLOC122)*(5263/10000))
                        + arr((V_RLOC92+V_RLOC118)*(625/1000))

                        + arr((V_RLOC60+V_RLOC88)*(5263/10000))
                        + arr((V_RLOC53+V_RLOC81)*(625/1000))
                        + arr((V_RLOC99+V_RLOC123)*(5263/10000))
                        + arr((V_RLOC93+V_RLOC119)*(625/1000))

                        + arr((V_RLOC100+V_RLOC124)*(5263/10000))
                        + arr((V_RLOC94+V_RLOC120)*(625/1000))
			
			)) * (1 - V_CNR) ;

RCOLENT = RCOLENT_1 * (1-ART1731BIS) 
          + min( RCOLENT_1 , max(RCOLENT_P+RCOLENTP2 , RCOLENT1731+0 ) * (1-PREM8_11)) * ART1731BIS ;

regle 4086:
application : iliad, batch ;


RRIREP = RRI1 - DLOGDOM - RTOURES - RTOURREP - RTOUHOTR - RTOUREPA - RCOMP - RCREAT - RRETU 
              - RDONS - RCELTOT - RLOCNPRO - RDUFLOTOT - RPINELTOT - RNOUV - RPLAFREPME4 - RFOR - RPATNATOT ;




REPKH = ( max(0 , INVOMSOCKH - max(0 , RRIREP - INVSOCNRET)) * (1-ART1731BIS)
            + max(0 , INVOMSOCKH - max(0 , RDOMSOC1 - INVSOCNRET)) * ART1731BIS 
        ) * (1 - V_CNR) ;

REPKI = ( max(0 , INVOMSOCKI - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH)) * (1-ART1731BIS)
            + max(0, INVOMSOCKI - max(0 , RDOMSOC1 -INVSOCNRET-INVOMSOCKH)) * ART1731BIS  
        ) * (1 - V_CNR) ;
                                                               
REPDOMSOC4 = REPKH + REPKI ;


REPQN = ( max(0 , INVSOC2010 - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI)) * (1-ART1731BIS)
            + max(0, INVSOC2010 - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI)) * ART1731BIS  
        ) * (1 - V_CNR) ;

REPQU = (max(0 , INVOMSOCQU - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010)) * (1-ART1731BIS)
            + max(0, INVOMSOCQU - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010)) * ART1731BIS  
        ) * (1 - V_CNR) ;

REPQK = (max(0 , INVLOGSOC - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU)) * (1-ART1731BIS)
            + max(0, INVLOGSOC - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU)) * ART1731BIS  
        ) * (1 - V_CNR) ;


REPDOMSOC3 = REPQN + REPQU + REPQK ;


REPQJ = (max(0 , INVOMSOCQJ - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC)) * (1-ART1731BIS)
            + max(0, INVOMSOCQJ  - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC)) * ART1731BIS  
        ) * (1 - V_CNR) ;

REPQS = (max(0 , INVOMSOCQS - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ)) * (1-ART1731BIS)
            + max(0, INVOMSOCQS  - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ)) * ART1731BIS  
        ) * (1 - V_CNR) ;

REPQW = (max(0 , INVOMSOCQW - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS)) * (1-ART1731BIS) 
            + max(0, INVOMSOCQW  - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS)) * ART1731BIS  
        ) * (1 - V_CNR) ;

REPQX = (max(0 , INVOMSOCQX - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW)) * (1-ART1731BIS)
            + max(0, INVOMSOCQX  - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW)) * ART1731BIS  

        ) * (1 - V_CNR) ;

REPDOMSOC2 = REPQJ + REPQS + REPQW + REPQX ;


REPRA = (max(0 , CODHRA - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS
                                         -INVOMSOCQW-INVOMSOCQX)) * (1-ART1731BIS)
            + max(0, CODHRA - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ
                                             -INVOMSOCQS-INVOMSOCQW-INVOMSOCQX)) * ART1731BIS 
        ) * (1 - V_CNR) ;

REPRB = (max(0 , CODHRB - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS
                                         -INVOMSOCQW-INVOMSOCQX-CODHRA)) * (1-ART1731BIS)
            + max(0, CODHRB - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ
                                             -INVOMSOCQS-INVOMSOCQW-INVOMSOCQX-CODHRA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRC = (max(0 , CODHRC - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS
                                         -INVOMSOCQW-INVOMSOCQX-CODHRA-CODHRB)) * (1-ART1731BIS)
            + max(0, CODHRC - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ
                                             -INVOMSOCQS-INVOMSOCQW-INVOMSOCQX-CODHRA-CODHRB)) * ART1731BIS
        ) * (1 - V_CNR) ;


REPRD = (max(0 , CODHRD - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS
                                         -INVOMSOCQW-INVOMSOCQX-CODHRA-CODHRB-CODHRC)) * (1-ART1731BIS)
            + max(0, CODHRD - max(0,RDOMSOC1 -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ
                                             -INVOMSOCQS-INVOMSOCQW-INVOMSOCQX-CODHRA-CODHRB-CODHRC)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMSOC1 = REPRA + REPRB + REPRC + REPRD ;


REPXA = (max(0 , CODHXA - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW
                                         -INVOMSOCQX-CODHRA-CODHRB-CODHRC-CODHRD)) * (1-ART1731BIS)
         + max(0, CODHXA - RLOGSOC) * ART1731BIS
        ) * (1 - V_CNR) ;

REPXB = (max(0 , CODHXB - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW
                                         -INVOMSOCQX-CODHRA-CODHRB-CODHRC-CODHRD-CODHXA)) * (1-ART1731BIS)
         + max(0, CODHXB - max(0 , RLOGSOC-CODHXA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPXC = (max(0 , CODHXC - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW
                                         -INVOMSOCQX-CODHRA-CODHRB-CODHRC-CODHRD-CODHXA-CODHXB)) * (1-ART1731BIS)
         + max(0, CODHXC - max(0 , RLOGSOC-CODHXA-CODHXB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPXE = (max(0 , CODHXE - max(0 , RRIREP -INVSOCNRET-INVOMSOCKH-INVOMSOCKI-INVSOC2010-INVOMSOCQU-INVLOGSOC-INVOMSOCQJ-INVOMSOCQS-INVOMSOCQW
                                         -INVOMSOCQX-CODHRA-CODHRB-CODHRC-CODHRD-CODHXA-CODHXB-CODHXC)) * (1-ART1731BIS)
         + max(0, CODHXE - max(0 , RLOGSOC-CODHXA-CODHXB-CODHXC)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMSOC = REPXA + REPXB + REPXC + REPXE ;

REPSOC = INVSOCNRET + INVOMSOCKH + INVOMSOCKI + INVSOC2010 + INVOMSOCQU + INVLOGSOC + INVOMSOCQJ + INVOMSOCQS 
         + INVOMSOCQW + INVOMSOCQX + CODHRA + CODHRB + CODHRC + CODHRD + CODHXA + CODHXB + CODHXC + CODHXE ;



REPENT5 = INVOMREP + NRETROC40 + NRETROC50 + INVENDI ;


REPMN = (max(0 , INVOMENTMN - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5)) * (1-ART1731BIS)
         + max(0 , INVOMENTMN - max(0,RCOLENT-REPENT5)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPMB = (max(0 , RETROCOMMB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN)) * (1-ART1731BIS)
         + max(0 , RETROCOMMB - max(0,RCOLENT-REPENT5-INVOMENTMN)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPMC = (max(0 , RETROCOMMC - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN-RETROCOMMB)) * (1-ART1731BIS)
         + max(0 , RETROCOMMC - max(0,RCOLENT-REPENT5-INVOMENTMN-RETROCOMMB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPLH = (max(0 , RETROCOMLH - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC)) * (1-ART1731BIS)  
         + max(0 , RETROCOMLH - max(0,RCOLENT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPLI = (max(0 , RETROCOMLI - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH)) * (1-ART1731BIS)
         + max(0 , RETROCOMLI - max(0,RCOLENT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPKT = (max(0 , INVOMENTKT - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH
                                             -RETROCOMLI)) * (1-ART1731BIS)
         + max(0 , INVOMENTKT - max(0,RCOLENT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH-RETROCOMLI)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPKU = (max(0 , INVOMENTKU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH
                                             -RETROCOMLI-INVOMENTKT)) * (1-ART1731BIS) 
         + max(0 , INVOMENTKU - max(0,RCOLENT-REPENT5-INVOMENTMN-RETROCOMMB-RETROCOMMC-RETROCOMLH-RETROCOMLI-INVOMENTKT)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMENTR4 = REPMN + REPMB + REPMC + REPLH + REPLI + REPKT + REPKU ;

REPENT4 = INVOMENTMN + RETROCOMMB + RETROCOMMC + RETROCOMLH + RETROCOMLI + INVOMENTKT + INVOMENTKU ;


REPQV = (max(0 , INVOMQV - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4)) * (1-ART1731BIS)
         + max(0 , INVOMQV - max(0,RCOLENT-REPENT5-REPENT4)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQE = (max(0 , INVENDEB2009 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV)) * (1-ART1731BIS)
         + max(0 ,INVENDEB2009 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQP = (max(0 , INVRETRO2 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009)) * (1-ART1731BIS)
         + max(0 ,INVRETRO2 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQG = (max(0 , INVDOMRET60 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2)) * (1-ART1731BIS)
         + max(0 ,INVDOMRET60 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPB = (max(0 , INVOMRETPB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPB - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPF = (max(0 , INVOMRETPF - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPF - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPJ = (max(0 , INVOMRETPJ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPJ - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQO = (max(0 , INVRETRO1 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                            -INVOMRETPF-INVOMRETPJ)) * (1-ART1731BIS)
         + max(0 ,INVRETRO1 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQF = (max(0 , INVDOMRET50 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                              -INVOMRETPF-INVOMRETPJ-INVRETRO1)) * (1-ART1731BIS)
         + max(0 ,INVDOMRET50 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                              -INVRETRO1)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPA = (max(0 , INVOMRETPA - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPA - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPE = (max(0 , INVOMRETPE - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPE - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPI = (max(0 , INVOMRETPI - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPI - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQR = (max(0 , INVIMP - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                         -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI)) * (1-ART1731BIS)
         + max(0 ,INVIMP - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                         -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPQI = (max(0 , INVDIR2009 - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP)) * (1-ART1731BIS)
         + max(0 ,INVDIR2009 - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPD = (max(0 , INVOMRETPD - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP
                                             -INVDIR2009)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPD - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP-INVDIR2009)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPH = (max(0 , INVOMRETPH - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP
                                             -INVDIR2009-INVOMRETPD)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPH - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP-INVDIR2009-INVOMRETPD)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPL = (max(0 , INVOMRETPL - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB
                                             -INVOMRETPF-INVOMRETPJ-INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP
                                             -INVDIR2009-INVOMRETPD-INVOMRETPH)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPL - max(0,RCOLENT -REPENT5-REPENT4-INVOMQV-INVENDEB2009-INVRETRO2-INVDOMRET60-INVOMRETPB-INVOMRETPF-INVOMRETPJ
                                             -INVRETRO1-INVDOMRET50-INVOMRETPA-INVOMRETPE-INVOMRETPI-INVIMP-INVDIR2009-INVOMRETPD
                                             -INVOMRETPH)) * ART1731BIS
        ) * (1 - V_CNR) ;


REPDOMENTR3 = REPQE + REPQV + REPQP + REPQG + REPQO + REPQF + REPQR + REPQI + REPPB + REPPF + REPPJ + REPPA + REPPE + REPPI + REPPD + REPPH + REPPL ;

REPENT3 = INVOMQV + INVENDEB2009 + INVRETRO2 + INVDOMRET60 + INVOMRETPB + INVOMRETPF + INVOMRETPJ + INVRETRO1 + INVDOMRET50 
          + INVOMRETPA + INVOMRETPE + INVOMRETPI + INVIMP + INVDIR2009 + INVOMRETPD + INVOMRETPH + INVOMRETPL ;


REPPM = (max(0 , INVOMRETPM - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPM - max(0,RCOLENT -REPENT5-REPENT4-REPENT3)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRJ = (max(0 , INVOMENTRJ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRJ - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPO = (max(0 , INVOMRETPO - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPO - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPT = (max(0 , INVOMRETPT - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPT - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPY = (max(0 , INVOMRETPY - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPY - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT)) * ART1731BIS
         ) * (1 - V_CNR) ;

REPRL = (max(0 , INVOMENTRL - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRL - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRQ = (max(0 , INVOMENTRQ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRQ - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRV = (max(0 , INVOMENTRV - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRV - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPNV = (max(0 , INVOMENTNV - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV)) * (1-ART1731BIS)
         + max(0 ,INVOMENTNV - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPN = (max(0 , INVOMRETPN - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPN - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPS = (max(0 , INVOMRETPS - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPS - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPX = (max(0 , INVOMRETPX - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPX - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRK = (max(0 , INVOMENTRK - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRK - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRP = (max(0 , INVOMENTRP - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRP - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRU = (max(0 , INVOMENTRU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRU - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPNU = (max(0 , INVOMENTNU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU)) * (1-ART1731BIS)
         + max(0 ,INVOMENTNU - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPP = (max(0 , INVOMRETPP - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPP - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPU = (max(0 , INVOMRETPU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPU - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRG = (max(0 , INVOMENTRG - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRG - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU)) * ART1731BIS
        )* (1 - V_CNR) ;

REPRM = (max(0 , INVOMENTRM - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRM - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG )) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRR = (max(0 , INVOMENTRR - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRR - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM )) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRW = (max(0 , INVOMENTRW - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRW - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR )) * ART1731BIS
        ) * (1 - V_CNR) ;

REPNW = (max(0 , INVOMENTNW - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW)) * (1-ART1731BIS)
         + max(0 ,INVOMENTNW - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW )) * ART1731BIS
        ) * (1 - V_CNR) ;

REPPR = (max(0 , INVOMRETPR - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPR - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW)) * ART1731BIS
        )* (1 - V_CNR) ;

REPPW = (max(0 , INVOMRETPW - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR)) * (1-ART1731BIS)
         + max(0 ,INVOMRETPW - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRI = (max(0 , INVOMENTRI - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR-INVOMRETPW)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRI - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR-INVOMRETPW)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRO = (max(0 , INVOMENTRO - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR-INVOMRETPW-INVOMENTRI)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRO - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR-INVOMRETPW-INVOMENTRI)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPRT = (max(0 , INVOMENTRT - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRT - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO)) * ART1731BIS
         ) * (1 - V_CNR) ;

REPRY = (max(0 , INVOMENTRY - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO-INVOMENTRT)) * (1-ART1731BIS)
         + max(0 ,INVOMENTRY - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO-INVOMENTRT)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPNY = (max(0 , INVOMENTNY - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY
                                             -INVOMENTRL-INVOMENTRQ-INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK
                                             -INVOMENTRP-INVOMENTRU-INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR
                                             -INVOMENTRW-INVOMENTNW-INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO-INVOMENTRT-INVOMENTRY)) * (1-ART1731BIS)
         + max(0 ,INVOMENTNY - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-INVOMRETPM-INVOMENTRJ-INVOMRETPO-INVOMRETPT-INVOMRETPY-INVOMENTRL-INVOMENTRQ
                                             -INVOMENTRV-INVOMENTNV-INVOMRETPN-INVOMRETPS-INVOMRETPX-INVOMENTRK-INVOMENTRP-INVOMENTRU
                                             -INVOMENTNU-INVOMRETPP-INVOMRETPU-INVOMENTRG-INVOMENTRM-INVOMENTRR-INVOMENTRW-INVOMENTNW
                                             -INVOMRETPR-INVOMRETPW-INVOMENTRI-INVOMENTRO-INVOMENTRT-INVOMENTRY)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMENTR2 = REPPM + REPRJ + REPPO + REPPT + REPPY + REPRL + REPRQ + REPRV + REPNV + REPPN + REPPS + REPPX + REPRK + REPRP + REPRU + REPNU 
	      + REPPP + REPPU + REPRG + REPRM + REPRR + REPRW + REPNW + REPPR + REPPW + REPRI + REPRO + REPRT + REPRY + REPNY ;

REPENT2 = INVOMRETPM + INVOMENTRJ + INVOMRETPO + INVOMRETPT + INVOMRETPY + INVOMENTRL + INVOMENTRQ + INVOMENTRV + INVOMENTNV + INVOMRETPN + INVOMRETPS 
          + INVOMRETPX + INVOMENTRK + INVOMENTRP + INVOMENTRU + INVOMENTNU + INVOMRETPP + INVOMRETPU + INVOMENTRG + INVOMENTRM + INVOMENTRR + INVOMENTRW 
          + INVOMENTNW + INVOMRETPR + INVOMRETPW + INVOMENTRI + INVOMENTRO + INVOMENTRT + INVOMENTRY + INVOMENTNY ;


REPSB = (max(0 , CODHSB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2)) * (1-ART1731BIS)
         + max(0 ,CODHSB - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSG = (max(0 , CODHSG - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB)) * (1-ART1731BIS)
         + max(0 ,CODHSG - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSL = (max(0 , CODHSL - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG)) * (1-ART1731BIS)
         + max(0 ,CODHSL - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG)) * ART1731BIS
        )* (1 - V_CNR) ;

REPSQ = (max(0 , CODHSQ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL)) * (1-ART1731BIS)
         + max(0 ,CODHSQ - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSV = (max(0 , CODHSV - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ)) * (1-ART1731BIS)
         + max(0 ,CODHSV - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPTA = (max(0 , CODHTA - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV)) * (1-ART1731BIS)
         + max(0 ,CODHTA - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSA = (max(0 , CODHSA - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA)) * (1-ART1731BIS)
         + max(0 ,CODHSA - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSF = (max(0 , CODHSF - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA)) * (1-ART1731BIS)
         + max(0 ,CODHSF - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSK = (max(0 , CODHSK - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF)) * (1-ART1731BIS)
         + max(0 ,CODHSK - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSP = (max(0 , CODHSP - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK)) * (1-ART1731BIS)
         + max(0 ,CODHSP - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSU = (max(0 , CODHSU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP)) * (1-ART1731BIS)
         + max(0 ,CODHSU - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSZ = (max(0 , CODHSZ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU)) * (1-ART1731BIS)
         + max(0 ,CODHSZ - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSC = (max(0 , CODHSC - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ)) * (1-ART1731BIS)
         + max(0 ,CODHSC - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ)) * ART1731BIS
        ) * (1 - V_CNR) ; 

REPSH = (max(0 , CODHSH - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC)) * (1-ART1731BIS)
         + max(0 ,CODHSH - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC)) * ART1731BIS
        ) * (1 - V_CNR) ; 

REPSM = (max(0 , CODHSM - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH)) * (1-ART1731BIS)
         + max(0 ,CODHSM - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH)) * ART1731BIS
        ) * (1 - V_CNR) ; 


REPSR = (max(0 , CODHSR - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM)) * (1-ART1731BIS)
         + max(0 ,CODHSR - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSW = (max(0 , CODHSW - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR)) * (1-ART1731BIS)
         + max(0 ,CODHSW - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPTB = (max(0 , CODHTB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW)) * (1-ART1731BIS)
         + max(0 ,CODHTB - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSE = (max(0 , CODHSE - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB)) * (1-ART1731BIS)
         + max(0 ,CODHSE - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSJ = (max(0 , CODHSJ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB-CODHSE)) * (1-ART1731BIS)
         + max(0 ,CODHSJ - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB-CODHSE)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSO = (max(0 , CODHSO - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB-CODHSE-CODHSJ)) * (1-ART1731BIS)
         + max(0 ,CODHSO - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB-CODHSE
                                         -CODHSJ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPST = (max(0 , CODHST - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB-CODHSE-CODHSJ-CODHSO)) * (1-ART1731BIS)
         + max(0 ,CODHST - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB-CODHSE
                                         -CODHSJ-CODHSO)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPSY = (max(0 , CODHSY - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB-CODHSE-CODHSJ-CODHSO-CODHST)) * (1-ART1731BIS)
         + max(0 ,CODHSY - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB-CODHSE
                                         -CODHSJ-CODHSO-CODHST)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPTD = (max(0 , CODHTD - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV
                                         -CODHTA-CODHSA-CODHSF-CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR
                                         -CODHSW-CODHTB-CODHSE-CODHSJ-CODHSO-CODHST-CODHSY)) * (1-ART1731BIS)
         + max(0 ,CODHTD - max(0,RCOLENT -REPENT5-REPENT4-REPENT3-REPENT2-CODHSB-CODHSG-CODHSL-CODHSQ-CODHSV-CODHTA-CODHSA-CODHSF
                                         -CODHSK-CODHSP-CODHSU-CODHSZ-CODHSC-CODHSH-CODHSM-CODHSR-CODHSW-CODHTB-CODHSE
                                         -CODHSJ-CODHSO-CODHST-CODHSY)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMENTR1 = REPSB + REPSG + REPSL + REPSQ + REPSV + REPTA + REPSA + REPSF + REPSK + REPSP + REPSU + REPSZ + REPSC 
              + REPSH + REPSM + REPSR + REPSW + REPTB + REPSE + REPSJ + REPSO + REPST + REPSY + REPTD ;

REPENT1 = CODHSB + CODHSG + CODHSL + CODHSQ + CODHSV + CODHTA + CODHSA + CODHSF + CODHSK + CODHSP + CODHSU + CODHSZ 
          + CODHSC + CODHSH + CODHSM + CODHSR + CODHSW + CODHTB + CODHSE + CODHSJ + CODHSO + CODHST + CODHSY + CODHTD ;

REPAB = (max(0 , CODHAB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1)) * (1-ART1731BIS)
         + max(0 ,CODHAB - RLOCENT) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAG = (max(0 , CODHAG - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB)) * (1-ART1731BIS)
         + max(0 ,CODHAG - max(0,RLOCENT -CODHAB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAL = (max(0 , CODHAL - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG)) * (1-ART1731BIS)
         + max(0 ,CODHAL - max(0,RLOCENT -CODHAB-CODHAG)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAQ = (max(0 , CODHAQ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL)) * (1-ART1731BIS)
         + max(0 ,CODHAQ - max(0,RLOCENT -CODHAB-CODHAG-CODHAL)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAV = (max(0 , CODHAV - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ)) * (1-ART1731BIS)
         + max(0 ,CODHAV - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPBB = (max(0 , CODHBB - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV)) * (1-ART1731BIS)
         + max(0 ,CODHBB - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAA = (max(0 , CODHAA - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB)) * (1-ART1731BIS)
         + max(0 ,CODHAA - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAF = (max(0 , CODHAF - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA)) * (1-ART1731BIS)
         + max(0 ,CODHAF - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAK = (max(0 , CODHAK - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF)) * (1-ART1731BIS)
         + max(0 ,CODHAK - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAP = (max(0 , CODHAP - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK)) * (1-ART1731BIS)
         + max(0 ,CODHAP - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAU = (max(0 , CODHAU - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP)) * (1-ART1731BIS)
         + max(0 ,CODHAU - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPBA = (max(0 , CODHBA - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU)) * (1-ART1731BIS)
         + max(0 ,CODHBA - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAC = (max(0 , CODHAC - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA)) * (1-ART1731BIS)
         + max(0 ,CODHAC - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAH = (max(0 , CODHAH - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC)) * (1-ART1731BIS)
         + max(0 ,CODHAH - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAM = (max(0 , CODHAM - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                          -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH)) * (1-ART1731BIS)
          + max(0 ,CODHAM - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                          -CODHBA-CODHAC-CODHAH)) * ART1731BIS
         ) * (1 - V_CNR) ;

REPHAR = (max(0 , CODHAR - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                          -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM)) * (1-ART1731BIS)
          + max(0 ,CODHAR - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                          -CODHBA-CODHAC-CODHAH-CODHAM)) * ART1731BIS
         ) * (1 - V_CNR) ;

REPAW = (max(0 , CODHAW - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR)) * (1-ART1731BIS)
         + max(0 ,CODHAW - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR)) * ART1731BIS
         ) * (1 - V_CNR) ;

REPBE = (max(0 , CODHBE - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW)) * (1-ART1731BIS)
         + max(0 ,CODHBE - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAE = (max(0 , CODHAE - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE)) * (1-ART1731BIS)
         + max(0 ,CODHAE - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAJ = (max(0 , CODHAJ - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE
                                         -CODHAE)) * (1-ART1731BIS)
         + max(0 ,CODHAJ - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE-CODHAE)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAO = (max(0 , CODHAO - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE
                                         -CODHAE-CODHAJ)) * (1-ART1731BIS)
         + max(0 ,CODHAO - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE-CODHAE-CODHAJ)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAT = (max(0 , CODHAT - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE
                                         -CODHAE-CODHAJ-CODHAO)) * (1-ART1731BIS)
         + max(0 ,CODHAT - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE-CODHAE-CODHAJ-CODHAO)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPAY = (max(0 , CODHAY - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE
                                         -CODHAE-CODHAJ-CODHAO-CODHAT)) * (1-ART1731BIS)
         + max(0 ,CODHAY - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE-CODHAE-CODHAJ-CODHAO-CODHAT)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPBG = (max(0 , CODHBG - max(0 , RRIREP -REPSOC-RIDOMPROTOT-REPENT5-REPENT4-REPENT3-REPENT2-REPENT1-CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV
                                         -CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU-CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE
                                         -CODHAE-CODHAJ-CODHAO-CODHAT-CODHAY)) * (1-ART1731BIS)
         + max(0 ,CODHBG - max(0,RLOCENT -CODHAB-CODHAG-CODHAL-CODHAQ-CODHAV-CODHBB-CODHAA-CODHAF-CODHAK-CODHAP-CODHAU
                                         -CODHBA-CODHAC-CODHAH-CODHAM-CODHAR-CODHAW-CODHBE-CODHAE-CODHAJ-CODHAO-CODHAT-CODHAY)) * ART1731BIS
        ) * (1 - V_CNR) ;

REPDOMENTR = REPAB + REPAG + REPAL + REPAQ + REPAV + REPBB + REPAA + REPAF + REPAK + REPAP + REPAU + REPBA 
             + REPAC + REPAH + REPAM + REPHAR + REPAW + REPBE + REPAE + REPAJ + REPAO + REPAT + REPAY + REPBG ;







