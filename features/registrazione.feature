# language: it
Funzionalità: registrazione utente
  Come utente anonimo volgio registrami sulla piattaforma 
  per poter accedere ai servizi che offre

Contesto:
  Dato che esistono gli utenti: 
    | username | password  | nome | cognome | email                  | status | token | token_expire_delta_sec |
    | test     | letmein   | utente test | attivo | test@knplabs.com       | active | 1234             | -10 | 
    | inactive | letmein   | questo utente | inattivo | inactive@symfony.com   | inactive | 4566           | 1000 |
    | tokenexpired | letmein   | questo qua | token vecchio | expired@symfony.com   | inactive | 4566           | -600 |
    | disabled  | letmein   | ciccio | disabilitato | disable@symfony.com    | disable |  10110          | 0  |

   
  @users
  Scenario: Registration ok
    Quando faccio POST su "/v1/register" con body "url-encoded"
    """
    username=test2&password=letmein&nome=pippo&cognome=pluto&email=pippo%40example.com
    """
    
    Allora lo status code è "200"
    E il body è JSON
    E la risposta contiene JSONPath "$.status"
    E JSONPath "$.status" è uguale a "inactive"
#     E la risposta contiene JSONPath $.userid
#     E la risposta contiene JSONPath $.fullname

  @users
  Scenario: Activation ok
    
    Quando faccio PUT su "/v1/activate/inactive" con codice di attivazione di "inactive"
    
    Allora lo status code è "200"
    E il body è JSON
    E mostra il body
    E la risposta contiene JSONPath "$.status"
    E JSONPath "$.status" è uguale a "active"

  @users
  Scenario: Activation expired
        
    Quando faccio PUT su "/v1/activate/tokenexpired" con codice di attivazione di "tokenexpired"
    
    Allora lo status code è "403"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"


  @users
  Scenario: Activation retry
       
    Quando faccio PUT su "/v1/activate/test" con codice di attivazione di "test"
    
    Allora lo status code è "422"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"    

  @users
  Scenario: Activation disable unprocessable entity
    Quando faccio PUT su "/v1/activate/disabled" con codice di attivazione di "disabled"
    
    Allora lo status code è "422"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"   