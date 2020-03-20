<?php
namespace App\Controller\Frontend\Homepage;

use App\Document\Example;
use Doctrine\ODM\MongoDB\DocumentManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomepageController extends AbstractController
{
    /** @var DocumentManager */
    private $documentManager;

    /**
     * @param DocumentManager $documentManager
     */
    public function __construct(DocumentManager $documentManager)
    {
        $this->documentManager = $documentManager;
    }

    /**
     * Homepage index action
     *
     * @Route(path="/", name="frontend_homepage_index")
     * @param Request $request
     * @return Response
     */
    public function index(Request $request)
    {
        return $this->render('frontend/homepage/index.html.twig');
    }

    /**
     * Secured content
     *
     * @Route(path="/secured", name="frontend_homepage_secured")
     * @param Request $request
     * @return Response
     */
    public function secured(Request $request)
    {
        return $this->render('frontend/homepage/secured.html.twig');
    }

    /**
     * Create MongoDB document
     *
     * @Route(path="/mongocreate", name="frontend_homepage_mongocreate")
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

        return $this->render('frontend/homepage/mongodb_created.html.twig', ['docid' => $example->getId()]);
    }

    /**
     * Display MongoDB document
     *
     * @Route(path="/mongodisplay", name="frontend_homepage_mongodisplay")
     * @param Request $request
     * @return Response
     * @throws \Doctrine\ODM\MongoDB\MongoDBException
     */
    public function mongoDisplayDoc(Request $request)
    {
        $docid = $request->get('docid', null);
        $example = $docid != null ? $this->documentManager->getRepository(Example::class)->find($docid) : null;

        return $this->render('frontend/homepage/mongodb_display.html.twig', ['doc' => $example]);
    }
}
