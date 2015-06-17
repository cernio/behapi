# language: it
Funzionalità: registrazione utente
  Come utente anonimo volgio registrami sulla piattaforma 
  per poter accedere ai servizi che offre

Contesto:
  Dato che esistono gli utenti: 
    | username | password | email                  |status|
    | test     | letmein   | test@knplabs.com      |active|
    | inactive | letmein   | inactive@symfony.com  |inactive|
    | disable  | letmein   | disavle@symfony.com   |disable|
   

  Scenario: Registration ok
    Quando faccio POST su "/v1/registrazione" con body "url-encoded"
    """
    user=test&password=letmein&nome=pippo&cognome=pluto
    """
    
    E il body è JSON
    Allora lo status code è "200"
    E la risposta contiene JSONPath $.status
#     E la risposta contiene JSONPath $.userid
#     E la risposta contiene JSONPath $.fullname


