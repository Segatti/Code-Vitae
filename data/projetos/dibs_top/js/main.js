$(function(){
  // Show/Hidden Menu mobile
  $('.icone-menu').click(function() {
    $('.menu-mobile').slideToggle();
  })

  $('.menu-mobile nav li').click(function() {
    $('.menu-mobile').slideToggle();
  })

  // Scroll ao clicar no menu
  $('nav li').click(function() {
    let href = $(this).attr('href');
    let distanciaTopo = $(href).offset().top;

    $('html, body').animate({'scrollTop': (distanciaTopo - 150)});

    return false;
  });
})
