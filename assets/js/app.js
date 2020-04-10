/*
 * Welcome to your app's main JavaScript file!
 *
 * We recommend including the built version of this JavaScript file
 * (and its CSS file) in your base layout (base.html.twig).
 */

// any CSS you import will output into a single css file (app.css in this case)
import '../css/app.scss';

// Navbar toggle changer
function navbarToggleChanger() {
    const navbarBurgers = document.getElementsByClassName('navbar-burger');

    if (navbarBurgers.length > 0) {
        navbarBurgers.forEach(navbarBurger => {
            navbarBurger.addEventListener('click', () => {
                const target = navbarBurger.dataset.target;
                const targetElement = document.getElementById(target);
                navbarBurger.classList.toggle('is-active');
                targetElement.classList.toggle('is-active');
            });
        });
    }
}

// Navbar burger toggle
document.addEventListener('DOMContentLoaded', () => navbarToggleChanger());
