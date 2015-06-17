<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Behat\Hook\Scope\AfterFeatureScope;
use Behat\Behat\Hook\Scope\AfterScenarioScope;
use Behat\Behat\Hook\Scope\BeforeFeatureScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Testwork\Hook\Scope\BeforeSuiteScope;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\TransferException;
use Peekmo\JsonPath\JsonStore;

/**
 * Description of ApiContext
 *
 * @author cernio
 */
class ApiContext implements Context, SnippetAcceptingContext {

    public $_client;

    /**
     *
     * @todo gestire meglio gli header 
     */
    public $loggedUser;
    public $headers = array();
    public $_response;
    public $_bodyDecoded;
    public $_jsonStore;
    public $_request;

    /**
     * @BeforeSuite
     */
    public static function prepare(BeforeSuiteScope $scope) {
        // prepare system for test suite
        // before it runs
    }

    /**
     * @BeforeFeature
     * @param \JYL\Bundle\JYLApiBundle\Features\Context\BeforeFeature $scope
     */
    public static function prepareFeature(BeforeFeatureScope $scope) {
        //da eseguire PRIMA di un file .feature
    }

    /**
     *
     * @AfterFeature
     * @param \JYL\Bundle\JYLApiBundle\Features\Context\AfterFeature $scope
     */
    public static function closeFeature(AfterFeatureScope $scope) {
        //da eseguire alla fine di un file .feature
    }

    /**
     * @BeforeScenario @database
     */
    public function prepareDB(BeforeScenarioScope $scope) {
        // clean database after scenarios,
        // tagged with @database
    }

    /**
     * @AfterScenario @database
     */
    public function cleanDB(AfterScenarioScope $scope) {
        // clean database after scenarios,
        // tagged with @database
    }

    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct($baseUrl) {

//        $baseUrl=$params['baseUrl'];
        $this->_client = new Client(['base_url' => $baseUrl]);
    }

    /**
     * @Then lo status code deve essere :httpStatus
     * @Then lo status code è :httpStatus
     */
    public function loStatusCodeDeveEssere($httpStatus) {
        if ((string) $this->_response->getStatusCode() !== $httpStatus) {
            throw new \Exception('HTTP code does not match ' . $httpStatus .
            ' (actual: ' . $this->_response->getStatusCode() . ')' . substr($this->_response->getBody(), 0, 10000));
        }
    }

    /**
     * @Then il body e JSON
     * @Then il body è JSON
     */
    public function ilBodyEJson() {
        $body = $this->_response->json();
        $this->_bodyDecoded = $body;
        $this->_jsonStore = new JsonStore($body);
    }

    /**
     * @When faccio GET su :url
     * @Given che faccio GET su :url
     */
    public function chefaccioGetSu($url) {
        try {
            if (!empty($this->loggedUser)) {
                $response = $this->_client->get($url, [
                    'auth' => [$this->loggedUser, ""]
                ]);
            } else {
                $response = $this->_client->get($url);
            }



            $this->_response = $response;
//            throw new \Exception("prova");
        } catch (TransferException $e) {
            if ($e->hasResponse()) {
                $this->_response = $e->getResponse();
            } else {
                throw $e;
            }
        } catch (\Exception $e) {
            throw $e;
        }
    }

    /**
     * @Then /^la response deve contenere la property "([^"]*)"/ 
     */
    public function laResponseDeveContenereLaProprieta($arg1) {
        $data = $this->_response->json();
        if (empty($data)) {
            throw new \Exception("JSON is empty\n" . $this->_response->getBody(true));
        }
        if (!isset($data[$arg1])) {
            throw new \Exception("Property '" . $arg1 . "' is not set!\n");
        }
    }

    /**
     * @Then la property :arg1 deve contenere un box :arg2 e la qstring_params deve contenere :arg3
     */
    public function laPropertyDeveContenereUnBoxELaQstringParamsDeveContenere($arg1, $arg2, $arg3) {
        $data = json_decode($this->_response->getBody(true));

        $data = $this->_response->json();
        $esisteInfobox = false;
        $esisteCampo = false;
        if (!empty($data)) {
            foreach ($data[$arg1] as $tipo => $value) {
                $infobox = $value['box'][0];
                if ($infobox['service'] == $arg2) {
                    $esisteInfobox = true;
                    $qstringParams = $infobox['qstring_params'];
                    if (array_key_exists($arg3, $qstringParams)) {
                        $esisteCampo = true;
                    }
                }
            }
        }
        if (!$esisteInfobox) {
            throw new \Exception("Not infobox '" . $arg2 . "' !\n");
        }

        if (!$esisteCampo) {
            throw new \Exception("Not field'" . $arg3 . "' !\n");
        }
    }

//    /**
//     * la property :$propertyName deve contenere un box :$propertyValue con valore nella qstring di :arg3
//     */
//    public function laPropertyDeveContenereUnBoxConValoreNellaQstringDi($propertyName, $propertyValue, $arg3){
//    
//        $data = json_decode($this->_response->getBody(true));
//        
//        $data = $this->_response->json();
//        if (!empty($data)) {
//            foreach ($data[$propertyName] as $tipo=>$value){
//                var_dump($tipo);
//                var_dump($value);
//            }
//            
//            
//        } else {
//            throw new Exception("Response was not JSON\n" . $this->_response->getBody(true));
//        }
//        
//        
//    }
    /**
     * @Then JSONPATH :jsonpath è uguale a :valore
     */
    public function jsonpathEUgualeA($jsonpath, $valore) {

        $res = $this->_jsonStore->get($this->_bodyDecoded, $jsonpath);
        //todo estendi per valori multipli
//        if(is_array($valore)){ 
//            foreach($valore as $val){
//                
//            }
//        }
        print "jsonpath res:\n";
        print_r($res);
    }

    /**
     * @Then la risposta contiene JSONPath :arg1
     */
    public function laRispostaContieneJsonpath($arg1) {
        $res = $this->_jsonStore->get($arg1);
        if (empty($res)) {
            throw new \Exception("$arg1 non è valorizzato");
        }
    }

    /**
     * @Then JSONPATH :arg1 contiene una property :arg2

     */
    public function jsonpathContieneUnaProperty($arg1, $arg2) {
        $res = $this->_jsonStore->get($arg1);
        foreach ($res as $resItem) {
//            print_r($resItem[$arg2]);
            if (empty($resItem[$arg2])) {
                print_r($resItem);
                throw new \Exception("item $arg2 not found ");
            }
        }
    }

    /**
     * @Then JSONPATH :arg1 contiene un dato di tipo :arg2
     * @Then la proprieta JSON :arg1 contiene un dato di tipo :arg2
     */
    public function jsonpathContieneUnDatoDiTipo($arg1, $arg2) {
        $res = $this->_jsonStore->get($arg1);
        if (empty($res)) {
            throw new \Exception("no items matching criteria ");
        }
//        print_r($res);
        foreach ($res as $resItem) {
//            print_r($resItem[$arg2]);
            if (empty($resItem)) {
                throw new \Exception("item not found ");
            }
            switch ($arg2) {
                case 'integer':
                    if (!is_integer($resItem)) {
                        throw new \Exception("not integer");
                    }
                    break;
                case 'float':
                case 'double':
                    if (!is_double($resItem)) {
                        throw new \Exception("not double");
                    }
                    break;
                case 'string':
                    if (!is_string($resItem)) {
                        throw new \Exception("not string");
                    }
                    break;
                case 'url':
                    if (filter_var($resItem, FILTER_VALIDATE_URL) === FALSE) {
                        throw new \Exception("not a valid url: " . $resItem);
                    }
                    break;
                default:
                    throw new \Exception("case not implemented");
            }
        }
    }

    /**
     * @Given che ho un request body
     */
    public function cheHoUnRequestBody(PyStringNode $string) {
        $this->_request['body'] = $string->getRaw();
    }

    /**
     * @Given ho un header :arg1 :arg2
     */
    public function hoUnHeader($arg1, $arg2) {
        $this->_request['headers'][$arg1][] = $arg2;
    }

    /**
     * @When faccio POST su :arg1
     */
    public function faccioPostSu($arg1) {
        $this->_client->createRequest('POST', $arg1, ['body' => $this->_request['body'],
            'headers' => $this->_request['headers']]);
    }

    /**
     * @When faccio POST su :arg1 con body :arg2
     */
    public function faccioPostSuConBody($arg1, $arg2, PyStringNode $string) {
        try {
            if ($arg2 == 'url-encoded') {

              
                $request = $this->_client->createRequest('POST', $arg1,['headers'=>['Content-Type'=>'application/x-www-form-urlencoded'],'body'=>$string->getRaw()]);
//                $request->setBody( $streamBody);
            } else if ($arg2 == 'json') {
                $request = $this->_client->createRequest('POST', $arg1, ['json' => $string->getRaw()]);
            }
            $response = $this->_client->send($request);
            $this->_response = $response;
        } catch (TransferException $e) {
            if ($e->hasResponse()) {
                $this->_response = $e->getResponse();
            } else {
                throw $e;
            }
        } catch (\Exception $e) {
            throw $e;
        }
    }

    /**
     * @Given che esiste l’utente “test” con password “letmein”
     * @Given che esiste l’utente inactive “test” con password “letmein”
     * @Given che esiste l’utente disable “test” con password “letmein”
     */
    public function cheEsisteLUtenteTestConPasswordLetmein() {
        //qui si puo scegliere che strada seguire:
        //inserire l'utente
        //prendere l'utente dal db
        //chiamare una url esterna        
        return true;
    }
    
    
    /**
     * @Given che esistono gli utenti:
     */
    public function cheEsistonoGliUtenti(TableNode $table)
    {
        foreach ($table as $t){
            //qui si puo scegliere che strada seguire:
            //inserire l'utente
            //prendere l'utente dal db
            //chiamare una url esterna        
            //var_dump($t);
        }
        return true;
    }

    

}
