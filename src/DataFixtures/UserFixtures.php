<?php
namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;

class UserFixtures extends Fixture
{
    /** @var UserPasswordEncoderInterface */
    private $userPasswordEncoder;

    /**
     * UserFixtures constructor
     *
     * @param UserPasswordEncoderInterface $userPasswordEncoder
     */
    public function __construct(UserPasswordEncoderInterface $userPasswordEncoder)
    {
        $this->userPasswordEncoder = $userPasswordEncoder;
    }

    /**
     * Add fixture users
     *
     * @param ObjectManager $manager
     */
    public function load(ObjectManager $manager)
    {
        // admin account
        $admin = new User();
        $admin->setEmail('admin@symfony.local');
        $admin->setPassword(
            $this->userPasswordEncoder->encodePassword(
               $admin,
               'adminadmin'
            )
        );
        $admin->setRoles(['ROLE_ADMIN']);
        $manager->persist($admin);

        // demo account 1
        $demo1 = new User();
        $demo1->setEmail('demo1@symfony.local');
        $demo1->setPassword(
            $this->userPasswordEncoder->encodePassword(
                $demo1,
                'demodemo'
            )
        );
        $demo1->setRoles(['ROLE_USER']);
        $manager->persist($demo1);

        // demo account 2
        $demo2 = new User();
        $demo2->setEmail('demo2@symfony.local');
        $demo2->setPassword(
            $this->userPasswordEncoder->encodePassword(
                $demo2,
                'demodemo'
            )
        );
        $demo2->setRoles(['ROLE_USER']);
        $manager->persist($demo2);

        $manager->flush();
    }
}
