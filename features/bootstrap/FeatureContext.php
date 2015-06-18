<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

class PendingException extends \Exception
{
}
/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context, SnippetAcceptingContext
{
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
//        
//        $kernel;
//        $kernel->
//                $serverWeb=new ServerWeb();
//        $serverWeb->start();
//        ...
        
    }


   /**
     * @Given che esiste :arg1 con notifiche digest
    
     */
    public function cheEsisteConNotificheDigest($arg1)
    {
	print "esiste $arg1";
	return true;
    }

    /**
     * @Given che esiste :arg1
     */
    public function cheEsiste($arg1)
    {
	print "esiste $arg1";
	return true;
    }

    /**
     * @Given :arg1 è un utente attivo
     */
    public function eUnUtenteAttivo($arg1)
    {
	print "esiste ed èattivo $arg1";
	return true;
    }

    /**
     * @When :arg1 segue :arg2
     */
    public function segue($arg1, $arg2)
    {
	print "$arg1 -> $arg2";
    }

    /**
     * @Then :arg1 riceve una mail di notifica diretta
     */
    public function riceveUnaMailDiNotificaDiretta($arg1)
    {
	print	"$arg1 ha ricevuto una mail diretta";
    }

    /**
     * @Then :arg1 non riceve una mail di notifica digest
     */
    public function nonRiceveUnaMailDiNotificaDigest($arg1)
    {
        print "$arg1 ha ricevuto una mail digest";
    }
    


    /**
     * @Given che :arg1 non segue :arg2
     */
    public function cheNonSegue($arg1, $arg2)
    {
        $user1= $this->dm->findUser($arg1);
        $user2 = $this->dm->findUser($arg2);
        if(in_array($user2->getId(), $user1->getFollowing())) {
            throw new \Exception ("$arg1 segue già $arg2");
        }
        
    }
}
