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
                                                                         #####
  ####   #    #    ##    #####      #     #####  #####   ######         #     #
 #    #  #    #   #  #   #    #     #       #    #    #  #                    #
 #       ######  #    #  #    #     #       #    #    #  #####           #####
 #       #    #  ######  #####      #       #    #####   #                    #
 #    #  #    #  #    #  #          #       #    #   #   #              #     #
  ####   #    #  #    #  #          #       #    #    #  ###### #######  #####
 #
 #
 #
 #
 #
 #
 #
 #                       CALCUL DE L'IMPOT NET
 #
 #
 #
 #
 #
 #
regle 301:
application : bareme , iliad , batch  ;

IRN = min( 0, IAN + AVFISCOPTER - IRE ) + max( 0, IAN + AVFISCOPTER - IRE ) * positif( IAMD1 + 1 - SEUIL_61) ;


regle 3010:
application : bareme , iliad , batch  ;

IAR = min( 0, IAN + AVFISCOPTER - IRE ) + max( 0, IAN + AVFISCOPTER - IRE ) ;

regle 302:
application : iliad , batch  ;
CREREVET =  min(arr((BPTP3 + BPTPD + BPTPG) * TX16/100),arr(CIIMPPRO * TX_CREREVET/100 ))
	  + min(arr(BPTP19 * TX19/100),arr(CIIMPPRO2 * TX19/100 ));

CIIMPPROTOT = CIIMPPRO + CIIMPPRO2 ;
regle 30202:
application : iliad , batch  ;
ICI8XFH = min(arr(BPTP18 * TX18/100),arr(COD8XF * TX18/100 ))
      + min(arr(BPTP4I * TX30/100),arr(COD8XG * TX30/100 ))
      + min(arr(BPTP40 * TX41/100),arr(COD8XH * TX41/100 ));
ICI8XV  = min(arr(RCM2FA * TX24/100),arr(COD8XV * TX24/100 )) * (1 - positif(null(2 - V_REGCO)+null(4-V_REGCO)));
ICIGLO = min(arr(BPTP18 * TX18/100),arr(COD8XF * TX18/100 ))
      + min(arr(RCM2FA * TX24/100),arr(COD8XV * TX24/100 )) * (1 - positif(null(2 - V_REGCO)+null(4-V_REGCO)))
      + min(arr(BPTP4I * TX30/100),arr(COD8XG * TX30/100 ))
      + min(arr(BPTP40 * TX41/100),arr(COD8XH * TX41/100 ));

CIGLOTOT = COD8XF + COD8XG + COD8XH; 
CI8XV = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET,ICI8XV));
CI8XFH = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET-CI8XV,ICI8XFH));
CIGLO = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET,ICIGLO));
regle 3025:
application : iliad , batch  ;

ICREREVET = max(0,min(IAD11 + ITP - CIRCMAVFT - IRETS - min(IAD11 , CRCFA), min(ITP,CREREVET)));

regle 3026:
application : iliad , batch , bareme ;

INE = (CIRCMAVFT + IRETS + min(max(0,IAD11-CIRCMAVFT-IRETS) , CRCFA) + ICREREVET + CIGLO + CICULTUR + CIGPA + CIDONENTR + CICORSE + CIRECH + CICOMPEMPL)
            * (1-positif(RE168+TAX1649));

IAN = max( 0, (IRB - AVFISCOPTER + ((- CIRCMAVFT
				     - IRETS
                                     - min(max(0,IAD11-CIRCMAVFT-IRETS) , CRCFA) 
                                     - ICREREVET
                                     - CIGLO
                                     - CICULTUR
                                     - CIGPA
                                     - CIDONENTR
                                     - CICORSE
				     - CIRECH 
                                     - CICOMPEMPL)
                                   * (1 - positif(RE168 + TAX1649)))
                  + min(TAXASSUR+0 , max(0,INE-IRB+AVFISCOPTER)) 
                  + min(IPCAPTAXTOT+0 , max(0,INE-IRB+AVFISCOPTER - min(TAXASSUR+0,max(0,INE-IRB+AVFISCOPTER))))
                  + min(TAXLOY+0 ,max(0,INE-IRB+AVFISCOPTER - min(IPCAPTAXTOT+0 , max(0,INE-IRB+AVFISCOPTER - min(TAXASSUR+0,max(0,INE-IRB+AVFISCOPTER))))
										  - min(TAXASSUR+0 , max(0,INE-IRB+AVFISCOPTER))))
	      )
         )
 ;

regle 3021:
application : iliad , batch  ;
IRE = (1- positif(RE168+TAX1649+0)) * (
                      CIDIREPARGNE + EPAV + CRICH + CICORSENOW 
                    + CIGE + CIDEVDUR + CITEC
                    +  IPELUS + CICA + CIGARD + CISYND 
                    + CIPRETUD + CIADCRE + CIHABPRIN + CREFAM 
                    + CREAPP +CREAGRIBIO + CREPROSP + CRESINTER 
                    + CREFORMCHENT + CREINTERESSE + CREARTS + CICONGAGRI 
                    + CRERESTAU + CILOYIMP + AUTOVERSLIB
                    + PPETOTX - PPERSA
                    + CI2CK + CIFORET + CIEXCEDENT
                    + COD8TL * (1 - positif(RE168 + TAX1649))
	                              );
IRE2 = IRE + (BCIGA * (1 - positif(RE168+TAX1649))); 
regle 3022:
application : iliad , batch  ;

CRICH =  IPRECH * (1 - positif(RE168+TAX1649));
regle 30221:
application : iliad , batch  ;
CIRCMAVFT = max(0,min(IRB + TAXASSUR + IPCAPTAXTOT +TAXLOY - AVFISCOPTER , RCMAVFT * (1 - positif(null(2 - V_REGCO)+null(4-V_REGCO)))));
regle 302229:
application : iliad , batch  ;
CIEXCEDENT =  arr((COD3VE * TX45/100) + (COD3UV * TX30/100))* (1 - positif(RE168 + TAX1649));
regle 30222:
application : iliad , batch  ;
CIDIREPARGNE = DIREPARGNE * (1 - positif(RE168 + TAX1649)) * (1 - positif(null(2 - V_REGCO)+null(4-V_REGCO)));
CI2CK = COD2CK * (1 - positif(RE168 + TAX1649)) * (1 - positif(null(2 - V_REGCO)+null(4-V_REGCO)));
regle 30226:
application : batch, iliad;
CICA =  arr(BAILOC98 * TX_BAIL / 100) * (1 - positif(RE168 + TAX1649)) ;
regle 3023:
application : iliad , batch  ;
CRCFA = (arr(IPQ1 * REGCI / (RB018XR + TONEQUO )) * (1 - positif(RE168+TAX1649)));
regle 30231:
application : iliad , batch  ;
IRETS = max(0,min(min(COD8PA,IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT)*present(COD8PA)+(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT)*(1-present(COD8PA)) , (IPSOUR * (1 - positif(RE168+TAX1649))))) ;
regle 3023101:
application : iliad , batch  ;
CRDIE = max(0,min(IRB-REI-AVFISCOPTER-CIRCMAVFT-IRETS,(min(IAD11-CIRCMAVFT-IRETS,CRCFA) * (1 - positif(RE168+TAX1649)))));
CRDIE2 = -CRDIE+0;
regle 3023102:
application : iliad , batch  ;
BCIAQCUL = arr(CIAQCUL * TX_CIAQCUL / 100);
CICULTUR = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-REI-IRETS-CRDIE-ICREREVET-CIGLO,min(IAD11+ITP+TAXASSUR+TAXLOY +IPCAPTAXTOT+CHRAPRES,BCIAQCUL)));
regle 3023103:
application : iliad , batch  ;
BCIGA = CRIGA;
CIGPA = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR,BCIGA));
regle 3023104:
application : iliad , batch  ;
BCIDONENTR = RDMECENAT * (1-V_CNR) ;
CIDONENTR = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-REI-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA,BCIDONENTR));
regle 3023105:
application : iliad , batch  ;
CICORSE = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IPPRICORSE-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA-CIDONENTR,CIINVCORSE+IPREPCORSE));
CICORSEAVIS = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY-AVFISCOPTER-CIRCMAVFT-IPPRICORSE-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA-CIDONENTR,CIINVCORSE+IPREPCORSE))+CICORSENOW;
TOTCORSE = CIINVCORSE + IPREPCORSE + CICORSENOW;
regle 3023106:
application : iliad , batch  ;
CIRECH = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA-CIDONENTR-CICORSE,IPCHER));
regle 30231061:
application : iliad , batch  ;
CICOMPEMPL = max(0,min(IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA-CIDONENTR-CICORSE-CIRECH,COD8UW));

DIEMPLOI = (COD8UW + COD8TL) * (1 - positif(RE168+TAX1649)) ;

CIEMPLOI = (CICOMPEMPL + COD8TL) * (1 - positif(RE168+TAX1649)) ;

IRECR = abs(min(0 ,IRB+TAXASSUR+IPCAPTAXTOT+TAXLOY -AVFISCOPTER-CIRCMAVFT-IRETS-CRDIE-ICREREVET-CIGLO-CICULTUR-CIGPA-CIDONENTR-CICORSE-CIRECH-CICOMPEMPL));
regle 30231051:
application : iliad , batch  ;
REPCORSE = abs(CIINVCORSE+IPREPCORSE-CICORSE) ;
REPRECH = abs(IPCHER - CIRECH) ;
REPCICE = abs(COD8UW - CICOMPEMPL) ;
regle 3023107:
application : iliad , batch  ;
CICONGAGRI = CRECONGAGRI * (1-V_CNR) ;
regle 30231071:
application : iliad , batch  ;
BCICAP = min(IPCAPTAXTOT,arr((PRELIBXT - arr(PRELIBXT * TX10/100))*T_PCAPTAX/100));
BCICAPAVIS = max(0,(PRELIBXT - arr(PRELIBXT * TX10/100)));
CICAP = max(0,min(IRB + TAXASSUR + IPCAPTAXTOT +TAXLOY +CHRAPRES - AVFISCOPTER ,min(IPCAPTAXTOT,BCICAP)));
regle 30231072:
application : iliad , batch  ;
BCICHR = arr(CHRAPRES * (REGCI*(1-present(COD8XY))+COD8XY+0) / (REVKIREHR - TEFFHRC+COD8YJ));
CICHR = max(0,min(IRB + TAXASSUR + IPCAPTAXTOT +TAXLOY +CHRAPRES - AVFISCOPTER-CICAP ,min(CHRAPRES,BCICHR)));
regle 407015:
application : iliad , batch  ;
BCOS = max(0 , min(RDSYVO+0,arr(TX_BASECOTSYN/100*
                                   (TSBV*IND_10V
                                   - BPCOSAV + EXPRV)))) 
       + max(0 , min(RDSYCJ+0,arr(TX_BASECOTSYN/100*
                                   (TSBC*IND_10C
                                   - BPCOSAC + EXPRC)))) 
       + min(RDSYPP+0,arr(TX_BASECOTSYN/100* (somme(i=1..4:TSBi *IND_10i + EXPRi))))  ;

CISYND = arr(TX_REDCOTSYN/100 * BCOS) * (1 - V_CNR) ;

DSYND = RDSYVO + RDSYCJ + RDSYPP ;

ASYND = BCOS * (1-V_CNR) ;

regle 3023108:
application : iliad , batch ;

IAVF = IRE - EPAV + CICORSE + CICULTUR + CIGPA + CIRCMAVFT ;


DIAVF2 = (BCIGA + IPRECH + IPCHER + IPELUS + RCMAVFT + DIREPARGNE + COD3VE + COD3UV) * (1 - positif(RE168+TAX1649)) + CIRCMAVFT * positif(RE168+TAX1649);


IAVF2 = (CIDIREPARGNE + IPRECH + CIRECH + IPELUS + CIRCMAVFT + CIGPA + CIEXCEDENT + 0) * (1 - positif(RE168 + TAX1649))
        + CIRCMAVFT * positif(RE168 + TAX1649) ;

IAVFGP = IAVF2 + CREFAM + CREAPP ;

regle 3023109:
application : iliad , batch ;

I2DH = EPAV ;

regle 30231011:
application : iliad , batch  ;
BTANTGECUM   = (V_BTGECUM * (1 - present(DEPMOBIL)) + DEPMOBIL);
BTANTGECUMWL = (V_BTGECUMWL * (1 - present(COD7WD)) + COD7WD);
P2GE = max( (   PLAF_GE2 * (1 + BOOL_0AM)
             + PLAF_GE2_PACQAR * (V_0CH + V_0DP)
             + PLAF_GE2_PAC * (V_0CR + V_0CF + V_0DJ + V_0DN)  
              ) - BTANTGECUM
             , 0
             ) ;
BGEDECL = RDTECH + RDEQPAHA ;
BGEPAHA = min(RDEQPAHA , P2GE) * (1 - V_CNR);
P2GEWL = max(0,P2GE + PLAF_GE2 * (1 + BOOL_0AM) -  BGEPAHA - BTANTGECUMWL);

BGTECH = min(RDTECH , P2GEWL) * (1 - V_CNR) ;
TOTBGE = BGTECH + BGEPAHA ;
RGEPAHA =  (BGEPAHA * TX25 / 100 ) * (1 - V_CNR) ;
RGTECH = (BGTECH * TX40 / 100 ) * (1 - V_CNR) ;
CIGE = arr (RGTECH + RGEPAHA ) * (1 - positif(RE168 + TAX1649)) * (1 - V_CNR) ;
GECUM = min(P2GE,BGEPAHA + BGTECH)+BTANTGECUM ;
GECUMWL = max(0,BGTECH + BGEPAHA - min(P2GE,BGEPAHA + BGTECH)+BTANTGECUMWL) ;
DAIDC = CREAIDE ;
AAIDC = BADCRE * (1-V_CNR) ;
CIADCRE = arr (BADCRE * TX_AIDOMI /100) * (1 - positif(RE168 + TAX1649)) * (1 - V_CNR) ;
regle 30231012:
application : iliad , batch  ;
DLOYIMP = LOYIMP ;
ALOYIMP = DLOYIMP;
CILOYIMP = arr(ALOYIMP*TX_LOYIMP/100) * (1 - positif(RE168 + TAX1649)) ;
regle 30231014:
application : iliad , batch  ;

DDEVDUR = 
  CIBOIBAIL  + COD7SA  + CINRJBAIL  + COD7SB  + CRENRJ  + COD7SC  + TRAMURWC  
 + COD7WB  + CINRJ  + COD7RG  + TRATOIVG  + COD7VH  + CIDEP15  + COD7RH  
 + MATISOSI  + COD7RI  + TRAVITWT  + COD7WU  + MATISOSJ  + COD7RJ  + VOLISO  
 + COD7RK  + PORENT  + COD7RL  + CHAUBOISN  + COD7RN  + POMPESP  + COD7RP  
 + POMPESR  + COD7RR  + CHAUFSOL  + COD7RS  + POMPESQ  + COD7RQ  + ENERGIEST  
 + COD7RT  + DIAGPERF  + COD7TV  + RESCHAL  + COD7TW  + COD7RV  + COD7RW  + COD7RZ  ;

PDEVDUR = max( (   PLAF_DEVDUR * (1 + BOOL_0AM)
                  + PLAF_GE2_PACQAR * (V_0CH+V_0DP)
	          + PLAF_GE2_PAC * (V_0CR+V_0CF+V_0DJ+V_0DN) 
		 ) - (V_BTDEVDUR*(1-present(DEPCHOBAS))+DEPCHOBAS) , 0 );
BQRESS = positif(CIBOIBAIL + CINRJBAIL + CRENRJ + CINRJ + CIDEP15 + MATISOSI + MATISOSJ + VOLISO + PORENT
                                          + CHAUBOISN + POMPESP + POMPESR + CHAUFSOL + POMPESQ + ENERGIEST + DIAGPERF + RESCHAL
                                          + TRAMURWC + TRATOIVG + TRAVITWT) * 1
        + 0;
BQTRAV = positif((present(TRAVITWT)+present(COD7WU)) * (present(TRAMURWC)+present(COD7WB))
                +(present(TRAVITWT)+present(COD7WU)) * (present(TRATOIVG)+present(COD7VH))
                +(present(TRAVITWT)+present(COD7WU)) * (present(CHAUBOISN)+present(COD7RN))
                +(present(TRAVITWT)+present(COD7WU)) * (present(POMPESR)+present(COD7RR)+present(CHAUFSOL)+present(COD7RS))
                +(present(TRAVITWT)+present(COD7WU)) * (present(CIBOIBAIL)+present(COD7SA)+present(CINRJBAIL)+present(COD7SB)
                                                       +present(POMPESP)+present(COD7RP)+present(POMPESQ)+present(COD7RQ)
                                                       +present(ENERGIEST)+present(COD7RT))
                +(present(TRAMURWC)+present(COD7WB)) * (present(TRATOIVG)+present(COD7VH))
                +(present(TRAMURWC)+present(COD7WB)) * (present(CHAUBOISN)+present(COD7RN))
                +(present(TRAMURWC)+present(COD7WB)) * (present(POMPESR)+present(COD7RR)+present(CHAUFSOL)+present(COD7RS))
                +(present(TRAMURWC)+present(COD7WB)) * (present(CIBOIBAIL)+present(COD7SA)+present(CINRJBAIL)+present(COD7SB)
                                                       +present(POMPESP)+present(COD7RP)+present(POMPESQ)+present(COD7RQ)
                                                       +present(ENERGIEST)+present(COD7RT))
                +(present(TRATOIVG)+present(COD7VH)) * (present(CHAUBOISN)+present(COD7RN))
                +(present(TRATOIVG)+present(COD7VH)) * (present(CHAUBOISN)+present(COD7RN))
                +(present(TRATOIVG)+present(COD7VH)) * (present(POMPESR)+present(COD7RR)+present(CHAUFSOL)+present(COD7RS))
                +(present(TRATOIVG)+present(COD7VH)) * (present(CIBOIBAIL)+present(COD7SA)+present(CINRJBAIL)+present(COD7SB)
                                                       +present(POMPESP)+present(COD7RP)+present(POMPESQ)+present(COD7RQ)
                                                       +present(ENERGIEST)+present(COD7RT))
                +(present(CHAUBOISN)+present(COD7RN)) * (present(POMPESR)+present(COD7RR)+present(CHAUFSOL)+present(COD7RS))
                +(present(CHAUBOISN)+present(COD7RN)) * (present(CIBOIBAIL)+present(COD7SA)+present(CINRJBAIL)+present(COD7SB)
                                                       +present(POMPESP)+present(COD7RP)+present(POMPESQ)+present(COD7RQ)
                                                       +present(ENERGIEST)+present(COD7RT))
                +(present(POMPESR)+present(COD7RR)+present(CHAUFSOL)+present(COD7RS)) * (present(CIBOIBAIL)+present(COD7SA)+present(CINRJBAIL)+present(COD7SB)
                                                       +present(POMPESP)+present(COD7RP)+present(POMPESQ)+present(COD7RQ)
                                                       +present(ENERGIEST)+present(COD7RT))
                ) + 0;


PLAF1M = null(1-V_REGCO) * arr(  24043 
                                + 2808.5 * min( (NBPT - 1) * 4 , 2 ) * positif( NBPT -1 )
                                + 2210.5 * ( (NBPT - 1.5) * 4 ) * positif( NBPT - 1.5 )
                              );

PLAF1MGR = null(5-V_REGCO) * arr( 29058  
                                + 3082 * min( (NBPT - 1) * 4 , 2 ) * positif( NBPT -1 )
                                + 2938.5  * min( (NBPT - 1.5) * 4 , 2 ) * positif( NBPT - 1.5 )
                                + 2210.5  *  ( (NBPT - 2) * 4 ) * positif( NBPT - 2 )
                                );

PLAF1GM = positif(null(6-V_REGCO)+null(7-V_REGCO)) * arr( 31843  
                                                        + 3082 * min( (NBPT - 1) * 4 , 4 ) * positif( NBPT -1 )
                                                        + 2624.5  * min( (NBPT - 2) * 4 , 2 ) * positif( NBPT - 2 )
                                                        + 2210.5  *  ( (NBPT - 2.5) * 4 ) * positif( NBPT - 2.5 )
                                                        );


PLAF2M = null(1-V_REGCO) * arr(  25005 
                               + 2921 * min( (NBPT - 1) * 4 , 2 ) * positif( NBPT -1 )
                               + 2299 * ( (NBPT - 1.5) * 4 ) * positif( NBPT - 1.5 )
                              );


PLAF2MGR = null(5-V_REGCO) * arr( 30220  
                                + 3205.5 * min( (NBPT - 1) * 4 , 2 ) * positif( NBPT -1 )
                                + 3056  * min( (NBPT - 1.5) * 4 , 2 ) * positif( NBPT - 1.5 )
                                + 2299  *  ( (NBPT - 2) * 4 ) * positif( NBPT - 2 )
                                );


PLAF2GM = positif(null(6-V_REGCO)+null(7-V_REGCO)) * arr( 33117  
                                                        + 3205.5 * min( (NBPT - 1) * 4 , 4 ) * positif( NBPT -1 )
                                                        + 2729.5  * min( (NBPT - 2) * 4 , 2 ) * positif( NBPT - 2 )
                                                        + 2299  *  ( (NBPT - 2.5) * 4 ) * positif( NBPT - 2.5 )
                                                        );


PLAF1 = PLAF1M + PLAF1MGR + PLAF1GM;
PLAF2 = PLAF2M + PLAF2MGR + PLAF2GM;

RESS = positif(positif_ou_nul(PLAF1 - ((V_BTRFRN2+0)*(1-present(RFRN2))+RFRN2)) 
                + (1-positif_ou_nul(PLAF1 - ((V_BTRFRN2+0)*(1-present(RFRN2))+RFRN2))) * 
                                      positif_ou_nul(PLAF2 - ((V_BTRFRN1+0)*(1-present(RFRN1))+RFRN1))+present(COD7WX));

BDEV30 =  min(PDEVDUR,COD7SA  + COD7SB  + COD7SC  + COD7WB  + COD7RG  + COD7VH  + COD7RH  + COD7RI
                    + COD7WU  + COD7RJ  + COD7RK  + COD7RL  + COD7RN  + COD7RP  + COD7RR  + COD7RS
                    + COD7RQ  + COD7RT  + COD7TV  + COD7TW  + COD7RV  + COD7RW  + COD7RZ)
              * positif(positif(BQRESS)*positif(BQTRAV)
                       +positif(BQRESS)*null(BQTRAV)*null(RESS)
                       +positif(BQRESS)*null(BQTRAV)*positif(RESS)
                       +positif(BQRESS)*null(BQTRAV)*positif(RESS)*present(CRECHOBOI)
                       +null(BQRESS))
                  ;

BDEV25 =  min(max(0,PDEVDUR-BDEV30),CIBOIBAIL  + CINRJBAIL  + TRAMURWC  + TRATOIVG  + TRAVITWT
                                  + CHAUBOISN  + POMPESP  + POMPESR  + CHAUFSOL  + POMPESQ  + ENERGIEST)
              * positif(positif(BQRESS)*positif(BQTRAV));

BDEV15 =  min(max(0,PDEVDUR-BDEV30-BDEV25),CRENRJ  + CINRJ  + CIDEP15  + MATISOSI  + MATISOSJ
                                         + VOLISO  + PORENT  + DIAGPERF  + RESCHAL)
              * positif(positif(BQRESS)*positif(BQTRAV))

        + min(max(0,PDEVDUR-BDEV30),( CIBOIBAIL  + CINRJBAIL  + CRENRJ  + TRAMURWC  + CINRJ  + TRATOIVG  + CIDEP15  + MATISOSI  + TRAVITWT
                                    + MATISOSJ  + VOLISO  + PORENT  + CHAUBOISN  + POMPESP  + POMPESR  + CHAUFSOL  + POMPESQ  + ENERGIEST
                                    + DIAGPERF  + RESCHAL) * (1-present(COD7WX)) + present(COD7WX) * COD7WX) 
              *positif(positif(BQRESS)*null(BQTRAV)*positif(RESS)*(1-present(CRECHOBOI)))

        + min(max(0,PDEVDUR-BDEV30),(CIBOIBAIL  + CINRJBAIL  + CRENRJ  + TRAMURWC  + CINRJ  + TRATOIVG  + CIDEP15
                                   + MATISOSI  + CHAUBOISN  + POMPESP  + POMPESR  + CHAUFSOL  + POMPESQ  + ENERGIEST  
                                   + DIAGPERF  + RESCHAL)* (1-present(COD7WX)) + present(COD7WX) * COD7WX)
              * positif(positif(BQRESS)*null(BQTRAV)*positif(RESS)*present(CRECHOBOI))
          ;

ADEVDUR = BDEV30 + BDEV25 + BDEV15; 

CIDEVDUR = arr( BDEV30 * TX30/100
               +BDEV25 * TX25/100
               +BDEV15 * TX15/100
      	      )  * (1 - positif(RE168 + TAX1649)) * (1 - V_CNR) ;

DEVDURCUM = ADEVDUR + (V_BTDEVDUR*(1-present(DEPCHOBAS))+DEPCHOBAS);
regle 30231015:
application : iliad , batch  ;
DTEC = RISKTEC;
ATEC = positif(DTEC) * DTEC;
CITEC = arr (ATEC * TX40/100);
regle 30231016:
application : iliad , batch  ;
DPRETUD = PRETUD + PRETUDANT ;
APRETUD = max(min(PRETUD,LIM_PRETUD) + min(PRETUDANT,LIM_PRETUD*CASEPRETUD),0) * (1-V_CNR) ;

CIPRETUD = arr(APRETUD*TX_PRETUD/100) * (1 - positif(RE168 + TAX1649)) * (1-V_CNR) ;
regle 30231017:
application : iliad , batch  ;

EM7 = somme (i=0..7: min (1 , max(0 , V_0Fi + AG_LIMFG - V_ANREV)))
      + (1 - positif(somme(i=0..7:V_0Fi) + 0)) * V_0CF ;

EM7QAR = somme (i=0..5: min (1 , max(0 , V_0Hi + AG_LIMFG - V_ANREV)))
         + somme (j=0..3: min (1 , max(0 , V_0Pj + AG_LIMFG - V_ANREV)))
         + (1 - positif(somme(i=0..5: V_0Hi) + somme(j=0..3: V_0Pj) + 0)) * (V_0CH + V_0DP) ;

BRFG = min(RDGARD1,PLAF_REDGARD) + min(RDGARD2,PLAF_REDGARD)
       + min(RDGARD3,PLAF_REDGARD) + min(RDGARD4,PLAF_REDGARD)
       + min(RDGARD1QAR,PLAF_REDGARDQAR) + min(RDGARD2QAR,PLAF_REDGARDQAR)
       + min(RDGARD3QAR,PLAF_REDGARDQAR) + min(RDGARD4QAR,PLAF_REDGARDQAR)
       ;
RFG = arr ( (BRFG) * TX_REDGARD /100 ) * (1 -V_CNR);
DGARD = somme(i=1..4:RDGARDi)+somme(i=1..4:RDGARDiQAR);
AGARD = (BRFG) * (1-V_CNR) ;
CIGARD = RFG * (1 - positif(RE168 + TAX1649)) ;
regle 30231018:
application : iliad , batch  ;

PREHAB = PREHABT + PREHABTN + PREHABTN1 + PREHABT1 + PREHABT2 + PREHABTN2 + PREHABTVT ;

BCIHP = max(( PLAFHABPRIN * (1 + BOOL_0AM) * (1+positif(V_0AP+V_0AF+V_0CG+V_0CI+V_0CR))
                 + (PLAFHABPRINENF/2) * (V_0CH + V_0DP)
                 + PLAFHABPRINENF * (V_0CR + V_0CF + V_0DJ + V_0DN)
                  )
             ,0);

BCIHABPRIN1 = min(BCIHP , PREHABT) * (1 - V_CNR) ;
BCIHABPRIN2 = min(max(0,BCIHP-BCIHABPRIN1),PREHABT1) * (1 - V_CNR);
BCIHABPRIN3 = min(max(0,BCIHP-BCIHABPRIN1-BCIHABPRIN2),PREHABTN) * (1 - V_CNR);
BCIHABPRIN4 = min(max(0,BCIHP-BCIHABPRIN1-BCIHABPRIN2-BCIHABPRIN3),PREHABTN1) * (1 - V_CNR);
BCIHABPRIN5 = min(max(0,BCIHP-BCIHABPRIN1-BCIHABPRIN2-BCIHABPRIN3-BCIHABPRIN4),PREHABT2) * (1 - V_CNR);
BCIHABPRIN6 = min(max(0,BCIHP-BCIHABPRIN1-BCIHABPRIN2-BCIHABPRIN3-BCIHABPRIN4-BCIHABPRIN5),PREHABTN2) * (1 - V_CNR);
BCIHABPRIN7 = min(max(0,BCIHP-BCIHABPRIN1-BCIHABPRIN2-BCIHABPRIN3-BCIHABPRIN4-BCIHABPRIN5-BCIHABPRIN6),PREHABTVT) * (1 - V_CNR);

BCIHABPRIN = BCIHABPRIN1 + BCIHABPRIN2 + BCIHABPRIN3 + BCIHABPRIN4 + BCIHABPRIN5 + BCIHABPRIN6 + BCIHABPRIN7 ;

CIHABPRIN = arr((BCIHABPRIN1 * TX40/100)
                + (BCIHABPRIN2 * TX40/100)
                + (BCIHABPRIN3 * TX30/100)
                + (BCIHABPRIN4 * TX25/100)
                + (BCIHABPRIN5 * TX20/100)
                + (BCIHABPRIN6 * TX15/100)
                + (BCIHABPRIN7 * TX10/100))
                * (1 - positif(RE168 + TAX1649)) * (1 - V_CNR);
regle 30231020:
application : iliad , batch  ;

BDCIFORET  = RDFORESTRA + SINISFORET + COD7UA + COD7UB + RDFORESTGES + COD7UI;
BCIFORETUA = max(0,min(COD7UA,max(0,PLAF_FOREST1 * (1 + BOOL_0AM)))) * (1-V_CNR);
BCIFORETUB = max(0,min(COD7UB,max(0,PLAF_FOREST1 * (1 + BOOL_0AM)-BCIFORETUA))) * (1-V_CNR);
BCIFORETUP = max(0,min(RDFORESTRA,PLAF_FOREST1 * (1 + BOOL_0AM)-BCIFORETUA-BCIFORETUB)) * (1-V_CNR);
BCIFORETUT = max(0,min(SINISFORET,max(0,PLAF_FOREST1 * (1 + BOOL_0AM)-BCIFORETUA-BCIFORETUB-BCIFORETUP))) * (1-V_CNR);
BCIFORETUI = max(0,min(COD7UI,max(0,PLAF_FOREST2 * (1 + BOOL_0AM))))  * (1-V_CNR);
BCIFORETUQ = max(0,min(RDFORESTGES, PLAF_FOREST2 * (1 + BOOL_0AM)-BCIFORETUI)) * (1-V_CNR);
BCIFORET  = BCIFORETUP+BCIFORETUT+BCIFORETUA+BCIFORETUB+BCIFORETUQ+BCIFORETUI;
CIFORET = arr(BCIFORETUP * TX18/100 + BCIFORETUT * TX18/100 + BCIFORETUA * TX25/100 + BCIFORETUB * TX25/100
             + BCIFORETUQ * TX18/100 + BCIFORETUI * TX25/100); 
regle 30231025:
application : iliad , batch  ;

REPCIFAD = max(0,COD7UA - PLAF_FOREST1 * (1+ BOOL_0AM)) * (1-V_CNR);
REPCIFADSIN = (positif_ou_nul(COD7UA - PLAF_FOREST1 * (1+ BOOL_0AM)) * COD7UB
            + (1-positif_ou_nul(COD7UA - PLAF_FOREST1 * (1+ BOOL_0AM))) * max(0,COD7UB - (PLAF_FOREST1 * (1+ BOOL_0AM) - COD7UA))) * (1-V_CNR);
REPCIF = (positif_ou_nul(COD7UA + COD7UB - PLAF_FOREST1 * (1+ BOOL_0AM)) * RDFORESTRA
            + (1-positif_ou_nul(COD7UA + COD7UB- PLAF_FOREST1 * (1+ BOOL_0AM))) * max(0,RDFORESTRA - (PLAF_FOREST1 * (1+ BOOL_0AM) - COD7UA-COD7UB))) * (1-V_CNR);

REPCIFSIN = (positif_ou_nul(COD7UA + COD7UB + RDFORESTRA - PLAF_FOREST1 * (1+ BOOL_0AM)) * SINISFORET
            + (1-positif_ou_nul(COD7UA + COD7UB+ RDFORESTRA- PLAF_FOREST1 * (1+ BOOL_0AM))) * max(0,SINISFORET - (PLAF_FOREST1 * (1+ BOOL_0AM) - COD7UA-COD7UB-RDFORESTRA))) * (1-V_CNR);
 
regle 302311:
application : iliad , batch ;
CICSG = min( CSGC , arr( IPPNCS * T_CSG/100 ));
CICSGAPS = min( CSGCAPS , arr( IPPNCS * T_CSG/100 ));
CIRDS = min( RDSC , arr( (IPPNCS+REVCSXA+REVCSXB+REVCSXC+REVCSXD+REVCSXE+COD8XI+COD8XJ) * T_RDS/100 ));
CIRDSAPS = min( RDSCAPS , arr( (IPPNCS+REVCSXA+REVCSXB+REVCSXC+REVCSXD+REVCSXE) * T_RDS/100 ));
CIPRS = min( PRSC , arr( IPPNCS * T_PREL_SOC/100 ));
CIPRSAPS = min( PRSCAPS , arr( IPPNCS * T_PREL_SOC/100 ));

CIRSE1 = min( RSE1 , arr( REVCSXA * TX075/100 ));

RSE8TV = arr(BRSE8TV * TXTV/100) * (1 - positif(ANNUL2042));
RSE8SA = arr(BRSE8SA * TXTV/100) * (1 - positif(ANNUL2042));
CIRSE8TV = min( RSE8TV , arr( REVCSXC * TX066/100 )) ;
CIRSE8SA = min( RSE8SA , arr(COD8XI * TX066/100 )) ;
CIRSE2 = CIRSE8TV + CIRSE8SA ; 

CIRSE3 = min( RSE3 , arr( REVCSXD * TX062/100 ));

RSE8TX = arr(BRSE8TX * TXTX/100) * (1 - positif(ANNUL2042));
RSE8SB = arr(BRSE8SB * TXTX/100) * (1 - positif(ANNUL2042));
CIRSE8TX = min( RSE8TX , arr( REVCSXE * TX038/100 )) ;
CIRSE8SB = min( RSE8SB , arr( COD8XJ * TX038/100 ));
CIRSE4 = CIRSE8TX + CIRSE8SB ;

CIRSE5 = min( RSE5 , arr( REVCSXB * TX075/100 ));

CIRSETOT = CIRSE1 + CIRSE2 + CIRSE3 + CIRSE4 + CIRSE5;



regle 30400:
application : iliad , batch  ;
PPE_DATE_DEB = positif(V_0AV+0) * positif(V_0AZ+0) * (V_0AZ+0)
              + positif(DATRETETR+0) * (DATRETETR+0) * null(V_0AZ+0) ;

PPE_DATE_FIN = positif(BOOL_0AM) * positif(V_0AZ+0) * (V_0AZ+0)
              + positif(DATDEPETR+0) * (DATDEPETR+0) * null(V_0AZ+0) ;
regle 30500:
application : iliad , batch  ;
PPE_DEBJJMMMM =  PPE_DATE_DEB + (01010000+V_ANREV) * null(PPE_DATE_DEB+0);
PPE_DEBJJMM = arr( (PPE_DEBJJMMMM - V_ANREV)/10000);
PPE_DEBJJ =  inf(PPE_DEBJJMM/100);
PPE_DEBMM =  PPE_DEBJJMM -  (PPE_DEBJJ*100);
PPE_DEBRANG= PPE_DEBJJ 
             + (PPE_DEBMM - 1 ) * 30;
regle 30501:
application : iliad , batch  ;
PPE_FINJJMMMM =  PPE_DATE_FIN + (30120000+V_ANREV) * null(PPE_DATE_FIN+0);
PPE_FINJJMM = arr( (PPE_FINJJMMMM - V_ANREV)/10000);
PPE_FINJJ =  inf(PPE_FINJJMM/100);
PPE_FINMM =  PPE_FINJJMM -  (PPE_FINJJ*100);
PPE_FINRANG= PPE_FINJJ 
             + (PPE_FINMM - 1 ) * 30
             - 1 * positif (PPE_DATE_FIN);
regle 30503:
application : iliad , batch  ;
PPE_DEBUT = PPE_DEBRANG ;
PPE_FIN   = PPE_FINRANG ;
PPENBJ = max(1, arr(min(PPENBJAN , PPE_FIN - PPE_DEBUT + 1))) ;
regle 30508:
application : iliad , batch  ;
PPETX1 = PPE_TX1 ;
PPETX2 = PPE_TX2 ;
PPETX3 = PPE_TX3 ;
regle 30510:
application : iliad , batch  ;
PPE_BOOL_ACT_COND = positif(


   positif ( TSHALLOV ) 
 + positif ( TSHALLOC ) 
 + positif ( TSHALLO1 ) 
 + positif ( TSHALLO2 ) 
 + positif ( TSHALLO3 ) 
 + positif ( TSHALLO4 ) 
 + positif ( GLD1V ) 
 + positif ( GLD2V ) 
 + positif ( GLD3V ) 
 + positif ( GLD1C ) 
 + positif ( GLD2C ) 
 + positif ( GLD3C ) 
 + positif ( BPCOSAV ) 
 + positif ( BPCOSAC ) 
 + positif ( TSASSUV ) 
 + positif ( TSASSUC ) 
 + positif( CARTSV ) * positif( CARTSNBAV )
 + positif( CARTSC ) * positif( CARTSNBAC )
 + positif( CARTSP1 ) * positif( CARTSNBAP1 )
 + positif( CARTSP2 ) * positif( CARTSNBAP2 )
 + positif( CARTSP3 ) * positif( CARTSNBAP3 )
 + positif( CARTSP4 ) * positif( CARTSNBAP4 )
 + positif ( FEXV ) 
 + positif ( BAFV ) 
 + positif ( BAFPVV ) 
 + positif ( BAEXV ) 
 + positif ( BACREV ) + positif ( 4BACREV )
 + positif  (BACDEV * (1 - positif(ART1731BIS)) ) 
 + positif ( BAHEXV ) 
 + positif ( BAHREV ) + positif ( 4BAHREV )
 + positif ( BAHDEV * (1 - positif(ART1731BIS) )) 
 + positif ( MIBEXV ) 
 + positif ( MIBVENV ) 
 + positif ( MIBPRESV ) 
 + positif ( MIBPVV ) 
 + positif ( BICEXV ) 
 + positif ( BICNOV ) 
 + positif ( BICDNV * (1 - positif(ART1731BIS) ) ) 
 + positif ( BIHEXV ) 
 + positif ( BIHNOV ) 
 + positif ( BIHDNV * (1 - positif(ART1731BIS) )) 
 + positif ( FEXC ) 
 + positif ( BAFC ) 
 + positif ( BAFPVC ) 
 + positif ( BAEXC ) 
 + positif ( BACREC ) + positif ( 4BACREC )
 + positif (BACDEC * (1 - positif(ART1731BIS) ) ) 
 + positif ( BAHEXC ) 
 + positif ( BAHREC ) + positif ( 4BAHREC )
 + positif ( BAHDEC * (1 - positif(ART1731BIS) ) )  
 + positif ( MIBEXC ) 
 + positif ( MIBVENC ) 
 + positif ( MIBPRESC ) 
 + positif ( MIBPVC ) 
 + positif ( BICEXC ) 
 + positif ( BICNOC ) 
 + positif ( BICDNC * (1 - positif(ART1731BIS) ) ) 
 + positif ( BIHEXC ) 
 + positif ( BIHNOC ) 
 + positif ( BIHDNC * (1 - positif(ART1731BIS) ))  
 + positif ( FEXP ) 
 + positif ( BAFP ) 
 + positif ( BAFPVP ) 
 + positif ( BAEXP ) 
 + positif ( BACREP ) + positif ( 4BACREP )
 + positif  (BACDEP * (1 - positif(ART1731BIS))) 
 + positif ( BAHEXP ) 
 + positif ( BAHREP ) + positif ( 4BAHREP )
 + positif ( BAHDEP * (1 - positif(ART1731BIS) )) 
 + positif ( MIBEXP ) 
 + positif ( MIBVENP ) 
 + positif ( MIBPRESP ) 
 + positif ( BICEXP ) 
 + positif ( MIBPVP ) 
 + positif ( BICNOP ) 
 + positif ( BICDNP * (1 - positif(ART1731BIS) )) 
 + positif ( BIHEXP ) 
 + positif ( BIHNOP ) 
 + positif ( BIHDNP * (1 - positif(ART1731BIS) ) )
 + positif ( BNCPROEXV ) 
 + positif ( BNCPROV ) 
 + positif ( BNCPROPVV ) 
 + positif ( BNCEXV ) 
 + positif ( BNCREV ) 
 + positif ( BNCDEV * (1 - positif(ART1731BIS) )) 
 + positif ( BNHEXV ) 
 + positif ( BNHREV ) 
 + positif ( BNHDEV * (1 - positif(ART1731BIS) ) ) 
 + positif ( BNCCRV ) 
 + positif ( BNCPROEXC ) 
 + positif ( BNCPROC ) 
 + positif ( BNCPROPVC ) 
 + positif ( BNCEXC ) 
 + positif ( BNCREC ) 
 + positif ( BNCDEC * (1 - positif(ART1731BIS) )) 
 + positif ( BNHEXC ) 
 + positif ( BNHREC ) 
 + positif ( BNHDEC * (1 - positif(ART1731BIS))) 
 + positif ( BNCCRC ) 
 + positif ( BNCPROEXP ) 
 + positif ( BNCPROP ) 
 + positif ( BNCPROPVP ) 
 + positif ( BNCEXP ) 
 + positif ( BNCREP ) 
 + positif ( BNCDEP * (1 - positif(ART1731BIS) )) 
 + positif ( BNHEXP ) 
 + positif ( BNHREP ) 
 + positif ( BNHDEP * (1 - positif(ART1731BIS) ) )
 + positif ( BNCCRP ) 
 + positif ( BIPERPV )
 + positif ( BIPERPC )
 + positif ( BIPERPP )
 + positif ( BAFORESTV )
 + positif ( BAFORESTC )
 + positif ( BAFORESTP )
 + positif ( AUTOBICVV ) + positif ( AUTOBICPV ) + positif ( AUTOBNCV ) 
 + positif ( AUTOBICVC ) + positif ( AUTOBICPC ) + positif ( AUTOBNCC )
 + positif ( AUTOBICVP ) + positif ( AUTOBICPP ) + positif ( AUTOBNCP )
 + positif ( LOCPROCGAV ) + positif ( LOCPROV ) + positif ( LOCDEFPROCGAV * (1 - positif(ART1731BIS) ))
 + positif ( LOCDEFPROV * (1 - positif(ART1731BIS) )) + positif ( LOCPROCGAC ) + positif ( LOCPROC )
 + positif ( LOCDEFPROCGAC * (1 - positif(ART1731BIS) )) 
 + positif ( LOCDEFPROC * (1 - positif(ART1731BIS) )) 
 + positif ( LOCPROCGAP ) 
 + positif ( LOCPROP ) 
 + positif ( LOCDEFPROCGAP * (1 - positif(ART1731BIS) )) 
 + positif ( LOCDEFPROP * (1 - positif(ART1731BIS) ))
 + positif ( XHONOAAV ) + positif ( XHONOAAC ) + positif ( XHONOAAP )
 + positif ( XHONOV ) + positif ( XHONOC ) + positif ( XHONOP )
 + positif ( GLDGRATV ) + positif ( GLDGRATC )
 + positif ( CODDAJ ) + positif ( CODEAJ ) + positif ( CODDBJ ) + positif ( CODEBJ )
 + positif ( SALEXTV ) + positif ( SALEXTC ) 
 + positif ( SALEXT1 ) + positif ( SALEXT2 ) + positif ( SALEXT3 ) + positif ( SALEXT4 )
);
regle 30520:
application : iliad , batch  ;
PPE_BOOL_SIFC 	= (1 - BOOL_0AM)*(1 - positif (V_0AV)*positif(V_0AZ)) ;


PPE_BOOL_SIFM	= BOOL_0AM  + positif (V_0AV)*positif(V_0AZ) ;

PPESEUILKIR   = PPE_BOOL_SIFC * PPELIMC  
                + PPE_BOOL_SIFM * PPELIMM
                + (NBPT - 1 - PPE_BOOL_SIFM - NBQAR) * 2 * PPELIMPAC
                + NBQAR * PPELIMPAC * 2 ;


PPE_KIRE =  REVKIRE * PPENBJAN / PPENBJ;

PPE_BOOL_KIR_COND =   (1 - null (IND_TDR)) * positif_ou_nul ( PPESEUILKIR - PPE_KIRE);

regle 30525:
application : iliad , batch  ;

PPE_BOOL_NADAV = min(1 , positif(TSHALLOV + 0) * null(PPETPV + 0) * null(PPENHV + 0)
                         + positif(SALEXTV + 0) * null(PPETPV + 0) * null(PPEXTV + 0)) ;

PPE_BOOL_NADAC = min(1 , positif(TSHALLOC + 0) * null(PPETPC + 0) * null(PPENHC + 0)
                         + positif(SALEXTC + 0) * null(PPETPC + 0) * null(PPEXTC + 0)) ;

PPE_BOOL_NADA1 = min(1 , positif(TSHALLO1 + 0) * null(PPETPP1 + 0) * null(PPENHP1 + 0)
                         + positif(SALEXT1 + 0) * null(PPETPP1 + 0) * null(PPEXT1 + 0)) ;

PPE_BOOL_NADA2 = min(1 , positif(TSHALLO2 + 0) * null(PPETPP2 + 0) * null(PPENHP2 + 0)
                         + positif(SALEXT2 + 0) * null(PPETPP2 + 0) * null(PPEXT2 + 0)) ;

PPE_BOOL_NADA3 = min(1 , positif(TSHALLO3 + 0) * null(PPETPP3 + 0) * null(PPENHP3 + 0)
                         + positif(SALEXT3 + 0) * null(PPETPP3 + 0) * null(PPEXT3 + 0)) ;

PPE_BOOL_NADA4 = min(1 , positif(TSHALLO4 + 0) * null(PPETPP4 + 0) * null(PPENHP4 + 0)
                         + positif(SALEXT4 + 0) * null(PPETPP4 + 0) * null(PPEXT4 + 0)) ;

PPE_BOOL_NADAU = min(1 , positif(TSHALLO1 + TSHALLO2 + TSHALLO3 + TSHALLO4 + 0)
                           * null(PPETPP1 + PPETPP2 + PPETPP3 + PPETPP4 + 0) 
                           * null(PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + 0)
                         + positif(SALEXT1 + SALEXT2 + SALEXT3 + SALEXT4 + 0)
                           * null(PPETPP1 + PPETPP2 + PPETPP3 + PPETPP4 + 0)
                           * null(PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4 + 0)) ;

pour i=V,C:
PPENEXOi = null(PPETPi + 0) + positif(TSHALLOi + 0) + positif(SALEXTi + 0) + (4 * positif(PPENHi + 0)) + (8 * positif(PPEXTi + 0)) ; 

pour i=1..4:
PPENEXOi = null(PPETPPi + 0) + positif(TSHALLOi + 0) + positif(SALEXTi + 0) + (4 * positif(PPENHPi + 0)) + (8 * positif(PPEXTi + 0)) ; 

regle 30530:
application : iliad , batch  ;


PPE_SALAVDEFV = TSHALLOV + BPCOSAV + GLD1V + GLD2V + GLD3V  
                + TSASSUV + CARTSV * positif(CARTSNBAV)
                + CODDAJ + CODEAJ + SALEXTV 
                + GLDGRATV ;

PPE_SALAVDEFC = TSHALLOC + BPCOSAC + GLD1C + GLD2C + GLD3C  
                + TSASSUC + CARTSC * positif(CARTSNBAC)
                + CODDBJ + CODEBJ + SALEXTC
                + GLDGRATC ;

PPE_SALAVDEF1 = TSHALLO1 + CARTSP1 * positif(CARTSNBAP1) + SALEXT1 ;
PPE_SALAVDEF2 = TSHALLO2 + CARTSP2 * positif(CARTSNBAP2) + SALEXT2 ;
PPE_SALAVDEF3 = TSHALLO3 + CARTSP3 * positif(CARTSNBAP3) + SALEXT3 ; 
PPE_SALAVDEF4 = TSHALLO4 + CARTSP4 * positif(CARTSNBAP4) + SALEXT4 ;

regle 30540:
application : iliad , batch  ;
pour i = V,C,P:
PPE_RPRO1i =   
(
   FEXi  
 + BAFi  
 + BAEXi  
 + BACREi + 4BACREi
 - (BACDEi * (1 - positif(ART1731BIS) )) 
 + BAHEXi  
 + BAHREi + 4BAHREi 
 - (BAHDEi * (1 - positif(ART1731BIS) ))
 + BICEXi  
 + BICNOi  
 - (BICDNi * (1 - positif(ART1731BIS) )) 
 + BIHEXi  
 + BIHNOi  
 - (BIHDNi * (1 - positif(ART1731BIS) )) 
 + BNCEXi  
 + BNCREi  
 - (BNCDEi * (1 - positif(ART1731BIS) ))
 + BNHEXi  
 + BNHREi  
 - (BNHDEi * (1 - positif(ART1731BIS) ))
 + MIBEXi  
 + BNCPROEXi  
 + TMIB_NETVi  
 + TMIB_NETPi
 + TSPENETPi  
 + BAFPVi  
 + MIBPVi  
 + BNCPROPVi  
 + BAFORESTi
 + LOCPROi + LOCPROCGAi - (LOCDEFPROCGAi * (1 - positif(ART1731BIS) ))
	   - (LOCDEFPROi * (1 - positif(ART1731BIS) ))
 + XHONOAAi + XHONOi

) ;

pour i = V,C,P:
PPE_AVRPRO1i = present(FEXi) + present(BAFi) + present(BAEXi) + present(BACREi) + present(4BACREi) 
               + present(BACDEi) + present(BAHEXi) + present(BAHREi) + present(4BAHREi) + present(BAHDEi) 
               + present(BICEXi) + present(BICNOi) + present(BICDNi) + present(BIHEXi) + present(BIHNOi) 
               + present(BIHDNi) + present(BNCEXi) + present(BNCREi) + present(BNCDEi) + present(BNHEXi) 
               + present(BNHREi) + present(BNHDEi) + present(MIBEXi) + present(BNCPROEXi) + present(MIBVENi) 
               + present(MIBPRESi) + present(BNCPROi) + present(BAFPVi) + present(MIBPVi) + present(BNCPROPVi) 
               + present(BAFORESTi) + present(AUTOBICVi) + present(AUTOBICPi) + present(AUTOBNCi) + present(LOCPROi) 
               + present(LOCPROCGAi) + present(LOCDEFPROCGAi) + present(LOCDEFPROi) + present(XHONOAAi) + present(XHONOi) ;

pour i=V,C,P:
PPE_RPROi = positif(PPE_RPRO1i) * arr((1+ PPETXRPRO/100) * PPE_RPRO1i )
           +(1-positif(PPE_RPRO1i)) * arr(PPE_RPRO1i * (1- PPETXRPRO/100));

pour i=V,C:
PPEPEXOi = positif(PPE_AVRPRO1i + 0) + positif(SALEXTi + 0) + (4 * positif(PPENJi + PPEACi + 0)) + (8 * positif(PPEXTi + PPETPi + 0)) ; 

pour i=1..4:
PPEPEXOi = positif(PPE_AVRPRO1P + 0) + positif(SALEXTi + 0) + (4 * positif(PPEXTi + PPETPPi + 0)) ; 

regle 30550:
application : iliad , batch  ;


PPE_BOOL_SEULPAC = null(V_0CF + V_0CR + V_0DJ + V_0DN + V_0CH + V_0DP -1);

PPE_SALAVDEFU = (somme(i=1,2,3,4: PPE_SALAVDEFi))* PPE_BOOL_SEULPAC;
PPE_KIKEKU = 1 * positif(PPE_SALAVDEF1 )
           + 2 * positif(PPE_SALAVDEF2 )
           + 3 * positif(PPE_SALAVDEF3 )
           + 4 * positif(PPE_SALAVDEF4 );


pour i=V,C:
PPESALi = PPE_SALAVDEFi + PPE_RPROi*(1 - positif(PPE_RPROi)) ;
 
PPESALU = (PPE_SALAVDEFU + PPE_RPROP*(1 - positif(PPE_RPROP)))
          * PPE_BOOL_SEULPAC;


pour i = 1..4:
PPESALi =  PPE_SALAVDEFi * (1 - PPE_BOOL_SEULPAC) ;

regle 30560:
application : iliad , batch  ;

pour i=V,C:
PPE_RTAi = max(0,PPESALi +  PPE_RPROi * positif(PPE_RPROi));


pour i =1..4:
PPE_RTAi = PPESALi;

PPE_RTAU = max(0,PPESALU + PPE_RPROP * positif(PPE_RPROP)) * PPE_BOOL_SEULPAC;
PPE_RTAN = max(0, PPE_RPROP ) * (1 - PPE_BOOL_SEULPAC);
regle 30570:
application : iliad , batch  ;

pour i=V,C:
PPENBHi = PPENHi + PPEXTi ;

pour i=1..4:
PPENBHi = PPENHPi + PPEXTi ;

pour i=V,C:
PPE_BOOL_TPi = positif
             (
                 positif(PPETPi + 0) * positif(PPE_SALAVDEFi + 0)
               + null(PPENHi + PPEXTi + 0) * null(PPETPi + 0) * positif(PPE_SALAVDEFi)
               + positif(360/PPENBJ * ((PPENHi + PPEXTi) * positif(PPE_SALAVDEFi + 0) /1820 
                                                + PPENJi * positif(PPE_AVRPRO1i + 0) /360 ) - 1 )
               + positif_ou_nul((PPENHi + PPEXTi) * positif(PPE_SALAVDEFi + 0) - 1820)
               + positif_ou_nul(PPENJi * positif(PPE_AVRPRO1i + 0) - 360)
               + positif(PPEACi * positif(PPE_AVRPRO1i + 0) + 0)  
               + (1 - positif(PPENJi * positif(PPE_AVRPRO1i + 0))) * positif(PPE_AVRPRO1i + 0)
             ) ;

PPE_BOOL_TPU = positif
             (
               (  positif(PPETPP1 + PPETPP2 + PPETPP3 + PPETPP4) * positif(PPE_SALAVDEF1 + PPE_SALAVDEF2 + PPE_SALAVDEF3 + PPE_SALAVDEF4)
               + null(PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4 + 0)
                 * null(PPETPP1 + PPETPP2 + PPETPP3 + PPETPP4 + 0)
                 * positif(PPE_SALAVDEF1 + PPE_SALAVDEF2 + PPE_SALAVDEF3 + PPE_SALAVDEF4)  
               + positif((360 / PPENBJ * ((PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4)
                                           * positif(PPE_SALAVDEF1+PPE_SALAVDEF2+PPE_SALAVDEF3+PPE_SALAVDEF4))/1820 
                          + PPENJP * positif(PPE_AVRPRO1P + 0) /360 ) - 1)
               + positif_ou_nul(((PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4) 
                                 * positif(PPE_SALAVDEF1 + PPE_SALAVDEF2 + PPE_SALAVDEF3 + PPE_SALAVDEF4))-1820)
               + positif_ou_nul(PPENJP * positif(PPE_AVRPRO1P + 0) - 360)
               + positif(PPEACP * positif(PPE_AVRPRO1P + 0))  
               + (1 - positif(PPENJP * positif(PPE_AVRPRO1P + 0))) * positif(PPE_AVRPRO1P + 0)) 
             * PPE_BOOL_SEULPAC
             ) ;


pour i =1,2,3,4:
PPE_BOOL_TPi = positif  
             (positif(PPETPPi) * positif(PPE_SALAVDEFi + 0)
              + null(PPENHPi + PPEXTi + 0) * null(PPETPPi + 0)* positif(PPE_SALAVDEFi)  
              + positif_ou_nul(360 / PPENBJ * (PPENHPi + PPEXTi) * positif(PPE_SALAVDEFi + 0) - 1820 )
             );

PPE_BOOL_TPN= positif 
             (
                positif_ou_nul ( 360 / PPENBJ * PPENJP * positif(PPE_AVRPRO1P + 0) - 360)
              + positif(PPEACP * positif(PPE_AVRPRO1P + 0))  
              + (1 - positif(PPENJP * positif(PPE_AVRPRO1P + 0))) * positif(PPE_AVRPRO1P + 0)
             ) ;

regle 30580:
application : iliad , batch  ;


pour i =V,C:
PPE_COEFFi = PPE_BOOL_TPi * 360 / PPENBJ
             + (1 - PPE_BOOL_TPi) / ((PPENHi + PPEXTi) * positif(PPE_SALAVDEFi + 0) /1820 
                                      + PPENJi * positif(PPE_AVRPRO1i + 0) /360) ;

PPE_COEFFU = PPE_BOOL_TPU * 360 / PPENBJ
       	     + (1 - PPE_BOOL_TPU) / 
               ((PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4)/1820 
                + PPENJP * positif(PPE_AVRPRO1P + 0) / 360)
               * PPE_BOOL_SEULPAC ;


pour i =1..4:
PPE_COEFFi = PPE_BOOL_TPi * 360 / PPENBJ
       	     + (1 - PPE_BOOL_TPi) / ((PPENHPi + PPEXTi) * positif(PPE_SALAVDEFi + 0) / 1820) ;


PPE_COEFFN = PPE_BOOL_TPN * 360 / PPENBJ
     	     + (1 -  PPE_BOOL_TPN) / (PPENJP * positif(PPE_AVRPRO1P + 0) / 360) ;


 
pour i= V,C,1,2,3,4,U,N:
PPE_RCONTPi = arr (  PPE_RTAi * PPE_COEFFi ) ;


regle 30590:
application : iliad , batch  ;

pour i=V,C,U,N,1,2,3,4:
PPE_BOOL_MINi = positif_ou_nul (PPE_RTAi- PPELIMRPB) * (1 - PPE_BOOL_NADAi);

regle 30600:
application : iliad , batch  ;

INDMONO =  BOOL_0AM 
            * (
                   positif_ou_nul(PPE_RTAV  - PPELIMRPB)
                 * positif(PPELIMRPB - PPE_RTAC)
               +
                   positif_ou_nul(PPE_RTAC - PPELIMRPB )
                   *positif(PPELIMRPB - PPE_RTAV)
               );

regle 30605:
application : iliad , batch  ;
PPE_HAUTE = PPELIMRPH * (1 - BOOL_0AM)
          + PPELIMRPH * BOOL_0AM * null(INDMONO)
                      * positif_ou_nul(PPE_RCONTPV - PPELIMRPB)
                      * positif_ou_nul(PPE_RCONTPC - PPELIMRPB)
          + PPELIMRPH2 * INDMONO;

regle 30610:
application : iliad , batch  ;

pour i=V,C:
PPE_BOOL_MAXi = positif_ou_nul(PPE_HAUTE - PPE_RCONTPi);

pour i=U,N,1,2,3,4:
PPE_BOOL_MAXi = positif_ou_nul(PPELIMRPH - PPE_RCONTPi);

regle 30615:
application : iliad , batch  ;

pour i = V,C,U,N,1,2,3,4:
PPE_FORMULEi = PPE_BOOL_KIR_COND
               * PPE_BOOL_ACT_COND
               * PPE_BOOL_MINi
               * PPE_BOOL_MAXi
               * arr(positif_ou_nul(PPELIMSMIC - PPE_RCONTPi)
                     * arr(PPE_RCONTPi * PPETX1/100)/PPE_COEFFi
                    +
                        positif(PPE_RCONTPi - PPELIMSMIC)
                      * positif_ou_nul(PPELIMRPH - PPE_RCONTPi )
                      * arr(arr((PPELIMRPH  - PPE_RCONTPi ) * PPETX2 /100)/PPE_COEFFi)
                    +
                      positif(PPE_RCONTPi - PPELIMRPHI)
                      * positif_ou_nul(PPE_HAUTE - PPE_RCONTPi )
                      * arr(arr((PPELIMRPH2 - PPE_RCONTPi ) * PPETX3 /100)/PPE_COEFFi)
                    ) ;


regle 30620:
application : iliad , batch  ;


pour i = V,C:
PPE_COEFFCONDi = (1 - PPE_BOOL_TPi)
                 * (null(PPENBJ - 360) * PPE_COEFFi
                    + (1 - null(PPENBJ - 360)) 
                       * (PPENBJ * 1820/360 /
                           ((PPENHi + PPEXTi) * positif(PPE_SALAVDEFi + 0) 
                            + PPENJi * positif(PPE_AVRPRO1i + 0) * 1820/360))
                   ) ;

pour i = U,N:
PPE_COEFFCONDi = (1 - PPE_BOOL_TPi)
                 * (null(PPENBJ - 360) * PPE_COEFFi
                    + (1 - null(PPENBJ - 360)) 
                       * (PPENBJ * 1820/360 /
                           ((PPENHP1 + PPENHP2 + PPENHP3 + PPENHP4 + PPEXT1 + PPEXT2 + PPEXT3 + PPEXT4) 
                            + PPENJP * positif(PPE_AVRPRO1P + 0) * 1820/360))
                   ) ;

pour i = 1,2,3,4:
PPE_COEFFCONDi = (1 - PPE_BOOL_TPi)
                 * (null(PPENBJ - 360) * PPE_COEFFi
                    + (1 - null(PPENBJ - 360)) 
                       * (PPENBJ * 1820/360 /
                           ((PPENHPi + PPEXTi) * positif(PPE_SALAVDEFi + 0) 
                            + PPENJP * positif(PPE_AVRPRO1P + 0) * 1820/360))
                   ) ;

pour i =V,C,U,1,2,3,4,N:
PPENARPRIMEi =   PPE_FORMULEi * ( 1 + PPETXMAJ2)
               * positif_ou_nul(PPE_COEFFCONDi - 2)
               * (1 - PPE_BOOL_TPi)

              +  (arr(PPE_FORMULEi * PPETXMAJ1) + arr(PPE_FORMULEi * (PPE_COEFFi * PPETXMAJ2 )))
               * positif (2 - PPE_COEFFCONDi)
               * positif (PPE_COEFFCONDi  -1 )
               * (1 - PPE_BOOL_TPi)

              + PPE_FORMULEi  * positif(PPE_BOOL_TPi + positif_ou_nul (1 - PPE_COEFFCONDi))  ; 


regle 30625:
application : iliad , batch  ;
pour i =V,C,U,1,2,3,4,N:
PPEPRIMEi =arr( PPENARPRIMEi) ;

PPEPRIMEPAC = PPEPRIMEU + PPEPRIME1 + PPEPRIME2 + PPEPRIME3 + PPEPRIME4 + PPEPRIMEN ;


PPEPRIMETTEV = PPE_BOOL_KIR_COND *  PPE_BOOL_ACT_COND 
               *(
                    ( PPE_PRIMETTE
                      * BOOL_0AM
                      * INDMONO
                      *  positif_ou_nul (PPE_RTAV - PPELIMRPB)
                      *  positif_ou_nul(PPELIMRPHI - PPE_RCONTPV)
                      *  (1 - positif(PPE_BOOL_NADAV))
                     )
                   ) 
               * ( 1 -  V_CNR) ;
                     
PPEPRIMETTEC =  PPE_BOOL_KIR_COND *  PPE_BOOL_ACT_COND 
                *(
                     ( PPE_PRIMETTE
                      * BOOL_0AM
                      * INDMONO
                      *  positif_ou_nul(PPELIMRPHI - PPE_RCONTPC)
                      *  positif_ou_nul (PPE_RTAC - PPELIMRPB)
                      *  (1 - positif(PPE_BOOL_NADAC))
                      )
                    )
               * ( 1 -  V_CNR);
PPEPRIMETTE = PPEPRIMETTEV + PPEPRIMETTEC ;




regle 30800:
application : iliad , batch  ;

BOOLENF = positif(V_0CF + V_0CH + V_0DJ + V_0CR + 0) ;

PPE_NB_PAC= V_0CF + V_0CR + V_0DJ + V_0DN  ;
PPE_NB_PAC_QAR =  V_0CH + V_0DP ;
TOTPAC = PPE_NB_PAC + PPE_NB_PAC_QAR;



PPE_NBNONELI = ( 
                        somme(i=1,2,3,4,U,N: positif(PPEPRIMEi))
                      + somme(i=1,2,3,4,U,N: positif_ou_nul(PPE_RTAi - PPELIMRPB) 
                                           * positif(PPE_RCONTPi - PPELIMRPH)
                              )
                  );
  



PPE_NBELIGI = PPE_NB_PAC + PPE_NB_PAC_QAR - PPE_NBNONELI;


PPE_BOOL_BT = V_0BT * positif(2 - V_0AV - BOOLENF) ;

PPE_BOOL_MAJO = (1 - PPE_BOOL_BT)
               * positif (  positif_ou_nul (PPELIMRPH - PPE_RCONTPV)
                           *positif_ou_nul (PPE_RTAV - PPELIMRPB)
                           *(1 - positif(PPE_BOOL_NADAV))
                          +
                            positif_ou_nul (PPELIMRPH - PPE_RCONTPC)
                           *positif_ou_nul (PPE_RTAC - PPELIMRPB)
                           *(1 - positif(PPE_BOOL_NADAC))
                          )
                        ;
PPE_NBMAJO =    positif_ou_nul (PPE_NB_PAC - PPE_NBELIGI)
                 *PPE_NBELIGI
               + (1 - positif_ou_nul (PPE_NB_PAC - PPE_NBELIGI))
               *  PPE_NB_PAC ;
PPE_NBMAJOQAR =    positif_ou_nul (PPE_NB_PAC - PPE_NBELIGI)
                 * 0
               + (1 - positif_ou_nul (PPE_NB_PAC - PPE_NBELIGI))
                 * ( PPE_NBELIGI - PPE_NB_PAC ) ;




PPE_MAJO =   PPE_BOOL_MAJO 
           * positif( PPE_NBELIGI )
           * ( PPE_NBMAJO * PPEMONMAJO
             + PPE_NBMAJOQAR * PPEMONMAJO / 2
             );

regle 30810:
application : iliad , batch  ;


PPE_BOOL_MONO =  (1 - PPE_BOOL_MAJO )
                *  (1 - PPE_BOOL_MAJOBT)
                * positif( PPE_NB_PAC + PPE_NB_PAC_QAR - PPE_NBNONELI)
                * INDMONO
                *( ( positif( PPE_BOOL_BT + BOOL_0AM )
                    *  positif_ou_nul (PPE_RTAV - PPELIMRPB)
                    *  positif_ou_nul (PPELIMRPH2 - PPE_RCONTPV)
                    *  (1 - positif(PPE_BOOL_NADAV))
                   )
                 + (  positif(  BOOL_0AM )
                    *  positif_ou_nul (PPE_RTAC - PPELIMRPB)
                    *  positif_ou_nul (PPELIMRPH2 - PPE_RCONTPC)
                    *  (1 - positif(PPE_BOOL_NADAC))
                  )
                 );
PPE_MONO = PPE_BOOL_MONO * ( 1 + PPE_BOOL_BT)
          *( positif( PPE_NBMAJO) * PPEMONMAJO 
            + 
             null( PPE_NBMAJO)*positif(PPE_NBMAJOQAR) * PPEMONMAJO / 2
           )
           ;


regle 30820:
application : iliad , batch  ;


PPE_BOOL_MAJOBT = positif (  positif_ou_nul (PPELIMRPH - PPE_RCONTPV)
                            *positif_ou_nul (PPE_RTAV - PPELIMRPB)
                            *(1 - positif(PPE_BOOL_NADAV))
                          )
                * PPE_BOOL_BT;

PPE_MABT =   PPE_BOOL_MAJOBT
           * positif( PPE_NBMAJO)
           * (( PPE_NBMAJO + 1) * PPEMONMAJO
             + PPE_NBMAJOQAR * PPEMONMAJO / 2
             )
         +   PPE_BOOL_MAJOBT
           * null( PPE_NBMAJO + 0)*positif(PPE_NBMAJOQAR)
           * (  positif(PPE_NBMAJOQAR-1) *  PPE_NBMAJOQAR * PPEMONMAJO / 2
                + PPEMONMAJO 
             )
          +  positif_ou_nul (PPELIMRPH2 - PPE_RCONTPV)
           * positif_ou_nul (PPE_RTAV - PPELIMRPB)
           * (1 - PPE_BOOL_MAJOBT)
           * (1 - positif(PPE_BOOL_NADAV))
           * PPE_BOOL_BT
           * ( positif( PPE_NB_PAC) * 2 * PPEMONMAJO
             + positif( PPE_NB_PAC_QAR ) * null ( PPE_NB_PAC + 0 ) * PPEMONMAJO
             )
            ;

                 
regle 30830:
application : iliad , batch  ;
PPEMAJORETTE =   PPE_BOOL_KIR_COND
               * PPE_BOOL_ACT_COND
               * arr ( PPE_MONO + PPE_MAJO + PPE_MABT )
               * ( 1 -  V_CNR) ;

regle 30900:
application : iliad , batch  ;

PPETOT = positif ( somme(i=V,C,U,1,2,3,4,N:PPENARPRIMEi)
                   +PPEPRIMETTE
                   +PPEMAJORETTE +0

 
                   +somme(i=V,C,U,1,2,3,4,N :( 1 - positif(PPELIMRPH - PPE_RCONTPi - 10))
                     *  PPE_BOOL_KIR_COND
                     *  PPE_BOOL_ACT_COND
                     *  PPE_BOOL_MINi
                     *  PPE_BOOL_MAXi)
                   +somme(i=V,C,U,1,2,3,4,N :( 1 - positif(PPELIMRPH2 - PPE_RCONTPi - 10))
                     *  PPE_BOOL_KIR_COND
                     *  PPE_BOOL_ACT_COND
                     *  PPE_BOOL_MINi
                     *  PPE_BOOL_MAXi)

           )
        
           * max(0,arr( (somme(i=V,C,U,1,2,3,4,N :PPEPRIMEi)
                                +PPEPRIMETTE
                                +PPEMAJORETTE
                        ) 
                      )
                 )
           * positif_ou_nul(arr( (somme(i=V,C,U,1,2,3,4,N :PPEPRIMEi)
                                +PPEPRIMETTE
                                +PPEMAJORETTE
				- PPELIMTOT                  )) 
                           )
       * (1 - positif(V_PPEISF + PPEISFPIR + PPEREVPRO))    
       * (1 - positif(RE168 + TAX1649)) 
       * (1 - null(7 - PPENEXOV)) * (1 - null(11 - PPENEXOV))
       * (1 - null(7 - PPENEXOC)) * (1 - null(11 - PPENEXOC))
       * (1 - null(7 - PPENEXO1)) * (1 - null(11 - PPENEXO1))
       * (1 - null(7 - PPENEXO2)) * (1 - null(11 - PPENEXO2))
       * (1 - null(7 - PPENEXO3)) * (1 - null(11 - PPENEXO3))
       * (1 - null(7 - PPENEXO4)) * (1 - null(11 - PPENEXO4))
       * (1 - null(2 - PPEPEXOV))
       * (1 - null(2 - PPEPEXOC))
       * (1 - null(2 - PPEPEXO1))
       * (1 - null(2 - PPEPEXO2))
       * (1 - null(2 - PPEPEXO3))
       * (1 - null(2 - PPEPEXO4))
       * (1 - V_CNR) ;

PPETOT2 = PPETOT ;

PPETOTMAY = arr(PPETOT * 81 / 100) * positif_ou_nul(arr(PPETOT * 81 / 100) - PPELIMTOT) * null(7 - V_REGCO) ;

PPETOTX = PPETOT * (1 - null(7 - V_REGCO)) + PPETOTMAY ;

regle 30910:
application : iliad,batch ;
PPENATREST = positif(IRE) * positif(IREST) * 
           (
            (1 - null(2 - V_REGCO))  *
            (
             ( null(IRE - PPETOTX + PPERSA) * 1                                              * 1
             + (1 - positif(PPETOTX-PPERSA))                                                 * 2 
             + null(IRE) * (1 - positif(PPETOTX-PPERSA))                                     * 3 
	     + positif(PPETOTX-PPERSA) * positif(IRE-PPETOTX+PPERSA)                          * 4
             )
	    )
           + 2 * null(2 - V_REGCO) 
           )
            ;

PPERESTA = positif(PPENATREST) * max(0,min(IREST , PPETOTX-PPERSA)) ;

PPENATIMPA = positif(PPETOTX-PPERSA) * (positif(IINET - PPETOTX + PPERSA - ICREREVET) + positif( PPETOTX - PPERSA - PPERESTA));

PPEIMPA = positif(PPENATIMPA) * positif_ou_nul(PPERESTA) * (PPETOTX - PPERSA - PPERESTA) ;

PPENATREST2 = (positif(IREST - V_ANTRE + V_ANTIR) + positif(V_ANTRE - IINET)) * positif(IRE) *
             (
              (1 - null(2 - V_REGCO))  *
               (
                ( null(IRE - PPETOTX + PPERSA) * 1                                              * 1
                + (1 - positif(PPETOTX-PPERSA))                                                 * 2 
                + null(IRE) * (1 - positif(PPETOTX-PPERSA))                                     * 3 
	        + positif(PPETOTX-PPERSA) * positif(IRE-PPETOTX+PPERSA)                          * 4
                )
	       )
              + 2 * null(2 - V_REGCO) 
             )
            ;

PPEREST2A = positif(IRE) * positif(IRESTITIR) * max(0,min(PPETOTX-PPERSA , IRESTITIR)) ; 

PPEIMP2A = positif_ou_nul(PPEREST2A) * (PPETOTX - PPERSA - PPEREST2A) ;



regle 30912:
application : iliad , batch  ;

pour i=V,C,1,2,3,4,N,U:
PPETEMPSi = arr(1 / PPE_COEFFi * 100) ;




pour i=V,C,1,2,3,4,N,U:
PPECOEFFi= arr(PPE_COEFFCONDi * 100 );
regle 989:
application : iliad, batch ;

CRESINTER = PRESINTER ;

regle 990:
application : iliad, batch ;

REST = positif(IRE) * positif(IRESTITIR) ;

LIBREST = positif(REST) * max(0,min(AUTOVERSLIB , IRESTITIR-(PPETOTX-PPERSA))) ;

LIBIMP = positif_ou_nul(LIBREST) * (AUTOVERSLIB - LIBREST) ;

LOIREST = positif(REST) * max(0,min(CILOYIMP , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB)) ;

LOIIMP = positif_ou_nul(LOIREST) * (CILOYIMP - LOIREST) ;

TAUREST = positif(REST) * max(0,min(CRERESTAU , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP)) ;

TAUIMP = positif_ou_nul(TAUREST) * (CRERESTAU - TAUREST) ;

AGRREST = positif(REST) * max(0,min(CICONGAGRI , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU)) ;

AGRIMP = positif_ou_nul(AGRREST) * (CICONGAGRI - AGRREST) ;

ARTREST = positif(REST) * max(0,min(CREARTS , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI)) ;

ARTIMP = positif_ou_nul(ARTREST) * (CREARTS - ARTREST) ;

INTREST = positif(REST) * max(0,min(CREINTERESSE , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS)) ;

INTIMP = positif_ou_nul(INTREST) * (CREINTERESSE - INTREST) ;

FORREST = positif(REST) * max(0,min(CREFORMCHENT , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE)) ;

FORIMP = positif_ou_nul(FORREST) * (CREFORMCHENT - FORREST) ;

PSIREST = positif(REST) * max(0,min(CRESINTER , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT)) ; 

PSIIMP = positif_ou_nul(PSIREST) * (CRESINTER - PSIREST) ;

PROREST = positif(REST) * max(0,min(CREPROSP , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                               -CRESINTER)) ;

PROIMP = positif_ou_nul(PROREST) * (CREPROSP - PROREST) ;

BIOREST = positif(REST) * max(0,min(CREAGRIBIO , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                                 -CRESINTER-CREPROSP)) ;

BIOIMP = positif_ou_nul(BIOREST) * (CREAGRIBIO - BIOREST) ;

APPREST = positif(REST) * max(0,min(CREAPP , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO)) ;

APPIMP = positif_ou_nul(APPREST) * (CREAPP - APPREST) ;

FAMREST = positif(REST) * max(0,min(CREFAM , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP)) ;

FAMIMP = positif_ou_nul(FAMREST) * (CREFAM - FAMREST) ;

HABREST = positif(REST) * max(0,min(CIHABPRIN , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                                -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM)) ;

HABIMP = positif_ou_nul(HABREST) * (CIHABPRIN - HABREST) ;

ROFREST = positif(REST) * max(0,min(CIFORET , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                              -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN)) ;

ROFIMP = positif_ou_nul(ROFREST) * (CIFORET - ROFREST) ;

SALREST = positif(REST) * max(0,min(CIADCRE , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                              -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET)) ;

SALIMP = positif_ou_nul(SALREST) * (CIADCRE - SALREST) ;

PREREST = positif(REST) * max(0,min(CIPRETUD , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                               -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE)) ;

PREIMP = positif_ou_nul(PREREST) * (CIPRETUD - PREREST) ;

SYNREST = positif(REST) * max(0,min(CISYND , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD)) ;

SYNIMP = positif_ou_nul(SYNREST) * (CISYND - SYNREST) ;

GARREST = positif(REST) * max(0,min(CIGARD , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND)) ;

GARIMP = positif_ou_nul(GARREST) * (CIGARD - GARREST) ;

BAIREST = positif(REST) * max(0,min(CICA , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                           -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD)) ;
 
BAIIMP = positif_ou_nul(BAIREST) * (CICA - BAIREST) ;

ELUREST = positif(REST) * max(0,min(IPELUS , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA)) ;
 
ELUIMP = positif_ou_nul(ELUREST) * (IPELUS - ELUREST) ;

TECREST = positif(REST) * max(0,min(CITEC , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                            -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS)) ;

TECIMP = positif_ou_nul(TECREST) * (CITEC - TECREST) ;

DEPREST = positif(REST) * max(0,min(CIDEVDUR , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                               -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                               -CITEC)) ;

DEPIMP = positif_ou_nul(DEPREST) * (CIDEVDUR - DEPREST) ;

AIDREST = positif(REST) * max(0,min(CIGE , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                           -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                           -CITEC-CIDEVDUR)) ;

AIDIMP = positif_ou_nul(AIDREST) * (CIGE - AIDREST) ;

ASSREST = positif(REST) * max(0,min(I2DH , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                           -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                           -CITEC-CIDEVDUR-CIGE)) ;

ASSIMP = positif_ou_nul(ASSREST) * (I2DH - ASSREST) ;

2CKREST = positif(REST) * max(0,min(CI2CK , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                            -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                            -CITEC-CIDEVDUR-CIGE-I2DH)) ;

2CKIMP = positif_ou_nul(2CKREST) * (CI2CK - 2CKREST) ;

EMPREST = positif(REST) * max(0,min(COD8TL , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                             -CITEC-CIDEVDUR-CIGE-I2DH-CI2CK)) ;

EMPIMP = positif_ou_nul(EMPREST) * (COD8TL - EMPREST) ;

EPAREST = positif(REST) * max(0,min(CIDIREPARGNE , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                                   -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                                   -CITEC-CIDEVDUR-CIGE-I2DH-CI2CK-COD8TL)) ;

EPAIMP = positif_ou_nul(EPAREST) * (CIDIREPARGNE - EPAREST) ;


RECREST = positif(REST) * max(0,min(IPRECH , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                             -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                             -CITEC-CIDEVDUR-CIGE-I2DH-CI2CK-COD8TL-CIDIREPARGNE)) ;

RECIMP = positif_ou_nul(RECREST) * (IPRECH - RECREST) ;

EXCREST = positif(REST) * max(0,min(CIEXCEDENT , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                                 -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                                 -CITEC-CIDEVDUR-CIGE-I2DH-CI2CK-COD8TL-CIDIREPARGNE-IPRECH)) ;

EXCIMP = positif_ou_nul(EXCREST) * (CIEXCEDENT - EXCREST) ;

CORREST = positif(REST) * max(0,min(CICORSENOW , IRESTITIR-(PPETOTX-PPERSA)-AUTOVERSLIB-CILOYIMP-CRERESTAU-CICONGAGRI-CREARTS-CREINTERESSE-CREFORMCHENT
                                                 -CRESINTER-CREPROSP-CREAGRIBIO-CREAPP-CREFAM-CIHABPRIN-CIFORET-CIADCRE-CIPRETUD-CISYND-CIGARD-CICA-IPELUS
                                                 -CITEC-CIDEVDUR-CIGE-I2DH-CI2CK-COD8TL-CIDIREPARGNE-IPRECH-CIEXCEDENT)) ;

CORIMP = positif_ou_nul(CORREST) * (CICORSENOW - CORREST) ;

