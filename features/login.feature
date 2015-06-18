# language: it
Funzionalità: login
  Come utente della piattaforma
  Voglio autenticarmi
  Così che io possa salvare i documenti, essere riconoscibile...


Contesto:
  Dato che esistono gli utenti: 
    | username | password  | nome | cognome | email                  | status | token | token_expire_delta_sec |
    | test     | letmein   | utente test | attivo | test@knplabs.com       | active | 1234             | -10 | 
    | inactive | letmein   | questo utente | inattivo | inactive@symfony.com   | inactive | 4566           | 60 |
    | tokenexpired | letmein   | questo qua | token vecchio | expired@symfony.com   | inactive | 4566           | -5 |
    | disable  | letmein   | ciccio | disabilitato | disable@symfony.com    | disable |  10110          | 0  |



  @users
  Scenario: Login successful
#     Dato che esistono gli utenti:
#     | username | password  | nome | cognome | email                  | status | token | token_expire_delta_sec |
#     | test     | letmein   | utente test | attivo | test@knplabs.com       | active | 1234             | -10 | 
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    username=test&password=letmein
    """
    
    Allora lo status code è "200"
    E il body è JSON
    E mostra il body
    E la risposta contiene JSONPath "$.username"


  # Schema dello scenario: o Scenario outline: si usa quando lo scenario prende degli esempi per l'esecuzione
  @users
  Schema dello scenario: Bad login  
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    <qstring_credenziali>
    """
    Allora lo status code è "400"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"
      Esempi:
      | qstring_credenziali |
      | username=&password=|
      | username=test&password=|
      | username=&password=letmein|
    
  # Schema dello scenario: o Scenario outline: si usa quando lo scenario prende degli esempi per l'esecuzione
  @users
  Schema dello scenario: User inactive
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    <qstring_credenziali>
    """
    Allora lo status code è "403"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"
      Esempi:
      | qstring_credenziali |
      | username=inactive&password=letmein |
      | username=disable&password=letmein |

  @users
  Schema dello scenario: Forbidden
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    <qstring_credenziali>
    """
    Allora lo status code è "403"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"
      Esempi:
      | qstring_credenziali |
      | username=test&password=sbagliata |
      | username=cippalippa&password=sbagliata |
        


#   #alternativa con header esplicto nella request 
#   Scenario: Login successful (http style)
#     Dato che ho un request body 
#     """
#     username=test&password=letmein
#     """
#     E ho un header "Content-Type" "application/x-www-form-urlencoded"
#     
#     
#     Quando faccio POST su "/v1/login"
#     #nel post ci saranno gli header definiti sopra
# 
#     Allora lo status code è "200"
#     E esiste un header "Content-Type" "application/json"
#     E la risposta contiene JSONPath "$.username"
#     E la risposta contiene JSONPath "$.userid"
#     E la risposta contiene JSONPath "$.fullname"

    
