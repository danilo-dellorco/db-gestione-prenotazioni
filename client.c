#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>
#include <unistd.h>
#define fflush(stdin) while ((getchar()) != '\n')

MYSQL *conn;
MYSQL *login;
char u[255];
char p[255];
char query[255];
char c;
int cmd1 = 0;
int cmd2 = 0;
int num_fields;
MYSQL_RES *result;
MYSQL_ROW row;
MYSQL_FIELD *field;

static void finish_with_error(MYSQL *con, char *err)
{
	fprintf(stderr, "%s error: %s\n", err, mysql_error(con));
	mysql_close(con);
	exit(1);        
}

void input_wait()
{	
	fflush(stdin);
	char c;
	printf("\n> Premi invio per continuare: \n");
	while (c = getchar() != '\n'){}
}

void print_simple_query(char *query)
{	
	printf("\n===== %s =====\n",query);
	mysql_query (conn,query);
	result = mysql_store_result(conn);

	if (result == NULL)
	{
		finish_with_error(conn, "errore");
	}

	num_fields = mysql_num_fields(result);
	printf ("\n");
	while ((row = mysql_fetch_row(result)))
	{ 


	
		for(int i = 0; i < num_fields; i++) 
		{	
			if (i == 0) 
			{              
				while(field = mysql_fetch_field(result)) //include il nome della colonna nella stampa
				{
					printf( "|  %s  ", field->name);
				}
				printf ("\n");       
			}
		printf(" %s ", row[i] ? row[i] : "NULL"); 
		}
	}
	mysql_free_result(result);
	mysql_next_result(conn);
	input_wait();
}

void run_query (char *query)
{
	printf("\n===== %s =====\n",query);
	if(mysql_query(conn,query))
	{	
		finish_with_error(conn, "Query");
	}
	else
	{
		printf ("> Operazione completata.");
		input_wait();
	}
}

void do_logout ()
{	printf ("\n===============================\n");
	printf ("> Logout eseguito.");
	printf ("\n===============================\n\n\n");
	mysql_close (conn);
	strcpy (u,"");
	strcpy (p,"");
}

void admin_logged()
{	
	printf("\n________________________________________________________\n");
	printf ("\n > Accesso eseguito come amministratore del sistema\n\n");
	while (true)
	{
		printf ("\n\n===========Lista Funzioni eseguibili dal personale del CUP===========\n\n");
		printf ("  1) Mostra una lista degli esami prenotabili\n");
		printf ("  2) Mostra una lista degli ospedali\n");
		printf ("  3) Mostra una lista dei laboratori\n");
		printf ("  4) Mostra una lista dei reparti ospedalieri\n");
		printf ("  5) Mostra una lista dei medici registrati\n\n");
		printf ("  6) Registra un nuovo esame prenotabile\n");
		printf ("  7) Modifica un esame prenotabile\n");
		printf ("  8) Cancella un esame prenotabile\n");
		printf ("  9) Cerca un esame prenotabile\n\n");
		printf (" 10) Registra un nuovo ospedale\n");
		printf (" 11) Modifica un ospedale\n");
		printf (" 12) Cancella un ospedale\n");
		printf (" 13) Cerca un ospedale\n\n");
		printf (" 14) Registra un nuovo laboratorio\n");
		printf (" 15) Modifica un laboratorio\n");
		printf (" 16) Cancella un laboratorio\n");
		printf (" 17) Cerca un laboratorio\n\n");
		printf (" 18) Registra un nuovo reparto\n");
		printf (" 19) Modifica un reparto\n");
		printf (" 20) Cancella un reparto\n");
		printf (" 21) Cerca un reparto\n\n");
		printf (" 22) Registra un nuovo Medico\n");
		printf (" 23) Modifica un Medico registrato\n");
		printf (" 24) Cancella un Medico registrato\n");
		printf (" 25) Cerca un medico tra quelli registrati\n\n");
		printf (" 26) Nomina il responsabile di un Ospedale\n");
		printf (" 27) Nomina il responsabile di un Laboratorio\n");
		printf (" 28) Nomina il Primario di un reparto\n");
		printf (" 29) Rimuovi il Primario di un reparto\n");
		printf (" 30) Registra una nuova specializzazione nel sistema\n");
		printf (" 31) Mostra una lista delle specializzazioni registrate\n");
		printf (" 32) Assegna una nuova specializzazione ad un Primario\n");
		printf (" 33) Cancella una specializzazione da un Primario\n");
		printf (" 34) Cerca un Primario tra quelli registrati\n");
		printf (" 35) Mostra tutti i Primari registrati\n");
		printf (" 36) Mostra le specializzazioni di un Primario\n\n");
		printf (" 37) Specifica un medico registrato come volontario\n");
		printf (" 38) Rimuovi un medico dalla lista dei volontari\n");
		printf (" 39) Cerca un volontario tra quelli registrati\n");
		printf (" 40) Mostra tutti i volontari registrati\n\n");
		printf (" 41) Genera un report sugli esami svolti in un certo periodo dai medici registrati \n");
		printf (" 42) Mostra il numero di esami svolti in un certo periodo dai medici registrati \n\n");
		printf (" 00) Logout \n");

		printf ("\nInserisci un comando: ");
		scanf ("%i",&cmd2);
		printf ("\n\n\n");

		if (cmd2 == 1)
		{
			print_simple_query("call mostra_esami");
		}
		else if (cmd2 == 2)
		{
			print_simple_query("call mostra_ospedali");
		}
		else if (cmd2 == 3)
		{
			print_simple_query("call mostra_laboratori");
		}
		else if (cmd2 == 4)
		{
			print_simple_query("call mostra_reparti");
		}
		else if (cmd2 == 5)
		{
			print_simple_query("call mostra_medici");
		}
		else if (cmd2 == 6) //esame_aggiungi (IN cod_esame CHAR(5), IN nome_esame VARCHAR(30), costo FLOAT)
		{
			char cod[20],nome[255],costo[255];
			printf ("\nInserisci il Codice dell'esame: ");
			scanf ("%s",cod);
			fflush(stdin);
			printf ("\nInserisci il Nome dell'esame: ");
			scanf("%[^\n]",nome);
			printf ("\nInserisci il Costo dell'esame: [xx.xx]: ");
			scanf ("%s",costo);
			snprintf(query, 1000, "call esame_aggiungi('%s','%s',%s);",cod,nome,costo);
			run_query(query);
		}
		else if (cmd2 == 7) //esame_modifica (IN cod_esame CHAR(5), IN nuovo_codice CHAR(5), IN nuovo_nome VARCHAR(30), IN nuovo_costo FLOAT)
		{
			char cod[20],n_cod[20],n_nome[255],n_costo[255];
			printf ("\nInserisci il Codice dell'esame da modificare: ");
			scanf ("%s",cod);
			fflush(stdin);
			printf ("\nInserisci il nuovo codice dell'esame: ");
			scanf("%s",n_cod);
			fflush(stdin);
			printf ("\nInserisci il nuovo nome dell'esame: ");
			scanf("%[^\n]",n_nome);
			fflush(stdin);
			printf ("\nInserisci il nuovo costo dell'esame: [xx.xx]: ");			
			scanf ("%s",n_costo);
			snprintf(query, 1000, "call esame_modifica('%s','%s','%s',%s);",cod,n_cod,n_nome,n_costo);
			run_query(query);
		}
		else if (cmd2 == 8) //esame_cancella (IN cod_esame CHAR(5))
		{
			char cod[20];
			printf ("\nInserisci il Codice dell'esame da modificare: ");
			scanf("%s",cod);
			snprintf(query, 1000, "call esame_cancella('%s');",cod);
			run_query(query);	
		}
		else if (cmd2 == 9)
		{
			char cod[20];
			printf ("\nInserisci il Codice dell'esame da cercare: ");
			scanf("%s",cod);
			snprintf(query, 1000, "call esame_cerca('%s');",cod);
			print_simple_query(query);	
		}
		else if (cmd2 == 10) //ospedale_aggiungi (IN cod_osp CHAR(4), IN nome_osp VARCHAR(20), IN indirizzo VARCHAR(30))
		{
			char cod[20],nome[255],indirizzo[255];
			printf ("\nInserisci il Codice dell'ospedale: ");
			scanf ("%s",cod);
			fflush(stdin);
			printf ("\nInserisci il Nome dell'ospedale: ");
			scanf("%[^\n]",nome);
			fflush(stdin);
			printf ("\nInserisci l'indirizzo dell'ospedale: ");
			scanf("%[^\n]",indirizzo);
			snprintf(query, 1000, "call ospedale_aggiungi('%s','%s','%s')",cod,nome,indirizzo);
			run_query(query);
		}
		else if (cmd2 == 11) //ospedale_modifica (IN cod_osp CHAR(4), IN nuovo_codice CHAR(4),IN nuovo_nome VARCHAR(20), IN nuovo_indirizzo VARCHAR(30))
		{
			char cod[20],n_cod[20],n_nome[255],n_indirizzo[255];
			printf ("\nInserisci il Codice dell'ospedale da modificare: ");
			scanf ("%s",cod);
			fflush(stdin);
			printf ("\nInserisci il nuovo codice dell'ospedale: ");
			scanf("%s",n_cod);
			fflush(stdin);
			printf ("\nInserisci il nuovo nome dell'ospedale: ");
			scanf("%[^\n]",n_nome);
			fflush(stdin);
			printf ("\nInserisci il nuovo indirizzo dell'ospedale: ");			
			scanf("%[^\n]",n_indirizzo);
			snprintf(query, 1000, "call ospedale_modifica('%s','%s','%s','%s');",cod,n_cod,n_nome,n_indirizzo);
			run_query(query);
		}
		else if (cmd2 == 12) //ospedale_cancella (IN cod_osp CHAR(4))
		{
			char cod[20];
			printf ("\nInserisci il Codice dell'ospedale da Cancellare: ");
			scanf ("%s",cod);
			fflush(stdin);
			snprintf(query, 1000, "call ospedale_cancella('%s')",cod);
			run_query(query);
		}
		else if (cmd2 == 13) //ospedale_cerca (IN cod_osp CHAR(4))
		{
			char cod[20];
			printf ("\nInserisci il Codice dell'ospedale da cercare: ");
			scanf ("%s",cod);
			fflush(stdin);
			snprintf(query, 1000, "call ospedale_cerca('%s')",cod);
			print_simple_query(query);			
		}
		else if (cmd2 == 14) //laboratorio_aggiungi (IN cod_lab CHAR(5), IN cod_osp CHAR(4), IN nome VARCHAR(25), IN piano INT, IN stanza INT)
		{
			char cod_lab[20],cod_osp[20],nome[255],piano[20],stanza[20];
			printf ("\nInserisci il Codice del laboratorio: ");
			scanf ("%s",cod_lab);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'ospedale: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf ("\nInserisci il Nome del laboratorio: ");
			scanf("%[^\n]",nome);
			fflush(stdin);
			printf ("\nInserisci il Piano del laboratorio: ");
			scanf ("%s",piano);
			fflush(stdin);
			printf ("\nInserisci la Stanza del laboratorio: ");
			scanf ("%s",stanza);
			snprintf(query, 1000, "call laboratorio_aggiungi('%s','%s','%s',%s,%s);",cod_lab,cod_osp,nome,piano,stanza);
			run_query(query);
		}		

		else if (cmd2 == 15) //laboratorio_modifica (IN cod_lab CHAR(5), IN cod_osp CHAR(4), IN nuovo_lab CHAR(5), IN nuovo_osp CHAR(4), IN nuovo_nome VARCHAR(25), IN nuovo_piano INT, IN nuova_stanza INT)
		{
			char cod_lab[6],cod_osp[5],n_lab[6],n_osp[5],n_nome[255],n_piano[20],n_stanza[20];
			printf ("\nInserisci il Codice del Laboratorio da modificare: ");
			scanf ("%s",cod_lab);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'Ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf ("\nInserisci il nuovo Codice del laboratorio: ");
			scanf ("%s",n_lab);
			fflush(stdin);
			printf ("\nInserisci il nuovo Codice dell'ospedale: ");
			scanf ("%s",n_osp);
			fflush(stdin);
			printf ("\nInserisci il nuovo Nome del laboratorio: ");
			scanf("%[^\n]",n_nome);
			fflush(stdin);
			printf ("\nInserisci il nuovo Piano del laboratorio: ");
			scanf ("%s",n_piano);
			fflush(stdin);
			printf ("\nInserisci la nuova Stanza del laboratorio: ");
			scanf ("%s",n_stanza);
			snprintf(query, 1000, "call laboratorio_modifica('%s','%s','%s','%s','%s',%s,%s);",cod_lab,cod_osp,n_lab,n_osp,n_nome,n_piano,n_stanza);
			run_query(query);
		}
		else if (cmd2 == 16) //laboratorio_cancella (IN cod_lab CHAR(5), IN cod_osp CHAR(4))
		{
			char cod_lab[6],cod_osp[5];
			printf ("\nInserisci il Codice del Laboratorio da cancellare: ");
			scanf ("%s",cod_lab);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'Ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			snprintf(query, 1000, "call laboratorio_cancella('%s','%s');",cod_lab,cod_osp);
			run_query(query);
		}
		else if (cmd2 == 17) //laboratorio_cerca (IN cod_lab CHAR(5), IN cod_osp CHAR(4))
		{
			char cod_lab[6],cod_osp[5];
			printf ("\nInserisci il Codice del Laboratorio da cercare: ");
			scanf ("%s",cod_lab);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'Ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			snprintf(query, 1000, "call laboratorio_cerca('%s','%s');",cod_lab,cod_osp);
			print_simple_query(query);
		}
		else if (cmd2 == 18) //reparto_aggiungi (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4), IN nome VARCHAR(20), IN numero_telefono CHAR(10))
		{
			char cod_rep[6],cod_osp[5],nome[255],numero[11];
			printf ("\nInserisci il Codice del reparto: ");
			scanf ("%s",cod_rep);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'ospedale di appartenenza del reparto: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf ("\nInserisci il Nome del reparto: ");
			scanf("%[^\n]",nome);
			fflush(stdin);
			printf ("\nInserisci il Numero di telefono del reparto: ");
			scanf ("%s",numero);
			snprintf(query, 1000, "call reparto_aggiungi('%s','%s','%s','%s');",cod_rep,cod_osp,nome,numero);
			run_query(query);

		}
		else if (cmd2 == 19) //reparto_modifica (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4),IN nuovo_codice CHAR(5),IN nuovo_ospedale CHAR(4), IN nuovo_nome VARCHAR(20), IN nuovo_numero CHAR(10))
		{
			char cod_rep[6],cod_osp[5],n_rep[6],n_osp[5],n_nome[255],n_piano[20],n_numero[11];
			printf ("\nInserisci il Codice del Reparto da modificare: ");
			scanf ("%s",cod_rep);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'Ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf ("\nInserisci il nuovo Codice del reparto: ");
			scanf ("%s",n_rep);
			fflush(stdin);
			printf ("\nInserisci il nuovo Codice dell'ospedale: ");
			scanf ("%s",n_osp);	
			fflush(stdin);
			printf ("\nInserisci il nuovo Nome del reparto: ");
			scanf("%[^\n]",n_nome);
			fflush(stdin);
			printf ("\nInserisci il nuovo Numero del reparto: ");
			scanf ("%s",n_numero);
			snprintf(query, 1000, "call reparto_modifica('%s','%s','%s','%s','%s','%s');",cod_rep,cod_osp,n_rep,n_osp,n_nome,n_numero);
			run_query(query);
		}
		else if (cmd2 == 20) //reparto_cancella (IN cod_reparto CHAR(5),IN cod_ospedale CHAR(4))
		{
			char cod_rep[6],cod_osp[5];
			printf ("\nInserisci il Codice del reparto da cancellare: ");
			scanf ("%s",cod_rep);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'ospedale di appartenenza del reparto: ");
			scanf ("%s",cod_osp);
			snprintf(query, 1000, "call reparto_cancella('%s','%s');",cod_rep,cod_osp);
			run_query(query);
		}
		else if (cmd2 == 21) //reparto_cerca (IN cod_reparto CHAR(5), IN cod_ospedale CHAR(4))
		{
			char cod_rep[6],cod_osp[5];
			printf ("\nInserisci il Codice del reparto da cercare: ");
			scanf ("%s",cod_rep);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'ospedale di appartenenza del reparto: ");
			scanf ("%s",cod_osp);
			snprintf(query, 1000, "call reparto_cerca('%s','%s');",cod_rep,cod_osp);
			print_simple_query(query);
		}
		else if (cmd2 == 22) //medico_aggiungi (IN cod_medico CHAR(16), nome_medico VARCHAR(15), cognome_medico VARCHAR(15), indirizzo VARCHAR(30), IN reparto CHAR(5),IN ospedale CHAR(4))
		{
			char CF[17],nome[16],cognome[16],indirizzo[31],reparto[6],ospedale[5];
			printf ("\nInserisci il Codice Fiscale del medico: ");
			scanf ("%s",CF);
			fflush(stdin);
			printf ("\nInserisci il Nome del medico: ");
			scanf("%[^\n]",nome);
			fflush(stdin);
			printf ("\nInserisci il Cognome del medico: ");
			scanf("%[^\n]",cognome);
			fflush(stdin);
			printf ("\nInserisci l'Indirizzo di residenza del medico: ");
			scanf("%[^\n]",indirizzo);
			fflush(stdin);
			printf ("\nInserisci l'Ospedale del medico: ");
			scanf ("%s",ospedale);
			fflush(stdin);
			printf ("\nInserisci il Reparto dove lavora il medico: ");
			scanf ("%s",reparto);
			snprintf(query, 1000, "call medico_aggiungi('%s','%s','%s','%s','%s','%s');",CF,nome,cognome,indirizzo,reparto,ospedale);
			run_query(query);
		}
		else if (cmd2 == 23) //medico_modifica (IN cod_medico CHAR(16), nuovo_indirizzo VARCHAR(30), IN nuovo_reparto CHAR(5),IN nuovo_ospedale CHAR(4))
		{	
			char CF[17],indirizzo[31],reparto[6],ospedale[5];
			printf ("\nInserisci il Codice Fiscale del medico da modificare: ");
			scanf ("%s",CF);
			fflush(stdin);
			printf ("\nInserisci il nuovo indirizzo del medico: ");
			scanf("%[^\n]",indirizzo);
			fflush(stdin);
			printf ("\nInserisci il nuovo Ospedale del medico: ");
			scanf ("%s",ospedale);
			fflush(stdin);
			printf ("\nInserisci il nuovo Reparto dove lavora il medico: ");
			scanf ("%s",reparto);
			snprintf(query, 1000, "call medico_modifica('%s','%s','%s','%s');",CF,indirizzo,reparto,ospedale);
			run_query(query);
		}
		else if (cmd2 == 24) //medico_cancella (IN cod_medico CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del medico da canellare: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call medico_cancella('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 25) //medico_cerca (IN cod_medico CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del medico da cercare: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call medico_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 26) //nomina_resp_osp (IN cod_medico CHAR(16),IN ospedale CHAR(4))
		{
			char CF[17],cod_osp[5];
			printf("\nInserisci il Codice dell'ospedale: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf("\nInserisci il Codice Fiscale del medico responsabile dell'ospedale: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call nomina_resp_osp('%s','%s');",CF,cod_osp);
			run_query(query);
		}
		else if (cmd2 == 27) //nomina_resp_lab (IN cod_medico CHAR(16), IN laboratorio CHAR(5), IN ospedale CHAR(4))
		{
			char CF[17],cod_lab[6],cod_osp[5];
			printf("\nInserisci il Codice del laboratorio: ");
			scanf ("%s",cod_lab);
			printf("\nInserisci il Codice dell'ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			fflush(stdin);
			printf("\nInserisci il Codice Fiscale del medico responsabile del laboratorio: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call nomina_resp_lab('%s','%s','%s');",CF,cod_lab,cod_osp);
			run_query(query);
		} 
		else if (cmd2 == 28) //nomina_primario (IN cod_medico CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del medico da nominare primario: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call nomina_primario('%s');",CF);
			run_query(query);
		}
		else if (cmd2 == 29) //rimuovi_primario (IN cod_primario CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del primario da rimuovere: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call rimuovi_primario('%s');",CF);
			run_query(query);
		}
		else if (cmd2 == 30) //nuova_specializzazione (IN nome VARCHAR(50))
		{
			char spec[51];
			printf("\nInserisci il nome della nuova Specializzazione Medica: ");
			fflush(stdin);
			scanf("%[^\n]",spec);
			snprintf(query, 1000, "call nuova_specializzazione('%s');",spec);
			run_query(query);
		}
		else if (cmd2 == 31) //mostra_specializzazioni ()
		{
			print_simple_query("call mostra_specializzazioni");
		}
		else if (cmd2 == 32) //primario_agg_spec(IN CF_primario CHAR(16),IN specializzazione VARCHAR(50))
		{
			char CF[17],spec[51];
			printf("\nInserisci il Codice Fiscale del Primario: ");
			scanf("%s",CF);
			fflush(stdin);
			printf("\nInserisci il nome della Specializzazione da aggiungere: ");
			scanf("%[^\n]",spec);
			snprintf(query, 1000, "call primario_agg_spec('%s','%s');",CF,spec);
			run_query(query);
		}
		else if (cmd2 == 33) //primario_rim_spec(IN CF_primario CHAR(16),IN specializzazione VARCHAR(50))
		{
			char CF[17],spec[51];
			printf("\nInserisci il Codice Fiscale del Primario: ");
			scanf("%s",CF);
			fflush(stdin);
			printf("\nInserisci il nome della Specializzazione da rimuovere: ");
			scanf("%[^\n]",spec);
			snprintf(query, 1000, "call primario_rim_spec('%s','%s');",CF,spec);
			run_query(query);
		}
		else if (cmd2 == 34) //primario_cerca (IN CodiceFiscale CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del Primario da cercare: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call primario_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 35) //mostra_primari ()
		{
			print_simple_query("call mostra_primari");
		}
		else if (cmd2 == 36) //primario_mostra_spec (IN CF CHAR(16))
		{
			char CF[17];
			printf("\nInserisci il Codice Fiscale del Primario: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call primario_mostra_spec('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 37) //nomina_volontario (IN cod_medico CHAR(16),IN associazione VARCHAR(50))
		{
			char CF[17],assoc[51];
			printf("\nInserisci il Codice Fiscale del medico da nominare volontario: ");
			scanf("%s",CF);
			fflush(stdin);
			printf("\nInserisci il nome dell'Associazione di Volontariato: ");
			scanf("%[^\n]",assoc);
			snprintf(query, 1000, "call nomina_volontario('%s','%s');",CF,assoc);
			run_query(query);
		}
		else if (cmd2 == 38) //rimuovi_volontario (IN cod_volontario CHAR(16))
		{
			char CF[6];
			printf("\nInserisci il Codice Fiscale del medico da rimuovere tra i volontari: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call rimuovi_volontario('%s');",CF);
			run_query(query);
		}
		else if (cmd2 == 39) //volontario_cerca (IN CodiceFiscale CHAR(16))
		{
			char CF[6];
			printf("\nInserisci il Codice Fiscale del volontario da cercare: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call volontario_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 40) //mostra_volontari ()
		{
			print_simple_query("call mostra_volontari");
		}
		else if (cmd2 == 41) //report_medici_esami (IN data_inizio DATE,IN data_fine DATE) AAAA-MM-GG
		{
			char inizio[11],fine[11];
			printf("\nInserisci la data di inizio del report [AAAA-MM-GG]: ");
			scanf ("%s",inizio);
			fflush(stdin);
			printf("\nInserisci la data di fine del report [AAAA-MM-GG]: ");
			scanf ("%s",fine);
			snprintf(query, 1000, "call report_medici_esami('%s','%s');",inizio,fine);
			print_simple_query(query);
		}
		else if (cmd2 == 42) //report_numero_esami (data_inizio DATE, data_fine DATE)
		{
			char inizio[11],fine[11];
			printf("\nInserisci la data di inizio del report [AAAA-MM-GG]: ");
			scanf ("%s",inizio);
			fflush(stdin);
			printf("\nInserisci la data di fine del report [AAAA-MM-GG]: ");
			scanf ("%s",fine);
			snprintf(query, 1000, "call report_numero_esami('%s','%s');",inizio,fine);
			print_simple_query(query);
		}
		else if (cmd2 == 00)
		{
			do_logout();
			break;
		}
	}	
}

void cup_logged()
{	
	printf("\n________________________________________________________\n");
	printf ("\n > Accesso eseguito come personale del CUP\n\n");

	while (true)
	{
		printf ("\n\n===========Lista Funzioni eseguibili dal personale del CUP===========\n\n");
		printf ("  1) Mostra una lista degli esami prenotabili\n");
		printf ("  2) Mostra una lista dei laboratori\n");
		printf ("  3) Mostra una lista dei pazienti registrati\n");
		printf ("  4) Mostra una lista dei medici registrati\n\n");
		printf ("  5) Cerca un esame tra quelli prenotabili\n");
		printf ("  6) Cerca un laboratorio tra quelli registrati\n");
		printf ("  7) Cerca un paziente registrato nel sistema\n");
		printf ("  8) Cerca un medico tra quelli registrati\n\n");
		printf ("  9) Apri una nuova prenotazione relativa ad un paziente\n");
		printf (" 10) Cancella una prenotazione aperta\n");
		printf (" 11) Mostra una lista delle prenotazioni registrate\n\n");
		printf (" 12) Registra un nuovo esame svolto\n");
		printf (" 13) Cancella un esame tra quelli svolti\n");
		printf (" 14) Inserisci una diagnosi ad un esame svolto\n");
		printf (" 15) Modifica la data di un esame svolto\n");
		printf (" 16) Cerca un esame tra quelli svolti\n");
		printf (" 17) Mostra una lista degli esami svolti, registrati nel sistema\n\n");
		printf (" 18) Registra un nuovo paziente nel sistema\n"); 
		printf (" 19) Cancella un paziente dal sistema\n"); 
		printf (" 20) Modifica un paziente registrato nel sistema\n"); 
		printf (" 21) Cerca un paziente registrato nel sistema\n\n");  
		printf (" 22) Genera un report con i risultati degli esami svolti relativi ad una prenotazione\n");
		printf (" 23) Genera un report con i risultati di tutti gli esami svolti da un paziente registrato\n\n");
		printf (" 00) Logout \n");
		printf ("\nInserisci un comando: ");
		scanf ("%i",&cmd2);
		printf ("\n\n\n");
		if (cmd2 == 1)
		{
			print_simple_query("call mostra_esami");
		}
		else if (cmd2 == 2)
		{
			print_simple_query("call mostra_laboratori"); 
		}
		else if (cmd2 == 3)
		{
			print_simple_query("call mostra_pazienti"); 
		}
		else if (cmd2 == 4)
		{
			print_simple_query("call mostra_medici");
		}
		else if (cmd2 == 5)
		{
			char cod[20];
			printf ("\nInserisci il Codice dell'esame da cercare: ");
			scanf("%s",cod);
			snprintf(query, 1000, "call esame_cerca('%s');",cod);
			print_simple_query(query);
		}
		else if (cmd2 == 6)
		{
			char cod_lab[6],cod_osp[5];
			printf ("\nInserisci il Codice del Laboratorio da cercare: ");
			scanf ("%s",cod_lab);
			fflush(stdin);
			printf ("\nInserisci il Codice dell'Ospedale di appartenenza del laboratorio: ");
			scanf ("%s",cod_osp);
			snprintf(query, 1000, "call laboratorio_cerca('%s','%s');",cod_lab,cod_osp);
			print_simple_query(query);
		}
		else if (cmd2 == 7)
		{
			char CF[17];
			printf ("\nInserisci il Codice Fiscale del paziente da cercare: ");
			scanf("%s",CF);
			snprintf(query, 1000, "call esame_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 8)
		{
			char CF[17];
			printf("Inserisci il Codice Fiscale del medico da cercare: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call medico_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 9) //prenotazione_aggiungi (IN cod_prenotazione CHAR(8),IN cf_paziente CHAR(16))
		{
			char pren[9],CF[17];
			printf ("\nInserisci il Codice Fiscale del paziente che vuole aprire la prenotazione: ");
			scanf ("%s",CF);
			printf ("\nInserisci il Codice numerico da associare alla prenotazione: ");
			scanf ("%s",pren);
			snprintf(query, 1000, "call prenotazione_aggiungi('%s','%s');",pren,CF);
			run_query(query);
		}
		else if (cmd2 == 10) //prenotazione_cancella (IN cod_prenot CHAR(8))
		{
			char pren[9];
			printf ("\nInserisci il Codice della prenotazione da cancellare: ");
			scanf ("%s",pren);
			snprintf(query, 1000, "call prenotazione_cancella('%s');",pren);
			run_query(query);
		}
		else if (cmd2 == 11) 
		{
			print_simple_query("call mostra_prenotazioni");
		}
		else if (cmd2 == 12) //esamereale_aggiungi (IN cod_prenot CHAR(8), cod_esame CHAR (5), data DATE, ora TIME, urgenza VARCHAR(15), parametri VARCHAR(30), laboratorio CHAR(5), ospedale CHAR(4), medico CHAR(16), diagnosi VARCHAR(50))
		{
			char pren[9],esame[6],data[11],ora[6],urg[16],param[31],lab[6],osp[5],med[17],diagn[51];
			printf ("\nInserisci il codice della prenotazione: ");
			scanf ("%s",pren);
			fflush(stdin);
			printf ("\nInserisci il codice dell'esame: ");
			scanf ("%s",esame);
			fflush(stdin);
			printf ("\nInserisci la data di svolgimento dell'esame [AAAA-MM-GG]: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci l'ora di svolgimento dell'esame [hh:mm]: ");
			scanf ("%s",ora);
			fflush(stdin);
			printf ("\nInserisci l'urgenza dell'esame: ");
			scanf("%[^\n]",urg);
			fflush(stdin);
			printf ("\nInserisci i parametri riscontrati: ");
			scanf("%[^\n]",param);
			fflush(stdin);
			printf ("\nInserisci l'ospedale: ");
			scanf ("%s",osp);
			fflush(stdin);
			printf ("\nInserisci il laboratorio: ");
			scanf ("%s",lab);
			fflush(stdin);
			printf ("\nInserisci il medico che svolge l'esame: ");
			scanf ("%s",med);
			fflush(stdin);
			printf ("\nInserisci la diagnosi relativa all'esame: ");
			scanf("%[^\n]",diagn);
			snprintf(query, 1000, "call esamereale_aggiungi('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');",pren,esame,data,ora,urg,param,lab,osp,med,diagn);
			run_query(query);			
		}
		else if (cmd2 == 13) //esamereale_cancella (IN cod_prenot CHAR(8), cod_esame CHAR (5), data_ DATE, ora_ TIME)
		{
			char pren[9],esame[6],data[11],ora[6];
			printf ("\nInserisci il codice di prenotazione dell'esame da cancellare: ");
			scanf ("%s",pren);
			fflush(stdin);
			printf ("\nInserisci il codice dell'esame: ");
			scanf ("%s",esame);
			fflush(stdin);
			printf ("\nInserisci la data di svolgimento dell'esame da cancellare [AAAA-MM-GG]: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci l'ora di svolgimento dell'esame da cancellare [hh:mm]: ");
			scanf ("%s",ora);
			snprintf(query, 1000, "call esamereale_cancella('%s','%s','%s','%s');",pren,esame,data,ora);
			run_query(query);
		}
		else if (cmd2 == 14) //esamereale_inserisci_diagnosi (IN cod_prenot CHAR(8), cod_esame CHAR (5), data DATE, ora TIME, IN nuovi_parametri VARCHAR(30), IN nuova_diagnosi VARCHAR(50))
		{
			char pren[9],esame[6],data[11],ora[6],param[31],diagn[51];
			printf ("\nInserisci il codice della prenotazione: ");
			scanf ("%s",pren);
			fflush(stdin);
			printf ("\nInserisci il codice dell'esame: ");
			scanf ("%s",esame);
			fflush(stdin);
			printf ("\nInserisci la data di svolgimento dell'esame [AAAA-MM-GG]: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci l'ora di svolgimento dell'esame [hh:mm]: ");
			scanf ("%s",ora);
			fflush(stdin);
			printf ("\nInserisci i parametri riscontrati: ");
			scanf("%[^\n]",param);
			fflush(stdin);
			printf ("\nInserisci la diagnosi relativa all'esame: ");
			scanf("%[^\n]",diagn);
			snprintf(query, 1000, "call esamereale_inserisci_diagnosi('%s','%s','%s','%s','%s','%s');",pren,esame,data,ora,param,diagn);
			run_query(query);
		}
		else if (cmd2 == 15) //esamereale_modifica_data (IN cod_prenot CHAR(8), IN esame CHAR(5),IN data DATE,IN ora TIME, nuova_data DATE, nuova_ora TIME)
		{
			char pren[9],esame[6],data[11],ora[6],n_data[11],n_ora[6];
			printf ("\nInserisci il codice della prenotazione: ");
			scanf ("%s",pren);
			fflush(stdin);
			printf ("\nInserisci il codice dell'esame: ");
			scanf ("%s",esame);
			fflush(stdin);
			printf ("\nInserisci la data di svolgimento dell'esame [AAAA-MM-GG]: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci l'ora di svolgimento dell'esame [hh:mm]: ");
			scanf ("%s",ora);
			fflush(stdin);
			printf ("\nInserisci la nuova data [AAAA-MM-GG]: ");
			scanf ("%s",n_data);
			fflush(stdin);
			printf ("\nInserisci la nuova ora [hh:mm]: ");
			scanf ("%s",n_ora);
			snprintf(query, 1000, "call esamereale_modifica_data('%s','%s','%s','%s','%s','%s');",pren,esame,data,ora,n_data,n_ora);
			run_query(query);
		}
		else if (cmd2 == 16) //esamereale_cerca (IN cod_prenot CHAR(8), cod_esame CHAR (5), data_ DATE, ora_ TIME)
		{
			char pren[9],esame[6],data[11],ora[6];
			printf ("\nInserisci il codice di prenotazione dell'esame da cercare: ");
			scanf ("%s",pren);
			fflush(stdin);
			printf ("\nInserisci il codice dell'esame: ");
			scanf ("%s",esame);
			fflush(stdin);
			printf ("\nInserisci la data di svolgimento dell'esame da cercare [AAAA-MM-GG]: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci l'ora di svolgimento dell'esame da cercare [hh:mm]: ");
			scanf ("%s",ora);
			snprintf(query, 1000, "call esamereale_cerca('%s','%s','%s','%s');",pren,esame,data,ora);
			print_simple_query(query);			
		}
		else if (cmd2 == 17) //mostra_esamireali ()
		{
			print_simple_query("call mostra_esamireali");
		}
		else if (cmd2 == 18) //paziente_aggiungi (IN CF CHAR(16), IN nome VARCHAR(15), IN cognome VARCHAR(15),IN indirizzo VARCHAR(30),IN Luogo VARCHAR(30),IN data DATE, IN Telefono VARCHAR(10),IN Mail VARCHAR(30),IN Cellulare VARCHAR(10))
		{
			char CF[17],nome[16],cognome[16],indirizzo[31],luogo[31],data[11],tel[11],mail[31],cell[11];
			printf ("\nInserisci il Codice Fiscale del Paziente: ");
			scanf ("%s",CF);
			fflush(stdin);
			printf ("\nInserisci il Nome del Paziente: ");
			scanf("%[^\n]",nome);
			fflush(stdin);
			printf ("\nInserisci il Cognome del Paziente: ");
			scanf("%[^\n]",cognome);
			fflush(stdin);
			printf ("\nInserisci l'Indirizzo del Paziente: ");
			scanf("%[^\n]",indirizzo);
			fflush(stdin);
			printf ("\nInserisci il Luogo di Nascita del Paziente: ");
			scanf("%[^\n]",luogo);
			fflush(stdin);
			printf ("\nInserisci la Data di Nascita del Paziente: ");
			scanf ("%s",data);
			fflush(stdin);
			printf ("\nInserisci il Numero di Telefono del Paziente: ");
			scanf ("%s",tel);
			fflush(stdin);
			printf ("\nInserisci l'Indirizzo e-mail del Paziente: ");
			scanf ("%s",mail);
			fflush(stdin);
			printf ("\nInserisci il Numero di Cellulare del Paziente: ");
			scanf ("%s",cell);
			snprintf(query, 1000, "call paziente_aggiungi('%s','%s','%s','%s','%s','%s','%s','%s','%s');",CF,nome,cognome,indirizzo,luogo,data,tel,mail,cell);
			run_query(query);
		}
		else if (cmd2 == 19) //paziente_cancella(IN CF CHAR(16))
		{
			char CF[17];
			printf ("\nInserisci il Codice Fiscale del Paziente da cancellare: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call paziente_cancella('%s');",CF);
			run_query(query);
		}
		else if (cmd2 == 20) //paziente_modifica (IN CF CHAR(16),IN n_indirizzo VARCHAR(30), IN n_Telefono VARCHAR(10),IN n_Mail VARCHAR(30),IN n_Cellulare VARCHAR(10))
		{
			char CF[17],indirizzo[31],tel[11],mail[31],cell[11];
			printf ("\nInserisci il Codice Fiscale del Paziente da modificare: ");
			scanf ("%s",CF);
			fflush(stdin);
			printf ("\nInserisci il nuovo Indirizzo: ");
			scanf("%[^\n]",indirizzo);
			fflush(stdin);
			printf ("\nInserisci il nuovo Numero di Telefono: ");
			scanf ("%s",tel);
			fflush(stdin);
			printf ("\nInserisci il nuovo Indirizzo e-mail: ");
			scanf ("%s",mail);
			fflush(stdin);
			printf ("\nInserisci il nuovo Numero di Cellulare: ");
			scanf ("%s",cell);
			snprintf(query, 1000, "call paziente_modifica('%s','%s','%s','%s','%s');",CF,indirizzo,tel,mail,cell);
			run_query(query);

		}
		else if (cmd2 == 21) //paziente_cerca (IN CodiceFiscale CHAR(16))
		{
			char CF[17];
			printf ("\nInserisci il Codice Fiscale del Paziente da cercare: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call paziente_cerca('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 22) //report_risultati_prenotazione(IN prenotazione CHAR(8))
		{
			char cod[9];
			printf ("\nInserisci il codice della prenotazione su cui generare il report: ");
			scanf ("%s",cod);
			snprintf(query, 1000, "call report_risultati_prenotazione('%s');",cod);
			print_simple_query(query);
		}
		else if (cmd2 == 23) //report_esami_paziente (IN CF CHAR(16))
		{
			char CF[17];
			printf ("\nInserisci il Codice Fiscale del paziente su cui generare il report: ");
			scanf ("%s",CF);
			snprintf(query, 1000, "call report_esami_paziente('%s');",CF);
			print_simple_query(query);
		}
		else if (cmd2 == 00) 
		{
			do_logout();
			break;
		}
	}
}

void do_login ()
{
	printf("\n========Login=======\n\n");
	printf("Inserisci l'username: ");
	scanf("%s",u);
	printf("Inserisci la password: ");
	scanf("%s",p);
	conn = mysql_init (NULL);
	login = mysql_real_connect(conn, "localhost",u,p, "ASL", 3306, NULL, 0);

	if (login == NULL)
	{
  		fprintf(stderr, "%s\n", mysql_error(conn));
  		mysql_close(conn);
  		exit(1);
	}

	else	
	{
		printf ("\nConnessione riuscita\n");
		if (strcmp(u, "personale_CUP") == 0)
		{
	    	printf("Loggato come membro del personale CUP\n\n");
	    	cup_logged();
			
		}

		else if (strcmp(u, "amministratore") == 0)
		{	
			printf ("Loggato come amministratore");
			admin_logged();
		}
	}
}

int main (int argc, char *argv[])
{	
	while (true)
	{	
		printf("\n=============Programma Gestione ASL============\n\nInserisci un Comando:\n");
		printf ("1) Login\n2) Termina Sessione\n");
		scanf ("%i",&cmd1);
		if (cmd1 == 1)
		{
			do_login();
		}

		else
		{
			printf("===================================\nProgramma Gestione ASL terminato.\n===================================\n\n");
			exit(0);
		}
	}
}