<h1 class="mb-3"><?php echo "POPULER KURSLAR"; ?></h1>
<p class="lead">
<?php $kategoriler=getCategories();
$kurslar=getCourses(0,0);
?>
    <?php echo mysqli_num_rows($kategoriler) ?> kategoride <?php echo mysqli_num_rows($kurslar) ?> kurs listelenmiştir
</p>