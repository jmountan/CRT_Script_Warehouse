*** Settings ***

Documentation           Test suite for Pace starter.
Library                 QWeb
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***
Test the home page
    [Tags]              Broken
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal

Check the navigation menu items
    [Tags]              Broken
    [Documentation]     Go to the shop homepage and verify the menu items.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Products
    VerifyText          Our Story
    VerifyText          Contact

Shop for products
    [Tags]              Broken
    [Documentation]     Select the ONLY "Sacha the Deer" product to add to cart and confirm that it is in the cart, then verify details on the page,
    ...                 add the product to the cart and continue shopping.
    GoTo                https://qentinelqi.github.io/shop/
    ClickText           Sacha the Deer
    VerifyText          Slim Fit, 5oz 100% Cotton T-Shirt.
    GoTo                https://qentinelqi.github.io/shop/
    ClickText           Bumble the Elephant
    #ClickText           Add to cart
    ClickText           Add to carts
    VerifyText          Cart summary
    VerifyText          Sacha the Deer
    ClickText           Continue shopping

Continue shopping
    [Tags]              Broken
    [Documentation]     Now add "Gavin the Tiger" to the cart and confirm its in the cart.
    AppState            Home
    ClickText           Gavin the Tiger
    VerifyText          His favorite meal is chickpea salad with a lemon juice dressing.
    VerifyText          $9.00
    ClickText           Add to carts
    ClickText           Continue shopping
    # Check if we've exited the "cart" by looking for text in the footer.
    VerifyText          Fur, Inc.

Check Our Story
    [Tags]              Broken
    [Documentation]    VerifyText on Ava Sandler and Steph Poco in the /about/ page   <Hint: Our Story>
    Appstate           Home
    VerifyText         Ava Sandler
    VerifyText         Steph Poco
    VerifyText         Passion
    VerifyText         Animal
    VerifyText         Style

Start payment info
    [Tags]              Broken
    [Documentation]    Start filling out the payment info. We will only fill out a fake name, email, and address After that the test is done.
    Appstate           Home   
    ClickText          shopping_cart
    ClickText          Checkout
    TypeText           Tina Smith            Full name
    TypeText           Email                 Tina.Smith@growmore.com   
    
    ClickText          I don't see my address    
    TypeText           Street address       416 Growmore Ave.      
    TypeText           City                 DreamCity
    ClickText          Country
    ClickText          Canada
    ClickText          Province/State
    ClickText          Manitoba
    TypeText           Postal/ZIP code      12345

*** Keywords ***

Home
    [Documentation]     Set the application state to the shop home page.
    GoTo                https://qentinelqi.github.io/shop/
