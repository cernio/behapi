# language: it

Funzionalità: Notifica di following

  Come utente della piattaforma
  Voglio ricevere una notifica via email quando un altro utente inizia a seguirmi
  Così che io possa scegliere se seguirlo a mia volta

  Contesto:
    Dato che esiste "pluto_direct" con notifiche dirette
    E che esiste "topolino_digest" con notifiche digest
    E che esiste "pippo" 

  Scenario: Notifica di following
    Dato che "pippo" non segue "pluto_direct"
    E "pippo" è un utente attivo

    Quando "pippo" segue "pluto_direct"

    Allora "pluto_direct" riceve una mail di notifica diretta
    Ma "pluto_direct" non riceve una mail di notifica digest

