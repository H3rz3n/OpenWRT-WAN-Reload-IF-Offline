#!/bin/sh

# SPIEGAZIONE IN ITALIANO - QUANDO E PERCHÈ USARE QUESTO SCRIPT

# Il caso d'uso di questo script è il seguente : Abbiamo un modem 4G-5G in bridge mode collegato ad un router con OpenWRT.
# Al cambiare dell'indirizzo IP del modem da parte dell'ISP, OpenWRT non cambia automaticamente l'indirizzo IP esterno, impedendo la navigazione.
# Con questo script sistemiamo il problema ricaricando le interfacce WAN (IPV4) e WAN6 (IPV6) utilizzando 
# come riferimento il fallito ping al modem o ad un sever DNS di propria scelta.



# ENGLISH EXPLAINATION - WHEN AND WHY USE THIS SCRIPT

# This is the use case of this script : We have a 4G-5G modem in bridge mode connected to an OpenWRT Router.
# When the ISP changes the modem external address, the OpenWRT router does not change his WAN (IPV4) and WAN6 (IPV6) address automatically.
# With this script we can fix up this problem, using our modem IP or a DNS server as a reference, we will ping this address
# and if it fails three times it will reload the WAN and WAN6 interfaces.
 


# SPIEGAZIONE IN ITALIANO - COME INSTALLARE LO SCRIPT

# Per installare questo script nel router ed eseguiro automaticamente è necessario :

# Collegarsi utilizzando l'SSH al proprio router con  il seguente comando : " ssh username-del-router@indirizzo-ip-del-router " Ed inserire la password che abbiamo messo al router durante la configurazione. Es. ssh root@192.168.0.1
# Installare con il comando "opkg install nano" il text editor Nano.
# Usare il comando " nano " per aprire un file di testo vuoto e incollare con Ctrl+V il seguente script.
# Salvare il file con Ctrl+S, dandogli un nome a piacere, purchè si utilizzi l'estensione " .sh ", io l'ho chiamato wan-reload.sh ad esempio.
# Usare il comando " chmod +x nome-tuo-file.sh " per rendere il file eseguibile.
# Inseriamo il nostro script nella tabella di cron per farlo eseguire ogni 2 minuti con i seguenti comandi :
# " crontab -e " per aprire la tabella di cron.
# Incollare il seguente comando nella tabella " */2 * * * * /root/nome-tuo-file.sh ".
# Salvare con Ctrl+S ed uscire con Ctrl+X.
# Se tutto è stato eseguito correttamente dovresti avere un router OpenWRT in grado di tornare online da solo ad ogni cambio di IP esterno da parte del ISP.



# ENGLISH EXPLAINATION - HOW INSTALL AND USE THIS SCRIPT

# For use this script in the correct way and install it in the router you need to do the following instructions :

# Connect to the router with the SSH using the following command :  " ssh username-on-your-router@router-Ip-Adress " And after that insert your router password.    Es. ssh root@192.168.0.1
# Install the text editor Nano with the following command : " opkg install nano "
# Use the command " nano " to startup the Nano text editor and past with Ctrl+V the script.
# Save the file with Ctrl+S and give it a name of your choice with " .sh " extention in the end. After that exit with Ctrl+X Es. wan-reload.sh
# Use the command " chmod +x your-file-name.sh " to make it executable.
# The next step is to insert our script in the CronTab for make it's execution automatically every two minutes.
# Use the command " crontab -e " to open the CronTab table.
# Paste here with Ctrl+V the following code " */2 * * * * /root/your-file-name.sh ".
# Save it with Ctrl+S and exit with Ctrl+X.
# If everything was done right you will have an OpenWRT router with the ability to go back online by itself every time the ISP changes the external IP.



# SCRIPT

# Dichiarazione delle variabili
# Variables declaration
pang=0                  # Variabile dello stato del ping, se 0 il ping riesce / This variable is used to record the success or failure state of the ping of the designed address.
tentativi=0             # Variabile che conta i tentativi di ottenere il ping / This variable is used to record the number of tries to obtain a successful ping of the designed address.
contatore=3             # Variabile che agisce da contatore di riferimento per i tentativi / This variable is used as counter reference for the while cicle.
zero=0                  # Variabile di valore zero, necessaria per le comparazioni / This variable is used as a Zero Value for comparation.

# Apertura della while con condizione "finchè i tentativi sono minori del contatore esegui il codice".
# Opening of the while cicle with the number of tries lower than the counter as a do condition.
while [[ $tentativi -lt $contatore ]]; do

        # Esecuzione del ping ad un indirizzo che sappiamo essere sempre online o l'indirizzo del modem a cui riconnettersi.
        # Execution of the ping on the disigned address, this has to be an address that we know it's always going to be always online. In my case it's my modem, but you can use a DNS as 1.1.1.1 or 8.8.8.8
        ping -c 1 8.8.8.8

        # Copiamo il valore di riuscita 0 o non riuscita 1 del ping.
        # Copying the value of the ping, if it's zero the adress is online, otherwise it's offline.
        pang=$?

        # Apertura della If che decreta se il nostro modem/ indirizzo è raggiungibile.
        # Opening of the If, with a zero value our address is online, otherwise it will try another two times before reloading the wan interfaces.
        if [[ $pang -eq $zero ]]; then

                # Condizione di uscita positiva, tutto funziona correttamente e lo diciamo con echo !.
                # Positive exit condition, the address is online and everything is fine.
                echo "il modem funziona"

                # Uscita dal programma.
                # Exit from the script.
                exit 0

        else

                # Condizione di uscita negativa, qualcosa è andato storto. Per ora riproviamo e lo diciamo con echo !.
                # Negative exit condition, something has gone wrong. For now it will try another two times before reloading the wan interfaces.
                echo "il modem non funziona, adesso riprovo"

                # Aumenticamo il contatore dei tentativi.
                # Adding a +1 to the tries counter.
                tentativi=$(( tentativi + 1 ))
        fi

done
# Siamo usciti dalla while, qualcosa è andato storto. Dobbiamo ricaricare le interfacce WAN e WAN6.
# We are out of the while, something is wrong and we need to fix it.

# Controllo se effettivamente abbiamo provato a verificare tre volte il ping dell'indirizzo di riferimento.
# Checking if we actually tried to ping the reference address three times.
if [[ $tentativi -gt $zero ]]; then

# Riavvio delle interfacce WAN e WAN6.
# Reloading of the WAN (IPV4) and WAN 6 (IPV6) interfaces.
        ifup wan
        ifup wan6
fi

