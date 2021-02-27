<?php
namespace App\Controller;

use App\Document\Example;
use Doctrine\ODM\MongoDB\DocumentManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Annotation\Route;

class HomepageController extends AbstractController
{
    /** @var DocumentManager */
    private $documentManager;

    /** @var MailerInterface */
    private $mailer;

    /**
     * @param DocumentManager $documentManager
     * @param MailerInterface $mailer
     */
    public function __construct(DocumentManager $documentManager, MailerInterface $mailer)
    {
        $this->documentManager = $documentManager;
        $this->mailer = $mailer;
    }

    /**
     * Homepage index action
     *
     * @Route(path="/", name="home_index")
     * @param Request $request
     * @return Response
     */
    public function index(Request $request)
    {
        return $this->render('index.html.twig');
    }

    /**
     * Secured content
     *
     * @Route(path="/secured", name="home_secured")
     * @param Request $request
     * @return Response
     */
    public function secured(Request $request)
    {
        return $this->render('secured.html.twig');
    }

    /**
     * Create MongoDB document
     *
     * @Route(path="/mongocreate", name="home_mongocreate")
     * @param Request $request
     * @return Response
     * @throws \Doctrine\ODM\MongoDB\MongoDBException
     */
    public function mongoCreateDoc(Request $request)
    {
        $example = new Example();
        $example->setData('My content');

        $this->documentManager->persist($example);
        $this->documentManager->flush();

        return $this->render('mongodb_created.html.twig', ['docid' => $example->getId()]);
    }

    /**
     * Display MongoDB document
     *
     * @Route(path="/mongodisplay", name="home_mongodisplay")
     * @param Request $request
     * @return Response
     * @throws \Doctrine\ODM\MongoDB\MongoDBException
     */
    public function mongoDisplayDoc(Request $request)
    {
        $docid = $request->get('docid', null);
        $example = $docid != null ? $this->documentManager->getRepository(Example::class)->find($docid) : null;

        return $this->render('mongodb_display.html.twig', ['doc' => $example]);
    }

    /**
     * Send example mail
     *
     * @Route(path="/sendmail", name="home_sendmail")
     * @return Response
     */
    public function sendExampleMail()
    {
        $email = (new Email())
            ->from('noreply@symfony.local')
            ->to('user@symfony.local')
            ->subject('Test for Symfony Mailer')
            ->text('Exmaple Mail (text part).')
            ->html('<p>Example Mail <b>HTML part</b></p>');

        $this->mailer->send($email);

        return $this->render('mail_sent.html.twig');
    }
}
