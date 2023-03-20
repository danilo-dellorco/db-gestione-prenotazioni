# ================================TABLES=================================#


CREATE SCHEMA ASL;

CREATE TABLE ASL.paziente(
    CF_Paziente CHAR(16) PRIMARY KEY,
    Nome_Paziente VARCHAR (15) NOT NULL,
    Cognome_Paziente VARCHAR (15) NOT NULL,
    Indirizzo VARCHAR (30),
    Luogo VARCHAR (30),
    Data DATE,
    Telefono VARCHAR(10),
    Mail VARCHAR(30),
    Cellulare VARCHAR(10)
    );
    
CREATE TABLE ASL.esame(
    Codice_Esame CHAR(5) PRIMARY KEY,
    Nome_Esame VARCHAR (30) NOT NULL,
    Costo FLOAT NOT NULL
    );
    
CREATE TABLE ASL.prenotazione(
    Codice_Prenotazione CHAR(8) PRIMARY KEY,
    Paziente CHAR(16) NOT NULL,
    FOREIGN KEY (Paziente) REFERENCES ASL.paziente(CF_Paziente) ON DELETE CASCADE ON UPDATE CASCADE
    );

CREATE TABLE ASL.ospedale(
    Codice_Ospedale CHAR(4) PRIMARY KEY,
    Nome_Ospedale VARCHAR(20) NOT NULL,
    Indirizzo VARCHAR(30)
    );
    
CREATE TABLE ASL.reparto(
    Codice_Reparto CHAR(5),
    Ospedale CHAR(4),
    Nome_Reparto VARCHAR(20) NOT NULL,
    Num_Telefono CHAR(10),
    PRIMARY KEY (Codice_Reparto, Ospedale),
    FOREIGN KEY (Ospedale) REFERENCES ASL.ospedale(Codice_Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.medico(
    CF_Medico CHAR(16) PRIMARY KEY,
    Nome_Medico VARCHAR(15) NOT NULL,
    Cognome VARCHAR(15) NOT NULL,
    Indirizzo VARCHAR(30),
    Reparto CHAR(5) NOT NULL,
    Ospedale CHAR(4) NOT NULL,
    FOREIGN KEY (Reparto,Ospedale) REFERENCES ASL.reparto(Codice_Reparto,Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.laboratorio(
    Codice_Laboratorio CHAR(5),
    Ospedale CHAR(4),
    Nome_Laboratorio VARCHAR(25) NOT NULL,
    Piano INT,
    Stanza INT,
    PRIMARY KEY (Codice_Laboratorio, Ospedale),
    FOREIGN KEY (Ospedale) REFERENCES ASL.ospedale(Codice_Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );    

CREATE TABLE ASL.esamereale(
    Cod_Prenotazione CHAR (8),
    Tipo_Esame CHAR(5),
    Data Date,
    Ora TIME,
    Urgenza VARCHAR(15),
    Parametri VARCHAR (30),
    Laboratorio CHAR (5) NOT NULL,
    Ospedale CHAR(4) NOT NULL,
    Medico CHAR (16) NOT NULL,
    Diagnosi VARCHAR (50),
    UNIQUE (Cod_Prenotazione,Tipo_Esame,Data), #un esame non può essere ripetuto nello stesso giorno dallo stesso paziente.
    UNIQUE (Data,Ora,Medico), #un medico non può effettuare due esami contemporaneamente.
    UNIQUE (Data,Ora,Laboratorio,Ospedale), #in un laboratorio non posso effettuare due esami contemporaneamente
    PRIMARY KEY (Cod_Prenotazione, Tipo_Esame, Data, Ora),
    FOREIGN KEY (Cod_Prenotazione) REFERENCES ASL.prenotazione(Codice_Prenotazione) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Laboratorio,Ospedale) REFERENCES ASL.laboratorio(Codice_Laboratorio,Ospedale) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Medico) REFERENCES ASL.medico(CF_Medico) ON DELETE CASCADE ON UPDATE CASCADE
    );

CREATE TABLE ASL.primario(
    CF_Primario CHAR(16) PRIMARY KEY,
    Reparto_Primario CHAR(5) NOT NULL,
    Ospedale CHAR(4) NOT NULL,
    UNIQUE (Reparto_Primario,Ospedale), #un reparto ospedaliero non può avere due o più primari
    FOREIGN KEY (CF_Primario) REFERENCES ASL.medico(CF_Medico) ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (Reparto_Primario,Ospedale) REFERENCES ASL.reparto(Codice_Reparto,Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.volontario(
    CF_Volontario CHAR(16) PRIMARY KEY,
    Associazione VARCHAR(50),
    FOREIGN KEY (CF_Volontario) REFERENCES ASL.medico(CF_Medico) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.specializzazione(
    Nome_Specializzazione VARCHAR(50) PRIMARY KEY
    );

CREATE TABLE ASL.possiede(
    Primario CHAR(16),
    Specializzazione VARCHAR(50),
    PRIMARY KEY (Primario, Specializzazione),
    FOREIGN KEY (Primario) REFERENCES ASL.primario(CF_Primario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Specializzazione) REFERENCES ASL.specializzazione(Nome_Specializzazione) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.responsabilelaboratorio(
    Medico_Responsabile CHAR(16),
    Laboratorio CHAR(5),
    Ospedale CHAR (4),
    UNIQUE (Laboratorio,Ospedale), #un laboratorio deve avere un solo responsabile
    PRIMARY KEY (Medico_Responsabile,Laboratorio,Ospedale),
    FOREIGN KEY (Medico_Responsabile) REFERENCES ASL.medico(CF_Medico) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Laboratorio,Ospedale) REFERENCES ASL.laboratorio(Codice_Laboratorio, Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );
    
CREATE TABLE ASL.responsabileospedale(
    Medico_Responsabile CHAR(16),
    Ospedale CHAR (4) UNIQUE, #un ospedale deve avere un solo responsabile
    PRIMARY KEY (Medico_Responsabile,Ospedale),
    FOREIGN KEY (Medico_Responsabile) REFERENCES ASL.medico(CF_Medico) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Ospedale) REFERENCES ASL.ospedale(Codice_Ospedale) ON DELETE CASCADE ON UPDATE CASCADE
    );










    # ===============================POPULATE================================#


INSERT INTO ASL.paziente
    VALUES ("MNTVTR97T57I493M","Vittoria","Mount","Via scopigliette,21","SCAMPITELLA (AV)","1997-12-17","0775408976","mntvtr97t57i493m@mailstop.it","3311456789"),
    ("RVSNZT92T60I089W","Nunziata","Rivas","Via roma,13","SAN PIETRO AL TANAGRO (SA)","1992-12-20","0311345678","cuchurivas@libero,it","3546756129"),
    ("ZNGSBN98P28I561G","Sabino","Zinghini","via pellicano,23","SECUGNAGO (LO)","1998-09-28","0775678956","sabizinghi@hmail.com","3318978654"),
    ("DNGGDE79R21G943W","Egidio","Donegaglia","via della questura,2","POVE DEL GRAPPA (VI)","1979-10-21","019876546","egidonaga@outlook.com","3771234987"),
    ("DNIDTT79B42G893V","Diletta","Dione","via accorciatoia,27","PORTA CARRATICA (PT)","1979-02-02","0987456734","dnidtt79b42g893v@mailstop.it","3456787432"),
    ("SNNSNN96E52F557A","Osanna","Sannullo","via libertà,13","SANT'ARCANGELO TRIMONTE (BN)","1996-05-12","0812897654","sannullolib@libero.it","3335678342"),
    ("GNSRFL92B09I022L","Raffaele","Giansetto","viale ippocrate,32","SAN MASSIMO (VR)","1992-02-09","0986452314","rafygian@tiscali.it","3456767687"),
    ("CRRCDD69B62G024R","Candida","Carrabotta","via mastruccia,2","OLGIA (NO)","1969-02-22","0956234567","candida69@libero.it","3125676543"),
    ("PTRMRZ85E69H447Q","Marzia","Pietrantoni","via cavour,8","ROCCASPARVERA (CN)","1985-05-29","0775678765","stonemarz@gmail.com","3456123453"),
    ("TRMSNT87B64H597L","Santa","Taramasco","via aldo moro,43","ROVATE (VA)","1987-02-24","0912345323","terasar44@libero.it","3456576879"),
    ("LMBGVF60H44F273C","Genoveffa","Lambagi","via marittima,12","MOIANA (CO)","1960-06-04","0986090807","geno1518@hotmail.it","3314565876"),
    ("DGNDNI78R45G864Y","Diana","Digangi","via aristotele,12","PONTIDA (BG)","1978/10/05","0543564578","digaghana@gmail.com","3459876123"),
    ("MLPLNZ70L24G144J","Lorenzo","Melponti","viale augusto,8","ORTOVERO (SV)","1970-07-24","0555345610","meldru7@tor.it","3934565456"),
    ("SNGLSN48L20E252P","Alessandro","Asnago","via lucciola,2","GUASILA (CA)","1948-07-20","01564532","alemanas1@alice.it","3214593457"),
    ("BRGVLR81B23H064W","Valerio","Borgianini","via tornabene,5","PRIMANO (FM)","1981-02-23","024567865","borgvale@tim.it","3435678123");

INSERT INTO ASL.esame
    VALUES ("01543","Radiografia",30.45), ("76453","TAC",50.12), ("46763","Elettrocardiogramma",65.87), ("34871","Elettroencefalogramma",120.30),
    ("46098","Analisi del Sangue",15.09), ("01009","MOC",45.98), ("02031","PAP-Test",34.65), ("99654","Vaccino",15.14), ("33456","Ecografia",21.65),
    ("30009","Ecodoppler",65.87), ("77001","Gastroscopia",25.65), ("77002","Colonscopia",35.54), ("00123","Analisi Tossicologica",65.23), 
    ("21234","PHmetria",33.43), ("88001","Esame Prostata",12.90), ("12010","Emocromo",7.90), ("33990","Biopsia",72.94);    

INSERT INTO ASL.ospedale
    VALUES ("0423","San Raffaele","Via Polledrara,32"),("8675","San Francesco","Via della ricerca,15"),("9090","Spaziani","Via Armando Fabi,12"),
    ("9231","San Benedetto","Via Chiappitto,32"),("1276","San Giovanni","Via dei tassi,15"),("5510","Umberto I","Via santa cecilia,2"),
    ("0992","San Martino","Via della libertà,5");
   
INSERT INTO ASL.reparto
    VALUES ("00145","0423","Radiologia","0775403124"),("00146","0423","Pronto Soccorso","0775406578"),("00147","0423","Pediatria","0775405690"),
    ("00148","0423","Ortopedia","0775408855"),("00149","0423","Oncologia","0775401143"),("11001","8675","Oculistica","0334608976"),("11002","8675","Cardiologia","0334608811"),
    ("11003","8675","Ortopedia","0334606523"),("11004","8675","Radiologia","0334609965"),("10650","9090","Cardiologia","0265783456"),("10651","9090","Pediatria","0265785690"),
    ("10652","9090","Radiologia","0265785512"),("10653","9090","Gastroenterologia","0265789012"),("55101","9231","Radiologia","0711325678"),("55102","9231","Pediatria","0711325671"),
    ("55103","9231","Oncologia","0711321195"),("55104","9231","Pronto Soccorso","0711322376"),("55105","9231","Oculistica","0711326677"),("55106","9231","Neurologia","0711325512"),
    ("55107","9231","Urologia","0711326610"),("21300","5510","Pediatria","0345651277"),("21301","5510","Radiologia","0345652388"),("21302","5510","Oncologia","0345651092"),
    ("21303","5510","Neurologia","0345655472"),("21504","5510","Oculistica","0345651145"),("21505","5510","Ortopedia","0345654123"),("21506","5510","Odontoiatria","0345652134"),
    ("13130","0992","Radiologia","0980801277"),("13131","0992","Ortopedia","0980807263"),("13132","0992","Oncologia","0980809812"),("13133","0992","Odontoiatria","0980801265"),
    ("13134","0992","Neurologia","0980801265"),("13135","0992","Oculistica","0980801380"),("02200","1276","Pediatria","0140985680"),("02201","1276","Cardiologia","0140986523");
    
INSERT INTO ASL.laboratorio
    VALUES ("05132","0423","Laboratorio di Radiologia","2","8"),("05133","0423","Centro Analisi","3","18"),("05134","0423","Centro Esami","0","4"),
    ("77100","8675","Centro Radiologia","0","7"),("77101","8675","Analisi","2","16"),("77102","8675","Laboratorio Generico","0","4"),
    ("13005","9090","Analisi","3","15"),("13006","9090","Raggi X","2","10"),("13007","9090","Medicina Generale","0","3"),
    ("22880","9231","Lab. Analisi 1","4","40"),("22881","9231","Lab. Radiologia","2","23"),("22882","9231","Lab. Generico 1","0","4"),
    ("22883","9231","Lab. Analisi 2","4","41"),("22884","9231","Lab. Generico 2","0","5"),("03001","1276","Centro Analisi","0","9"),
    ("03002","1276","Laboratorio di Radiologia","2","16"),("03003","1276","Laboratorio Generale","1","12"),("99000","5510","Laboratorio Analisi","2","23"),
    ("99001","5510","Laboratorio di Radiologia","2","24"),("99002","5510","Laboratorio Esami","2","25"),("22110","0992","Analisi","1","15"),
    ("22111","0992","Raggi X","3","32"),("22112","0992","Centro Esami","0","4"); 
    
INSERT INTO ASL.medico
    VALUES ("PCVNDM80B23G969Z","Nicodemo","Pacuvio","Via della libertà,15","00145","0423"),("MTTNSI69L54G051I","Ines","Matteozzi","Viale della repubblica,1","00145","0423"),
    ("RSTNST84L44H358G","Onesta","Rustea","Via polledrara,18","00145","0423"),("CTCDCE73S02G430T","Decio","Coticchia","via scozzarella,7","00146","0423"),
    ("RGNNVS81D57M279N","Nives","Reganati","viale ippocrate,2","00146","0423"),("PCCMRT74R63G515U","Marta","Picicco","via marittima,29","00146","0423"),
    ("FFADGS67A07F839N","Adalgiso","Alafa","via carnevale,16","00147","0423"),("RNZLCA70M15G145C","Alceo","Aranzi","piazza san marco,13","00147","0423"),
    ("PRTPTR68S16F994T","Pietro","Pratesi","Via sant'anna","00147","0423"),("GRSFRC84R56H397U","Federica","Grossole","via braga,11","00147","0423"),
    ("FRCLVE67D48F859G","Elvia","Fracelio","via della carta,18","00148","0423"),("FSCGZE64B41F556A","Egizia","Fasce","via cavour,3","00148","0423"),
    ("SNGMHL76R30G693W","Michele","Sangemi","via mastruccia,12","00149","0423"),("SGMCRI67T01F919I","Ciro","Sigimbosco","via aldo moro,2","00149","0423"),
    ("RCTNLL72T64G352T","Novella","Ricetti","via della cultura,19","11001","8675"),("ZPPVVN68A30F934V","Viviano","Zappellini","Via cicogna,4","11001","8675"),
    ("MRRLDI68D43F946Z","Ilda","Marrancone","viale cesare,7","11002","8675"),("CHNLEO68H12F966D","Leo","Cheni","via eduardo de filippo,5","11002","8675"),
    ("PPCLNU81M60H100X","Luna","Papucci","via vittorio de sica,4","11003","8675"),("SCRBFC64L18F607O","Bonifacio","Scarpante","via santa cecilia,16","11003","8675"),
    ("CNTBGI80M24H016Y","Biagio","Caonetto","via danimarca,11","11004","8675"),("NLLGTN69P53G067H","Agostina","Anellucci","via roma,4","11004","8675"),
    ("SBESDR66B07F761A","Sandro","Seba","via sanremo,18","10650","9090"),("MTTTLN59B44F156R","Teolinda","Mattacheo","viale maramao,5","10650","9090"),
    ("ZNZZNE65M28F722O","Zeno","Zuanazzi","via preziosi,5","10651","9090"),("SNDBRT62M63F626P","Berta","Sandor","via santa colomba,5","10651","9090"),
    ("NNFLNI78A48G794T","Lina","Nunfris","via fogli,11","10651","9090"),("MMNSVR69C28G026N","Severo","Ammanato","via lucciola,6","10652","9090"),
    ("LVRGNI62E22F488L","Igino","Levorin","via vortice,5","10652","9090"),("FRDFDL67S18F915Y","Fedele","Fredo","via del cane,13","10653","9090"),
    ("LCRDLM68A19F932J","Adelmo","Alcuri","via santa colomba,7","55101","9231"),("GRSFRZ74M52G496O","Fabrizia","Gorospe","via armando fabi,7","55101","9231"),
    ("GLLRSL80A70G963I","Ersilia","Gellini","Via della scienza,5","55102","9231"),("MRTLNI68L68F976G","Ilenia","Martusciello","via colle traiano","55102","9231"),
    ("NCLMZU77T20G789S","Muzio","Nocellese","viale dello sport,6","55102","9231"),("FRBRMS83D18H250U","Ermes","Farabbi","via della ricerca,9","55103","9231"),
    ("MBRLVC78S50G869P","Ludovica","Ombroneschi","via del mare,8","55103","9231"),("TLLTDR74L17G489D","Teodoro","Tellona","via marco polo,19","55104","9231"),
    ("TRZSST54M42E769N","Sebastiana","Terzic","via moratti,15","55104","9231"),("BNCMSA76S12G697A","Amos","Bencresciuto","via novella,20","55104","9231"),
    ("FRNLSE66A61F757T","Elisa","Frinu","via popolare,11","55105","9231"),("DPTDDR58L70F111Y","Desideria","De Pietro","via platone,4","55105","9231"),
    ("NPTMHL76P24G684I","Michele","Nepitali","via tornabene,9","55106","9231"),("MRCGNZ67M54F890X","Ignazia","Marcino","via della cultura,9","55106","9231"),
    ("CRNCDD65D46F686N","Candida","Carniselli","via milano,6","55107","9231"),("RBLPRM56L04E932J","Primo","Rabelli","via dei tassi,6","21300","5510"),
    ("PLCMNC69R60G076R","Monica","Pulcinari","via delle segrete,7","21300","5510"),("TRVDBR57A41E977F","Debora","Trevisoli","via accorciatoia,21","21300","5510"),
    ("RPMNCC59C64F169F","Nuccia","Ripamonti","via maremma,14","21301","5510"),("LCCMLE83E44H253V","Emilia","Lucci","via porta nuova,12","21301","5510"),
    ("MRMGNS69E44G036M","Agnese","Amrami","viale italia,14","21302","5510"),("GRNFRZ74M49G495J","Fabrizia","Gorner","via siracusa,4","21302","5510"),
    ("MSTTEA58R55F129X","Tea","Mastrobiso","via paciotti,8","21303","5510"),("ZNDVGL67R56F906Z","Virgilia","Zandigiacomo","via gaucci,8","21303","5510"),
    ("VRCLVO83R66H296Y","Olivia","Vercellono","Via Chiappitto,9","21504","5510"),("RBLQNT71T23G263D","Quinto","Rebellati","via pepe,31","21504","5510"),
    ("RPPMSM74E23G475G","Massimiliano","Roppo","via conte,6","21505","5510"),("GLLFRM69L09G050N","Fermo","Gallichi","via salina,21","21505","5510"),
    ("CVGCMR66S50F823U","Casimira","Cavigliani","via cristianesimo,5","21506","5510"),("MNTMRA73S24G434F","Mario","Monterenzi","via padova,7","21506","5510"),
    ("LTRFTT55H63E841O","Fioretta","Ielitro","via imperiale,14","13130","0992"),("LBZGIO63D65F487U","Gioia","Lebez","via del mare,17","13130","0992"),
    ("GLNGTN65L13F710F","Gastone","Gualina","Via montemario,8","13131","0992"),("MNDGLL66M51F802C","Guglielma","Mandalino","viale del mercato,12","13131","0992"),
    ("PRGPTR68R16F990I","Pietro","Paglioli","viale degli ulivi,16","13132","0992"),("SCHLRN79E59G906K","Lorena","Schoss","via della pace, 1","13132","0992"),
    ("CHRCTN69D10G030P","Costante","Chirigoni","Via akihabara,12","13133","0992"),("BDSDNT60E16F267D","Donetta","Baldassarre","via coinciliazione,12","13133","0992"),
    ("PGLLRC69T48G089B","Alberica","Pagliucci","via del martire,1","13134","0992"),("BRBTTL63B12F464K","Attilio","Breber","via mastruccia,19","13134","0992"),
    ("NZZLTZ76H61G663Q","Letizia","Nazzarelli","viale innocenzo,17","13135","0992"),("LNTLDE84A66H317A","Elda","Lanteri","via borsellino,32","13135","0992"),
    ("GDDNZE45R41E006H","Enza","Gadda","viale ippocrate,17","02200","1276"),("PRRMMM68H50F964B","Mimma","Porriello","via bitta,16","02201","1276");
    
INSERT INTO ASL.specializzazione
    VALUES ("Logopedia"),("Chirurgia Vascolare‎"),("Medicina legale‎"),("Ortopedia"),("Dermatologia"),("Epidemiologia‎"),("Odontoiatria"),("Neuroscienze"),("Traumatologia‎"),
    ("Cardiologia‎"),("Cardiochirurgia"),("Medicina sportiva"),("Pediatria‎"),("Infettivologia‎"),("Dietetica"),("Igiene e medicina preventiva"),("Neuroriabilitazione"),
    ("Endocrinologia‎"),("Reumatologia‎");
    
INSERT INTO ASL.prenotazione
    VALUES ("00000000","MNTVTR97T57I493M"),("00000001","RVSNZT92T60I089W"),("00000002","ZNGSBN98P28I561G"),("00000003","DNGGDE79R21G943W"),
    ("00000004","DNIDTT79B42G893V"),("00000005","SNNSNN96E52F557A"),("00000006","GNSRFL92B09I022L"),("00000007","CRRCDD69B62G024R"),("00000008","PTRMRZ85E69H447Q"),
    ("00000010","TRMSNT87B64H597L"),("00000011","LMBGVF60H44F273C"),("00000012","DGNDNI78R45G864Y"),("00000013","MLPLNZ70L24G144J"),("00000014","SNGLSN48L20E252P"),
    ("00000016","CRRCDD69B62G024R"),("00000017","BRGVLR81B23H064W"),("00000018","DNIDTT79B42G893V"),("00000019","SNGLSN48L20E252P"),("00000020","MNTVTR97T57I493M"),
    ("00000022","BRGVLR81B23H064W"),("00000023","GNSRFL92B09I022L"),("00000024","TRMSNT87B64H597L"),("00000025","RVSNZT92T60I089W"),("00000026","GNSRFL92B09I022L"),
    ("00000009","BRGVLR81B23H064W"),("00000015","RVSNZT92T60I089W"),("00000021","DNGGDE79R21G943W"),("00000027","LMBGVF60H44F273C"),("00000028","TRMSNT87B64H597L");
    
INSERT INTO ASL.esamereale
    VALUES ("00000000","77001","2019-03-21","15:30","codice bianco","a5iu8f34gh7g","05132","0423","NCLMZU77T20G789S","parametri ok"),
    ("00000001","33990","2019-05-12","12:00","codice verde","s6jh32jv4g9","22883","9231","RSTNST84L44H358G","NULL"),
    ("00000002","46098","2018-12-06","14:00","codice giallo","kdne7skn3","22883","9231","GLNGTN65L13F710F","riscontrata patologia, necessari ulteriori esami"),
    ("00000003","01543","2019-10-08","09:30","codice verde","dj238fjcsad","13007","9090","FFADGS67A07F839N","parametri ok"),
    ("00000004","76453","2019-03-01","11:30","codice rosso","d39jc8hf8a0","99002","5510","LVRGNI62E22F488L","NULL"),
    ("00000005","21234","2018-02-14","09:45","codice verde","a34ng83nfas","13007","9090","NCLMZU77T20G789S","nessun problema riscontrato"),
    ("00000006","34871","2018-01-05","10:15","codice verde","c9wnf73nfda9","22883","9231","LVRGNI62E22F488L","necessario un intervento specifico"),
    ("00000007","76453","2017-12-01","16:05","codice giallo","c83hdfaijf93","77102","8675","RSTNST84L44H358G","NULL"),
    ("00000008","02031","2018-06-13","18:00","codice verde","f39hdfa8hf3oi","13007","9090","GLNGTN65L13F710F","riscontrato un problema,necessario intervento"),
    ("00000009","33990","2016-05-09","12:10","codice giallo","gfh83ha9f0k5","22883","9231","NCLMZU77T20G789S","nessun problema rilevato"),
    ("00000010","02031","2019-07-10","08:15","codice giallo","h38hv8as9","03003","1276","FFADGS67A07F839N","NULL"),
    ("00000011","33456","2018-02-06","07:30","codice rosso","cn983hfda93","22883","9231","FRCLVE67D48F859G","nessun problema,ma consigliata ulteriore visita"),
    ("00000012","01543","2015-04-09","14:30","codice verde","dfh3jfaw303","13005","9090","SBESDR66B07F761A","NULL"),
    ("00000013","77001","2015-12-14","12:45","codice bianco","fh39fj93jfi","03003","1276","CRNCDD65D46F686N","necessaria una radiografia"),
    ("00000014","46098","2018-02-14","15:00","codice giallo","df3fjh9hj3jg","77100","8675","MSTTEA58R55F129X","NULL"),
    ("00000015","46763","2019-03-23","08:15","codice bianco","djh3jv9sedj3","22112","0992","MSTTEA58R55F129X","NULL"),
    ("00000016","21234","2019-05-07","12:10","codice rosso","ffh3jhf9as3jg9","05134","0423","MRMGNS69E44G036M","NULL"),
    ("00000017","02031","2010-09-14","15:30","codice giallo","fn3nfiasdjf33","22112","0992","SBESDR66B07F761A","NULL"),
    ("00000018","33456","2018-02-28","08:15","codice giallo","mbnf239f94hf8","77102","8675","PRTPTR68S16F994T","riscontrati valori anomali"),
    ("00000019","46763","2012-06-09","18:00","codice bianco","mdfb83fa9034f","13005","9090","MSTTEA58R55F129X","valori nella norma"),
    ("00000020","77001","2011-12-31","12:00","codice rosso","bnndsfj308gth","03003","1276","MRMGNS69E44G036M","NULL"),
    ("00000021","00123","2016-09-16","09:30","codice bianco","bnwsnf93ah8hg","13006","9090","MSTTEA58R55F129X","consigliata cura riabilitativa"),
    ("00000022","01543","2018-02-09","15:30","codice bianco","bmfn98h38hfaf","05133","0423","NCLMZU77T20G789S","NULL"),
    ("00000023","46098","2013-05-08","09:30","codice rosso","mfan398nfs9u","13005","9090","LCRDLM68A19F932J","condigliato ulteriore controllo medico"),
    ("00000024","33456","2016-07-11","09:30","codice giallo","fn8sadherw8h","05134","0423","MSTTEA58R55F129X","parametri regolari"),
    ("00000025","77001","2015-10-15","12:10","codice bianco","jg9j943j9ejf9j","77102","8675","FRCLVE67D48F859G","nessuna patologia rilevata"),
    ("00000026","30009","2019-05-07","12:00","codice bianco","gnwehr8jas3fg","05132","0423","SBESDR66B07F761A","NULL"),
    ("00000027","34871","2016-05-09","18:00","codice verde","dwenmr3jn8fdyg","77100","8675","CRNCDD65D46F686N","controllo ok"),
    ("00000028","30009","2016-05-09","15:30","codice verde","dingbnb49df84j","22112","0992","MSTTEA58R55F129X","NULL"),
    ("00000012","01009","2018-02-11","12:10","codice rosso","bbba3h8fh834","05133","0423","PLCMNC69R60G076R","nessun problema rilevato"),
    ("00000009","88001","2019-05-11","08:15","codice verde","mjqa938gydfg34","77101","8675","PRTPTR68S16F994T","NULL"),
    ("00000019","01009","2019-05-07","12:00","codice verde","z934j988fj84hg","22883","9231","MBRLVC78S50G869P","NULL"),
    ("00000007","30009","2018-02-18","18:00","codice verde","ogjioj49fds873","77101","8675","LCRDLM68A19F932J","NULL"),
    ("00000028","34871","2019-05-01","15:30","codice giallo","m876fdhf934fj9","05132","0423","PLCMNC69R60G076R","NULL"),
    ("00000021","88001","2018-08-01","09:30","codice verde","j834hfj93fdsf0e","77100","8675","PRTPTR68S16F994T","parametri regolari"),
    ("00000020","33456","2017-03-04","10:15","codice giallo","564fg34rtg6hj6","22112","0992","FRCLVE67D48F859G","consigliata una ulteriore visita"),
    ("00000000","02031","2016-09-18","15:00","codice bianco","d3dasfg45ytgs3","03003","1276","GLNGTN65L13F710F","nessun problema"),
    ("00000000","46098","2015-05-21","12:00","codice bianco","bv4trws34sdcg4","13007","9090","CHRCTN69D10G030P","diagnosticata patologia"),
    ("00000001","33456","2014-12-31","08:15","codice giallo","dcv43w5tsg546y","99002","5510","PRTPTR68S16F994T","NULL"),
    ("00000008","46763","2013-08-09","08:15","codice verde","cv4fgt32rfatgy4","77100","8675","GLLRSL80A70G963I","necessario ulteriore controllo"),
    ("00000008","46098","2012-09-11","12:00","codice rosso","bvrty4w5wsr3234f","03003","1276","PRTPTR68S16F994T","rilevato problema"),
    ("00000009","02031","2011-01-10","09:30","codice giallo","cvvgh432wfr3234","13005","9090","FRCLVE67D48F859G","NULL"),
    ("00000015","88001","2010-04-12","08:15","codice bianco","dgf3raf4rteytsdg","22112","0992","GLLRSL80A70G963I","nessun problema rilevato"),
    ("00000012","46763","2018-10-13","09:30","codice verde","f3fadf45w56dsft4","13007","9090","RCTNLL72T64G352T","necessario ulteriore controllo");

INSERT INTO ASL.primario
    VALUES ("MTTNSI69L54G051I","00145","0423"),("RGNNVS81D57M279N","00146","0423"),("GRSFRC84R56H397U","00147","0423"),("FSCGZE64B41F556A","00148","0423"),
    ("SNGMHL76R30G693W","00149","0423"),("ZPPVVN68A30F934V","11001","8675"),("MRRLDI68D43F946Z","11002","8675"),("PPCLNU81M60H100X","11003","8675"),
    ("NLLGTN69P53G067H","11004","8675"),("SBESDR66B07F761A","10650","9090"),("NNFLNI78A48G794T","10651","9090"),("MMNSVR69C28G026N","10652","9090"),
    ("FRDFDL67S18F915Y","10653","9090"),("LCRDLM68A19F932J","55101","9231"),("MRTLNI68L68F976G","55102","9231"),("FRBRMS83D18H250U","55103","9231"),
    ("TRZSST54M42E769N","55104","9231"),("FRNLSE66A61F757T","55105","9231"),("NPTMHL76P24G684I","55106","9231"),("CRNCDD65D46F686N","55107","9231"),
    ("PLCMNC69R60G076R","21300","5510"),("LCCMLE83E44H253V","21301","5510"),("GRNFRZ74M49G495J","21302","5510"),("MSTTEA58R55F129X","21303","5510"),
    ("VRCLVO83R66H296Y","21504","5510"),("RPPMSM74E23G475G","21505","5510"),("MNTMRA73S24G434F","21506","5510"),("LBZGIO63D65F487U","13130","0992"),
    ("MNDGLL66M51F802C","13131","0992"),("PRGPTR68R16F990I","13132","0992"),("CHRCTN69D10G030P","13133","0992"),("PGLLRC69T48G089B","13134","0992"),
    ("NZZLTZ76H61G663Q","13135","0992"),("GDDNZE45R41E006H","02200","1276"),("PRRMMM68H50F964B","02201","1276");
    
INSERT INTO ASL.possiede
    VALUES ("MTTNSI69L54G051I","Cardiochirurgia"),("MTTNSI69L54G051I","Cardiologia"),("RGNNVS81D57M279N","Odontoiatria"),("GRSFRC84R56H397U","Ortopedia"),
    ("FSCGZE64B41F556A","Reumatologia"),("FSCGZE64B41F556A","Medicina Sportiva"),("SNGMHL76R30G693W","Neuroscienze"),("ZPPVVN68A30F934V","Dietetica"),
    ("MRRLDI68D43F946Z","Dermatologia"),("MRRLDI68D43F946Z","Chirurgia Vascolare"),("PPCLNU81M60H100X","Cardiologia"),("NLLGTN69P53G067H","Odontoiatria"),
    ("SBESDR66B07F761A","Cardiochirurgia"),("NNFLNI78A48G794T","Dermatologia"),("NNFLNI78A48G794T","Igiene e medicina preventiva"),("MMNSVR69C28G026N","Pediatria"),
    ("FRDFDL67S18F915Y","Reumatologia"),("LCRDLM68A19F932J","Infettivologia"),("MRTLNI68L68F976G","Cardiologia"),("FRBRMS83D18H250U","Logopedia"),
    ("TRZSST54M42E769N","Dietetica"),("FRNLSE66A61F757T","Traumatologia"),("NPTMHL76P24G684I","Logopedia"),("CRNCDD65D46F686N","Infettivologia"),
    ("PLCMNC69R60G076R","Reumatologia"),("LCCMLE83E44H253V","Medicina Sportiva"),("LCCMLE83E44H253V","Cardiologia"),("GRNFRZ74M49G495J","Dermatologia"),
    ("MSTTEA58R55F129X","Logopedia"),("VRCLVO83R66H296Y","Pediatria"),("RPPMSM74E23G475G","Chirurgia Vascolare"),("MNTMRA73S24G434F","Dietetica"),
    ("MNTMRA73S24G434F","Cardiologia"),("LBZGIO63D65F487U","Pediatria"),("MNDGLL66M51F802C","Reumatologia"),("PRGPTR68R16F990I","Medicina Sportiva"),
    ("CHRCTN69D10G030P","Dermatologia"),("PGLLRC69T48G089B","Reumatologia"),("PGLLRC69T48G089B","Dermatologia"),("NZZLTZ76H61G663Q","Logopedia"),
    ("GDDNZE45R41E006H","Pediatria"),("PRRMMM68H50F964B","Cardiologia");
    
INSERT INTO ASL.volontario
    VALUES ("SNDBRT62M63F626P","Croce Rossa Italiana"),("PCCMRT74R63G515U","AVIS"),("LVRGNI62E22F488L","ANPAS"),("GLLRSL80A70G963I","AVER"),
    ("RPMNCC59C64F169F","Associazione Italiana Volontari"),("BRBTTL63B12F464K","SILOE");
    
INSERT INTO ASL.responsabilelaboratorio
    VALUES ("RSTNST84L44H358G","05132","0423"),("CTCDCE73S02G430T","05133","0423"),("RNZLCA70M15G145C","05134","0423"),("FRCLVE67D48F859G","77100","8675"),
    ("SGMCRI67T01F919I","77101","8675"),("PPCLNU81M60H100X","77102","8675"),("SBESDR66B07F761A","13005","9090"),("ZNZZNE65M28F722O","13006","9090"),
    ("MMNSVR69C28G026N","13007","9090"),("GLLRSL80A70G963I","22880","9231"),("FRBRMS83D18H250U","22881","9231"),("TLLTDR74L17G489D","22882","9231"),
    ("FRNLSE66A61F757T","22883","9231"),("NPTMHL76P24G684I","22884","9231"),("RPPMSM74E23G475G","03001","1276"),("LBZGIO63D65F487U","03002","1276"),
    ("CHRCTN69D10G030P","03003","1276"),("RBLQNT71T23G263D","99000","5510"),("TRVDBR57A41E977F","99001","5510"),("NPTMHL76P24G684I","99002","5510"),
    ("TLLTDR74L17G489D","22110","0992"),("MMNSVR69C28G026N","22111","0992"),("CTCDCE73S02G430T","22112","0992");

INSERT INTO ASL.responsabileospedale
    VALUES ("FRCLVE67D48F859G","0423"),("MRRLDI68D43F946Z","8675"),("FRDFDL67S18F915Y","9090"),("MRTLNI68L68F976G","9231"),
    ("PRRMMM68H50F964B","1276"),("GRNFRZ74M49G495J","5510"),("CHRCTN69D10G030P","0992");










    # ===========================STORED PROCEDURES===========================#


# Operazioni sui Pazienti

CREATE PROCEDURE ASL.paziente_cerca (IN CodiceFiscale CHAR(16))
SELECT *
FROM ASL.paziente
WHERE CF_Paziente = CodiceFiscale;

CREATE PROCEDURE ASL.mostra_pazienti ()
SELECT *
FROM ASL.paziente;

CREATE PROCEDURE ASL.paziente_aggiungi (IN CF CHAR(16), IN nome VARCHAR(15), IN cognome VARCHAR(15),IN indirizzo VARCHAR(30),IN Luogo VARCHAR(30),IN data DATE, IN Telefono VARCHAR(10),IN Mail VARCHAR(30),IN Cellulare VARCHAR(10)) #aggiunge un paziente al DB
INSERT INTO ASL.paziente 
VALUES (CF,nome,cognome,indirizzo,luogo,data,telefono,mail,cellulare);

CREATE PROCEDURE ASL.paziente_cancella(IN CF CHAR(16)) #cancella un paziente dal DB
DELETE FROM ASL.paziente
WHERE CF_paziente = CF;

CREATE PROCEDURE ASL.paziente_modifica (IN CF CHAR(16),IN n_indirizzo VARCHAR(30), IN n_Telefono VARCHAR(10),IN n_Mail VARCHAR(30),IN n_Cellulare VARCHAR(10))
UPDATE ASL.paziente
SET Indirizzo = n_indirizzo,
    Telefono = n_Telefono,
    Mail = n_Mail,
    Cellulare = n_cellulare
WHERE CF = CF_Paziente;






# Operazioni sulle Prenotazioni degli esami

CREATE PROCEDURE ASL.prenotazione_aggiungi (IN cod_prenotazione CHAR(8),IN cf_paziente CHAR(16))
INSERT INTO ASL.prenotazione
VALUES (cod_prenotazione,cf_paziente);

CREATE PROCEDURE ASL.prenotazione_cancella (IN cod_prenot CHAR(8))
DELETE FROM ASL.prenotazione
WHERE Codice_Prenotazione=cod_prenot;

CREATE PROCEDURE ASL.mostra_prenotazioni ()
SELECT *
FROM ASL.prenotazione ORDER BY Codice_Prenotazione;

CREATE PROCEDURE ASL.esamereale_aggiungi (IN cod_prenot CHAR(8), cod_esame CHAR (5), data DATE, ora TIME, urgenza VARCHAR(15), parametri VARCHAR(30), laboratorio CHAR(5), ospedale CHAR(4), medico CHAR(16), diagnosi VARCHAR(50)) #aggiunge  un esame reale relativo ad una prenotazione
INSERT INTO ASL.esamereale
VALUES (cod_prenot,cod_esame,data,ora,urgenza,parametri,laboratorio,ospedale,medico,diagnosi);

CREATE PROCEDURE ASL.esamereale_cancella (IN cod_prenot CHAR(8), cod_esame CHAR (5), data_ DATE, ora_ TIME)
DELETE FROM ASL.esamereale
WHERE (cod_prenot,cod_esame,data_,ora_) = (Cod_Prenotazione,tipo_esame,data,ora);

CREATE PROCEDURE ASL.esamereale_modifica_data (IN cod_prenot CHAR(8), IN esame CHAR(5),IN data DATE,IN ora TIME, nuova_data DATE, nuova_ora TIME)
UPDATE ASL.esamereale
SET data = nuova_data,
    ora = nuova_ora
WHERE (Cod_Prenotazione,Tipo_Esame,Data,Ora) = (cod_prenot,esame,data,ora);

CREATE PROCEDURE ASL.esamereale_inserisci_diagnosi (IN cod_prenot CHAR(8), cod_esame CHAR (5), data DATE, ora TIME, IN nuovi_parametri VARCHAR(30), IN nuova_diagnosi VARCHAR(50))
UPDATE ASL.esamereale
SET parametri = nuovi_parametri,
    diagnosi = nuova_diagnosi
WHERE (Cod_Prenotazione,Tipo_Esame,Data,Ora) = (cod_prenot,cod_esame,data,ora);

CREATE PROCEDURE ASL.esamereale_cerca (IN cod_prenot CHAR(8), cod_esame CHAR (5), data_ DATE, ora_ TIME)
SELECT Codice_Prenotazione AS Codice,Paziente,Tipo_Esame,Data,Ora,Urgenza,Parametri,Laboratorio,Ospedale,Medico,Diagnosi
FROM ASL.esamereale JOIN ASL.prenotazione ON esamereale.Cod_Prenotazione = prenotazione.Codice_Prenotazione
WHERE (cod_prenot,cod_esame,data,ora) = (Cod_Prenotazione,Tipo_Esame,Data,Ora);

CREATE PROCEDURE ASL.mostra_esamireali ()
SELECT Codice_Prenotazione AS Codice,Paziente,Tipo_Esame,Data,Ora,Urgenza,Parametri,Laboratorio,Ospedale,Medico,Diagnosi
FROM ASL.esamereale JOIN ASL.prenotazione ON esamereale.Cod_Prenotazione = prenotazione.Codice_Prenotazione;





# Operazioni sugli Esami disponibili

CREATE PROCEDURE ASL.esame_aggiungi (IN cod_esame CHAR(5), IN nome_esame VARCHAR(30), costo FLOAT)
INSERT INTO ASL.esame
VALUES (cod_esame,nome_esame,costo);

CREATE PROCEDURE ASL.esame_cancella (IN cod_esame CHAR(5))
DELETE FROM ASL.esame
WHERE Codice_Esame = cod_esame;

CREATE PROCEDURE ASL.esame_modifica (IN cod_esame CHAR(5), IN nuovo_codice CHAR(5), IN nuovo_nome VARCHAR(30), IN nuovo_costo FLOAT)
UPDATE ASL.esame
SET codice_esame = nuovo_codice,nome_esame = nuovo_nome,costo = nuovo_costo
WHERE Codice_Esame = cod_esame;

CREATE PROCEDURE ASL.esame_cerca (IN cod_esame CHAR(5))
SELECT *
FROM ASL.esame
WHERE cod_esame = Codice_Esame;

CREATE PROCEDURE ASL.mostra_esami ()
SELECT *
FROM ASL.esame;





# Operazioni sugli Ospedali

CREATE PROCEDURE ASL.ospedale_aggiungi (IN cod_osp CHAR(4), IN nome_osp VARCHAR(20), IN indirizzo VARCHAR(30))
INSERT INTO ASL.ospedale
VALUES (cod_osp,nome_osp,indirizzo);

CREATE PROCEDURE ASL.ospedale_cancella (IN cod_osp CHAR(4))
DELETE FROM ASL.ospedale
WHERE Codice_Ospedale = cod_osp;

CREATE PROCEDURE ASL.ospedale_cerca (IN cod_osp CHAR(4))
SELECT *
FROM ASL.ospedale
WHERE Codice_Ospedale = cod_osp;

CREATE PROCEDURE ASL.mostra_ospedali()
SELECT Codice_Ospedale AS Codice,Nome_Ospedale AS Nome,Indirizzo,Medico_Responsabile AS Responsabile
FROM ASL.ospedale
JOIN ASL.responsabileospedale ON ospedale.Codice_Ospedale = responsabileospedale.Ospedale;

CREATE PROCEDURE ASL.ospedale_modifica (IN cod_osp CHAR(4), IN nuovo_codice CHAR(4),IN nuovo_nome VARCHAR(20), IN nuovo_indirizzo VARCHAR(30))
UPDATE ASL.ospedale
SET Codice_Ospedale = nuovo_codice, Nome_Ospedale = nuovo_nome, Indirizzo = nuovo_indirizzo
WHERE Codice_Ospedale = cod_osp;





# Operazioni sui Laboratori

CREATE PROCEDURE ASL.laboratorio_aggiungi (IN cod_lab CHAR(5), IN cod_osp CHAR(4), IN nome VARCHAR(25), IN piano INT, IN stanza INT)
INSERT INTO ASL.laboratorio
VALUES (cod_lab,cod_osp,nome,piano,stanza);

CREATE PROCEDURE ASL.laboratorio_cancella (IN cod_lab CHAR(5), IN cod_osp CHAR(4))
DELETE FROM ASL.laboratorio
WHERE (Codice_Laboratorio,Ospedale) = (cod_lab,cod_osp);

CREATE PROCEDURE ASL.laboratorio_cerca (IN cod_lab CHAR(5), IN cod_osp CHAR(4))
SELECT *
FROM ASL.laboratorio
WHERE (Codice_Laboratorio,Ospedale) = (cod_lab,cod_osp);

CREATE PROCEDURE ASL.mostra_laboratori()
SELECT Codice_Laboratorio AS Laboratorio,laboratorio.Ospedale AS Ospedale,Nome_Laboratorio AS Nome,Piano,Stanza,Medico_Responsabile AS Responsabile
FROM ASL.laboratorio
JOIN ASL.responsabilelaboratorio ON laboratorio.Codice_Laboratorio = responsabilelaboratorio.Laboratorio
AND laboratorio.Ospedale = responsabilelaboratorio.Ospedale;

CREATE PROCEDURE ASL.laboratorio_modifica (IN cod_lab CHAR(5), IN cod_osp CHAR(4), IN nuovo_lab CHAR(5), IN nuovo_osp CHAR(4), IN nuovo_nome VARCHAR(25), IN nuovo_piano INT, IN nuova_stanza INT)
UPDATE ASL.laboratorio
SET Codice_Laboratorio = nuovo_lab,
    Ospedale = nuovo_osp,
    Nome_Laboratorio = nuovo_nome,
    Piano = nuovo_piano,
    Stanza = nuova_stanza
WHERE (Codice_Laboratorio,Ospedale) = (cod_lab,cod_osp);





# Operazioni sui Medici

CREATE PROCEDURE ASL.medico_aggiungi (IN cod_medico CHAR(16), nome_medico VARCHAR(15), cognome_medico VARCHAR(15), indirizzo VARCHAR(30), IN reparto CHAR(5),IN ospedale CHAR(4))
INSERT INTO ASL.medico
VALUES (cod_medico,nome_medico,cognome_medico,indirizzo,reparto,ospedale);

CREATE PROCEDURE ASL.medico_cancella (IN cod_medico CHAR(16))
DELETE FROM ASL.medico
WHERE CF_Medico = cod_medico;

CREATE PROCEDURE ASL.medico_modifica (IN cod_medico CHAR(16), nuovo_indirizzo VARCHAR(30), IN nuovo_reparto CHAR(5),IN nuovo_ospedale CHAR(4))
UPDATE ASL.medico
SET Indirizzo = nuovo_indirizzo,
    Reparto = nuovo_reparto,
    Ospedale = nuovo_ospedale
WHERE CF_Medico = cod_medico;

CREATE PROCEDURE ASL.nomina_resp_osp (IN cod_medico CHAR(16),IN ospedale CHAR(4))
INSERT INTO ASL.responsabileospedale
VALUES (cod_medico,ospedale);

CREATE PROCEDURE ASL.nomina_resp_lab (IN cod_medico CHAR(16), IN laboratorio CHAR(5), IN ospedale CHAR(4))
INSERT INTO ASL.responsabilelaboratorio
VALUES (cod_medico,laboratorio,ospedale);

CREATE PROCEDURE ASL.medico_cerca (IN cod_medico CHAR(16))
SELECT *
FROM ASL.medico
WHERE CF_Medico = cod_medico;

CREATE PROCEDURE ASL.mostra_medici ()
SELECT *
FROM ASL.medico;





# Operazioni sui Primari

CREATE PROCEDURE ASL.nomina_primario (IN cod_medico CHAR(16))
INSERT INTO ASL.primario (CF_Primario,Reparto_Primario,Ospedale)
SELECT CF_Medico,Reparto,Ospedale
FROM ASL.medico
WHERE CF_Medico = cod_medico;

CREATE PROCEDURE ASL.rimuovi_primario (IN cod_primario CHAR(16))
DELETE FROM ASL.primario
WHERE cod_primario = CF_Primario;

CREATE PROCEDURE ASL.nuova_specializzazione (IN nome VARCHAR(50))
INSERT INTO ASL.specializzazione (Nome_Specializzazione)
VALUES (nome);

CREATE PROCEDURE ASL.mostra_specializzazioni ()
SELECT *
FROM ASL.specializzazione;

CREATE PROCEDURE ASL.primario_agg_spec(IN CF_primario CHAR(16),IN spec VARCHAR(50))
INSERT INTO ASL.possiede
VALUES (CF_primario,spec);

CREATE PROCEDURE ASL.primario_rim_spec(IN CF_primario CHAR(16),IN spec VARCHAR(50))
DELETE FROM ASL.possiede
WHERE (CF_primario,spec) = (Primario,Specializzazione);

CREATE PROCEDURE ASL.primario_cerca (IN CodiceFiscale CHAR(16))
SELECT CF_Primario,Nome_Medico,Cognome,Indirizzo,medico.Reparto,medico.Ospedale 
FROM ASL.primario
    JOIN ASL.medico ON primario.CF_Primario = medico.CF_Medico
WHERE CodiceFiscale = CF_Primario;

CREATE PROCEDURE ASL.mostra_primari ()
SELECT CF_Primario,Nome_Medico,Cognome,Indirizzo,medico.Reparto,medico.Ospedale
FROM ASL.primario
    JOIN ASL.medico ON primario.CF_Primario = medico.CF_Medico;
    
CREATE PROCEDURE ASL.primario_mostra_spec (IN CF CHAR(16))
SELECT *
FROM ASL.possiede
WHERE Primario = CF;





# Operazioni sui Volontari

CREATE PROCEDURE ASL.nomina_volontario (IN cod_medico CHAR(16),IN associazione VARCHAR(50))
INSERT INTO ASL.volontario
VALUES (cod_medico,associazione);

CREATE PROCEDURE ASL.rimuovi_volontario (IN cod_volontario CHAR(16))
DELETE FROM ASL.volontario
WHERE CF_Volontario = cod_volontario;

CREATE PROCEDURE ASL.volontario_cerca (IN CodiceFiscale CHAR(16))
SELECT CF_Volontario AS CF,Nome_Medico AS Nome,Cognome,Indirizzo,medico.Reparto,medico.Ospedale,Associazione
FROM ASL.volontario
    JOIN ASL.medico ON volontario.CF_Volontario = medico.CF_Medico
WHERE CF_Volontario = CodiceFiscale;

CREATE PROCEDURE ASL.mostra_volontari ()
SELECT CF_Volontario AS CF,Nome_Medico AS Nome,Cognome,Indirizzo,medico.Reparto,medico.Ospedale,Associazione
FROM ASL.volontario
    JOIN ASL.medico ON volontario.CF_Volontario = medico.CF_Medico;





# Operazioni sui Reparti

CREATE PROCEDURE ASL.reparto_aggiungi (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4), IN nome VARCHAR(20), IN numero_telefono CHAR(10))
INSERT INTO ASL.reparto
VALUES (cod_reparto,cod_ospedale,nome,numero_telefono);

CREATE PROCEDURE ASL.reparto_modifica (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4),IN nuovo_codice CHAR(5),IN nuovo_ospedale CHAR(4), IN nuovo_nome VARCHAR(20), IN nuovo_numero CHAR(10))
UPDATE ASL.reparto
SET Codice_Reparto = nuovo_codice,
    Ospedale = nuovo_ospedale,
    Nome_Reparto = nuovo_nome,
    Num_Telefono = nuovo_numero
WHERE (Codice_Reparto,Ospedale) = (cod_reparto,cod_ospedale);

CREATE PROCEDURE ASL.reparto_cancella (IN cod_reparto CHAR(5),IN cod_ospedale CHAR(4))
DELETE FROM ASL.reparto
WHERE (Codice_Reparto,Ospedale) = (cod_reparto,cod_ospedale);

CREATE PROCEDURE ASL.reparto_cerca (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4))
SELECT *
FROM ASL.reparto
WHERE (Codice_Reparto,Ospedale) = (cod_reparto,cod_ospedale);

CREATE PROCEDURE ASL.mostra_reparti ()
SELECT *
FROM ASL.reparto;





# Operazioni degli Amministratori

CREATE PROCEDURE ASL.report_medici_esami (IN data_inizio DATE,IN data_fine DATE)
SELECT CF_Medico AS Codice_Medico,Nome_Medico,Cognome AS Cognome_Medico,Tipo_Esame,Nome_Esame,Data,Ora
FROM ASL.esamereale 
    JOIN ASL.esame ON esamereale.Tipo_Esame = esame.Codice_Esame
    RIGHT JOIN ASL.medico ON esamereale.Medico = medico.CF_Medico
WHERE Data>=data_inizio AND Data<=data_fine OR Data is NULL
ORDER BY Cognome_Medico;

CREATE PROCEDURE ASL.report_numero_esami (data_inizio DATE, data_fine DATE)
SELECT CF_Medico AS Codice,Nome_Medico AS Nome ,Cognome, COUNT(Medico) AS num_esami
FROM ASL.esamereale RIGHT JOIN ASL.medico ON esamereale.Medico = medico.CF_Medico
WHERE Data is null or Data>=data_inizio AND Data<=data_fine
GROUP BY CF_Medico
ORDER BY num_esami DESC;





# Operazioni del Personale CUP

CREATE PROCEDURE ASL.report_esami_paziente (IN CF CHAR(16))
SELECT 
CF_Paziente AS CodiceFiscale,
 Nome_Paziente AS Nome,
 Cognome_Paziente AS Cognome,
 Tipo_Esame AS cod_Esame,
 Nome_Esame AS Esame,
 esamereale.Data AS Data,
 esamereale.Ora AS Ora,
 Diagnosi
FROM ASL.paziente 
    JOIN ASL.prenotazione ON paziente.CF_Paziente = prenotazione.Paziente
    JOIN ASL.esamereale ON prenotazione.Codice_Prenotazione = esamereale.Cod_Prenotazione
    JOIN ASL.esame ON esamereale.Tipo_Esame = esame.Codice_Esame
WHERE CF_Paziente = CF;

CREATE PROCEDURE ASL.report_risultati_prenotazione(IN prenotazione CHAR(8))
SELECT Tipo_Esame AS Codice,Nome_Esame,Data,Ora,Parametri,Diagnosi
FROM ASL.esamereale JOIN ASL.esame ON esamereale.Tipo_Esame = esame.Codice_Esame
WHERE prenotazione = Cod_Prenotazione;










# =================================USERS=================================#


# Creo gli utenti e garantisco i privilegi sulle tabelle che devono gestire

CREATE USER 'personale_CUP' IDENTIFIED BY 'personalecup';
CREATE USER 'amministratore' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON ASL.paziente TO 'personale_CUP';
GRANT ALL PRIVILEGES ON ASL.esamereale TO 'personale_CUP';
GRANT ALL PRIVILEGES ON ASL.prenotazione TO 'personale_CUP';
GRANT ALL PRIVILEGES ON ASL.esame TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.ospedale TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.laboratorio TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.reparto TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.medici TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.responsabileospedale TO 'amministratore';
GRANT ALL PRIVILEGES ON ASL.responsabilelaboratorio TO 'amministratore';


#grant procedure Personale CUP

GRANT EXECUTE ON PROCEDURE ASL.esamereale_aggiungi TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.esamereale_cancella TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.esamereale_cerca TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.esamereale_inserisci_diagnosi TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.esamereale_modifica_data TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.paziente_aggiungi TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.paziente_cancella TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.paziente_cerca TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.paziente_modifica TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.report_esami_paziente TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.report_risultati_prenotazione TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.mostra_esami TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.mostra_esamireali TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.mostra_pazienti TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.esame_cerca TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.medico_cerca TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.mostra_medici TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.laboratorio_cerca TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.mostra_laboratori TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.prenotazione_aggiungi TO 'personale_CUP';
GRANT EXECUTE ON PROCEDURE ASL.prenotazione_cancella TO 'personale_CUP'; 
GRANT EXECUTE ON PROCEDURE ASL.mostra_prenotazioni TO 'personale_CUP';


#grant procedure Amministratore

GRANT EXECUTE ON PROCEDURE ASL.esame_aggiungi TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.esame_cancella TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.esame_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.esame_modifica TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_esami TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.ospedale_aggiungi TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.ospedale_cancella TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.ospedale_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_ospedali TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.ospedale_modifica TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.laboratorio_aggiungi TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.laboratorio_cancella TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.laboratorio_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.laboratorio_modifica TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_laboratori TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.reparto_aggiungi TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.reparto_cancella TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.reparto_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.reparto_modifica TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_reparti TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_medici TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.medico_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.medico_aggiungi TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.medico_modifica TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.medico_cancella TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.nomina_resp_osp TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.nomina_resp_lab TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.nomina_primario TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.rimuovi_primario TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.nuova_specializzazione TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_specializzazioni TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.primario_agg_spec TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.primario_rim_spec TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.primario_cerca TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_primari TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.primario_mostra_spec TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.nomina_volontario TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.rimuovi_volontario TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.volontario_cerca  TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.mostra_volontari TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.report_numero_esami TO 'amministratore';
GRANT EXECUTE ON PROCEDURE ASL.report_medici_esami TO 'amministratore';