# OpenWRT WAN interfaces automatic reload on external IP changes

**When and why use this script :**

This script was created to fix a lack functionality in the OpenWRT software. When my ISP changes the external IP address on my 4G-5G modem connected in bridge mode, the OpenWRT router does not automatically update the external IP on the WAN interfaces. With this script being executed every two minutes using Cron, we can fix this problem and make the router automatically update the external IP address on every ISP's refresh.



**IT - Quando e perchè usare questo script :**

Questo script è stato creato per riempire un vuoto nelle impostazioni di OpenWRT. Quando il ISP cambia l'indirizzo IP esterno sul mio modem 4G-5G connesso in bridge mode, il router non rileva il cambiamento e non aggiorna l'indirizzo IP nelle interfacce WAN. Questo script viene eseguito ogni due minuti con Cron e permette di tenere sempre aggiornate automaticamente le interfacce WAN del router in modo da cambiare l'indirizzo IP esterno ogni volta che viene cambiato dall'ISP.



**How install and use this script :**

For use this script in the correct way and install it in the router you need to do the following instructions :

1) Connect to the router with the SSH using the following command :  " ssh username-on-your-router@router-Ip-Adress " And after that insert your router password. 					Es. ssh root@192.168.0.1

2) Install the text editor Nano with the following command : " opkg install nano ".

3) Use the command " nano " to startup the Nano text editor and past with Ctrl+V the script.

4) Save the file with Ctrl+S and give it a name of your choice with " .sh " extention in the end. After that exit with Ctrl+X Es. wan-reload.sh

5) Use the command " chmod +x your-file-name.sh " to make it executable.

The next step is to insert our script in the CronTab for make it's execution automatically every two minutes.

6) Use the command " crontab -e " to open the CronTab table.

7) Paste inside it with Ctrl+V the following code 			
" */2 * * * * /root/your-file-name.sh ".

8) Save it with Ctrl+S and exit with Ctrl+X.

If everything was done right you will have an OpenWRT router with the ability to go back online by itself every time the ISP changes the external IP.



**IT - Come installare ed usare lo script :**
Per installare questo script nel router ed eseguiro automaticamente è necessario :

1) Collegarsi utilizzando l'SSH al proprio router con  il seguente comando : " ssh username-del-router@indirizzo-ip-del-router " Ed inserire la password che abbiamo messo al router durante la configurazione. Es. ssh root@192.168.0.1

2) Installare con il comando "opkg install nano" il text editor Nano.

3) Usare il comando " nano " per aprire un file di testo vuoto e incollare con Ctrl+V il seguente script.

4) Salvare il file con Ctrl+S, dandogli un nome a piacere, purchè si utilizzi l'estensione " .sh ", io l'ho chiamato 
" wan-reload.sh " ad esempio.

5) Usare il comando " chmod +x nome-tuo-file.sh " per rendere il file eseguibile.

Inseriamo il nostro script nella tabella di cron per farlo eseguire ogni 2 minuti con i seguenti comandi :

6) " crontab -e " per aprire la tabella di cron.

7) Incollare il seguente comando nella tabella 
" */2 * * * * /root/nome-tuo-file.sh ".

8) Salvare con Ctrl+S ed uscire con Ctrl+X.

Se tutto è stato eseguito correttamente dovresti avere un router OpenWRT in grado di tornare online da solo ad ogni cambio di IP esterno da parte del ISP.
