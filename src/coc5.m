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
verif 800:
application : iliad , batch ;

si
   RG + 2 < PRODOM + PROGUY

alors erreur A800 ;
verif 8021:
application : iliad , batch ;

si
   (V_NOTRAIT >= 20
    et
    IPTEFP > 0
    et
    IPTEFN > 0)
   ou
   (V_NOTRAIT + 0 < 20
    et
    IPTEFP >= 0
    et
    IPTEFN >= 0
    et
    V_ROLCSG+0 < 40)

alors erreur A80201 ;
verif 8022:
application : iliad , batch ;

si
   (
    V_NOTRAIT + 0 < 20
    et
    IPTEFP + IPTEFN >= 0
    et
    PRODOM + PROGUY + CODDAJ + CODDBJ + CODEAJ + CODEBJ >= 0
   )
   ou
   (
    V_NOTRAIT >= 20
    et
    IPTEFP + IPTEFN > 0
    et
    PRODOM + PROGUY + CODDAJ + CODDBJ + CODEAJ + CODEBJ > 0
   )

alors erreur A80202 ;
verif 8023:
application : iliad , batch ;
si
   (
    V_NOTRAIT + 0 < 20
    et
    SOMMEA802 > 0
    et
    PRODOM + PROGUY + CODDAJ + CODDBJ + CODEAJ + CODEBJ >= 0
   )
   ou
   (
    V_NOTRAIT >= 20
    et
    SOMMEA802 > 0
    et
    PRODOM + PROGUY + CODDAJ + CODDBJ + CODEAJ + CODEBJ > 0
   )

alors erreur A80203 ;
verif 803:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODDAJ + CODDBJ + CODEAJ + CODEBJ + 0) = 1
   et
   V_REGCO + 0 != 1

alors erreur A803 ;
verif 804:
application : iliad , batch ;

si
   PROGUY + PRODOM + CODDAJ + CODEAJ + CODDBJ + CODEBJ+ 0 > 0
   et
   SOMMEA804 > 0

alors erreur A804 ;
verif 805:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(TREVEX) = 1
   et
   SOMMEA805 = 0

alors erreur A805 ;
verif 806:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(PROGUY + PRODOM + CODDAJ + CODEAJ + CODDBJ + CODEBJ + 0) = 1
   et
   ((positif(CARTSNBAV + 0) = 1
     et    
     null(CARTSNBAV - 4) = 0)
   ou
    (positif(CARTSNBAC + 0) = 1
     et 
     null(CARTSNBAC - 4) = 0))

alors erreur A806 ;
verif 807:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(PRELIBXT + 0) = 1
   et
   positif(PCAPTAXV + PCAPTAXC + 0) = 0

alors erreur A807 ;
verif 821:
application : iliad , batch ;

si
   (V_IND_TRAIT > 0 )
   et
   present(BASRET) + present(IMPRET) = 1

alors erreur A821 ;
verif corrective 850:
application : iliad ;

si 
   APPLI_OCEANS = 0 
   et 
   V_NOTRAIT > 20
   et
   (positif(CSPROVYD) = 1
    ou
    positif(CSPROVYE) = 1
    ou
    positif(CSPROVYF) = 1
    ou
    positif(CSPROVYG) = 1
    ou
    positif(CSPROVYH) = 1
    ou
    positif(COD8YL) = 1
    ou
    positif(CSPROVYN) = 1
    ou
    positif(CSPROVYP) = 1
    ou
    positif(COD8YT) = 1
    ou
    positif(CDISPROV) = 1
    ou
    positif(IRANT) = 1
    ou
    positif(CRDSIM) = 1
    ou
    positif(CSGIM) = 1
    ou
    positif(DCSGIM) = 1
    ou
    positif(PRSPROV) = 1)

alors erreur A850 ;
verif corrective 851:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT > 20
   et
   positif(CRDSIM) = 1

alors erreur A851 ;
verif corrective 852:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(CSGIM) = 1
   et
   V_NOTRAIT > 20

alors erreur A852 ;
verif corrective 853:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(PRSPROV) = 1
   et
   V_NOTRAIT > 20

alors erreur A853 ;
verif 858:
application : iliad , batch ;

si
   COD8TL + COD8UW + 0 > 0
   et
   SOMMEA858 = 0

alors erreur A858 ;
verif 859:
application : iliad , batch ;

si
   PRESINTER > 0
   et
   SOMMEA859 = 0

alors erreur A859 ;
verif 862:
application : iliad , batch ;

si
   AUTOVERSLIB > 0
   et
   SOMMEA862 = 0

alors erreur A862 ;
verif corrective 8630:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   positif(AUTOVERSSUP + 0) = 1
   et
   positif(AUTOBICVV + AUTOBICPV + AUTOBNCV
           + AUTOBICVC + AUTOBICPC + AUTOBNCC
           + AUTOBICVP + AUTOBICPP + AUTOBNCP + 0) = 0

alors erreur A863 ;
verif 864:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   COD8YL + 0 > CGLOA + 0

alors erreur A864 ;
verif 865:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   COD8YT + 0 > CVNSALC + 0

alors erreur A865 ;
verif 8661:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYD + 0 > max(0 , RSE1 + PRSE1 - CIRSE1) + 0

alors erreur A86601 ;
verif 8662:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYE + 0 > max(0 , RSE5 + PRSE5 - CIRSE5) + 0

alors erreur A86602 ;
verif 8663:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYF + 0 > max(0 , RSE8TV + arr(max(0 , RSE8TV - CIRSE8TV - CSPROVYF) * TXINT/100) - CIRSE8TV) + 0

alors erreur A86603 ;
verif 8664:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYG + 0 > max(0 , RSE3 + PRSE3 - CIRSE3) + 0

alors erreur A86604 ;
verif 8665:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYH + 0 > max(0 , RSE8TX + arr(max(0 , RSE8TX - CIRSE8TX - CSPROVYH) * TXINT/100) - CIRSE8TX) + 0

alors erreur A86605 ;
verif 8666:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYN + 0 > max(0 , RSE8SA + arr(max(0 , RSE8SA - CIRSE8SA - CSPROVYN) * TXINT/100) - CIRSE8SA) + 0

alors erreur A86606 ;
verif 8667:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   CSPROVYP + 0 > max(0 , RSE8SB + arr(max(0 , RSE8SB - CIRSE8SB - CSPROVYP) * TXINT/100) - CIRSE8SB) + 0

alors erreur A86607 ;
verif 868:
application : batch , iliad ;

si
   V_IND_TRAIT + 0 > 0
   et
   (CDISPROV + 0 > CDIS + 0
    ou
    (positif(CDISPROV + 0) = 1 et positif(GSALV + GSALC + 0) = 0))

alors erreur A868 ;
verif 870:
application : batch , iliad ;

si
   positif(DCSGIM) = 1 
   et 
   positif(CSGIM + 0) != 1
    
alors erreur A870 ;
verif 871:
application : batch , iliad ;

si
   CRDSIM > RDSN

alors erreur A871 ;
verif 872:
application : iliad , batch ;

si
   V_IND_TRAIT + 0 > 0
   et
   PRSPROV > PRS

alors erreur A872 ;
verif 873:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   CSGIM > CSG
    
alors erreur A873 ;
verif 874:
application : iliad , batch ;

si
   IPSOUR >= 0
   et
   V_CNR + 0 = 0
   et
   SOMMEA874 = 0

alors erreur A874 ;
verif 875:
application : iliad , batch ;

si
   max(0 , IRB + TAXASSUR + IPCAPTAXT + TAXLOY + IHAUTREVT + PTOTD
               - IAVT - RCMAVFT - CICA - I2DH - CICORSE - CIRECH - CICAP
               - CICHR - CICULTUR - CREREVET - CIGLO - CIDONENTR) < IRANT

alors erreur A875 ;
verif 877:
application : iliad , batch ;

si
   (IPRECH + 0 > 0 ou IPCHER + 0 > 0)
   et
   SOMMEA877 = 0

alors erreur A877 ;
verif 8781:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(REVCSXA + 0) = 1
   et
   positif(SALECS + 0) = 0

alors erreur A87801 ;
verif 8782:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(REVCSXB + 0) = 1
   et
   positif(SALECSG + 0) = 0

alors erreur A87802 ;
verif 8783:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(REVCSXC + 0) = 1
   et
   positif(ALLECS + 0) = 0

alors erreur A87803 ;
verif 8784:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(REVCSXD + 0) = 1
   et
   positif(INDECS + 0) = 0

alors erreur A87804 ;
verif 8785:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(REVCSXE + 0) = 1
   et
   positif(PENECS + 0) = 0

alors erreur A87805 ;
verif 8786:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(COD8XI + 0) = 1
   et
   positif(COD8SA + 0) = 0

alors erreur A87806 ;
verif 8787:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(COD8XJ + 0) = 1
   et
   positif(COD8SB + 0) = 0

alors erreur A87807 ;
verif 879:
application : iliad , batch ;

si
   CIINVCORSE + CICORSENOW + 0 > 0
   et
   SOMMEA879 = 0

alors erreur A879 ;
verif 880:
application : iliad , batch ;

si
   CRIGA > 0
   et
   SOMMEA880 = 0

alors erreur A880 ;
verif 881:
application : iliad , batch ;

si
   CREFAM > 0
   et
   SOMMEA881 = 0

alors erreur A881 ;
verif 8821:
application : iliad , batch ;

si
  (
   IPMOND > 0
   et
   (present(IPTEFP) = 0 et present(IPTEFN) = 0)
  )
  ou
  (
   (present(IPTEFP) = 1 ou present(IPTEFN) = 1)
   et
   present(IPMOND) = 0
  )

alors erreur A88201 ;
verif 8822:
application : iliad , batch ;

si
   (present(IPMOND)
    + present(SALEXTV) + present(SALEXTC) + present(SALEXT1) + present(SALEXT2) + present(SALEXT3) + present(SALEXT4)
    + present(COD1AH) + present(COD1BH) + present(COD1CH) + present(COD1DH) + present(COD1EH) + present(COD1FH)) = 0
   et
   positif_ou_nul(TEFFHRC + COD8YJ) = 1

alors erreur A88202 ;
verif 883:
application : iliad , batch ;

si
   IPBOCH > 0
   et
   CIIMPPRO + CIIMPPRO2 + REGCI + PRELIBXT + COD8XF + COD8XG + COD8XH + COD8XV + COD8XY + 0 = 0

alors erreur A883 ;
verif 884:
application : iliad , batch ;

si
   REGCI + COD8XY > 0
   et
   SOMMEA884 = 0

alors erreur A884 ;
verif 8851:
application : iliad , batch ;

si
   positif(CIIMPPRO2 + 0) = 1
   et
   present(BPVSJ) = 0

alors erreur A88501 ;
verif 8852:
application : iliad , batch ;

si
   positif(COD8XV + 0) = 1
   et
   present(COD2FA) = 0

alors erreur A88502 ;
verif 8853:
application : iliad , batch ;

si
   positif(CIIMPPRO + 0) = 1
   et
   somme(i=V,C,P:present(BA1Ai) + present(BI1Ai) + present(BN1Ai)) = 0

alors erreur A88503 ;
verif 8854:
application : iliad , batch ;

si
   positif(COD8XF + 0) = 1
   et
   present(BPV18V) + present(BPV18C) = 0

alors erreur A88504 ;
verif 8855:
application : iliad , batch ;

si
   positif(COD8XG + 0) = 1
   et
   present(BPCOPTV) + present(BPCOPTC) = 0

alors erreur A88505 ;
verif 8856:
application : iliad , batch ;

si
   positif(COD8XH + 0) = 1
   et
   present(BPV40V) + present(BPV40C) = 0

alors erreur A88506 ;
verif 886:
application : iliad , batch ;

si
   IPPNCS > 0
   et
   positif(REGCI + CIIMPPRO + CIIMPPRO2 + COD8XV + COD8XF + COD8XG + COD8XH + COD8PA + 0) != 1

alors erreur A886 ;
verif 887:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   REGCI + 0 > IPBOCH + 0

alors erreur A887 ;
verif 888:
application : iliad , batch ;

si
   IPELUS > 0
   et
   positif(present(TSHALLOV) + present(TSHALLOC) + present(CARTSV) + present(CARTSC) + present(CARTSNBAV) + present(CARTSNBAC)) = 0
   et
   positif(present(ALLOV) + present(ALLOC) + present(REMPLAV) + present(REMPLAC) + present(REMPLANBV) + present(REMPLANBC)) = 0

alors erreur A888 ;
verif 889:
application : iliad , batch ;

si
   (APPLI_OCEANS = 0)
   et
   REVFONC + 0 > IND_TDR + 0
   et
   present(IND_TDR) = 0

alors erreur A889 ;
verif 890:
application : iliad , batch ;

si
   CREAPP > 0
   et
   SOMMEA890 = 0

alors erreur A890 ;
verif 891:
application : iliad , batch ;

si
   CREPROSP > 0
   et
   SOMMEA891 = 0

alors erreur A891 ;
verif 893:
application : iliad , batch ;

si
   CREFORMCHENT > 0
   et
   SOMMEA893 = 0

alors erreur A893 ;
verif 894:
application : iliad , batch ;

si
   CREINTERESSE > 0
   et
   SOMMEA894 = 0

alors erreur A894 ;
verif 895:
application : iliad , batch ;

si
   CREAGRIBIO > 0
   et
   SOMMEA895 = 0

alors erreur A895 ;
verif 896:
application : iliad , batch ;

si
   CREARTS > 0
   et
   SOMMEA896 = 0

alors erreur A896 ;
verif 898:
application : iliad , batch ;

si
   CRECONGAGRI > 0
   et
   SOMMEA898 = 0

alors erreur A898 ;
verif 899:
application : iliad , batch ;

si
   CRERESTAU > 0
   et
   SOMMEA899 = 0

alors erreur A899 ;
