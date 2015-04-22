<div class="box" id="home-box3">
    <h2>Novidades</h2>
    <div class="box-content">
        <? foreach($noticias as $noticia): ?>
        <div class="novidade-box">
            <small class="data"><span class="data-numero"><? echo $noticia['dia']; ?></span> | <? echo $noticia['mes']; ?></small>
            <p>
                <? echo  $noticia['texto']; ?>
            </p>
        </div>
        <? endforeach; ?>
    </div>
    <!-- #box-content-->
    <div class="box-footer">
        <?php echo $html->link( '» mais novidades',
                                'http://www.twitter.com/cvirtuais/',
                                array('class' => 'more-link', 'target' => '_blank')); ?>
    </div>
</div>