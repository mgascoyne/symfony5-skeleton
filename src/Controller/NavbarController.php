<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;

class NavbarController extends AbstractController
{
    /**
     * Show Navbar
     *
     * @param AuthenticationUtils $authenticationUtils
     * @return Response
     */
    public function show(AuthenticationUtils $authenticationUtils): Response
    {
        // get the login error if there is one
        $error = $authenticationUtils->getLastAuthenticationError();
        // last username entered by the user
        $lastUsername = $authenticationUtils->getLastUsername();

        return $this->render('navigation_bar.html.twig', ['last_username' => $lastUsername, 'error' => $error]);
    }
}
