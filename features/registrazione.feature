# language: it
Funzionalità: registrazione utente
  Come utente anonimo volgio registrami sulla piattaforma 
  per poter accedere ai servizi che offre

Contesto:
  Dato che esistono gli utenti: 
    | username | password  | email                  | status | activation_token | token_expire_delta_sec |
    | test     | letmein   | test@knplabs.com       | active | 1234             | -10 | 
    | inactive | letmein   | inactive@symfony.com   | inactive | 4566           | 60 |
    | tokenexpired | letmein   | expired@symfony.com   | inactive | 4566           | -5 |
    | disable  | letmein   | disavle@symfony.com    | disable |  10110          | 0  |
   

  Scenario: Registration ok
    Quando faccio POST su "/v1/register" con body "url-encoded"
    """
    user=test&password=letmein&nome=pippo&cognome=pluto
    """
    
    Allora lo status code è "200"
    E il body è JSON
    E la risposta contiene JSONPath "$.status"
    E JSONPath "$.status" è uguale a "inactive"
#     E la risposta contiene JSONPath $.userid
#     E la risposta contiene JSONPath $.fullname


  Scenario: Activation ok
    Dato che uso l'utente "inactive"
    
    Quando faccio PUT su "/v1/activate" con codice di attivazione
    
    Allora lo status code è "200"
    E il body è JSON
    E la risposta contiene JSONPath "$.status"
    E JSONPath "$.status" è uguale a "active"


  Scenario: Activation expired
    Dato che uso l'utente "expired"
    
    Quando faccio PUT su "/v1/activate" con codice di attivazione
    
    Allora lo status code è "403"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"



  Scenario: Activation retry
    Dato che uso l'utente "test"
    
    Quando faccio PUT su "/v1/activate" con codice di attivazione
    
    Allora lo status code è "403"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"    

 Scenario: Activation disable unprocessable entity
    Dato che uso l'utente "disable"
    
    Quando faccio PUT su "/v1/activate" con codice di attivazione
    
    Allora lo status code è "422"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"   