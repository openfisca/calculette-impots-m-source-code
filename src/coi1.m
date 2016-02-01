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
verif 2572:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   positif(RNOUV) = 1
   et
   positif(RDSNO) = 1
   et
   positif(CINE1 + CINE2) = 1

alors erreur DD02 ;
verif 1104:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   RCMFR > LIM_CONTROLE
   et
   ((RCMFR > 0.30 * ( RCMABD + RCMHAD + REVACT + DISQUO + RCMHAB + INTERE + 0 ))
    ou
    ((RCMABD + RCMHAD + REVACT + DISQUO + RCMHAB + INTERE + 0 = 0)
     et
     (RCMTNC + RCMAV + REGPRIV + REVPEA + PROVIE + RESTUC + 0 > 0)))

alors erreur DD03 ;
verif 1103:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   ((RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA + 0 > 0
     et
     RCMAVFT > ((1/3) * (RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA)) +  PLAF_AF)
    ou
    (DIREPARGNE > ((PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM) * (538/1000)) + PLAF_AF
     et
     PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM + 0 > 0))

alors erreur DD04 ;
verif 5050:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   V_ZDC + 0 = 0
   et
   V_BTMUL = 0
   et
   V_0AX+0 = 0 et V_0AY+0 = 0 et V_0AZ+0= 0
   et
   V_BTRNI > LIM_BTRNI10
   et
   RNI < V_BTRNI/5
   et
   V_BTANC + 0 = 1
   et
   ((V_BTNI1 + 0) non dans (50,92))
   et
   V_IND_TRAIT = 4

alors erreur DD05 ;
verif 3645:
application : batch, iliad ;
si (APPLI_OCEANS = 0 ) et (
   (
    ( RINVLOCINV + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( RINVLOCREA + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( INVLOCHOTR + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( REPINVTOU + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( INVLOGREHA + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( INVLOGHOT + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( INVLOCXN + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( INVLOCXV + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( COD7UY + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   ou
    ( COD7UZ + 0  > (LIM_INVLOC3 * ( 1 + V_0AM + V_0AO ) + positif(V_0AM + V_0AO)))
   )
 et
     (RTOURREP + RTOUHOTR + RTOUREPA + 0 > 0)
                           )
alors erreur DD06 ;
verif 1330:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   pour un i dans V,C,P:
   (
    (MIBVENi + MIBNPVENi + MIBGITEi + LOCGITi > LIM_MIBVEN)
    ou
    (MIBPRESi + MIBNPPRESi + MIBMEUi > LIM_MIBPRES)
    ou
    (MIBVENi + MIBNPVENi + MIBGITEi + LOCGITi + MIBPRESi + MIBNPPRESi + MIBMEUi <= LIM_MIBVEN
     et
     MIBPRESi + MIBNPPRESi + MIBMEUi > LIM_MIBPRES)
    ou
    (MIBVENi + MIBNPVENi + MIBGITEi + LOCGITi + MIBPRESi + MIBNPPRESi + MIBMEUi > LIM_MIBVEN)
    ou
    (BNCPROi + BNCNPi > LIM_SPEBNC)
  )

alors erreur DD08 ;
verif 3647:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_REGCO != 2
   et
   V_REGCO != 4
   et
   positif(PRETUDANT + 0) = 1
   et
   positif(V_BTPRETUD + 0) = 1
   et
   V_IND_TRAIT = 4

alors erreur DD09 ;
verif 5205:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   (
    (CIGARD > 0
     et
     1 - V_CNR > 0
     et
     positif(RDGARD1) + positif(RDGARD2) + positif(RDGARD3) + positif(RDGARD4) > EM7 + 0)
    ou
    (CIGARD > 0
     et
     1 - V_CNR > 0
     et
     positif(RDGARD1QAR) + positif(RDGARD2QAR) + positif(RDGARD3QAR) + positif(RDGARD4QAR) > EM7QAR + 0)
   )

alors erreur DD10 ;
verif 1605:
application : batch, iliad ;

si
   APPLI_OCEANS = 0
   et
   RFMIC > 0
   et
   RFDANT> 0

alors erreur DD11 ;
verif 5203:
application : iliad,batch ;

si
   APPLI_OCEANS = 0
   et
   positif(present(BAFV) + present(BAFC)) = 1
   et
   positif(  present ( BICEXV ) + present ( BICEXC ) + present ( BICNOV )
           + present ( BICNOC )
           + present ( BI1AV ) + present ( BI1AC ) + present ( BICDNV )
           + present ( BICDNC )
           + present ( BIHEXV ) + present ( BIHEXC ) + present ( BIHNOV )
           + present ( BIHNOC )
           + present ( BIHDNV ) + present ( BIHDNC )
           + present ( BNCEXV ) + present ( BNCEXC )
           + present ( BNCREV ) + present ( BNCREC ) + present ( BN1AV )
           + present ( BN1AC ) + present ( BNCDEV ) + present ( BNCDEC )
           + present ( BNHEXV ) + present ( BNHEXC ) + present ( BNHREV )
           + present ( BNHREC ) + present ( BNHDEV ) + present ( BNHDEC )
           + present ( LOCPROCGAV ) + present ( LOCPROCGAC ) + present ( LOCDEFPROCGAV )
           + present ( LOCDEFPROCGAC ) + present ( LOCPROV ) + present ( LOCPROC )
           + present ( LOCDEFPROV ) + present ( LOCDEFPROC )) = 1

alors erreur DD13 ;
verif 1606:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   RCMRDS > (LIM_CONTROLE + RCMABD + RCMAV + RCMHAD + RCMTNC
                          + REVACT + PROVIE + DISQUO + REVPEA
                          + RCMHAB + INTERE + COD2FA)

alors erreur DD14 ;
verif 1616:
application : iliad , batch ;

si (APPLI_OCEANS=0) et (
          (
                ( RDPRESREPORT +0  > V_BTPRESCOMP  +  LIM_REPORT )
           ou
                ( PRESCOMP2000 + PRESCOMPJUGE  +0 > LIM_REPORT  et
                   V_BTPRESCOMP  + 0> 0 )
           ou
                ( RDPRESREPORT +0  > LIM_REPORT et V_BTPRESCOMP+0 = 0 )
          )
          et
          (
              1 - V_CNR > 0
          )
          et
          (
              RPRESCOMP > 0
          )
         et
          ((APPLI_ILIAD = 1 et V_NOTRAIT+0 < 16)
             ou APPLI_COLBERT = 1
             ou ((V_BTNI1+0) non dans (50,92) et APPLI_BATCH = 1))
                       )
alors erreur DD15 ;
verif 2022:
application : batch , iliad ;

si
   APPLI_BATCH + APPLI_ILIAD + APPLI_OCEANS = 1
   et
   1 - V_CNR > 0
   et
   CHRFAC > 0
   et
   V_0CR > 0
   et
   RFACC != 0

alors erreur DD16 ;
verif 5000:
application : iliad , batch ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   NBPT > (V_BTNBP1 + 4 * APPLI_ILIAD + 400 * APPLI_BATCH)
   et
   V_BTNBP1 + 0 > 0
   et
   V_IND_TRAIT = 4 et V_BTANC = 1 et ((V_BTNI1 + 0) non dans (50,92))
   et
   V_BTMUL != 1 et V_CODILIAD = 1
   et
   (V_BT0AC = V_0AC ou V_BT0AM = V_0AM ou V_BT0AO = V_0AO ou V_BT0AD = V_0AD ou V_BT0AV = V_0AV)

 alors erreur DD17 ;
verif 5103:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   DAR > LIM_CONTROLE
   et
   V_BTRNI > 0
   et
   ((V_BTNI1+0) non dans (50,92))
   et
   V_IND_TRAIT = 4

alors erreur DD18 ;
verif 2562:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   NBACT > SOMMEA700
   et
   (V_REGCO+0) dans (1,3,5,6,7)

alors erreur DD19 ;
verif 5104:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   V_BTANC = 1
   et
   DAGRI1 + DAGRI2 + DAGRI3 + DAGRI4 + DAGRI5 + DAGRI6 > LIM_CONTROLE + V_BTDBA
   et
   V_IND_TRAIT = 4

alors erreur DD20 ;
verif 2575:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   ( RVAIDE + RVAIDAS + CREAIDE + 0) > (LIM_AIDOMI3 * (1 - positif(PREMAIDE)) + LIM_PREMAIDE2 * positif(PREMAIDE))
   et
   INAIDE = 1
   et
   (positif(V_0AP+0)=0
    et positif(V_0AF+0)=0
    et positif(V_0CG+0)=0
    et positif(V_0CI+0)=0
    et positif(V_0CR+0)=0
   )

alors erreur DD21 ;
verif 2010:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   (V_BTCSGDED * (1-present(DCSG)) + DCSG) * (1-null(4 -V_REGCO)) > V_BTCSGDED +  LIM_CONTROLE
   et
   1 - V_CNR > 0
   et
   RDCSG > 0
   et
   ((APPLI_ILIAD = 1 et V_NOTRAIT+0 < 16)
    ou
    ((V_BTNI1+0) non dans (50,92) et APPLI_BATCH = 1))

alors erreur DD22 ;
verif 1607:
application : batch ,iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   (BAILOC98 > V_BTBAILOC98
    ou
    (present(BAILOC98) = 1 et present(V_BTBAILOC98) = 0))

alors erreur DD24 ;
verif 2540:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_BATCH + APPLI_ILIAD = 1
   et
   RFORDI + FONCI + REAMOR + RFDORD + RFDHIS + RFDANT > LIM_BTREVFONC
   et
   V_BTANC = 1
   et
   V_BTIRF = 0
   et
   V_IND_TRAIT = 4

alors erreur DD26 ;
verif 5108:
application : batch, iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   (1 - V_CNR) > 0
   et
   (REPSNO3 > LIM_CONTROLE + V_BTPME4
    ou
    REPSNO2 > LIM_CONTROLE + V_BTPME3
    ou
    REPSNO1 > LIM_CONTROLE + V_BTPME2
    ou
    REPSNON > LIM_CONTROLE + V_BTPME1
    ou
    COD7CQ > LIM_CONTROLE + V_BTITENT1
    ou
    COD7CR > LIM_CONTROLE + V_BTITENT2)
   et
   positif(NATIMP + 0) = 1

alors erreur DD27 ;
verif 51091:
application : batch, iliad ;

si
   APPLI_OCEANS = 0
   et
   CREPROSP > 0
   et
   positif(V_BTCREPROSP + 0) = 1
   et
   V_IND_TRAIT = 4

alors erreur DD28 ;
verif 5110:
application : batch , iliad ;
si
   APPLI_OCEANS = 0
   et
   V_CNR + 0 = 0
   et
   positif(NATIMP) = 1
   et
   ((REPDON03 > LIM_CONTROLE + V_BTDONS5)
    ou
    (REPDON04 > LIM_CONTROLE + V_BTDONS4)
    ou
    (REPDON05 > LIM_CONTROLE + V_BTDONS3)
    ou
    (REPDON06 > LIM_CONTROLE + V_BTDONS2)
    ou
    (REPDON07 > LIM_CONTROLE + V_BTDONS1))
   et
   V_IND_TRAIT = 4

alors erreur DD29 ;
verif 5112:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_REGCO + 0 = 1
   et
   positif(PRODOM + PROGUY + 0) = 0
   et
   positif(COD7RZ + 0) = 1

alors erreur DD30 ;
verif 5114:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   COD8SA + COD8SB + 0 > PCAPTAXV + PCAPTAXC + 0

alors erreur DD31 ;
verif 6632:
application : batch , iliad ;
si 
   APPLI_OCEANS = 0 
   et
   (1 - V_CNR > 0) 
   et 
   V_REGCO+0 !=2 
   et 
   V_REGCO+0 != 4
   et
  positif(CREAIDE+0) > 0
  et
  (
  (1 - BOOL_0AM) *
   (present(TSHALLOV) + present(ALLOV) + present(GLD1V) + present(GLD2V) + present(GLD3V)
   + present(BPCOSAV) + present(TSASSUV) + present(XETRANV)
   + present(CARTSV) + present(REMPLAV) 
   + present(CODDAJ) + present(CODEAJ) + present(SALEXTV)
   + present(FEXV) + present(BAFV) + positif(V_FORVA) + present(BAFORESTV)
   + present(BAFPVV) + present(BAF1AV) + present(BAEXV) + present(BACREV)
   + present(BACDEV) + present(BAHEXV) + present(BAHREV) + present(BAHDEV)
   + present(BA1AV) + present(BAPERPV)
   + present(MIBEXV) + present(MIBVENV) + present(MIBPRESV) + present(MIBPVV)
   + present(MIB1AV) + present(MIBDEV)
   + present( BICPMVCTV )
   + present(BICEXV)
   + present(BICNOV) + present(BICDNV)
   + present(BIHEXV) + present(BIHNOV) + present(BIHDNV)
   + present(BI1AV) + present(BIPERPV)
   + present(BNCPROEXV) + present(BNCPROV) + present(BNCPROPVV) + present(BNCPRO1AV)
   + present(BNCPRODEV) + present(BNCPMVCTV) + present(BNCEXV) + present(BNCREV)
   + present(BNCDEV) + present(BNHEXV) + present(BNHREV) + present(BNHDEV)
   + present(BN1AV) + present(BNCCRV) + present(CESSASSV)
   + present(AUTOBICVV) + present(AUTOBICPV) + present(LOCPROCGAV)
   + present(LOCDEFPROCGAV) + present(LOCPROV) + present(LOCDEFPROV)
   + present(AUTOBNCV) + present(XHONOAAV) + present(XHONOV)
   + present(GLDGRATV) + present(BICPMVCTV))

+ (1 - positif(V_0AP+V_0AF)) * BOOL_0AM *
   (present(TSHALLOV) + present(ALLOV) + present(GLD1V) + present(GLD2V) + present(GLD3V)
    + present(BPCOSAV) + present(TSASSUV) + present(XETRANV)
    + present(CARTSV) + present(REMPLAV) 
    + present(CODDAJ) + present(CODEAJ) + present(SALEXTV)
    + present(FEXV) + present(BAFV) + positif(V_FORVA) + present(BAFORESTV)
    + present(BAFPVV) + present(BAF1AV) + present(BAEXV) + present(BACREV)
    + present(BACDEV) + present(BAHEXV) + present(BAHREV) + present(BAHDEV)
    + present(BA1AV) + present(BAPERPV)
    + present(MIBEXV) + present(MIBVENV) + present(MIBPRESV) + present(MIBPVV)
    + present(MIB1AV) + present(MIBDEV) + present(BICEXV)
    + present(BICPMVCTV) + present(BICNOV) + present(BICDNV)
    + present(BIHEXV) + present(BIHNOV) + present(BIHDNV)
    + present(BI1AV) + present(BIPERPV)
    + present(BNCPROEXV) + present(BNCPROV) + present(BNCPROPVV) + present(BNCPRO1AV)
    + present(BNCPRODEV) + present(BNCPMVCTV) + present(BNCEXV) + present(BNCREV)
    + present(BNCDEV) + present(BNHEXV) + present(BNHREV) + present(BNHDEV)
    + present(BN1AV) + present(BNCCRV) + present(CESSASSV)
    + present(AUTOBICVV) + present(AUTOBICPV) + present(LOCPROCGAV)
    + present(LOCDEFPROCGAV) + present(LOCPROV) + present(LOCDEFPROV)
    + present(AUTOBNCV) + present(XHONOAAV) + present(XHONOV)
    + present(GLDGRATV) + present(BICPMVCTV))
   *
   (present(TSHALLOC) + present(ALLOC) + present(GLD1C) + present(GLD2C) + present(GLD3C)
    + present(BPCOSAC) + present(TSASSUC) + present(XETRANC)
    + present(CARTSC) + present(REMPLAC) 
    + present(FEXC) + present(BAFC) + positif(V_FORCA) + present(BAFORESTC)
    + present(CODDBJ) + present(CODEBJ) + present(SALEXTC)
    + present(BAFPVC) + present(BAF1AC) + present(BAEXC) + present(BACREC)
    + present(BACDEC) + present(BAHEXC) + present(BAHREC) + present(BAHDEC)
    + present(BA1AC) + present(BAPERPC)
    + present(MIBEXC) + present(MIBVENC) + present(MIBPRESC) + present(MIBPVC)
    + present(MIB1AC) + present(MIBDEC) + present(BICEXC)
    + present(BICPMVCTC) + present(BICNOC) + present(BICDNC)
    + present(BIHEXC) + present(BIHNOC) + present(BIHDNC)
    + present(BI1AC) + present(BIPERPC)
    + present(BNCPROEXC) + present(BNCPROC) + present(BNCPROPVC) + present(BNCPRO1AC)
    + present(BNCPRODEC) + present(BNCEXC) + present(BNCREC)
    + present(BNCDEC) + present(BNHEXC) + present(BNHREC) + present(BNHDEC)
    + present(BN1AC) + present(BNCCRC) + present(CESSASSC)
    + present(AUTOBICVC) + present(AUTOBICVC) + present(LOCPROCGAC)
    + present(LOCDEFPROCGAC) + present(LOCPROC) + present(LOCDEFPROC)
    + present(AUTOBNCC) + present(XHONOAAC) + present(XHONOC)
    + present(GLDGRATC) + present(BICPMVCTC) + present(BNCPMVCTC))

  + BOOL_0AM * positif(V_0AF) *
   (present(TSHALLOV) + present(ALLOV) + present(GLD1V) + present(GLD2V) + present(GLD3V)
   + present(BPCOSAV) + present(TSASSUV) + present(XETRANV)
   + present(CARTSV) + present(REMPLAV) 
   + present(CODDAJ) + present(CODEAJ) + present(SALEXTV)
   + present(FEXV) + present(BAFV) + positif(V_FORVA) + present(BAFORESTV)
   + present(BAFPVV) + present(BAF1AV) + present(BAEXV) + present(BACREV)
   + present(BACDEV) + present(BAHEXV) + present(BAHREV) + present(BAHDEV)
   + present(BA1AV) + present(BAPERPV)
   + present(MIBEXV) + present(MIBVENV) + present(MIBPRESV) + present(MIBPVV)
   + present(MIB1AV) + present(MIBDEV) + present(BICEXV)
   + present( BICPMVCTV )
   + present(BICNOV) + present(BICDNV)
   + present(BIHEXV) + present(BIHNOV) + present(BIHDNV)
   + present(BI1AV) + present(BIPERPV)
   + present(BNCPROEXV) + present(BNCPROV) + present(BNCPROPVV) + present(BNCPRO1AV)
   + present(BNCPRODEV) + present(BNCPMVCTV) + present(BNCEXV) + present(BNCREV)
   + present(BNCDEV) + present(BNHEXV) + present(BNHREV) + present(BNHDEV)
   + present(BN1AV) + present(BNCCRV) + present(CESSASSV)
   + present(AUTOBICVV) + present(AUTOBICPV) + present(LOCPROCGAV)
   + present(LOCDEFPROCGAV) + present(LOCPROV) + present(LOCDEFPROV)
   + present(AUTOBNCV) + present(XHONOAAV) + present(XHONOV)
   + present(GLDGRATV) + present(BICPMVCTV))

  + BOOL_0AM * positif(V_0AP) *
   (present(TSHALLOC) + present(ALLOC) + present(GLD1C) + present(GLD2C) + present(GLD3C)
   + present(BPCOSAC) + present(TSASSUC) + present(XETRANC)
   + present(CARTSC) + present(REMPLAC) 
   + present(CODDBJ) + present(CODEBJ) + present(SALEXTC)
   + present(FEXC) + present(BAFC) + positif(V_FORCA) + present(BAFORESTC)
   + present(BAFPVC) + present(BAF1AC) + present(BAEXC) + present(BACREC)
   + present(BACDEC) + present(BAHEXC) + present(BAHREC) + present(BAHDEC)
   + present(BA1AC) + present(BAPERPC)
   + present(MIBEXC) + present(MIBVENC) + present(MIBPRESC) + present(MIBPVC)
   + present(MIB1AC) + present(MIBDEC) + present(BICEXC)
   + present(BICNOC) + present(BICDNC)
   + present(BIHEXC) + present(BIHNOC) + present(BIHDNC)
   + present(BI1AC) + present(BIPERPC)
   + present(BNCPROEXC) + present(BNCPROC) + present(BNCPROPVC) + present(BNCPRO1AC)
   + present(BNCPRODEC) + present(BNCEXC) + present(BNCREC)
   + present(BNCDEC) + present(BNHEXC) + present(BNHREC) + present(BNHDEC)
   + present(BN1AC) + present(BNCCRC) + present(CESSASSC)
   + present(AUTOBICVC) + present(AUTOBICVC) + present(LOCPROCGAC)
   + present(LOCDEFPROCGAC) + present(LOCPROC) + present(LOCDEFPROC)
   + present(AUTOBNCC) + present(XHONOAAC) + present(XHONOC)
   + present(GLDGRATC) + present(BICPMVCTC) + present(BNCPMVCTC))

   = 0
   )
alors erreur DD32 ;
verif 3400:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et (
   1 - V_CNR > 0
   et
   V_REGCO+0 !=2
   et
   V_REGCO+0 != 4
   et
   positif(FIPCORSE+0) = 1
   et
   positif(FFIP + FCPI) = 1
                         )
alors erreur DD34;
verif 3900:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   positif(PERPIMPATRIE + 0) = 1
   et
   positif(V_BTPERPIMP + 0) = 1
   et
   V_IND_TRAIT = 4

alors erreur DD35 ;
verif 3910:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   V_IND_TRAIT = 4
   et
   PTZDEVDURN > 0
   et
   (V_BTRFRN3 + 0 > PLAF_RFRN3
    ou
    RFRN3 + 0 > PLAF_RFRN3
    ou
    positif(V_BTRFRN3 + RFRN3 + 0) = 0)

alors erreur DD3601 ;
verif 3911:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   V_IND_TRAIT = 4
   et
   PTZDEVDUR > 0
   et
   (V_BTRFRN2 + 0 > 25000 + (10000 * BOOL_0AM) + (3750 * (V_0CH + V_0DP + 2 * (V_0CF + V_0DJ + V_0DN + V_0CR)))
    ou
    RFRN2 + 0 > 25000 + (10000 * BOOL_0AM) + (3750 * (V_0CH + V_0DP + 2 * (V_0CF + V_0DJ + V_0DN + V_0CR)))
    ou
    positif(V_BTRFRN2 + V_BTRFRN1 + RFRN2 + RFRN1 + 0) = 0)

alors erreur DD3602 ;
verif 3920:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 !=2
   et
   V_REGCO+0 != 4
   et
   V_IND_TRAIT = 4
   et
   positif(V_BTRFRN2 + 0) = 1
   et
   (pour un i dans V,C,P:
    (AUTOBICVi > LIM_MIBVEN)
    ou
    (AUTOBICPi > LIM_MIBPRES)
    ou
    (AUTOBICVi + AUTOBICPi > LIM_MIBVEN)
    ou
    (AUTOBNCi > LIM_SPEBNC))

alors erreur DD37 ;
verif 3930:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   V_IND_TRAIT = 4
   et
   V_BTRFRN2 + 0 > arr(LIM_BARN2 * V_BTNBP2)
   et
   pour un i dans V,C,P: positif(AUTOBICVi + AUTOBICPi + AUTOBNCi) = 1

alors erreur DD3801 ;
verif 3940:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   1 - V_CNR > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   V_IND_TRAIT = 4
   et
   positif(V_BTRFRN2 + 0) = 0
   et
   1 - positif_ou_nul(RFRN2) = 1
   et
   pour un i dans V,C,P: positif(AUTOBICVi + AUTOBICPi + AUTOBNCi) = 1

alors erreur DD3802 ;
verif 3410:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   REPGROREP1 + REPGROREP2 + REPGROREP11 + REPGROREP12 + REPGROREP13 > LIM_CONTROLE + V_BTNUREPAR

alors erreur DD39 ;
verif 3420:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   CELRREDLA + CELRREDLB + CELRREDLE + CELRREDLM + CELRREDLN > LIM_CONTROLE + V_BTRRCEL4

alors erreur DD40 ;
verif 3430:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   REDMEUBLE + REDREPNPRO + LOCMEUBIX + LOCMEUBIY + COD7PA > LIM_CONTROLE + V_BTRILMNP5

alors erreur DD41 ;
verif 3440:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   (REPFOR + REPFOR1 + REPFOR2 + REPFOR3 > LIM_CONTROLE + V_BTFOREST
    ou
    REPSINFOR + REPSINFOR1 + REPSINFOR2 + REPSINFOR3 + REPSINFOR4 > LIM_CONTROLE + V_BTSINFOR)

alors erreur DD42 ;
verif 3450:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   (INVOMREP + NRETROC50 + NRETROC40 + INVENDI + INVOMENTMN + RETROCOMLH
   + RETROCOMMB + INVOMENTKT + RETROCOMLI + RETROCOMMC + INVOMENTKU
   + INVOMQV + INVRETRO1 + INVRETRO2 + INVIMP + INVDOMRET50 + INVDOMRET60
   + INVDIR2009 + INVENDEB2009 + INVOMRETPA + INVOMRETPB + INVOMRETPD
   + INVOMRETPE + INVOMRETPF + INVOMRETPH + INVOMRETPI + INVOMRETPJ + INVOMRETPL
   + INVOMRETPM + INVOMRETPN + INVOMRETPO + INVOMRETPP + INVOMRETPR + INVOMRETPS
   + INVOMRETPT + INVOMRETPU + INVOMRETPW + INVOMRETPX + INVOMRETPY
   + INVOMENTRG + INVOMENTRI + INVOMENTRJ + INVOMENTRK + INVOMENTRL + INVOMENTRM
   + INVOMENTRO + INVOMENTRP + INVOMENTRQ + INVOMENTRR + INVOMENTRT + INVOMENTRU
   + INVOMENTRV + INVOMENTRW + INVOMENTRY
   + INVOMENTNU + INVOMENTNV + INVOMENTNW + INVOMENTNY
   + CODHSA + CODHSB + CODHSC + CODHSE + CODHSF + CODHSG + CODHSH + CODHSJ + CODHSK
   + CODHSL + CODHSM + CODHSO + CODHSP + CODHSQ + CODHSR + CODHST + CODHSU + CODHSV
   + CODHSW + CODHSY + CODHSZ + CODHTA + CODHTB + CODHTD
   > LIM_CONTROLE + V_BTREPOMENT)

alors erreur DD43 ;
verif 3460:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   (INVSOCNRET + INVOMSOCKH + INVOMSOCKI + INVSOC2010 + INVOMSOCQU 
    + INVLOGSOC + INVOMSOCQJ + INVOMSOCQS + INVOMSOCQW + INVOMSOCQX 
    + CODHRA + CODHRB + CODHRC + CODHRD > LIM_CONTROLE + V_BTREPOMSOC)

alors erreur DD44 ;
verif 3470:
application : batch , iliad ;

si (APPLI_OCEANS = 0) et (

   V_IND_TRAIT > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   (CELREPHR > LIMLOC2
    ou
    CELREPHS > LIMLOC2
    ou
    CELREPHT > LIMLOC2
    ou
    CELREPHU > LIMLOC2
    ou
    CELREPHV > LIMLOC2
    ou
    CELREPHW > LIMLOC2
    ou
    CELREPHX > LIMLOC2
    ou
    CELREPHZ > LIMLOC2)
                        )
alors erreur DD45 ;
verif 3480:
application : batch , iliad ;
si (APPLI_OCEANS = 0) et (
   V_IND_TRAIT > 0
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   (INVREPMEU > LIMLOC2
    ou
    INVREPNPRO > LIMLOC2
    ou
    INVNPROREP > LIMLOC2
    ou
    REPMEUBLE > LIMLOC2)
                           )
alors erreur DD46 ;
verif 34201:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   CELRREDLC + CELRREDLD + CELRREDLS + CELRREDLT > LIM_CONTROLE + V_BTRRCEL3

alors erreur DD48 ;
verif 34301:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   INVREDMEU + LOCMEUBIH + LOCMEUBJC + COD7PB > LIM_CONTROLE + V_BTRILMNP4

alors erreur DD49 ;
verif 3490:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   PATNAT1 + PATNAT2 + PATNAT3 + PATNAT4 > LIM_CONTROLE + V_BTPATNAT

alors erreur DD50 ;
verif 34901:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
    LNPRODEF10 + LNPRODEF9 + LNPRODEF8 + LNPRODEF7 + LNPRODEF6 + LNPRODEF5
    + LNPRODEF4 + LNPRODEF3 + LNPRODEF2 + LNPRODEF1 > LIM_CONTROLE + V_BTDEFNPLOC

alors erreur DD52 ;
verif 34902:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   DEFBIC6 + DEFBIC5 + DEFBIC4 + DEFBIC3 + DEFBIC2 + DEFBIC1 > LIM_CONTROLE + V_BTBICDF

alors erreur DD53 ;
verif 4110:
application : iliad , batch ;

si
   SALECSG + SALECS + ALLECS + INDECS + PENECS + 0 > 0
   et
   SOMMEDD55 = 0

alors erreur DD55 ;
verif 1257:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   CELRREDLF + CELRREDLZ + CELRREDLX > LIM_CONTROLE + V_BTRRCEL2

alors erreur DD57 ;
verif 1258:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   LOCMEUBIZ + LOCMEUBJI + COD7PC > LIM_CONTROLE + V_BTRILMNP3

alors erreur DD58 ;
verif 12611:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   positif(CVNSALAV + 0) = 1
   et
   positif(BPV18V + BPCOPTV + BPV40V + BPCOSAV + 0) = 0

alors erreur DD6101 ;
verif 12612:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   positif(CVNSALAC + 0) = 1
   et
   positif(BPV18C + BPCOPTC + BPV40C + BPCOSAC + 0) = 0

alors erreur DD6102 ;
verif 1263:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   IPTEFP < RNI + 0

alors erreur DD63 ;
verif 1264:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   CELRREDMG + CELRREDMH > LIM_CONTROLE + V_BTRRCEL1

alors erreur DD64 ;
verif 1265:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   LOCMEUBJS + COD7PD > LIM_CONTROLE + V_BTRILMNP2

alors erreur DD65 ;
verif 1266:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   COD7PE > LIM_CONTROLE + V_BTRILMNP1

alors erreur DD66 ;
verif 1267:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT = 4
   et
   V_REGCO+0 != 2
   et
   V_REGCO+0 != 4
   et
   COD7CY > LIM_CONTROLE + V_BTPLAFPME

alors erreur DD67 ;
