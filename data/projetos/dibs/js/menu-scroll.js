$(function(){
  $('nav a').click(function() {
    let href = $(this).attr('href');
    let distanciaTopo = $(href).offset().top;

    $('html, body').animate({'scrollTop': (distanciaTopo - 100)});

    return false;
  });

  $(window).scroll(function() {
    $('section.sessao').each(function() {
      let scrollAtual = $(window).scrollTop();
      let alturaJanela = $(window).height();
      let distanciaObjetoTopo = $(this).offset().top;

      if(distanciaObjetoTopo < (scrollAtual + alturaJanela) && (distanciaObjetoTopo + $(this).height()) > scrollAtual){
        $('nav a').css('border-bottom', '0');
        $('nav a').css('color', 'white');
        let id = $(this).attr('id');
        $('.menu-'+id).css({'border-bottom': '2px solid #5ce6c9'});
        $('.menu-'+id).css({'color': '#5ce6c9'});
        return;
      }
    })
  })
});