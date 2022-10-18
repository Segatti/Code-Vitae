$(function(){
  $('.menu-pc').click(function() {
    $('.menu-mobile').find('nav').slideToggle();
  })

  $('.menu-mobile nav span').click(function() {
    $('.menu-mobile nav').fadeOut();
  })
})